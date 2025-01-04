//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 SDRAM Controller,data ff module
//
//	2013/04/24	version beta2.0
//
//  luyanheng
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_dat_f(
	ddr3_mcb_clk,
    ddr3_mcb_clk_n,
	ddr3_mcb_rst_n,

	ddr3_mcb_wbe,
	ddr3_mcb_rdat,
	ddr3_mcb_wdat,
    
	i_ready,
	d_dp_ie,
	d_dp_oe,
	d_wr_ld,
    
	dbf_dq_ie,
	dbf_dq_i,
	dbf_dq_oe,
	dbf_dq_o,
	ddr3_dqm,
    
    ddr3_dqs_o,
    ddr3_dqs_i,
    ddr3_dqs_n_i,
    ddr3_dqs_n_o
);
`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
// interface signals
input						ddr3_mcb_clk;
input                       ddr3_mcb_clk_n;
input						ddr3_mcb_rst_n;

input	[8-1:0]		        ddr3_mcb_wbe;
output	[64-1:0]		    ddr3_mcb_rdat;
input	[64-1:0]		    ddr3_mcb_wdat;

input						i_ready;
input						d_dp_ie;
input						d_dp_oe;
input						d_wr_ld;

output						dbf_dq_ie;
input	[32-1:0]		    dbf_dq_i;
output						dbf_dq_oe;
output	[32-1:0]		    dbf_dq_o;
output	[4-1:0]		        ddr3_dqm;

output                      ddr3_dqs_o;
output                      ddr3_dqs_n_o;
input                       ddr3_dqs_i;
input                       ddr3_dqs_n_i;

// internal registers
reg		[32-1:0]		    dbf_dq_o;
reg  [64-1:0]      ddr3_mcb_rdat;
reg                ddr3_dqs_o;
reg                ddr3_dqs_n_o;
reg  [4-1:0]       ddr3_dqm;

// dbf_dq_ie signal
assign dbf_dq_ie = d_dp_ie;
// dbf_dq_oe signal
assign dbf_dq_oe = d_dp_oe;
// ddr3_mcb_rdat register
always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n or posedge ddr3_mcb_clk_n)
	if(ddr3_mcb_rst_n == 1'b0)
		ddr3_mcb_rdat		 <=	0;
	else if( (ddr3_mcb_clk == 1'b1) )
        ddr3_mcb_rdat[31:0]  <= ((ddr3_dqs_i == 1'b1) ? dbf_dq_i : ddr3_mcb_rdat);
    else if( (ddr3_mcb_clk_n == 1'b1) && (ddr3_dqs_n_i == 1'b1) )
        ddr3_mcb_rdat[63:32] <= dbf_dq_i;
	else
		ddr3_mcb_rdat		 <=	ddr3_mcb_rdat;
// dbf_dq_o register
always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n or posedge ddr3_mcb_clk_n)
	if(ddr3_mcb_rst_n == 1'b0)begin
		dbf_dq_o		<=	0;
        ddr3_dqs_o      <=  0;
        ddr3_dqs_n_o    <=  0;
        end
	else if( (ddr3_mcb_clk == 1'b1) )begin
		dbf_dq_o		<=	((d_wr_ld == 1'b1) ? ddr3_mcb_wdat[31:0] : 'd0);
        ddr3_dqs_o      <= ((d_wr_ld == 1'b1) ? 1'b1 : 1'b0);
        end
    else if( (ddr3_dqs_o == 1'b1) & (ddr3_mcb_clk_n == 1'b1) )begin
        dbf_dq_o        <= ddr3_mcb_wdat[63:32];
        ddr3_dqs_n_o    <=  1'b1;
        end
	else begin
		dbf_dq_o		<=	dbf_dq_o;
        ddr3_dqs_o      <=  'd0;
        ddr3_dqs_n_o    <=  1'b0;
        end
        
// ddr3_dqm register
always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n or posedge ddr3_mcb_clk_n)
	if(ddr3_mcb_rst_n == 1'b0)
		ddr3_dqm			<=	{SDR_M_W{1'b1}};
	else if( (ddr3_mcb_clk == 1'b1) )
		ddr3_dqm			<=	((d_wr_ld == 1'b1) ? (~ddr3_mcb_wbe[3:0]) : {SDR_M_W{1'b1}});
    else if( ddr3_mcb_clk_n == 1'b1 )
		ddr3_dqm			<=	((d_wr_ld == 1'b1) ? (~ddr3_mcb_wbe[7:4]) : {SDR_M_W{1'b1}});
	else
		ddr3_dqm			<=	((i_ready == 1'b0) ? {SDR_M_W{1'b1}} : 'd0);
endmodule