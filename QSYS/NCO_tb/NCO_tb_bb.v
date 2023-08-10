
module NCO_tb (
	nco_ii_0_rst_reset_n,
	nco_ii_0_clk_clk,
	nco_ii_0_in_valid,
	nco_ii_0_in_data,
	nco_ii_0_out_data,
	nco_ii_0_out_valid);	

	input		nco_ii_0_rst_reset_n;
	input		nco_ii_0_clk_clk;
	input		nco_ii_0_in_valid;
	input	[15:0]	nco_ii_0_in_data;
	output	[23:0]	nco_ii_0_out_data;
	output		nco_ii_0_out_valid;
endmodule
