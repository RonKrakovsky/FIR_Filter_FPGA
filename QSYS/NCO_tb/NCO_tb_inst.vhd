	component NCO_tb is
		port (
			nco_ii_0_rst_reset_n : in  std_logic                     := 'X';             -- reset_n
			nco_ii_0_clk_clk     : in  std_logic                     := 'X';             -- clk
			nco_ii_0_in_valid    : in  std_logic                     := 'X';             -- valid
			nco_ii_0_in_data     : in  std_logic_vector(15 downto 0) := (others => 'X'); -- data
			nco_ii_0_out_data    : out std_logic_vector(23 downto 0);                    -- data
			nco_ii_0_out_valid   : out std_logic                                         -- valid
		);
	end component NCO_tb;

	u0 : component NCO_tb
		port map (
			nco_ii_0_rst_reset_n => CONNECTED_TO_nco_ii_0_rst_reset_n, -- nco_ii_0_rst.reset_n
			nco_ii_0_clk_clk     => CONNECTED_TO_nco_ii_0_clk_clk,     -- nco_ii_0_clk.clk
			nco_ii_0_in_valid    => CONNECTED_TO_nco_ii_0_in_valid,    --  nco_ii_0_in.valid
			nco_ii_0_in_data     => CONNECTED_TO_nco_ii_0_in_data,     --             .data
			nco_ii_0_out_data    => CONNECTED_TO_nco_ii_0_out_data,    -- nco_ii_0_out.data
			nco_ii_0_out_valid   => CONNECTED_TO_nco_ii_0_out_valid    --             .valid
		);

