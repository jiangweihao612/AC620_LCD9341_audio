/*============================================================================
*
*  LOGIC CORE:          音频录制播放控制模块	
*  MODULE NAME:         Record_Play_Control()
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

module Record_Play_Control(
	Clk,
	Rst_n,
	Key,
	
	Audio_LRCLK,
	
	Record_EN,
	Play_EN,
	
	Init_Record,
	Init_Play,
	Read_Length,
	Disp_Length
);

	//允许录制的最大状态为SDRAM存储空间大小
	localparam RECORD_MAX_LENGTH = 23'h7fffff;

	input Clk;	//50M工作时钟
	input Rst_n;	//复位信号
	input [1:0]Key;	//控制按键
	input Audio_LRCLK;	//音频基本数据时钟
	
	output reg [31:0]Read_Length;	//播放所需读取的数据长度
	output reg[31:0]Disp_Length;	//将实时录制和播放长度送往数码管显示
	output Init_Record;	//初始化录制。主要是清零SDRAM写入侧FIFO
	output Init_Play;		//初始化播放。主要是清零SDRAM读出侧FIFO
	output reg Record_EN;	//录制使能
	output reg Play_EN; //播放使能

	wire key_flag0;
	wire key_flag1;
	
	wire key_state0;
	wire key_state1;
	
	key_filter key_filter0(
		.Clk(Clk),      //50M时钟输入
		.Rst_n(Rst_n),    //模块复位
		.key_in(Key[0]),   //按键输入
		.key_flag(key_flag0), //按键标志信号
		.key_state(key_state0) //按键状态信号
	);
	
	key_filter key_filter1(
		.Clk(Clk),      //50M时钟输入
		.Rst_n(Rst_n),    //模块复位
		.key_in(Key[1]),   //按键输入
		.key_flag(key_flag1), //按键标志信号
		.key_state(key_state1) //按键状态信号
	);
	
	assign Init_Record = key_flag0 && !key_state0;	//按键0按下
	assign Init_Play = key_flag1 && !key_state1;		//按键1按下

	reg [31:0] record_cnt;	//录制数据实时计数器
	reg [31:0] record_length;	//一次录制的数据长度
	always@(posedge Audio_LRCLK or negedge Rst_n)
	if(!Rst_n)begin
		record_cnt <= 0;
		Record_EN <= 1'd0;
		record_length <= 32'd0;
	end
	else if(!key_state0)begin	//按键按下状态
		record_length <= record_cnt;
		if(record_cnt >= RECORD_MAX_LENGTH)begin //录制超过最大长度，停止录制
			record_cnt <= record_cnt;
			Record_EN <= 1'd0;
		end
		else begin
			record_cnt <= record_cnt + 1'b1;
			Record_EN <= 1'd1;		
		end
	end
	else begin
		record_length <= record_length;
		record_cnt <= 0;
		Record_EN <= 1'd0;
	end
	
	reg [31:0] Play_cnt;	//播放实时计数器
	always@(posedge Audio_LRCLK or negedge Rst_n)
	if(!Rst_n)begin
		Play_cnt <= 0;
		Play_EN <= 1'd0;		
	end
	else if(!key_state1)begin	//按键按下状态
		if(Play_cnt >= record_length)begin //播放达到录制长度，停止播放
			Play_cnt <= Play_cnt;
			Play_EN <= 1'd0;
		end
		else begin
			Play_cnt <= Play_cnt + 1'b1;
			Play_EN <= 1'd1;		
		end
	end
	else begin
		Play_cnt <= 0;
		Play_EN <= 1'd0;
	end
	
	//每次播放开始，将录制的长度寄存，作为SDRAM读取最大地址范围参数
	always@(posedge Clk or negedge Rst_n)
	if(!Rst_n)
		Read_Length <= 0;
	else if(Init_Play)	//初始化播放时，将录制长度寄存
		Read_Length <= record_length;
	else 
		Read_Length <= Read_Length;

		
	//录制时，实时加，播放时，实时减
	always@(posedge Audio_LRCLK or negedge Rst_n)
	if(!Rst_n)
		Disp_Length <= 32'd0;
	else if(Play_EN)
		Disp_Length <= Disp_Length - 1'b1;
	else if(Record_EN)
		Disp_Length <= record_length;
	else
		Disp_Length <= record_length;

endmodule
