//顶层

module Audio_Record_Play(
	audio_data,
	
	Clk,
	Rst_n,
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,
	i2c_sdat,
	i2c_sclk
);

	input Clk;
	input Rst_n;

	input AUD_ADCDAT;	//ADC数字音频信号输出
	output AUD_ADCLRCK;	//ADC采样左/右声道信号
	output AUD_BCLK;	//数字音频位时钟
	output AUD_DACDAT;	//DAC数字音频数据输入
	output AUD_DACLRCK;	//DAC采样左/右声道信号
	output AUD_XCK;	//WM8731芯片的主工作时钟
	
	inout i2c_sdat;
	output i2c_sclk;
	output [15:0] audio_data;
	
	wire [15:0]rdat;
	wire audio_clk;
	wire Audio_LRCLK;
	
	assign AUD_DACLRCK = Audio_LRCLK;
	assign AUD_ADCLRCK = Audio_LRCLK;
	
	assign sdram_clk = Clk;
	
	//WM8731寄存器初始化模块
WM8731_Init WM8731_Init(
		.Clk(Clk),
		.Rst_n(Rst_n),
		.Init_Done(),
		.i2c_sclk(i2c_sclk),
		.i2c_sdat(i2c_sdat)
	);
	
	//PLL
aud_pll aud_pll(
		.inclk0(Clk),
		.c0(audio_clk)
	);
	
	//分频器，产生提供给WM8731芯片所需的基本工作时钟、音频数据位时钟和声道选择时钟
Audio_Clk_Gen	Audio_Clk_Gen(
		.clock_ref(audio_clk),
		.Rst_n(Rst_n),
		.xck(AUD_XCK),
		.Audio_LRCLK(Audio_LRCLK),
		.bclk(AUD_BCLK)
	);
	defparam	Audio_Clk_Gen.CLOCK_REF = 18432000;
	defparam	Audio_Clk_Gen.CLOCK_SAMPLE = 48000;
	localparam RECORD_MAX_LENGTH = 23'h7fffff;

	//I2S音频采集模块，FPGA使用I2S接口读取WM8731输出的实时音频数据流,仅采集右声道
I2S_Bit_Shift_IN I2S_Bit_Shift_IN(
		.Rst_n(Rst_n),
		.Audio_LRCLK(Audio_LRCLK),
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCDAT(AUD_ADCDAT),
		.ldat(),
		.rdat(rdat)			//adc输入的 16bit 数字数据
	);
	
	//I2S接口输出，将需要输出的音频数据通过I2S接口输出到WM8731芯片	
I2S_Bit_Shift_Out I2S_Bit_Shift_Out(
		.Audio_Data(rdat),///输出数据  数字数据
		.Audio_LRCLK(Audio_LRCLK),
		.AUD_BCLK(AUD_BCLK),
		.AUD_DACDAT(AUD_DACDAT)
	);
assign audio_data = rdat;
endmodule
