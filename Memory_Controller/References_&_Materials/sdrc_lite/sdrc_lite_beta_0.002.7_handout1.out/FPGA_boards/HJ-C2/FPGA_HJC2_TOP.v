module FPGA_HJC2_TOP(
	clk_in,
	sys_rst_n,
//	sys_led,
	sdr_clk,
	sdr_cke,
	sdr_cs_n,
	sdr_ras_n,
	sdr_cas_n,
	sdr_we_n,
	sdr_dqm,
	sdr_ba,
	sdr_addr,
	sdr_dq
);
// interface signals
input						clk_in;				//20MHz
input						sys_rst_n;
//output	[5-1:0]				sys_led;									
output						sdr_clk;
output						sdr_cke;
output						sdr_cs_n;
output						sdr_ras_n;
output						sdr_cas_n;
output						sdr_we_n;
output	[2-1:0]				sdr_dqm;
output	[2-1:0]				sdr_ba;
output	[12-1:0]			sdr_addr;
inout	[16-1:0]			sdr_dq;
// internal wires
wire						sys_clk;
wire						dbf_dq_ie;
wire	[16-1:0]			dbf_dq_i;
wire						dbf_dq_oe;
wire	[16-1:0]			dbf_dq_o;
// PLL core (typically c1 should have -3ns phase shift from c0)
MC_PLL mc_pll0(
	.inclk0(clk_in),
	.c0(sys_clk),
	.c1(sdr_clk)
);
// SOPC system
sopc_sys_one sopc_sys_one_inst(
	.reset_n                                 (sys_rst_n),
	.clk_0                                   (sys_clk),
	.coe_dbf_dq_i_to_the_MCB_AVL_IP_TOP_0    (dbf_dq_i),
	.coe_dbf_dq_ie_from_the_MCB_AVL_IP_TOP_0 (dbf_dq_ie),
	.coe_dbf_dq_o_from_the_MCB_AVL_IP_TOP_0  (dbf_dq_o),
	.coe_dbf_dq_oe_from_the_MCB_AVL_IP_TOP_0 (dbf_dq_oe),
	.coe_sdr_addr_from_the_MCB_AVL_IP_TOP_0  (sdr_addr),
	.coe_sdr_ba_from_the_MCB_AVL_IP_TOP_0    (sdr_ba),
	.coe_sdr_cas_n_from_the_MCB_AVL_IP_TOP_0 (sdr_cas_n),
	.coe_sdr_cke_from_the_MCB_AVL_IP_TOP_0   (sdr_cke),
	.coe_sdr_cs_n_from_the_MCB_AVL_IP_TOP_0  (sdr_cs_n),
	.coe_sdr_dqm_from_the_MCB_AVL_IP_TOP_0   (sdr_dqm),
	.coe_sdr_ras_n_from_the_MCB_AVL_IP_TOP_0 (sdr_ras_n),
	.coe_sdr_we_n_from_the_MCB_AVL_IP_TOP_0  (sdr_we_n)
);
// Dq tristate
assign dbf_dq_i		= dbf_dq_ie ? sdr_dq : {16{1'b0}};
assign sdr_dq		= dbf_dq_oe ? dbf_dq_o : {16{1'bz}};
// LEDs
endmodule
