//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/13	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_CTRL_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg							mcb_bb;
reg							mcb_wr_n;
reg		[1:0]				mcb_bl;
wire						mcb_busy;
wire						mcb_rdat_vld;
wire						mcb_wdat_req;
wire						i_prea;
wire						i_ref;
wire						i_lmr;
wire						i_ready;
wire	[1:0]				c_bst_num;
wire						c_ref;
wire						c_act;
wire						c_rda;
wire						c_rd;
wire						c_wra;
wire						c_wr;
wire						d_dp_ie;
wire						d_dp_oe;
wire						d_wr_ld;
// testbench variable
reg		[63:0] 				cnt_t;
// MCB_CTRL instance
MCB_CTRL mcb_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_busy(mcb_busy),
	.mcb_rdat_vld(mcb_rdat_vld),
	.mcb_wdat_req(mcb_wdat_req),
	.i_prea(i_prea),
	.i_ref(i_ref),
	.i_lmr(i_lmr),
	.i_ready(i_ready),
	.c_bst_num(c_bst_num),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
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
	mcb_bb			= 1'b0;
	mcb_wr_n		= 1'b0;
	mcb_bl			= 2'b00;
	#1
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	//initial wait time
	#(CtINIw*10)
	//initialize FSM operate and wait
	#(CtRFCm1*10*200)
	//wait
	#(MCB_tCK/2)
	for(cnt_t = 1; cnt_t < 100; cnt_t = cnt_t+1) begin
		write8;
	end
	#(100*MCB_tCK)
	for(cnt_t = 1; cnt_t < 100; cnt_t = cnt_t+1) begin
		read8;
	end
	#(100*MCB_tCK)
	read4;
	write4;
	write4;
	read4;
	read8;
	write8;
	write8;
	read8;
	read4;
	read4;
	write8;
	write4;
	read8;
	read8;
	write4;
	write8;
	read4;
	#(50*MCB_tCK)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_CTRL_tb.fsdb");
	$fsdbDumpvars(0,MCB_CTRL_tb);
end
// transaction definitions
// task write4
task write4;
//	input	[MCB_B_W-1:0]	tsk_mcb_ba;
//	input	[MCB_R_W-1:0]	tsk_mcb_ra;
//	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b0;
		mcb_bl			= 2'b00;
//		mcb_ba			= tsk_mcb_ba;
//		mcb_ra			= tsk_mcb_ra;
//		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task write8
task write8;
//	input	[MCB_B_W-1:0]	tsk_mcb_ba;
//	input	[MCB_R_W-1:0]	tsk_mcb_ra;
//	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b0;
		mcb_bl			= 2'b01;
//		mcb_ba			= tsk_mcb_ba;
//		mcb_ra			= tsk_mcb_ra;
//		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task read4
task read4;
//	input	[MCB_B_W-1:0]	tsk_mcb_ba;
//	input	[MCB_R_W-1:0]	tsk_mcb_ra;
//	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b1;
		mcb_bl			= 2'b00;
//		mcb_ba			= tsk_mcb_ba;
//		mcb_ra			= tsk_mcb_ra;
//		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
// task read8
task read8;
//	input	[MCB_B_W-1:0]	tsk_mcb_ba;
//	input	[MCB_R_W-1:0]	tsk_mcb_ra;
//	input	[MCB_C_W-1:0]	tsk_mcb_ca;
	begin
		while(mcb_busy == 1'b1) begin
			#(1*MCB_tCK)
			mcb_bb		= 1'b0;
		end
		#(1*MCB_tCK)
		mcb_bb			= 1'b1;
		mcb_wr_n		= 1'b1;
		mcb_bl			= 2'b01;
//		mcb_ba			= tsk_mcb_ba;
//		mcb_ra			= tsk_mcb_ra;
//		mcb_ca			= tsk_mcb_ca;
		#(1*MCB_tCK)
		mcb_bb			= 1'b0;
	end
endtask
endmodule
