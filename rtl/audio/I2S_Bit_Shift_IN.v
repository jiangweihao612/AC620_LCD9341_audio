module I2S_Bit_Shift_IN(
	Rst_n,
	
	Audio_LRCLK,
	AUD_BCLK,

	AUD_ADCDAT,
	rdat,
	ldat
);
	input Rst_n;   

	input AUD_BCLK;     
	
	input Audio_LRCLK; 
	
	output signed [15:0]rdat;
	output signed [15:0]ldat;
	
	input  AUD_ADCDAT;
	
	
	reg dacdat;

	reg [3:0]R_Bit_Cnt;	//右声道数据位计数器
	reg [3:0]L_Bit_Cnt;	//左声道数据位计数器  
	
	wire [15:0] rdat; //右声道采集的音频数据
	wire [15:0] ldat; //左声道采集的音频数据
	
	reg [15:0] irdat; 
	reg [15:0] ildat; 
	
	reg [15:0] irdat1; 
	reg [15:0] irdat2;
	
	
	assign rdat = irdat2;
	assign ldat = ildat;

	//采样右声道数据
	always@(posedge AUD_BCLK or negedge Rst_n)
	if(!Rst_n) begin
		R_Bit_Cnt<=0;
		irdat <= 0;
	end	
	else if( Audio_LRCLK ==1'b1) begin           
		irdat[R_Bit_Cnt] <= AUD_ADCDAT;
		R_Bit_Cnt <= R_Bit_Cnt + 1'b1;                                            
	end else begin
		irdat <= irdat;
		R_Bit_Cnt <= 0; 		
	end
	
	//采样左声道数据
	always@(posedge AUD_BCLK or negedge Rst_n)
	if(!Rst_n) begin
		L_Bit_Cnt <= 0;
	end	
	else if( Audio_LRCLK ==1'b0 ) begin              
		ildat[L_Bit_Cnt] <= AUD_ADCDAT;
		L_Bit_Cnt <= L_Bit_Cnt+1'b1; 
	end 
	else begin
		ildat <= ildat;
		L_Bit_Cnt <= 0;                                                           
	end 
	
	//每次采样完16位的数据，将采样结果存储到输出寄存器
	always@(posedge AUD_BCLK)
	if(R_Bit_Cnt==15)
		irdat1 <= irdat;
	else
		irdat1 <= irdat1;
	always@(posedge Audio_LRCLK)
		irdat2<=irdat1;
	 
endmodule 

 