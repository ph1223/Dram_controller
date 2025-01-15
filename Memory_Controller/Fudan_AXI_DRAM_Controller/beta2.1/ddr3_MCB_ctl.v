//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 SDRAM Controller,control module
//
//	2013/04/23	version beta2.0
//
//  luyanheng
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_ctl(
	ddr3_mcb_clk,
	ddr3_mcb_rst_n,
    init_begin,

	ddr3_mcb_bb,
    row_hit,
    row_miss,
    row_empty,
	ddr3_mcb_wr_n,
//	ddr3_mcb_bl,
	ddr3_mcb_busy,
	ddr3_mcb_rdat_vld,
	ddr3_mcb_wdat_req,
    
	i_lmr0,
    i_lmr1,
    i_lmr2,
    i_lmr3,
    i_cke,
    i_odt,
    i_zq,
    i_rst,
	i_ready,
    i_cmd,
    
    c_prea,
	c_ref,
    c_prec,
	c_act,
//	c_rda,
	c_rd,
//	c_wra,
	c_wr,

	d_dp_ie,
	d_dp_oe,
	d_wr_ld
);

// interface signals
    input						ddr3_mcb_clk;
    input						ddr3_mcb_rst_n;
    input                       init_begin;

    input						ddr3_mcb_bb;
    input                       row_hit;
    input                       row_miss;
    input                       row_empty;
    input						ddr3_mcb_wr_n;
//    input	[1:0]				ddr3_mcb_bl;
    output						ddr3_mcb_busy;
    output						ddr3_mcb_rdat_vld;
    output						ddr3_mcb_wdat_req;
    
    output                      i_odt;
    output                      i_rst;
    output                      i_cke;
    output                      i_ready;
    output                      i_lmr0;
    output                      i_lmr1;
    output                      i_lmr2;
    output                      i_lmr3;
    output                      i_zq;
    output                      i_cmd;
    
    output                      c_prea;
    output						c_ref;
    output                      c_prec;
    output						c_act;
//    output						c_rda;
    output						c_rd;
//    output						c_wra;
    output						c_wr;
    output						d_dp_ie;
    output						d_dp_oe;
    output						d_wr_ld;
// internal wires
    wire						c_ready;
//    wire	[1:0]				c_bst_num;
    wire						c_wdat_req;
    wire						ref_req;
    wire						ref_alert;
// INI_CTRL instance
ddr3_mcb_init ddr3_mcb_init0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    .init_begin(init_begin),

	.i_odt(i_odt),
	.i_rst(i_rst),
    .i_cke(i_cke),
    .i_cmd(i_cmd),
    .i_zq(i_zq),
	.i_lmr0(i_lmr0),
    .i_lmr1(i_lmr1),
    .i_lmr2(i_lmr2),
    .i_lmr3(i_lmr3),
	.i_ready(i_ready)
);
// CMD_CTRL instance
ddr3_mcb_cmd_ctl ddr3_mcb_cmd_ctl0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),

	.ddr3_mcb_bb(ddr3_mcb_bb),
    .row_hit(row_hit),
    .row_miss(row_miss),
    .row_empty(row_empty),
	.ddr3_mcb_wr_n(ddr3_mcb_wr_n),
//	.ddr3_mcb_bl(ddr3_mcb_bl),
	.ddr3_mcb_busy(ddr3_mcb_busy),
    
	.i_ready(i_ready),
	.ref_req(ref_req),
	.ref_alert(ref_alert),
    
//	.c_bst_num(c_bst_num),
	.c_ready(c_ready),
    .c_prea(c_prea),
	.c_ref(c_ref),
    .c_prec(c_prec),
	.c_act(c_act),
//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr),
	.c_wdat_req(c_wdat_req)
);
// REF_CTRL instance
ddr3_mcb_ref_ctl ddr3_mcb_ref_ctl0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),

	.i_ready(i_ready),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.ref_req(ref_req),
	.ref_alert(ref_alert)
);
// DAT_CTRL instance
ddr3_mcb_dat_ctl ddr3_mcb_dat_ctl0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),

	.ddr3_mcb_rdat_vld(ddr3_mcb_rdat_vld),
	.ddr3_mcb_wdat_req(ddr3_mcb_wdat_req),
    
//	.c_bst_num(c_bst_num),
//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr),
	.c_wdat_req(c_wdat_req),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld)
);
endmodule