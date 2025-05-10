//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/15	version beta2.2a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_CMD_CTRL(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_bb,
	mcb_wr_n,
	mcb_bl,
	mcb_busy,
	i_ready,
	r_ref_req,
	r_ref_alert,
	c_bst_num,
	c_ready,
	c_ref,
	c_act,
	c_rda,
	c_rd,
	c_wra,
	c_wr,
	c_wdat_req
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
input						i_ready;
input						r_ref_req;
input						r_ref_alert;
output	[1:0]				c_bst_num;
output						c_ready;
output						c_ref;
output						c_act;
output						c_rda;
output						c_rd;
output						c_wra;
output						c_wr;
output						c_wdat_req;
// internal wires
wire						c_cmd_cnt_sclr;
wire						c_bst_last;
wire						c_trcd;
// internal registers
reg							c_bst_dir;
reg		[1:0]				c_bst_num;
reg		[1:0]				c_bst_n_cnt;	
reg		[C_CMD_CNT_W-1:0]	c_cmd_cnt;
// memory controller back-end busy signal
assign mcb_busy = ~(c_ready & (~r_ref_alert) & (~mcb_bb));
// cmmmand controller write data request
assign c_wdat_req = (c_act | c_trcd) & (c_cmd_cnt == CtRCDm1) 
						& (c_bst_dir==1'b0);
// request register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		c_bst_dir		<=	0;
		c_bst_num		<=	0;
	end
	else if(mcb_sclr_n == 1'b0) begin
		c_bst_dir		<=	0;
		c_bst_num		<=	0;
	end
	else if(mcb_bb == 1'b1) begin
		c_bst_dir		<=	mcb_wr_n;
		c_bst_num		<=	mcb_bl;
	end
	else begin
		c_bst_dir		<=	c_bst_dir;
		c_bst_num		<=	c_bst_num;
	end
// CMD_FSM instance
MCB_CMD_FSM mcb_cmd_fsm0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.i_ready(i_ready),
	.r_ref_req(r_ref_req),
	.c_bst_dir(c_bst_dir),
	.c_bst_last(c_bst_last),
	.c_cmd_cnt(c_cmd_cnt),
	.c_cmd_cnt_sclr(c_cmd_cnt_sclr),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_trcd(c_trcd),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr)
);
// command control only one burst left signal
assign c_bst_last = (c_bst_num == c_bst_n_cnt);
// command control burst number counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		c_bst_n_cnt		<=	0;
	else if((mcb_sclr_n == 1'b0) | (mcb_bb == 1'b1))
		c_bst_n_cnt		<=	0;
	else if((c_rd == 1'b1) | (c_wr == 1'b1))
		c_bst_n_cnt		<=	c_bst_n_cnt + 2'b01;
	else
		c_bst_n_cnt		<=	c_bst_n_cnt;
// command control command interval counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		c_cmd_cnt		<=	0;
	else if((mcb_sclr_n == 1'b0) | (c_cmd_cnt_sclr == 1'b1))
		c_cmd_cnt		<=	0;
	else
		c_cmd_cnt		<=	c_cmd_cnt + {{(C_CMD_CNT_W-1){1'b0}}, 1'b1};
endmodule
