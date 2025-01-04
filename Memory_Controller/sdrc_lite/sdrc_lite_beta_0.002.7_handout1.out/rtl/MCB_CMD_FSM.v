//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/04/15	version beta2.2a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_CMD_FSM(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_bb,
	i_ready,
	r_ref_req,
	c_bst_dir,
	c_bst_last,
	c_cmd_cnt,
	c_cmd_cnt_sclr,
	c_ready,
	c_ref,
	c_act,
	c_trcd,
	c_rda,
	c_rd,
	c_wra,
	c_wr
);
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						mcb_bb;
input						i_ready;
input						r_ref_req;
input						c_bst_dir;
input						c_bst_last;
input	[C_CMD_CNT_W-1:0]	c_cmd_cnt;
output						c_cmd_cnt_sclr;
output						c_ready;
output						c_ref;
output						c_act;
output						c_trcd;
output						c_rda;
output						c_rd;
output						c_wra;
output						c_wr;
// internal wires
reg							c_cmd_cnt_sclr;
reg							c_ready;
reg							c_ref;
reg							c_act;
reg							c_trcd;
reg							c_rda;
reg							c_rd;
reg							c_wra;
reg							c_wr;
reg		[3:0]				c_st_nxt;
// internal registers
reg		[3:0]				c_st_now;
// states
parameter	c_st_wait	= 4'b0000;
parameter	c_st_ready	= 4'b0001;
parameter	c_st_ref	= 4'b0010;
parameter	c_st_trfc	= 4'b0011;
parameter	c_st_act	= 4'b0100;
parameter	c_st_trcd	= 4'b0101;
parameter	c_st_rd		= 4'b0110;
parameter	c_st_rd_w	= 4'b0111;
parameter	c_st_rda	= 4'b1000;
parameter	c_st_rda_w	= 4'b1001;
parameter	c_st_wr		= 4'b1010;
parameter	c_st_wr_w	= 4'b1011;
parameter	c_st_wra	= 4'b1100;
parameter	c_st_wra_w	= 4'b1101;
// load next state
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		c_st_now		<=	c_st_wait;
	else if((mcb_sclr_n == 1'b0) | (i_ready == 1'b0))
		c_st_now		<=	c_st_wait;
	else
		c_st_now		<=	c_st_nxt;
// next state logic and output logic
always @ (c_st_now, mcb_bb, i_ready, r_ref_req, c_bst_dir, c_bst_last, 
	c_cmd_cnt) begin
	c_ready				= 1'b0;
	c_ref				= 1'b0;
	c_act				= 1'b0;
	c_trcd				= 1'b0;
	c_rda				= 1'b0;
	c_rd				= 1'b0;
	c_wra				= 1'b0;
	c_wr				= 1'b0;
	c_cmd_cnt_sclr		= 1'b0;
	case(c_st_now)
		c_st_wait:	begin
			c_cmd_cnt_sclr		= 1'b1;
			if(i_ready == 1'b1)
				c_st_nxt		= c_st_ready;
			else
				c_st_nxt		= c_st_wait;
		end
		c_st_ready:	begin
			c_cmd_cnt_sclr		= 1'b1;
			c_ready				= 1'b1;
			if(r_ref_req == 1'b1)
				c_st_nxt		= c_st_ref;
			else if(mcb_bb == 1'b1)
				c_st_nxt		= c_st_act;				
			else
				c_st_nxt		= c_st_ready;
		end
		c_st_ref:	begin
			c_ref				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;
			if(CtRFCm1 == 0)
				c_st_nxt		= c_st_ready;
			else
				c_st_nxt		= c_st_trfc;
		end
		c_st_trfc:	begin
			if(c_cmd_cnt == CtRFCm1 - 1)
				c_st_nxt		= c_st_ready;
			else
				c_st_nxt		= c_st_trfc;
		end
		c_st_act:	begin
			c_act				= 1'b1;
			if(CtRCDm1 == 0)
				case({c_bst_dir, c_bst_last})
					2'b00:		c_st_nxt	= c_st_wr;
					2'b01:		c_st_nxt	= c_st_wra;
					2'b10:		c_st_nxt	= c_st_rd;
					2'b11:		c_st_nxt	= c_st_rda;
				endcase
			else
				c_st_nxt		= c_st_trcd;
		end
		c_st_trcd:	begin
			c_trcd				= 1'b1;
			if(c_cmd_cnt == CtRCDm1)
				case({c_bst_dir, c_bst_last})
					2'b00:		c_st_nxt	= c_st_wr;
					2'b01:		c_st_nxt	= c_st_wra;
					2'b10:		c_st_nxt	= c_st_rd;
					2'b11:		c_st_nxt	= c_st_rda;
				endcase
			else
				c_st_nxt		= c_st_trcd;							
		end
		c_st_rda:	begin
			c_rda				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;	
			c_st_nxt			= c_st_rda_w;		
		end
		c_st_rda_w:	begin
			if(c_cmd_cnt == pBL + CtRPm1 - 3)
				c_st_nxt		= c_st_ready;
			else
				c_st_nxt		= c_st_rda_w;			
		end
		c_st_rd:	begin
			c_rd				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;	
			c_st_nxt			= c_st_rd_w;			
		end
		c_st_rd_w:	begin
			if(c_cmd_cnt == pBL - 2)
				if(c_bst_last == 1'b1)
					c_st_nxt	= c_st_rda;
				else
					c_st_nxt	= c_st_rd;
			else
				c_st_nxt		= c_st_rd_w;	
		end
		c_st_wra:	begin
			c_wra				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;
			c_st_nxt			= c_st_wra_w;
		end
		c_st_wra_w:	begin
			if(c_cmd_cnt == pBL + CtDALm1 - 4)
				c_st_nxt		= c_st_ready;
			else
				c_st_nxt		= c_st_wra_w;			
		end
		c_st_wr:	begin
			c_wr				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;
			c_st_nxt			= c_st_wr_w;
		end
		c_st_wr_w:	begin
			if(c_cmd_cnt == pBL - 2)
				if(c_bst_last == 1'b1)
					c_st_nxt	= c_st_wra;
				else
					c_st_nxt	= c_st_wr;
			else
				c_st_nxt		= c_st_wr_w;
		end
		default:	begin
			c_st_nxt			= c_st_wait;
		end
	endcase
end
endmodule
