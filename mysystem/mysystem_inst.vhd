	component mysystem is
		port (
			clk_clk          : in    std_logic                     := 'X';             -- clk
			reset_reset_n    : in    std_logic                     := 'X';             -- reset_n
			lcd_rst_export   : out   std_logic;                                        -- export
			lcd_bl_export    : out   std_logic;                                        -- export
			sdram_clk_clk    : out   std_logic;                                        -- clk
			sdram_addr       : out   std_logic_vector(11 downto 0);                    -- addr
			sdram_ba         : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n      : out   std_logic;                                        -- cas_n
			sdram_cke        : out   std_logic;                                        -- cke
			sdram_cs_n       : out   std_logic;                                        -- cs_n
			sdram_dq         : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm        : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n      : out   std_logic;                                        -- ras_n
			sdram_we_n       : out   std_logic;                                        -- we_n
			lcd_wr_n         : out   std_logic;                                        -- wr_n
			lcd_rd_n         : out   std_logic;                                        -- rd_n
			lcd_data         : inout std_logic_vector(15 downto 0) := (others => 'X'); -- data
			lcd_rs           : out   std_logic;                                        -- rs
			lcd_cs_n         : out   std_logic;                                        -- cs_n
			uart_0_rxd       : in    std_logic                     := 'X';             -- rxd
			uart_0_txd       : out   std_logic;                                        -- txd
			epcs_dclk        : out   std_logic;                                        -- dclk
			epcs_sce         : out   std_logic;                                        -- sce
			epcs_sdo         : out   std_logic;                                        -- sdo
			epcs_data0       : in    std_logic                     := 'X';             -- data0
			pio_audio_export : in    std_logic_vector(15 downto 0) := (others => 'X')  -- export
		);
	end component mysystem;

	u0 : component mysystem
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --       clk.clk
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --     reset.reset_n
			lcd_rst_export   => CONNECTED_TO_lcd_rst_export,   --   lcd_rst.export
			lcd_bl_export    => CONNECTED_TO_lcd_bl_export,    --    lcd_bl.export
			sdram_clk_clk    => CONNECTED_TO_sdram_clk_clk,    -- sdram_clk.clk
			sdram_addr       => CONNECTED_TO_sdram_addr,       --     sdram.addr
			sdram_ba         => CONNECTED_TO_sdram_ba,         --          .ba
			sdram_cas_n      => CONNECTED_TO_sdram_cas_n,      --          .cas_n
			sdram_cke        => CONNECTED_TO_sdram_cke,        --          .cke
			sdram_cs_n       => CONNECTED_TO_sdram_cs_n,       --          .cs_n
			sdram_dq         => CONNECTED_TO_sdram_dq,         --          .dq
			sdram_dqm        => CONNECTED_TO_sdram_dqm,        --          .dqm
			sdram_ras_n      => CONNECTED_TO_sdram_ras_n,      --          .ras_n
			sdram_we_n       => CONNECTED_TO_sdram_we_n,       --          .we_n
			lcd_wr_n         => CONNECTED_TO_lcd_wr_n,         --       lcd.wr_n
			lcd_rd_n         => CONNECTED_TO_lcd_rd_n,         --          .rd_n
			lcd_data         => CONNECTED_TO_lcd_data,         --          .data
			lcd_rs           => CONNECTED_TO_lcd_rs,           --          .rs
			lcd_cs_n         => CONNECTED_TO_lcd_cs_n,         --          .cs_n
			uart_0_rxd       => CONNECTED_TO_uart_0_rxd,       --    uart_0.rxd
			uart_0_txd       => CONNECTED_TO_uart_0_txd,       --          .txd
			epcs_dclk        => CONNECTED_TO_epcs_dclk,        --      epcs.dclk
			epcs_sce         => CONNECTED_TO_epcs_sce,         --          .sce
			epcs_sdo         => CONNECTED_TO_epcs_sdo,         --          .sdo
			epcs_data0       => CONNECTED_TO_epcs_data0,       --          .data0
			pio_audio_export => CONNECTED_TO_pio_audio_export  -- pio_audio.export
		);

