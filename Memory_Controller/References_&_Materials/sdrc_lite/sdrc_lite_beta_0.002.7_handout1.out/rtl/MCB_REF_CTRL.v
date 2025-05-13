//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_REF_CTRL(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	i_ready,
	c_ready,
	c_ref,
	r_ref_req,
	r_ref_alert
);
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						i_ready;
input						c_ready;
input						c_ref;
output						r_ref_req;
output						r_ref_alert;
// internal registers
reg							r_ref_req;
reg							r_ref_alert;
reg		[R_REF_I_CNT_W-1:0]	r_ref_i_cnt;
// refresh request register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		r_ref_req		<=	1'b0;
	else if(mcb_sclr_n == 1'b0)
		r_ref_req		<=	1'b0;
	else
		r_ref_req		<=	c_ready & r_ref_alert;
// refresh interval counter and refresh alert register
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		r_ref_i_cnt		<=	0;
		r_ref_alert		<=	0;
	end
	else if((mcb_sclr_n == 1'b0) | (i_ready == 1'b0) | (c_ref == 1'b1)) begin
		r_ref_i_cnt		<=	0;
		r_ref_alert		<=	0;
	end
	else if(r_ref_alert == 1'b0) begin
		r_ref_i_cnt		<=	r_ref_i_cnt + {{(R_REF_I_CNT_W-1){1'b0}}, 1'b1};
		r_ref_alert		<=	(r_ref_i_cnt == CtREFi) ? 1'b1 : 1'b0;
	end
	else begin
		r_ref_i_cnt		<=	r_ref_i_cnt;
		r_ref_alert		<=	r_ref_alert;
	end
endmodule
