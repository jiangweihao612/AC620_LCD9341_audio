
module mysystem (
	clk_clk,
	reset_reset_n,
	lcd_rst_export,
	lcd_bl_export,
	sdram_clk_clk,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	lcd_wr_n,
	lcd_rd_n,
	lcd_data,
	lcd_rs,
	lcd_cs_n,
	uart_0_rxd,
	uart_0_txd,
	epcs_dclk,
	epcs_sce,
	epcs_sdo,
	epcs_data0,
	pio_audio_export);	

	input		clk_clk;
	input		reset_reset_n;
	output		lcd_rst_export;
	output		lcd_bl_export;
	output		sdram_clk_clk;
	output	[11:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		lcd_wr_n;
	output		lcd_rd_n;
	inout	[15:0]	lcd_data;
	output		lcd_rs;
	output		lcd_cs_n;
	input		uart_0_rxd;
	output		uart_0_txd;
	output		epcs_dclk;
	output		epcs_sce;
	output		epcs_sdo;
	input		epcs_data0;
	input	[15:0]	pio_audio_export;
endmodule
