//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_REF_CTRL_tb;
`include "../rtl/SDRC_LITE_MCB_PAR.v"
reg							mcb_clk;
reg							mcb_rst_n;
reg							mcb_sclr_n;
reg							i_ready;
reg							c_ready;
reg							c_ref;
wire						r_ref_req;
wire						r_ref_alert;
// REF_CTRL instance
MCB_REF_CTRL mcb_ref_ctrl0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.i_ready(i_ready),
	.c_ready(c_ready),
	.c_ref(c_ref),
	.r_ref_req(r_ref_req),
	.r_ref_alert(r_ref_alert)
);
// mcb_clk
initial mcb_clk = 1'b0;
always #(MCB_tCK/2) mcb_clk = ~mcb_clk;
// rst and conditions
initial begin
	mcb_rst_n		= 1'b1;
	mcb_sclr_n		= 1'b1;
	i_ready			= 1'b1;
	c_ready			= 1'b1;
	c_ref			= 1'b0;
	#1
	mcb_rst_n 		= 1'b0;
	#1
	mcb_rst_n 		= 1'b1;
	#(MCB_tCK*2)
	// wait
	#(CtREFi*MCB_tCK)
	#(MCB_tCK*20)
	i_ready			= 1'b0;
	#(MCB_tCK*1)
	i_ready			= 1'b1;
	// wait
	#(CtREFi*MCB_tCK)	
	#(MCB_tCK*2)
	c_ref 			= 1'b1;
	c_ready			= 1'b0;
	#(MCB_tCK*1)
	c_ref			= 1'b0;
	#(MCB_tCK*2)
	c_ready			= 1'b1;
	#(MCB_tCK*2)
	// wait
	refresh_hdl;
	#(MCB_tCK*10)
	$finish;
end
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_REF_CTRL_tb.fsdb");
	$fsdbDumpvars(0,MCB_REF_CTRL_tb);
end
// transaction definitions
// task refresh_hdl
task refresh_hdl;
	begin
		while(r_ref_req == 1'b0) begin
			#(MCB_tCK*1)
			c_ref		= 1'b0;
		end
		#(MCB_tCK*1)
		c_ref			= 1'b1;
		#(MCB_tCK*1)
		c_ref			= 1'b0;
	end
endtask
endmodule
