//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/07	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_TOP_ram_model_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// sdrc_tst_trx interface
reg							tst_tx_en;
reg							tst_tx_sclr_n;
wire						tst_tx_done;
wire						tst_rx_done;
// memory controller back-end interface
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
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
reg		[MCB_BE_W-1:0]		mcb_wbe;
wire						mcb_i_ready;
// sdram interface
wire						sdr_cke;
wire						sdr_cs_n;
wire						sdr_ras_n;
wire						sdr_cas_n;
wire						sdr_we_n;
wire	[SDR_M_W-1:0]		sdr_dqm;
wire	[SDR_B_W-1:0]		sdr_ba;
wire	[SDR_A_W-1:0]		sdr_addr;
// sdram data buffer interface
wire						dbf_dq_ie;
wire	[SDR_D_W-1:0]		dbf_dq_i;
wire						dbf_dq_oe;
wire	[SDR_D_W-1:0]		dbf_dq_o;
// sdram chip
wire						sdr_clk;
wire	[SDR_D_W-1:0]		sdr_dq;
// SDRC_MCB_TOP_TST_TRX16 instance
SDRC_MCB_TOP_TST_TRX16 sdrc_mcb_top_tst_trx160(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.tst_tx_en(tst_tx_en),
	.tst_tx_sclr_n(tst_tx_sclr_n),
	.tst_tx_done(tst_tx_done),
	.tst_rx_done(tst_rx_done),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_ba(mcb_ba),
	.mcb_ra(mcb_ra),
	.mcb_ca(mcb_ca),
	.mcb_busy(mcb_busy),
	.mcb_wdat_req(mcb_wdat_req),
	.mcb_wdat(mcb_wdat)
);
// MCB_TOP instance
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
// micron mt48lc4m16a2
mt48lc4m16a2 sdram0(
	.Dq				(sdr_dq),
	.Addr			(sdr_addr),
	.Ba				(sdr_ba),
	.Clk			(sdr_clk),
	.Cke			(sdr_cke),
	.Cs_n			(sdr_cs_n),
	.Ras_n			(sdr_ras_n),
	.Cas_n			(sdr_cas_n),
	.We_n			(sdr_we_n),
	.Dqm			(sdr_dqm)
);
// Dq tristate
assign sdr_dq		= dbf_dq_oe ? dbf_dq_o : {(SDR_D_W){1'bz}};
assign dbf_dq_i		= dbf_dq_ie ? sdr_dq : {(SDR_D_W){1'bz}};
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// sdr_clk (3ns ahead of mcb_clk)
assign #(MCB_tCK*0.5 - 3) sdr_clk	= ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	tst_tx_sclr_n	= 1'b1;
	tst_tx_en		= 1'b0;
	mcb_wbe			= {MCB_BE_W{1'b1}};
	#(1 + MCB_tCK*0.5 - 3)
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	@(posedge mcb_i_ready) begin
		#2
		tst_tx_en	= 1'b1;
	end
	#(500*MCB_tCK)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_TOP_ram_model_tb.fsdb");
	$fsdbDumpvars(0,MCB_TOP_ram_model_tb);
end
endmodule
