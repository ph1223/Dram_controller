//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_INI_CTRL_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
wire						i_prea;
wire						i_ref;
wire						i_lmr;
wire						i_ready;
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
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	#1
	mcb_rst_n		= 1'b0;
	#1
	mcb_rst_n		= 1'b1;
	#(MCB_tCK*2)
	//initial wait time
	#(CtINIw*MCB_tCK)
	//initialize FSM operate and wait
	#(CtRFCm1*MCB_tCK*200)
	//wait
	#(MCB_tCK*20)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_INI_CTRL_tb.fsdb");
	$fsdbDumpvars(0,MCB_INI_CTRL_tb);
end
endmodule
