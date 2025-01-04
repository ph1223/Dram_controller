//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/13	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_CMD_CTRL_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg							mcb_bb;
reg							mcb_wr_n;
reg		[1:0]				mcb_bl;
wire						mcb_busy;
reg							i_ready;
reg							r_ref_req;
reg							r_ref_alert;
wire	[1:0]				c_bst_num;
wire						c_ready;
wire						c_ref;
wire						c_act;
wire						c_rda;
wire						c_rd;
wire						c_wra;
wire						c_wr;
wire						c_wdat_req;
// CMD_CTRL instance
MCB_CMD_CTRL mcb_cmd_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.mcb_bb(mcb_bb),
	.mcb_wr_n(mcb_wr_n),
	.mcb_bl(mcb_bl),
	.mcb_busy(mcb_busy),
	.i_ready(i_ready),
	.r_ref_req(r_ref_req),
	.r_ref_alert(r_ref_alert),
	.c_bst_num(c_bst_num),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.c_act(c_act),
	.c_rda(c_rda),
	.c_rd(c_rd),
	.c_wra(c_wra),
	.c_wr(c_wr),
	.c_wdat_req(c_wdat_req)
);
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	i_ready			= 1'b1;
	r_ref_req		= 1'b0;
	r_ref_alert		= 1'b0;
	mcb_bb			= 1'b0;
	mcb_wr_n		= 1'b0;
	mcb_bl			= 2'b00;
	#1
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	#(2*MCB_tCK)
	refresh;
	write4;
	write8;
	read4;
	read8;
	#(30*MCB_tCK)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_CMD_CTRL_tb.fsdb");
	$fsdbDumpvars(0,MCB_CMD_CTRL_tb);
end
// transaction definitions
// task refresh
task refresh;
	begin
		r_ref_alert		= 1'b1;
		while(c_ready == 1'b0) begin
			#(1*MCB_tCK)
			r_ref_req	= 1'b0;
		end
		#(1*MCB_tCK)
		r_ref_req		= 1'b1;
		#(1*MCB_tCK)
		r_ref_req		= 1'b0;
		while(c_ref == 1'b0) begin
			#(1*MCB_tCK)
			r_ref_alert	= 1'b1;
		end
		#(1*MCB_tCK)
		r_ref_alert		= 1'b0;			
	end
endtask
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
