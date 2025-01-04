//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 SDRAM Controller,data control module
//
//	2013/04/24	version beta2.0
//
//  luyanheng
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_dat_ctl(
	ddr3_mcb_clk,
	ddr3_mcb_rst_n,

	ddr3_mcb_rdat_vld,
	ddr3_mcb_wdat_req,
//	c_bst_num,
//	c_rda,
	c_rd,
//	c_wra,
	c_wr,
	c_wdat_req,
	d_dp_ie,
	d_dp_oe,
	d_wr_ld
);
`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
// interface signals
input						ddr3_mcb_clk;
input						ddr3_mcb_rst_n;

output						ddr3_mcb_rdat_vld;
output						ddr3_mcb_wdat_req;
//input	[1:0]				c_bst_num;
//input						c_rda;
input						c_rd;
//input						c_wra;
input						c_wr;
input						c_wdat_req;
output						d_dp_ie;
output						d_dp_oe;
output						d_wr_ld;

// internal wires
wire						d_cl_cnt_sclr;
wire						d_bl_cnt_sclr;
// internal registers
reg							ddr3_mcb_rdat_vld;
reg		[1:0]				d_bst_num;
reg		[D_CL_CNT_W-1:0]	d_cl_cnt;
reg		[D_BL_CNT_W-1:0]	d_bl_cnt;

// d_wr_ld signal
assign d_wr_ld = c_wr | (d_dp_oe & (~(d_bl_cnt == 2'b11)));
// mcb_wdat_req signal
assign ddr3_mcb_wdat_req = c_wdat_req | c_wr | (d_dp_oe & (~(d_bl_cnt[D_BL_CNT_W-1:1] == 1'b1)));
    
// mcb_rdat_vld register
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0)
		ddr3_mcb_rdat_vld	<=	1'b0;
	else
		ddr3_mcb_rdat_vld	<=	d_dp_ie;

// DAT_FSM instance
ddr3_mcb_dat_ctl_fsm ddr3_mcb_dat_ctl_fsm0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),

//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr),
//	.d_bst_num(d_bst_num),
	.d_cl_cnt(d_cl_cnt),
	.d_bl_cnt(d_bl_cnt),
	.d_cl_cnt_sclr(d_cl_cnt_sclr),
	.d_bl_cnt_sclr(d_bl_cnt_sclr),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe)
);

// data control burst number register
//always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
//	if(ddr3_mcb_rst_n == 1'b0)
//		d_bst_num		<=	0;
//	else if((c_rda == 1'b1) | (c_rd == 1'b1) | (c_wra == 1'b1) | (c_wr == 1'b1))
//		d_bst_num		<=	c_bst_num;
//	else
//		d_bst_num		<=	d_bst_num;		
// data control cas latency counter
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0)
		d_cl_cnt		<=	0;
	else if(d_cl_cnt_sclr == 1'b1)
		d_cl_cnt		<=	0;
	else
		d_cl_cnt		<=	d_cl_cnt + 'd1;
// data control mcb burst length counter
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0)
		d_bl_cnt		<=	0;
	else if(d_bl_cnt_sclr == 1'b1)
		d_bl_cnt		<=	0;
	else
		d_bl_cnt		<=	d_bl_cnt + 'd1;
endmodule