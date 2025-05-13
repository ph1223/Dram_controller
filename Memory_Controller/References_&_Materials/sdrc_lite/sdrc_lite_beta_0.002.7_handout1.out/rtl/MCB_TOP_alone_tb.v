//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/07	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_TOP_alone_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// memory controller back-end interface
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg							mcb_bb;
reg							mcb_wr_n;
reg		[1:0]				mcb_bl;
reg		[MCB_B_W-1:0]		mcb_ba;
reg		[MCB_R_W-1:0]		mcb_ra;
reg		[MCB_C_W-1:0]		mcb_ca;
wire						mcb_busy;
wire						mcb_rdat_vld;
wire						mcb_wdat_req;
wire	[MCB_D_W-1:0]		mcb_rdat;
reg		[MCB_D_W-1:0]		mcb_wdat;
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
reg		[SDR_D_W-1:0]		dbf_dq_i;
wire						dbf_dq_oe;
wire	[SDR_D_W-1:0]		dbf_dq_o;
// testbench variable
reg		[63:0] 				cnt_t;
wire	[MCB_B_W-1:0]		cnt_t_ba;
wire	[MCB_R_W-1:0]		cnt_t_ra;
wire	[MCB_C_W-1:0]		cnt_t_ca;	
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
// convert cnt_t to mcb address
assign {cnt_t_ba, cnt_t_ra, cnt_t_ca} = cnt_t;
// clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	mcb_bb			= 1'b0;
	mcb_wr_n		= 1'b0;
	mcb_bl			= 2'b00;
	mcb_ba			= 0;
	mcb_ra			= 0;
	mcb_ca			= 0;
	mcb_wdat		= 5;
	cnt_t			= 0;
	dbf_dq_i		= 0;	// only for testing
	mcb_wbe			= {MCB_BE_W{1'b1}};
	#1
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	// wait for initialization to finish
	@(posedge mcb_i_ready) begin
		#2
		cnt_t		= 0;
	end
	// test
	#(2*MCB_tCK)
	for(cnt_t = 1; cnt_t < 100; cnt_t = cnt_t+1) begin
		write8(cnt_t_ba, cnt_t_ra, cnt_t_ca);
	end
	#(100*MCB_tCK)
	for(cnt_t = 1; cnt_t < 100; cnt_t = cnt_t+1) begin
		read8(cnt_t_ba, cnt_t_ra, cnt_t_ca);
	end
	#(100*MCB_tCK)
	read4(0, 12, 104);
	write4(1, 25, 96);
	write4(3, 45, 72);
	read4(2, 79, 64);
	read8(1, 43, 92);
	write8(0, 14, 84);
	write8(1, 1001, 120);
	read8(3, 2012, 16);
	read4(3, 1097, 36);
	read4(2, 1542, 116);
	write8(0, 1777, 136);
	write4(0, 1886, 200);
	read8(3, 1631, 212);
	read8(2, 1713, 180);
	write4(3, 1111, 92);
	write8(1, 987, 88);
	read4(0,1771, 92);
	#(50*MCB_tCK)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_TOP_alone_tb.fsdb");
	$fsdbDumpvars(0,MCB_TOP_alone_tb);
end
// transaction definitions
// task write4
task write4;
	input	[MCB_B_W-1:0]	tsk_mcb_ba;
	input	[MCB_R_W-1:0]	tsk_mcb_ra;
	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b0;
		mcb_bl			= 2'b00;
		mcb_ba			= tsk_mcb_ba;
		mcb_ra			= tsk_mcb_ra;
		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task write8
task write8;
	input	[MCB_B_W-1:0]	tsk_mcb_ba;
	input	[MCB_R_W-1:0]	tsk_mcb_ra;
	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b0;
		mcb_bl			= 2'b01;
		mcb_ba			= tsk_mcb_ba;
		mcb_ra			= tsk_mcb_ra;
		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task read4
task read4;
	input	[MCB_B_W-1:0]	tsk_mcb_ba;
	input	[MCB_R_W-1:0]	tsk_mcb_ra;
	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b1;
		mcb_bl			= 2'b00;
		mcb_ba			= tsk_mcb_ba;
		mcb_ra			= tsk_mcb_ra;
		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task read8
task read8;
	input	[MCB_B_W-1:0]	tsk_mcb_ba;
	input	[MCB_R_W-1:0]	tsk_mcb_ra;
	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b1;
		mcb_bl			= 2'b01;
		mcb_ba			= tsk_mcb_ba;
		mcb_ra			= tsk_mcb_ra;
		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
endmodule
