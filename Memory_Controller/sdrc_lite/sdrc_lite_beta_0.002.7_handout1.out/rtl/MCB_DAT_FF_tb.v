//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_DAT_FF_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// interface signals
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg		[MCB_BE_W-1:0]		mcb_wbe;
wire	[MCB_D_W-1:0]		mcb_rdat;
reg		[MCB_D_W-1:0]		mcb_wdat;
reg							d_dp_ie;
reg							d_dp_oe;
reg							d_wr_ld;
wire						dbf_dq_ie;
reg		[SDR_D_W-1:0]		dbf_dq_i;
wire						dbf_dq_oe;
wire	[SDR_D_W-1:0]		dbf_dq_o;
wire	[SDR_M_W-1:0]		sdr_dqm;
// DAT_FF instance
MCB_DAT_FF mcb_dat_ff0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_wbe(mcb_wbe),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat),
	.i_ready(i_ready),
	.d_dp_ie(d_dp_ie),
	.d_dp_oe(d_dp_oe),
	.d_wr_ld(d_wr_ld),
	.dbf_dq_ie(dbf_dq_ie),
	.dbf_dq_i(dbf_dq_i),
	.dbf_dq_oe(dbf_dq_oe),
	.dbf_dq_o(dbf_dq_o),
	.sdr_dqm(sdr_dqm)
);
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	mcb_wdat		= 31;
	d_dp_ie			= 1'b0;
	d_dp_oe			= 1'b0;
	d_wr_ld			= 1'b0;
	dbf_dq_i		= 26;
	mcb_wbe			= {MCB_BE_W{1'b1}};
	#1
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	#(MCB_tCK*1)
	d_wr_ld			= 1'b1;
	#(MCB_tCK*1)
	mcb_wdat		= 63;
	d_dp_oe			= 1'b1;
	#(MCB_tCK*1)
	d_wr_ld			= 1'b0;
	#(MCB_tCK*1)
	d_dp_oe			= 1'b0;
	#(MCB_tCK*1)
	d_dp_ie			= 1'b1;
	#(MCB_tCK*1)
	dbf_dq_i		= 27;
	#(MCB_tCK*1)
	d_dp_ie			= 1'b0;
	#(MCB_tCK*6)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_DAT_FF_tb.fsdb");
	$fsdbDumpvars(0,MCB_DAT_FF_tb);
end
endmodule
