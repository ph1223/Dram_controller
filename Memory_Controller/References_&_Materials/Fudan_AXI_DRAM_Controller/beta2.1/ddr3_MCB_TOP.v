//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,top module
//
//     2013/04/24   version beta 2.0
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

module ddr3_MCB_TOP(
    ddr3_mcb_clk,
	ddr3_mcb_rst_n,
    init_begin,

//	ddr3_mcb_bb,
    row_hit,
    row_miss,
    row_empty,
	ddr3_mcb_wr_n,
	ddr3_mcb_bl,
	ddr3_mcb_ba,
	ddr3_mcb_ra,
	ddr3_mcb_ca,
	ddr3_mcb_busy,
	ddr3_mcb_rdat_vld,
	ddr3_mcb_wdat_req,
	ddr3_mcb_rdat,
	ddr3_mcb_wdat,
	ddr3_mcb_wbe,
	ddr3_mcb_i_ready,
    
	ddr3_cke,
	ddr3_cs_n,
	ddr3_ras_n,
	ddr3_cas_n,
	ddr3_we_n,
	ddr3_dqm,
    ddr3_dqs_i,
    ddr3_dqs_o,
    ddr3_dqs_n_i,
    ddr3_dqs_n_o,
	ddr3_ba,
	ddr3_addr,
    ddr3_odt,
    ddr3_clk,
    ddr3_clk_n,
    ddr3_rst,
    
	dbf_dq_ie,
	dbf_dq_i,
	dbf_dq_oe,
	dbf_dq_o
);

`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"

    input						ddr3_mcb_clk;
    input						ddr3_mcb_rst_n;
    input                       init_begin;
    
//    input						ddr3_mcb_bb;
    input                       row_hit;
    input                       row_miss;
    input                       row_empty;
    input						ddr3_mcb_wr_n;
    input	[1:0]				ddr3_mcb_bl;
    input	[MCB_B_W-1:0]		ddr3_mcb_ba;
    input	[MCB_R_W-1:0]		ddr3_mcb_ra;
    input	[MCB_C_W-1:0]		ddr3_mcb_ca;
    output						ddr3_mcb_busy;
    output						ddr3_mcb_rdat_vld;
    output						ddr3_mcb_wdat_req;
    output	[MCB_D_W-1:0]		ddr3_mcb_rdat;
    input	[MCB_D_W-1:0]		ddr3_mcb_wdat;
    input	[MCB_BE_W-1:0]		ddr3_mcb_wbe;
    output						ddr3_mcb_i_ready;
// ddr3 sdram interface
	output                      ddr3_clk;
    output                      ddr3_clk_n;

    output						ddr3_cke;
    output						ddr3_cs_n;
    output						ddr3_ras_n;
    output						ddr3_cas_n;
    output						ddr3_we_n;
    output	[SDR_B_W-1:0]		ddr3_ba;
    output	[SDR_A_W-1:0]		ddr3_addr;
    output                      ddr3_odt;
    output                      ddr3_rst;
//    output                      ddr3_tdqs_n;
    input                       ddr3_dqs_i;
    output                      ddr3_dqs_o;
    input                       ddr3_dqs_n_i;
    output                      ddr3_dqs_n_o;
	output	[SDR_M_W-1:0]		ddr3_dqm;
    
// ddr3 sdram data buffer interface
    output						dbf_dq_ie;
    input	[SDR_D_W-1:0]		dbf_dq_i;

    output						dbf_dq_oe;
    output	[SDR_D_W-1:0]		dbf_dq_o;
    
    wire                        ddr3_mcb_bb;
    
// internal wires
    wire						i_lmr0;
	 wire						i_lmr1;
	 wire						i_lmr2;
	 wire						i_lmr3;
    wire						i_ready;
	 wire						i_zq;
	 wire						i_cke;
	 wire						i_cmd;
	 wire						i_odt;
	 wire						i_rst;
	
    wire                        c_pera;    
    wire						c_ref;
    wire                        c_prec;
    wire						c_act;
//    wire						c_rda;
    wire						c_rd;
//    wire						c_wra;
    wire						c_wr;
	 
    wire						d_dp_ie;
    wire						d_dp_oe;
    wire						d_wr_ld;
// ini ready signal
    assign ddr3_mcb_i_ready = i_ready;
	assign ddr3_clk = ddr3_mcb_clk;
	assign ddr3_clk_n = ~ddr3_mcb_clk;
    assign ddr3_mcb_bb = row_hit || row_miss || row_empty;
// MCB_CTRL instance
ddr3_mcb_ctl ddr3_mcb_ctl0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    .init_begin(init_begin),
    
	.ddr3_mcb_bb(ddr3_mcb_bb),
    .row_hit(row_hit),
    .row_miss(row_miss),
    .row_empty(row_empty),
	.ddr3_mcb_wr_n(ddr3_mcb_wr_n),
//	.ddr3_mcb_bl(ddr3_mcb_bl),
	.ddr3_mcb_busy(ddr3_mcb_busy),
	.ddr3_mcb_rdat_vld(ddr3_mcb_rdat_vld),
	.ddr3_mcb_wdat_req(ddr3_mcb_wdat_req),

	.i_lmr0(i_lmr0),
    .i_lmr1(i_lmr1),
    .i_lmr2(i_lmr2),
    .i_lmr3(i_lmr3),
	.i_ready(i_ready),
    .i_zq(i_zq),
    .i_cke(i_cke),
    .i_odt(i_odt),
    .i_rst(i_rst),
    .i_cmd(i_cmd),
    
    .c_prea(c_prea),
	.c_ref(c_ref),
    .c_prec(c_prec),
	.c_act(c_act),
//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld)
);
// SIG_FF instance
ddr3_mcb_sig_ff ddr3_mcb_sig_ff0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
	.ddr3_mcb_bb(ddr3_mcb_bb),
	.ddr3_mcb_ba(ddr3_mcb_ba),
	.ddr3_mcb_ra(ddr3_mcb_ra),
	.ddr3_mcb_ca(ddr3_mcb_ca),
    
	.i_lmr0(i_lmr0),
    .i_lmr1(i_lmr1),
    .i_lmr2(i_lmr2),
    .i_lmr3(i_lmr3),
    .i_zq(i_zq),
    .i_cke(i_cke),
    .i_odt(i_odt),
    .i_rst(i_rst),
    .i_cmd(i_cmd),
  
    .c_prea(c_prea),
    .c_ref(c_ref),
    .c_prec(c_prec),
	.c_act(c_act),
//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr),

	.ddr3_rst(ddr3_rst),
	.ddr3_odt(ddr3_odt),
	.ddr3_cke(ddr3_cke),
	.ddr3_cs_n(ddr3_cs_n),
	.ddr3_ras_n(ddr3_ras_n),
	.ddr3_cas_n(ddr3_cas_n),
	.ddr3_we_n(ddr3_we_n),
	.ddr3_ba(ddr3_ba),
	.ddr3_addr(ddr3_addr)
);
// DAT_FF instance
ddr3_mcb_dat_f ddr3_mcb_dat_f0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_clk_n(ddr3_clk_n),//
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
	.ddr3_mcb_wbe(ddr3_mcb_wbe),
	.ddr3_mcb_rdat(ddr3_mcb_rdat),
	.ddr3_mcb_wdat(ddr3_mcb_wdat),
	
	.i_ready(i_ready),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld),
	
	.dbf_dq_ie(dbf_dq_ie),
	.dbf_dq_i(dbf_dq_i),
	.dbf_dq_oe(dbf_dq_oe),
	.dbf_dq_o(dbf_dq_o),
	.ddr3_dqm(ddr3_dqm),
    
    .ddr3_dqs_o(ddr3_dqs_o),//
    .ddr3_dqs_i(ddr3_dqs_i),//
    .ddr3_dqs_n_o(ddr3_dqs_n_o),//
    .ddr3_dqs_n_i(ddr3_dqs_n_i)//
);
endmodule