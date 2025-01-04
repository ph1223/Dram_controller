//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/30		beta2.6
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_DAT_FF(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_wbe,
	mcb_rdat,
	mcb_wdat,
	i_ready,
	d_dp_ie,
	d_dp_oe,
	d_wr_ld,
	dbf_dq_ie,
	dbf_dq_i,
	dbf_dq_oe,
	dbf_dq_o,
	sdr_dqm
);
`include "./SDRC_LITE_MCB_PAR.vh"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input	[MCB_BE_W-1:0]		mcb_wbe;
output	[MCB_D_W-1:0]		mcb_rdat;
input	[MCB_D_W-1:0]		mcb_wdat;
input						i_ready;
input						d_dp_ie;
input						d_dp_oe;
input						d_wr_ld;
output						dbf_dq_ie;
input	[SDR_D_W-1:0]		dbf_dq_i;
output						dbf_dq_oe;
output	[SDR_D_W-1:0]		dbf_dq_o;
output	[SDR_M_W-1:0]		sdr_dqm;
// internal registers
reg		[MCB_D_W-1:0]		mcb_rdat;
reg		[SDR_D_W-1:0]		dbf_dq_o;
reg		[SDR_M_W-1:0]		sdr_dqm;
// dbf_dq_ie signal
assign dbf_dq_ie = d_dp_ie;
// dbf_dq_oe signal
assign dbf_dq_oe = d_dp_oe;
// mcb_rdat register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		mcb_rdat		<=	0;
	else if(mcb_sclr_n == 1'b0)
		mcb_rdat		<=	0;
	else if(d_dp_ie == 1'b1)
		mcb_rdat		<=	dbf_dq_i;
	else
		mcb_rdat		<=	mcb_rdat;
// dbf_dq_o register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		dbf_dq_o		<=	0;
	else if(mcb_sclr_n == 1'b0)
		dbf_dq_o		<=	0;
	else if(d_wr_ld == 1'b1)
		dbf_dq_o		<=	mcb_wdat;
	else
		dbf_dq_o		<=	dbf_dq_o;
// sdr_dqm register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		sdr_dqm			<=	{SDR_M_W{1'b1}};
	else if(i_ready == 1'b0)
		sdr_dqm			<=	{SDR_M_W{1'b1}};
	else if(d_wr_ld == 1'b1)
		sdr_dqm			<=	~mcb_wbe;
	else
		sdr_dqm			<=	0;
endmodule
