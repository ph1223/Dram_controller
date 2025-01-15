//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/02	version beta2.2c
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_TOP(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_bb,
	mcb_wr_n,
	mcb_bl,
	mcb_ba,
	mcb_ra,
	mcb_ca,
	mcb_busy,
	mcb_rdat_vld,
	mcb_wdat_req,
	mcb_rdat,
	mcb_wdat,
	mcb_wbe,
	mcb_i_ready,
	sdr_cke,
	sdr_cs_n,
	sdr_ras_n,
	sdr_cas_n,
	sdr_we_n,
	sdr_dqm,
	sdr_ba,
	sdr_addr,
	dbf_dq_ie,
	dbf_dq_i,
	dbf_dq_oe,
	dbf_dq_o
);
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// memory controller back-end interface
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						mcb_bb;
input						mcb_wr_n;
input	[1:0]				mcb_bl;
input	[MCB_B_W-1:0]		mcb_ba;
input	[MCB_R_W-1:0]		mcb_ra;
input	[MCB_C_W-1:0]		mcb_ca;
output						mcb_busy;
output						mcb_rdat_vld;
output						mcb_wdat_req;
output	[MCB_D_W-1:0]		mcb_rdat;
input	[MCB_D_W-1:0]		mcb_wdat;
input	[MCB_BE_W-1:0]		mcb_wbe;
output						mcb_i_ready;
// sdram interface
output						sdr_cke;
output						sdr_cs_n;
output						sdr_ras_n;
output						sdr_cas_n;
output						sdr_we_n;
output	[SDR_M_W-1:0]		sdr_dqm;
output	[SDR_B_W-1:0]		sdr_ba;
output	[SDR_A_W-1:0]		sdr_addr;
// sdram data buffer interface
output						dbf_dq_ie;
input	[SDR_D_W-1:0]		dbf_dq_i;
output						dbf_dq_oe;
output	[SDR_D_W-1:0]		dbf_dq_o;
// internal wires
wire						i_prea;
wire						i_ref;
wire						i_lmr;
wire						i_ready;
wire						c_ref;
wire						c_act;
wire						c_rda;
wire						c_rd;
wire						c_wra;
wire						c_wr;
wire						d_dp_ie;
wire						d_dp_oe;
wire						d_wr_ld;
// ini ready signal
assign mcb_i_ready = i_ready;
// MCB_CTRL instance
MCB_CTRL mcb_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.i_prea(i_prea),
	.i_ref(i_ref),
	.i_lmr(i_lmr),
	.i_ready(i_ready),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld)
);
// SIG_FF instance
MCB_SIG_FF mcb_sig_ff0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.i_prea(i_prea),
	.i_ref(i_ref),
	.i_lmr(i_lmr),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.sdr_cke(sdr_cke),
	.sdr_cs_n(sdr_cs_n),
	.sdr_ras_n(sdr_ras_n),
	.sdr_cas_n(sdr_cas_n),
	.sdr_we_n(sdr_we_n),
	.sdr_ba(sdr_ba),
	.sdr_addr(sdr_addr)
);
// DAT_FF instance
MCB_DAT_FF mcb_dat_ff0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_wbe(mcb_wbe),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat),
	.i_ready(i_ready),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld),
	.dbf_dq_ie(dbf_dq_ie),
	.dbf_dq_i(dbf_dq_i),
	.dbf_dq_oe(dbf_dq_oe),
	.dbf_dq_o(dbf_dq_o),
	.sdr_dqm(sdr_dqm)
);
endmodule
