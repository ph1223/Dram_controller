//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/10	version beta2.3a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_AVL_IP_TOP(
	csi_clockreset_clk,
	csi_clockreset_reset_n,
	avs_s1_address,
	avs_s1_read,
	avs_s1_write,
	avs_s1_beginbursttransfer,
	avs_s1_waitrequest,
	avs_s1_burstcount,
	avs_s1_readdatavalid,
	avs_s1_readdata,
	avs_s1_byteenable,
	avs_s1_writedata,
	coe_sdr_cke,
	coe_sdr_cs_n,
	coe_sdr_ras_n,
	coe_sdr_cas_n,
	coe_sdr_we_n,
	coe_sdr_dqm,
	coe_sdr_ba,
	coe_sdr_addr,
	coe_dbf_dq_ie,
	coe_dbf_dq_i,
	coe_dbf_dq_oe,
	coe_dbf_dq_o
);
`include "../rtl/SDRC_MCB_AVL_PAR.v"
// avalon interface signals
input						csi_clockreset_clk;
input						csi_clockreset_reset_n;
input	[AVL_A_W-1:0]		avs_s1_address;
input						avs_s1_read;
input						avs_s1_write;
input						avs_s1_beginbursttransfer;
output						avs_s1_waitrequest;
input	[4-1:0]				avs_s1_burstcount;
output						avs_s1_readdatavalid;
output	[AVL_D_W-1:0]		avs_s1_readdata;
input	[AVL_BE_W-1:0]		avs_s1_byteenable;
input	[AVL_D_W-1:0]		avs_s1_writedata;
// sdram interface
output						coe_sdr_cke;
output						coe_sdr_cs_n;
output						coe_sdr_ras_n;
output						coe_sdr_cas_n;
output						coe_sdr_we_n;
output	[SDR_M_W-1:0]		coe_sdr_dqm;
output	[SDR_B_W-1:0]		coe_sdr_ba;
output	[SDR_A_W-1:0]		coe_sdr_addr;
// sdram data buffer interface
output						coe_dbf_dq_ie;
input	[SDR_D_W-1:0]		coe_dbf_dq_i;
output						coe_dbf_dq_oe;
output	[SDR_D_W-1:0]		coe_dbf_dq_o;
// internal wires
wire						sdr_cke;
wire						sdr_cs_n;
wire						sdr_ras_n;
wire						sdr_cas_n;
wire						sdr_we_n;
wire	[SDR_M_W-1:0]		sdr_dqm;
wire	[SDR_B_W-1:0]		sdr_ba;
wire	[SDR_A_W-1:0]		sdr_addr;
wire						dbf_dq_ie;
wire	[SDR_D_W-1:0]		dbf_dq_i;
wire						dbf_dq_oe;
wire	[SDR_D_W-1:0]		dbf_dq_o;
wire						mcb_clk;
wire						mcb_rst_n;
wire						mcb_sclr_n;
wire						mcb_bb;
wire						mcb_wr_n;
wire	[1:0]				mcb_bl;
wire	[MCB_B_W-1:0]		mcb_ba;
wire	[MCB_R_W-1:0]		mcb_ra;
wire	[MCB_C_W-1:0]		mcb_ca;
wire						mcb_busy;
wire						mcb_rdat_vld;
wire						mcb_wdat_req;
wire	[MCB_D_W-1:0]		mcb_rdat;
wire	[MCB_D_W-1:0]		mcb_wdat;
wire	[MCB_BE_W-1:0]		mcb_wbe;
wire						mcb_i_ready;
// sync connects
assign mcb_clk					= csi_clockreset_clk;
assign mcb_rst_n				= csi_clockreset_reset_n;
assign mcb_sclr_n				= 1'b1;
// conduit interface
assign coe_sdr_cke				= sdr_cke;
assign coe_sdr_cs_n				= sdr_cs_n;
assign coe_sdr_ras_n			= sdr_ras_n;
assign coe_sdr_cas_n			= sdr_cas_n;
assign coe_sdr_we_n				= sdr_we_n;
assign coe_sdr_dqm				= sdr_dqm;
assign coe_sdr_ba				= sdr_ba;
assign coe_sdr_addr				= sdr_addr;
assign coe_dbf_dq_ie			= dbf_dq_ie;
assign dbf_dq_i					= coe_dbf_dq_i;
assign coe_dbf_dq_oe			= dbf_dq_oe;
assign coe_dbf_dq_o				= dbf_dq_o;
// mcf avalon wrapper
MCB_AVL_WRAP mcb_avl_wrap0(
	.csi_clockreset_clk(csi_clockreset_clk),
	.csi_clockreset_reset_n(csi_clockreset_reset_n),
	.avs_s1_address(avs_s1_address),
	.avs_s1_read(avs_s1_read),
	.avs_s1_write(avs_s1_write),
	.avs_s1_beginbursttransfer(avs_s1_beginbursttransfer),
	.avs_s1_waitrequest(avs_s1_waitrequest),
	.avs_s1_burstcount(avs_s1_burstcount),
	.avs_s1_readdatavalid(avs_s1_readdatavalid),
	.avs_s1_readdata(avs_s1_readdata),
	.avs_s1_byteenable(avs_s1_byteenable),
	.avs_s1_writedata(avs_s1_writedata),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat),
	.mcb_wbe(mcb_wbe),
	.mcb_i_ready(mcb_i_ready)
);
// MCB_CORE instance
MCB_TOP mcb_top0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.mcb_rdat(mcb_rdat),
	.mcb_wdat(mcb_wdat),
	.mcb_wbe(mcb_wbe),
	.mcb_i_ready(mcb_i_ready),
	.sdr_cke(sdr_cke),
	.sdr_cs_n(sdr_cs_n),
	.sdr_ras_n(sdr_ras_n),
	.sdr_cas_n(sdr_cas_n),
	.sdr_we_n(sdr_we_n),
	.sdr_dqm(sdr_dqm),
	.sdr_ba(sdr_ba),
	.sdr_addr(sdr_addr),
	.dbf_dq_ie(dbf_dq_ie),
	.dbf_dq_i(dbf_dq_i),
	.dbf_dq_oe(dbf_dq_oe),
	.dbf_dq_o(dbf_dq_o)
);
endmodule
