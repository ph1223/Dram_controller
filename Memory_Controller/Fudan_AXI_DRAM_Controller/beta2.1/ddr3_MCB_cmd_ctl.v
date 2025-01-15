//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 SDRAM Controller,command control module
//
//	2013/04/24	version beta2.0
//
//  luyanheng
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_cmd_ctl(
	ddr3_mcb_clk,
	ddr3_mcb_rst_n,

	ddr3_mcb_bb,
    row_hit,
    row_miss,
    row_empty,
	ddr3_mcb_wr_n,
//	ddr3_mcb_bl,
	ddr3_mcb_busy,
    
	i_ready,
	ref_req,
	ref_alert,
    
//	c_bst_num,
	c_ready,
    c_prea,
	c_ref,
    c_prec,
	c_act,
//	c_rda,
	c_rd,
//	c_wra,
	c_wr,
	c_wdat_req
);
`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
// interface signals
input						ddr3_mcb_clk;
input						ddr3_mcb_rst_n;

input						ddr3_mcb_bb;
input                       row_hit;
input                       row_miss;
input                       row_empty;
input						ddr3_mcb_wr_n;
//input	[1:0]				ddr3_mcb_bl;
output						ddr3_mcb_busy;

input						i_ready;
input						ref_req;
input						ref_alert;

//output	[1:0]				c_bst_num;
output						c_ready;
output                      c_prea;
output						c_ref;
output                      c_prec;
output						c_act;
//output						c_rda;
output						c_rd;
//output						c_wra;
output						c_wr;
output						c_wdat_req;
// internal wires
wire						c_cmd_cnt_sclr;
//wire						c_bst_last;
wire						c_trcd;
// internal registers
reg							c_bst_dir;
//reg		[1:0]				c_bst_num;
//reg		[1:0]				c_bst_n_cnt;	
reg		[C_CMD_CNT_W-1:0]	c_cmd_cnt;

// memory controller back-end busy signal
assign ddr3_mcb_busy = ~(c_ready & (~ref_alert) & (~ddr3_mcb_bb));

// cmmmand controller write data request
assign c_wdat_req = (c_act | c_trcd) & (c_cmd_cnt == CtRCDm1) 
						& (c_bst_dir==1'b0);
// request register
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0) begin
		c_bst_dir		<=	0;
//		c_bst_num		<=	0;
	end
	else if(ddr3_mcb_bb == 1'b1) begin
		c_bst_dir		<=	ddr3_mcb_wr_n;
//		c_bst_num		<=	ddr3_mcb_bl;
	end
	else begin
		c_bst_dir		<=	c_bst_dir;
//		c_bst_num		<=	c_bst_num;
	end
// CMD_FSM instance
ddr3_mcb_cmd_fsm ddr3_mcb_cmd_fsm0(
	.ddr3_mcb_clk(ddr3_mcb_clk),
	.ddr3_mcb_rst_n(ddr3_mcb_rst_n),

//	.ddr3_mcb_bb(ddr3_mcb_bb),
    .row_hit(row_hit),
    .row_miss(row_miss),
    .row_empty(row_empty),
	.i_ready(i_ready),
	.ref_req(ref_req),
    
	.c_bst_dir(c_bst_dir),
//	.c_bst_last(c_bst_last),
	.c_cmd_cnt(c_cmd_cnt),
	.c_cmd_cnt_sclr(c_cmd_cnt_sclr),
    
	.c_ready(c_ready),
    .c_prea(c_prea),
	.c_ref(c_ref),
    .c_prec(c_prec),
	.c_act(c_act),
	.c_trcd(c_trcd),
//	.c_rda(c_rda),
	.c_rd(c_rd),
//	.c_wra(c_wra),
	.c_wr(c_wr)
);
// command control only one burst left signal
//assign c_bst_last = (c_bst_num == c_bst_n_cnt);
// command control burst number counter
//always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
//	if(ddr3_mcb_rst_n == 1'b0)
//		c_bst_n_cnt		<=	0;
//	else if(ddr3_mcb_bb == 1'b1)
//		c_bst_n_cnt		<=	0;
//	else if((c_rd == 1'b1) | (c_wr == 1'b1))
//		c_bst_n_cnt		<=	c_bst_n_cnt + 2'b01;
//	else
//		c_bst_n_cnt		<=	c_bst_n_cnt;
// command control command interval counter
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0)
		c_cmd_cnt		<=	0;
	else if(c_cmd_cnt_sclr == 1'b1)
		c_cmd_cnt		<=	0;
	else
		c_cmd_cnt		<=	c_cmd_cnt + {{(C_CMD_CNT_W-1){1'b0}}, 1'b1};
endmodule