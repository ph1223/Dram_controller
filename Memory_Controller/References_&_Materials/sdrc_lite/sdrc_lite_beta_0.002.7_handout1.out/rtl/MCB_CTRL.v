//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/13	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_CTRL(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_bb,
	mcb_wr_n,
	mcb_bl,
	mcb_busy,
	mcb_rdat_vld,
	mcb_wdat_req,
	i_prea,
	i_ref,
	i_lmr,
	i_ready,
	c_ref,
	c_act,
	c_rda,
	c_rd,
	c_wra,
	c_wr,
	d_dp_ie,
	d_dp_oe,
	d_wr_ld
);
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						mcb_bb;
input						mcb_wr_n;
input	[1:0]				mcb_bl;
output						mcb_busy;
output						mcb_rdat_vld;
output						mcb_wdat_req;
output						i_prea;
output						i_ref;
output						i_lmr;
output						i_ready;
output						c_ref;
output						c_act;
output						c_rda;
output						c_rd;
output						c_wra;
output						c_wr;
output						d_dp_ie;
output						d_dp_oe;
output						d_wr_ld;
// internal wires
wire						c_ready;
wire	[1:0]				c_bst_num;
wire						c_wdat_req;
wire						r_ref_req;
wire						r_ref_alert;
// INI_CTRL instance
MCB_INI_CTRL mcb_ini_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.i_prea(i_prea),
	.i_ref(i_ref),
	.i_lmr(i_lmr),
	.i_ready(i_ready)
);
// CMD_CTRL instance
MCB_CMD_CTRL mcb_cmd_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_busy(mcb_busy),
	.i_ready(i_ready),
	.r_ref_req(r_ref_req),
	.r_ref_alert(r_ref_alert),
	.c_bst_num(c_bst_num),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.c_wdat_req(c_wdat_req)
);
// REF_CTRL instance
MCB_REF_CTRL mcb_ref_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.i_ready(i_ready),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.r_ref_req(r_ref_req),
	.r_ref_alert(r_ref_alert)
);
// DAT_CTRL instance
MCB_DAT_CTRL mcb_dat_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.c_bst_num(c_bst_num),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.c_wdat_req(c_wdat_req),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld)
);
endmodule
