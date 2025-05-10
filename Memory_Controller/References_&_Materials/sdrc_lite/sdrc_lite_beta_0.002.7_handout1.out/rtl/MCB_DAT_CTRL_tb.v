//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/13	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_DAT_CTRL_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
wire						mcb_rdat_vld;
wire						mcb_wdat_req;
reg		[1:0]				c_bst_num;
reg							c_rda;
reg							c_rd;
reg							c_wra;
reg							c_wr;
reg							c_wdat_req;
wire						d_dp_ie;
wire						d_dp_oe;
wire						d_wr_ld;
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
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	c_bst_num		= 2'b00;
	c_rda			= 1'b0;
	c_rd			= 1'b0;
	c_wra			= 1'b0;
	c_wr			= 1'b0;
	c_wdat_req		= 1'b0;
	#1
	mcb_rst_n		= 1'b0;
	#1
	mcb_rst_n		= 1'b1;
	#(MCB_tCK*2)
	c_bst_num		= 2'b00;
	c_rda			= 1'b1;
	#(MCB_tCK*1)
	c_rda			= 1'b0;
	#(pCL*MCB_tCK + pBL*1*MCB_tCK)
	#(MCB_tCK*1)
	#(MCB_tCK*2)
	c_bst_num		= 2'b01;
	c_rd			= 1'b1;
	#(MCB_tCK*1)
	c_rd			= 1'b0;
	#(pCL*MCB_tCK + pBL*2*MCB_tCK)
	#(MCB_tCK*1)
	#(MCB_tCK*1)
	c_bst_num		= 2'b00;
	c_wdat_req		= 1'b1;
	#(MCB_tCK*1)
	c_wra			= 1'b1;
	c_wdat_req		= 1'b0;
	#(MCB_tCK*1)
	c_wra			= 1'b0;
	#(pBL*1*MCB_tCK)
	#(MCB_tCK*1)
	#(MCB_tCK*1)
	c_bst_num		= 2'b01;
	c_wdat_req		= 1'b1;
	#(MCB_tCK*1)
	c_wr			= 1'b1;
	c_wdat_req		= 1'b0;
	#(MCB_tCK*1)
	c_wr			= 1'b0;
	#(pBL*2*MCB_tCK)
	#(MCB_tCK*3)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_DAT_CTRL_tb.fsdb");
	$fsdbDumpvars(0,MCB_DAT_CTRL_tb);
end
endmodule
