//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module SDRC_LITE_MCB_PAR_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
integer		x;
integer		log2_x;

integer		clk_tmrd;
integer		clk_trp;
integer		clk_trfc;
integer		clk_trcd;
integer		clk_twr;
integer		clk_tdal;

wire	[SDR_A_W-1:0]		mode_rg_val;
wire	[R_REF_I_CNT_W-1:0]	ref_intv_num;

assign	mode_rg_val	= MR_val;
assign	ref_intv_num = CtREFi;

initial begin
	x = 100;
	log2_x = log2(100);
	clk_tmrd	= CtMRDm1 + 1;
	clk_trp		= CtRPm1 + 1;
	clk_trfc	= CtRFCm1 + 1;
	clk_trcd	= CtRCDm1 + 1;
	clk_twr		= CtWRm1 + 1;
	clk_tdal	= CtDALm1 + 1;
	#5
	x = 64;
	log2_x = log2(64);
	#10
	$finish;
end
//For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("SDRC_LITE_MCB_PAR_tb.fsdb");
	$fsdbDumpvars(0,SDRC_LITE_MCB_PAR_tb);
end
endmodule
