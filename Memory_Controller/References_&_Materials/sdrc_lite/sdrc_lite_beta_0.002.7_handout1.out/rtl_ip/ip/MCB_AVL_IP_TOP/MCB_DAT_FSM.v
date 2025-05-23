//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/14	version beta2.1
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_DAT_FSM(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	c_rda,
	c_rd,
	c_wra,
	c_wr,
	d_bst_num,
	d_cl_cnt,
	d_bl_cnt,
	d_cl_cnt_sclr,
	d_bl_cnt_sclr,
	d_dp_ie,
	d_dp_oe
);
`include "./SDRC_LITE_MCB_PAR.vh"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input	[1:0]				d_bst_num;
input						c_rda;
input						c_rd;
input						c_wra;
input						c_wr;
input	[D_CL_CNT_W-1:0]	d_cl_cnt;
input	[D_BL_CNT_W-1:0]	d_bl_cnt;
output						d_cl_cnt_sclr;
output						d_bl_cnt_sclr;
output						d_dp_ie;
output						d_dp_oe;
// internal wires
reg							d_cl_cnt_sclr;
reg 						d_bl_cnt_sclr;
reg 						d_dp_ie;
reg 						d_dp_oe;
reg		[1:0]				d_st_nxt;
// internal registers
reg		[1:0]				d_st_now;
// states
parameter	d_st_idle	= 2'b00;
parameter	d_st_cl		= 2'b01;
parameter	d_st_rd		= 2'b10;
parameter	d_st_wr		= 2'b11;
// load next state
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		d_st_now		<=	d_st_idle;
	else if(mcb_sclr_n == 1'b0)
		d_st_now		<=	d_st_idle;
	else
		d_st_now		<=	d_st_nxt;
// next state logic and output logic
always @ (d_st_now, d_bst_num, c_rda, c_rd, c_wra, c_wr, d_cl_cnt, 
	d_bl_cnt) begin
	d_dp_ie				= 1'b0;
	d_dp_oe				= 1'b0;
	d_cl_cnt_sclr		= 1'b0;
	d_bl_cnt_sclr		= 1'b0;
	case(d_st_now)
		d_st_idle:	begin
			d_cl_cnt_sclr		= 1'b1;
			d_bl_cnt_sclr		= 1'b1;
			if((c_rda == 1'b1) | (c_rd == 1'b1))
				d_st_nxt		= d_st_cl;
			else if((c_wra == 1'b1) | (c_wr == 1'b1))
				d_st_nxt		= d_st_wr;
			else
				d_st_nxt		= d_st_idle;
		end
		d_st_cl:	begin
			d_bl_cnt_sclr		= 1'b1;
			if(d_cl_cnt == pCL -1)
				d_st_nxt		= d_st_rd;
			else
				d_st_nxt		= d_st_cl;
		end
		d_st_rd:	begin
			d_dp_ie				= 1'b1;
			d_cl_cnt_sclr		= 1'b1;
			if(d_bl_cnt == {d_bst_num, 2'b11})
				d_st_nxt		= d_st_idle;
			else
				d_st_nxt		= d_st_rd;			
		end
		d_st_wr:	begin
			d_dp_oe				= 1'b1;
			d_cl_cnt_sclr		= 1'b1;
			if(d_bl_cnt == {d_bst_num, 2'b11})
				d_st_nxt		= d_st_idle;
			else
				d_st_nxt		= d_st_wr;			
		end
		default:	begin
			d_st_nxt			= d_st_idle;
		end
	endcase
end
endmodule
