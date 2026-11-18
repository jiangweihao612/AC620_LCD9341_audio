/*============================================================================
*
*  LOGIC CORE:          音频芯片工作所需时钟生成模块	
*  MODULE NAME:         Audio_Clk_Gen()
*  COMPANY:             武汉芯路恒科技有限公司
*                       http://xiaomeige.taobao.com
*	author:					小梅哥
*	Website:					www.corecourse.cn
*  REVISION HISTORY:  
*
*    Revision 1.0  04/10/2019     Description: Initial Release.
*
*  FUNCTIONAL DESCRIPTION:
===========================================================================*/

module Audio_Clk_Gen(
	clock_ref,
	Rst_n,
	xck,
	Audio_LRCLK,
	bclk
);
	input clock_ref;       //wm8731振荡器时钟,18.432Mhz;
	input Rst_n;   
	output Audio_LRCLK;        
	output xck;
	output bclk;
	
	reg Audio_LRCLK;
	reg [8:0]Audio_LRCLK_cnt;
	reg bclk;
	reg [3:0]bclk_cnt;
   
	parameter CLOCK_REF=18432000;
	parameter CLOCK_SAMPLE=48000;
    
	assign xck = clock_ref;
   
	//产生DAC和ADC的左右声道区分时钟，该时钟等于实际的芯片采样率
	always@(posedge clock_ref or negedge Rst_n)    
	if(!Rst_n) begin
		Audio_LRCLK<=0;
		Audio_LRCLK_cnt<=0;
	end
	else if(Audio_LRCLK_cnt>=(CLOCK_REF/(CLOCK_SAMPLE*2)-1)) begin
		Audio_LRCLK<=~Audio_LRCLK;
		Audio_LRCLK_cnt<=0;
	end
	else
		Audio_LRCLK_cnt<=Audio_LRCLK_cnt+1'b1; 

	//产生I2S位时钟，BCLK的频率= 2 * 采样频率 * 采样位数，其中的2代表了2个声道。
	always@(posedge clock_ref or negedge Rst_n)
	if(!Rst_n) begin
		bclk<=0;
		bclk_cnt<=0;
	end
	else if(bclk_cnt>=(CLOCK_REF/(CLOCK_SAMPLE*2*16*2)-1)) begin
		bclk<=~bclk;
		bclk_cnt<=0;
	end
	else
		bclk_cnt<=bclk_cnt+1'b1;

endmodule
