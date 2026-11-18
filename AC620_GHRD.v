
module AC620_GHRD(
	//audio
	
	input 					AUD_ADCDAT,	//ADC数字音频信号输出
	output 					AUD_ADCLRCK,	//ADC采样左/右声道信号
	output 					AUD_BCLK,	//数字音频位时钟
	output 					AUD_DACDAT,	//DAC数字音频数据输入
	output 					AUD_DACLRCK,	//DAC采样左/右声道信号
	output 					AUD_XCK,	//WM8731芯片的主工作时钟
	
	inout 					i2c_sdat,
	output 					i2c_sclk,

	input  wire        clk,                   //               clk.clk
	input  wire        reset_n,               //           reset.reset_n
	output wire        lcd_rst,               //        lcd_rst.export
	output wire        lcd_rd_n,              //           lcd_rd.export
	output wire        lcd_bl,                //         lcd_bl.export
	output wire        lcd_wr_n,              //           lcd_wr.export
	output wire        lcd_rs,                //         lcd_rs.export
	output wire        lcd_cs_n,              //           lcd_cs.export
	inout  wire [15:0] lcd_data,              //           lcd_db.export
	output wire        sdram_clk,             //         sdram_clk.clk
	output wire [11:0] sdram_addr,            //                 sdram.addr
	output wire [1:0]  sdram_ba,              //                      .ba
	output wire        sdram_cas_n,           //                      .cas_n
	output wire        sdram_cke,             //                      .cke
	output wire        sdram_cs_n,            //                      .cs_n
	inout  wire [15:0] sdram_dq,              //                      .dq
	output wire [1:0]  sdram_dqm,             //                      .dqm
	output wire        sdram_ras_n,           //                      .ras_n
	output wire        sdram_we_n,            //                       .we_n
	input  wire        uart_0_rxd,            //                uart_0.rxd
	output wire        uart_0_txd,            //                      .txd
	output wire        epcs_dclk,             //                  epcs.dclk
	output wire        epcs_sce,              //                      .sce
	output wire        epcs_sdo,              //                      .sdo
	input  wire        epcs_data0             //                      .data0
);

wire	[15:0] audio_data;
//wire	[15:0] fft_audio_data;
mysystem u0 (
		.pio_audio_export 						(audio_data),  // pio_audio.export
		
		.clk_clk                           (clk),                      //                 clk.clk
		.reset_reset_n                     (reset_n),                  //             reset.reset_n
      .uart_0_rxd                        (uart_0_rxd),               //                  uart_0.rxd
      .uart_0_txd                        (uart_0_txd),               //                        .txd
      .epcs_dclk                         (epcs_dclk),                //                    epcs.dclk
      .epcs_sce                          (epcs_sce),                 //                        .sce
      .epcs_sdo                          (epcs_sdo),                 //                        .sdo
      .epcs_data0                        (epcs_data0),               //
		.lcd_rst_export                    (lcd_rst),                  //          lcd_rst.export
		.lcd_bl_export                     (lcd_bl),                   //           lcd_bl.export
		.lcd_wr_n                          (lcd_wr_n),                 //                     lcd.wr_n
		.lcd_rd_n                          (lcd_rd_n),                 //                        .rd_n
		.lcd_data                          (lcd_data),                 //                        .data
		.lcd_rs                            (lcd_rs),                   //                        .rs
		.lcd_cs_n                          (lcd_cs_n),                 //
		.sdram_clk_clk                     (sdram_clk),                //           sdram_clk.clk
		.altpll_0_phasedone_conduit_export (), // altpll_0_phasedone_conduit.export
		.altpll_0_locked_conduit_export    (), // altpll_0_locked_conduit.export
		.altpll_0_areset_conduit_export    (), // altpll_0_areset_conduit.export
		.sdram_addr                        (sdram_addr),              //                   sdram.addr
		.sdram_ba                          (sdram_ba),                //                        .ba
		.sdram_cas_n                       (sdram_cas_n),             //                        .cas_n
		.sdram_cke                         (sdram_cke),               //                        .cke
		.sdram_cs_n                        (sdram_cs_n),              //                        .cs_n
		.sdram_dq                          (sdram_dq),                //                        .dq
		.sdram_dqm                         (sdram_dqm),               //                        .dqm
		.sdram_ras_n                       (sdram_ras_n),             //                        .ras_n
		.sdram_we_n                        (sdram_we_n)               //                        .we_n
	);
	//audio
Audio_Record_Play Audio_Record_Play_inst(
		
		.audio_data		(audio_data),
		.Clk				(clk),
		.Rst_n			(reset_n),
		.AUD_ADCDAT		(AUD_ADCDAT),
		.AUD_ADCLRCK	(AUD_ADCLRCK),
		.AUD_BCLK		(AUD_BCLK),
		.AUD_DACDAT		(AUD_DACDAT),
		.AUD_DACLRCK	(AUD_DACLRCK),
		.AUD_XCK			(AUD_XCK),
		.i2c_sdat		(i2c_sdat),
		.i2c_sclk		(i2c_sclk)
);
//fft
//audio_fft u0 (
//		.clk          (clk),          //    clk.clk
//		.reset_n      (reset_n),      //    rst.reset_n
//		.sink_valid   (1'b1),   //   sink.sink_valid
//		.sink_ready   (1'b1),   //       .sink_ready
//		.sink_error   (0),   //       .sink_error
//		.sink_sop     (<connected-to-sink_sop>),     //       .sink_sop
//		.sink_eop     (<connected-to-sink_eop>),     //       .sink_eop
//		.sink_real    (audio_data),    //       .sink_real
//		.sink_imag    (audio_data),    //       .sink_imag
//		.fftpts_in    (1023),    //       .fftpts_in
//		.inverse      (0),      //       .inverse
//		.source_valid (1'b1), // source.source_valid
//		.source_ready (1'b1), //       .source_ready
//		.source_error (0), //       .source_error
//		.source_sop   (<connected-to-source_sop>),   //       .source_sop
//		.source_eop   (<connected-to-source_eop>),   //       .source_eop
//		.source_real  (fft_audio_data),  //       .source_real
//		.source_imag  (fft_audio_data),  //       .source_imag
//		.fftpts_out   (1023)    //       .fftpts_out
//	);
endmodule
