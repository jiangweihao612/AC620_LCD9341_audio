	mysystem u0 (
		.clk_clk          (<connected-to-clk_clk>),          //       clk.clk
		.reset_reset_n    (<connected-to-reset_reset_n>),    //     reset.reset_n
		.lcd_rst_export   (<connected-to-lcd_rst_export>),   //   lcd_rst.export
		.lcd_bl_export    (<connected-to-lcd_bl_export>),    //    lcd_bl.export
		.sdram_clk_clk    (<connected-to-sdram_clk_clk>),    // sdram_clk.clk
		.sdram_addr       (<connected-to-sdram_addr>),       //     sdram.addr
		.sdram_ba         (<connected-to-sdram_ba>),         //          .ba
		.sdram_cas_n      (<connected-to-sdram_cas_n>),      //          .cas_n
		.sdram_cke        (<connected-to-sdram_cke>),        //          .cke
		.sdram_cs_n       (<connected-to-sdram_cs_n>),       //          .cs_n
		.sdram_dq         (<connected-to-sdram_dq>),         //          .dq
		.sdram_dqm        (<connected-to-sdram_dqm>),        //          .dqm
		.sdram_ras_n      (<connected-to-sdram_ras_n>),      //          .ras_n
		.sdram_we_n       (<connected-to-sdram_we_n>),       //          .we_n
		.lcd_wr_n         (<connected-to-lcd_wr_n>),         //       lcd.wr_n
		.lcd_rd_n         (<connected-to-lcd_rd_n>),         //          .rd_n
		.lcd_data         (<connected-to-lcd_data>),         //          .data
		.lcd_rs           (<connected-to-lcd_rs>),           //          .rs
		.lcd_cs_n         (<connected-to-lcd_cs_n>),         //          .cs_n
		.uart_0_rxd       (<connected-to-uart_0_rxd>),       //    uart_0.rxd
		.uart_0_txd       (<connected-to-uart_0_txd>),       //          .txd
		.epcs_dclk        (<connected-to-epcs_dclk>),        //      epcs.dclk
		.epcs_sce         (<connected-to-epcs_sce>),         //          .sce
		.epcs_sdo         (<connected-to-epcs_sdo>),         //          .sdo
		.epcs_data0       (<connected-to-epcs_data0>),       //          .data0
		.pio_audio_export (<connected-to-pio_audio_export>)  // pio_audio.export
	);

