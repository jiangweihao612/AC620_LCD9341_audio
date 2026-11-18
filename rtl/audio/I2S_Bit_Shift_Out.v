/*============================================================================
*
*  LOGIC CORE:          I2S接口的输出	
*  MODULE NAME:         I2S_Bit_Shift_Out()
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

module I2S_Bit_Shift_Out(
	Audio_Data,
	Audio_LRCLK,
	
	AUD_BCLK,
	AUD_DACDAT
);

	input AUD_BCLK,Audio_LRCLK;
	input [15:0] Audio_Data;
	output AUD_DACDAT;
	
	reg	[3:0]rnum;
	reg	[3:0]rcount;
	reg 	[15:0]r_dat;
	
	
	reg	[3:0]lnum;
	reg	[3:0]lcount;
	reg 	[15:0]l_dat;

	always@(posedge AUD_BCLK)
	if(Audio_LRCLK	==	1'b0) begin
		r_dat[rnum]<= Audio_Data[0+rcount];
		rnum<=rnum+1'b1;
		rcount<=rcount+1'b1;
	end
	else	if(Audio_LRCLK	==	1'b1) begin
		rnum<=0;
	end
	
	
	always@(posedge AUD_BCLK)
	if(Audio_LRCLK	==	1'b1) begin
		l_dat[lnum]<= Audio_Data[0+lcount];
		lnum<=lnum+1'b1;
		lcount<=lcount+1'b1;
	end
	else	if(Audio_LRCLK	==	1'b0) begin
		lnum<=0;
	end

	assign AUD_DACDAT =Audio_LRCLK?l_dat[lnum]:r_dat[rnum]; 
	
endmodule
