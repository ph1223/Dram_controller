//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/14	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_DAT_CTRL(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_rdat_vld,
	mcb_wdat_req,
	c_bst_num,
	c_rda,
	c_rd,
	c_wra,
	c_wr,
	c_wdat_req,
	d_dp_ie,
	d_dp_oe,
	d_wr_ld
);
`include "./SDRC_LITE_MCB_PAR.vh"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
output						mcb_rdat_vld;
output						mcb_wdat_req;
input	[1:0]				c_bst_num;
input						c_rda;
input						c_rd;
input						c_wra;
input						c_wr;
input						c_wdat_req;
output						d_dp_ie;
output						d_dp_oe;
output						d_wr_ld;
// internal wires
wire						d_cl_cnt_sclr;
wire						d_bl_cnt_sclr;
// internal registers
reg							mcb_rdat_vld;
reg		[1:0]				d_bst_num;
reg		[D_CL_CNT_W-1:0]	d_cl_cnt;
reg		[D_BL_CNT_W-1:0]	d_bl_cnt;
// d_wr_ld signal
assign d_wr_ld = c_wra | c_wr | 
	(d_dp_oe & (~(d_bl_cnt == {c_bst_num, 2'b11})));
// mcb_wdat_req signal
assign mcb_wdat_req = c_wdat_req | c_wra | c_wr | 
	(d_dp_oe & (~(d_bl_cnt[D_BL_CNT_W-1:1] == {c_bst_num, 1'b1})));
// mcb_rdat_vld register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		mcb_rdat_vld	<=	1'b0;
	else if(mcb_sclr_n == 1'b0)
		mcb_rdat_vld	<=	1'b0;
	else
		mcb_rdat_vld	<=	d_dp_ie;
// DAT_FSM instance
MCB_DAT_FSM mcb_dat_fsm0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.d_bst_num(d_bst_num),
	.d_cl_cnt(d_cl_cnt),
	.d_bl_cnt(d_bl_cnt),
	.d_cl_cnt_sclr(d_cl_cnt_sclr),
	.d_bl_cnt_sclr(d_bl_cnt_sclr),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe)
);
// data control burst number register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		d_bst_num		<=	0;
	else if(mcb_sclr_n == 1'b0)
		d_bst_num		<=	0;
	else if((c_rda == 1'b1) | (c_rd == 1'b1) | (c_wra == 1'b1) | 
		(c_wr == 1'b1))
		d_bst_num		<=	c_bst_num;
	else
		d_bst_num		<=	d_bst_num;		
// data control cas latency counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		d_cl_cnt		<=	0;
	else if((mcb_sclr_n == 1'b0) | (d_cl_cnt_sclr == 1'b1))
		d_cl_cnt		<=	0;
	else
		d_cl_cnt		<=	d_cl_cnt + {{(D_CL_CNT_W-1){1'b0}}, 1'b1};
// data control mcb burst length counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		d_bl_cnt		<=	0;
	else if((mcb_sclr_n == 1'b0) | (d_bl_cnt_sclr == 1'b1))
		d_bl_cnt		<=	0;
	else
		d_bl_cnt		<=	d_bl_cnt + {{(D_BL_CNT_W-1){1'b0}}, 1'b1};
endmodule
