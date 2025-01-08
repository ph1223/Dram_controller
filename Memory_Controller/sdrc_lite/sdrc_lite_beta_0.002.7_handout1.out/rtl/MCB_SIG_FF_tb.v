//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_SIG_FF_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg							mcb_bb;
reg		[MCB_B_W-1:0]		mcb_ba;
reg		[MCB_R_W-1:0]		mcb_ra;
reg		[MCB_C_W-1:0]		mcb_ca;
reg							i_prea;
reg							i_ref;
reg							i_lmr;
reg							c_ref;
reg							c_act;
reg							c_rda;
reg							c_rd;
reg							c_wra;
reg							c_wr;
wire						sdr_cke;
wire						sdr_cs_n;
wire						sdr_ras_n;
wire						sdr_cas_n;
wire						sdr_we_n;
wire	[SDR_B_W-1:0]		sdr_ba;
wire	[SDR_A_W-1:0]		sdr_addr;
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
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	mcb_bb			= 1'b0;
	mcb_ba			= 0;
	mcb_ra			= 0;
	mcb_ca			= 0;
	i_prea			= 1'b0;
	i_ref			= 1'b0;
	i_lmr			= 1'b0;
	c_ref			= 1'b0;
	c_act			= 1'b0;
	c_rda			= 1'b0;
	c_rd			= 1'b0;
	c_wra			= 1'b0;
	c_wr			= 1'b0;
	#1
	mcb_rst_n		= 1'b0;
	#1
	mcb_rst_n		= 1'b1;
	#(3*MCB_tCK)
	i_prea			= 1'b1;
	#(1*MCB_tCK)
	i_prea			= 1'b0;
	#(1*MCB_tCK)
	i_ref			= 1'b1;
	#(1*MCB_tCK)
	i_ref			= 1'b0;
	#(1*MCB_tCK)
	i_lmr			= 1'b1;
	#(1*MCB_tCK)
	i_lmr			= 1'b0;
	#(1*MCB_tCK)
	#(3*MCB_tCK)
	mcb_bb			= 1'b1;
	mcb_ba			= 0;
	mcb_ra			= 5;
	mcb_ca			= 8;
	#(1*MCB_tCK)
	mcb_bb			= 1'b0;
	c_act			= 1'b1;
	#(1*MCB_tCK)
	c_act			= 1'b0;	
	#(1*MCB_tCK)
	c_rd			= 1'b1;
	#(1*MCB_tCK)
	c_rd			= 1'b0;
	#(3*MCB_tCK)
	c_rda			= 1'b1;
	#(1*MCB_tCK)
	c_rda			= 1'b0;
	#(5*MCB_tCK)
	mcb_bb			= 1'b1;
	mcb_ba			= 1;
	mcb_ra			= 7;
	mcb_ca			= 12;
	#(1*MCB_tCK)
	mcb_bb			= 1'b0;
	c_act			= 1'b1;
	#(1*MCB_tCK)
	c_act			= 1'b0;	
	#(1*MCB_tCK)
	c_wr			= 1'b1;
	#(1*MCB_tCK)
	c_wr			= 1'b0;
	#(3*MCB_tCK)
	c_wra			= 1'b1;
	#(1*MCB_tCK)
	c_wra			= 1'b0;
	#(10*MCB_tCK)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_SIG_FF_tb.fsdb");
	$fsdbDumpvars(0,MCB_SIG_FF_tb);
end
endmodule
