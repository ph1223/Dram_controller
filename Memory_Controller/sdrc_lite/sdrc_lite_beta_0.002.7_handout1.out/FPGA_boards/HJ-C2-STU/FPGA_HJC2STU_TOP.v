//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end : FPGA test
//
//	2012/05/12	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module FPGA_HJC2STU_TOP(
	clk_in,
	sys_rst_n,
	sys_led,
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
input						clk_in;				// 20MHz
input						sys_rst_n;
output	[5-1:0]				sys_led;									
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
wire	[16-1:0]			sys_cmp;
wire						mcb_clk;
wire						mcb_rst_n;
wire						mcb_sclr_n;
wire						mcb_bb;
wire						mcb_wr_n;
wire	[1:0]				mcb_bl;
wire	[2-1:0]				mcb_ba;
wire	[12-1:0]			mcb_ra;
wire	[8-1:0]				mcb_ca;
wire						mcb_busy;
wire						mcb_rdat_vld;
wire						mcb_wdat_req;
wire	[16-1:0]			mcb_rdat;
wire	[16-1:0]			mcb_wdat;
wire						mcb_i_ready;
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
// Write-Read-Compare Tester
FPGA_TST_WRRDCMP fpga_tst_wrrdcmp0(
	.sys_clk(sys_clk),
	.sys_rst_n(sys_rst_n),
	.sys_cmp(sys_cmp),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat)
);
// MCB_CORE instance
MCB_TOP mcb_top0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat),
	.mcb_i_ready(mcb_i_ready),
	.sdr_cke(sdr_cke),
	.sdr_cs_n(sdr_cs_n),
	.sdr_ras_n(sdr_ras_n),
	.sdr_cas_n(sdr_cas_n),
	.sdr_we_n(sdr_we_n),
	.sdr_dqm(sdr_dqm),
	.sdr_ba(sdr_ba),
	.sdr_addr(sdr_addr),
	.dbf_dq_ie(dbf_dq_ie),
	.dbf_dq_i(dbf_dq_i),
	.dbf_dq_oe(dbf_dq_oe),
	.dbf_dq_o(dbf_dq_o)
);
// mcb signals
assign mcb_clk		= sys_clk;
assign mcb_rst_n	= sys_rst_n;
assign mcb_sclr_n	= 1'b1;
// Dq tristate
assign dbf_dq_i		= dbf_dq_ie ? sdr_dq : {16{1'b0}};
assign sdr_dq		= dbf_dq_oe ? dbf_dq_o : {16{1'bz}};
// LEDs
assign sys_led[0]	= (sys_cmp[4-1:0] == 4'b1111);
assign sys_led[1]	= (sys_cmp[8-1:4] == 4'b1111);
assign sys_led[2]	= (sys_cmp[12-1:8] == 4'b1111);
assign sys_led[3]	= (sys_cmp[16-1:12] == 4'b1111);
assign sys_led[4]	= mcb_i_ready;
endmodule
