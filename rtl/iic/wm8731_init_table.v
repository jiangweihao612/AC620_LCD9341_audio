/*============================================================================
*
*  LOGIC CORE:          WM8731初始化寄存器表
*  MODULE NAME:         wm8731_init_table()
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

module wm8731_init_table
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q,
	output [7:0]dev_id,
	output [7:0]lut_size
);

	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
	
	assign dev_id = 8'h34;		//WM8731 IIC接口器件地址
	assign lut_size = 8'd12;	//WM8731 寄存器初始化数量

	//Line IN	
	initial begin
		rom[0 ][15:0] = {7'h0f,9'h000}; //  reset  wm8731    
		rom[1 ][15:0] = {7'h09,9'h000};  
		rom[2 ][15:0] = {7'h00,9'h01f};
		rom[3 ][15:0] = {7'h01,9'h01f};
		rom[4 ][15:0] = {7'h02,9'h07b};//
		rom[5 ][15:0] = {7'h03,9'h07b};
		
		//以下两行，录制LineIN就注释掉第二行，录制麦克风就注释掉第一行，两行只能选一个有效
		rom[6 ][15:0] = {7'h04,9'h010}; //录制Line IN音频
//		rom[6 ][15:0] = {7'h04,9'h015}; //录制MicroPhone
		
		rom[7 ][15:0] = {7'h05,9'h006};
		rom[8 ][15:0] = {7'h06,9'h000};
		rom[9 ][15:0] = {7'h07,9'h009};  //OK
		rom[10][15:0] = {7'h08,9'h006}; //OK
		rom[11][15:0] = {7'h09,9'h001}; 
	end
	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

endmodule
