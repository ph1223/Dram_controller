//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,control fsm module
//
//     2013/04/24  version beta 2.0
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_cmd_fsm(
    ddr3_mcb_clk,
    ddr3_mcb_rst_n,
    
//    ddr3_mcb_bb,
    
    ref_req,
    i_ready,
    row_hit,
    row_miss,
    row_empty,
    c_bst_dir,
//    c_bst_last,
    c_cmd_cnt,
	c_cmd_cnt_sclr,

    c_prea,    
    c_ref,
    c_prec,
    c_act,
    c_wr,
//    c_wra,
    c_rd,
//    c_rda,
    c_trcd,
    c_ready
);

`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"

    input               ddr3_mcb_clk;
    input               ddr3_mcb_rst_n;
    
//    input               ddr3_mcb_bb;
    
    input               ref_req;
    input               i_ready;
    input               row_hit;
    input               row_empty;
    input               row_miss;
    input				c_bst_dir;
//    input               c_bst_last;
    input     [C_CMD_CNT_W-1:0]          c_cmd_cnt;
    output              c_cmd_cnt_sclr;
    
    output              c_prea;
    output              c_ref;
    output              c_prec;
    output              c_act;
    output              c_wr;
//    output              c_wra;
    output              c_rd;
//    output              c_rda;
    output              c_trcd;
    output              c_ready;
    
    reg                 c_cmd_cnt_sclr;
    reg                 c_prea;
    reg                 c_ref;
    reg                 c_act;
    reg                 c_prec;
    reg                 c_wr;
//    reg                 c_wra;
    reg                 c_rd;
//    reg                 c_rda;
    reg                 c_trcd;
    
    reg      [3:0]      c_st_nxt;
    reg      [3:0]      c_st_now;
    reg                 c_ready;
    
    parameter	c_st_wait	= 4'b0000;
    parameter	c_st_ready	= 4'b0001;
    parameter   c_st_prea   = 4'b0010; 
    parameter   c_st_preaw  = 4'b0011;
    parameter	c_st_ref	= 4'b0100;
    parameter	c_st_trfc	= 4'b0101;
    parameter   c_st_prec   = 4'b0110;
    parameter   c_st_precw  = 4'b0111;
    parameter	c_st_act	= 4'b1000;
    parameter	c_st_trcd	= 4'b1001;
    parameter	c_st_rd		= 4'b1010;
    parameter	c_st_rd_w	= 4'b1011;
//    parameter	c_st_rda	= 4'b1000;
//    parameter	c_st_rda_w	= 4'b1001;
    parameter	c_st_wr		= 4'b1100;
    parameter	c_st_wr_w	= 4'b1101;
//    parameter	c_st_wra	= 4'b1100;
//    parameter	c_st_wra_w	= 4'b1101;
    
// load next state
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0)
		c_st_now		<=	c_st_wait;
	else if(i_ready == 1'b0)
		c_st_now		<=	c_st_wait;
	else
		c_st_now		<=	c_st_nxt;
// next state logic and output logic
always @ (c_st_now, row_hit, row_miss, row_empty, i_ready, ref_req, c_bst_dir,c_cmd_cnt) begin
	c_ready				= 1'b0;
    c_prea              = 1'b0;
	c_ref				= 1'b0;
    c_prec              = 1'b0;
	c_act				= 1'b0;
	c_trcd				= 1'b0;
//	c_rda				= 1'b0;
	c_rd				= 1'b0;
//	c_wra				= 1'b0;
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
			if(ref_req == 1'b1)
				c_st_nxt		= c_st_prea;
			else if(row_hit == 1'b1)
				c_st_nxt		= ( (c_bst_dir == 1'b1) ? c_st_rd : c_st_wr );
            else if(row_miss == 1'b1)
                c_st_nxt        = c_st_prec;
            else if(row_empty == 1'b1)
                c_st_nxt        = c_st_act;
			else
				c_st_nxt		= c_st_ready;
		end
        c_st_prea:begin
            c_prea              = 1'b1;
            c_cmd_cnt_sclr      = 1'b1;
            c_st_nxt            = c_st_preaw;
        end
        c_st_preaw:begin
            if(c_cmd_cnt == Ct-1)
                c_st_nxt        = c_st_ref;
            else
                c_st_nxt        = c_st_preaw;
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
        c_st_prec:begin
            c_prec              = 1'b1;
            c_cmd_cnt_sclr      = 1'b1;
            c_st_nxt            = c_st_precw;
        end
        c_st_precw:begin
            if(c_cmd_cnt == Ct-1)
                c_st_nxt        = c_st_act;
            else
                c_st_nxt        = c_st_precw;
        end
		c_st_act:	begin
			c_act				= 1'b1;
			if(CtRCDm1 == 0)
//				case({c_bst_dir, c_bst_last})
//					2'b00:		c_st_nxt	= c_st_wr;
//					2'b01:		c_st_nxt	= c_st_wra;
//					2'b10:		c_st_nxt	= c_st_rd;
//					2'b11:		c_st_nxt	= c_st_rda;
                c_st_nxt		= ( (c_bst_dir == 1'b1) ? c_st_rd : c_st_wr );
//				endcase
			else
				c_st_nxt		= c_st_trcd;
		end
		c_st_trcd:	begin
			c_trcd				= 1'b1;
			if(c_cmd_cnt == CtRCDm1)
//				case({c_bst_dir, c_bst_last})
//					2'b00:		c_st_nxt	= c_st_wr;
//					2'b01:		c_st_nxt	= c_st_wra;
//					2'b10:		c_st_nxt	= c_st_rd;
//					2'b11:		c_st_nxt	= c_st_rda;
//				endcase
                c_st_nxt		= ( (c_bst_dir == 1'b1) ? c_st_rd : c_st_wr );
			else
				c_st_nxt		= c_st_trcd;							
		end
//		c_st_rda:	begin
//			c_rda				= 1'b1;
//			c_cmd_cnt_sclr		= 1'b1;	
//			c_st_nxt			= c_st_rda_w;		
//		end
//		c_st_rda_w:	begin
//			if(c_cmd_cnt == pBL + CtRPm1 - 3)
//				c_st_nxt		= c_st_ready;
//			else
//				c_st_nxt		= c_st_rda_w;			
//		end
		c_st_rd:	begin
			c_rd				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;	
			c_st_nxt			= c_st_rd_w;			
		end
		c_st_rd_w:	begin
			if(c_cmd_cnt == pBL + CtDALm1 - 4)
//				if(c_bst_last == 1'b1)
//					c_st_nxt	= c_st_rda;
//				else
				c_st_nxt	= c_st_ready;
			else
				c_st_nxt		= c_st_rd_w;	
		end
//		c_st_wra:	begin
//			c_wra				= 1'b1;
//			c_cmd_cnt_sclr		= 1'b1;
//			c_st_nxt			= c_st_wra_w;
//		end
//		c_st_wra_w:	begin
//			if(c_cmd_cnt == pBL + CtDALm1 - 4)
//				c_st_nxt		= c_st_ready;
//			else
//				c_st_nxt		= c_st_wra_w;			
//		end
		c_st_wr:	begin
			c_wr				= 1'b1;
			c_cmd_cnt_sclr		= 1'b1;
			c_st_nxt			= c_st_wr_w;
		end
		c_st_wr_w:	begin
			if(c_cmd_cnt == pBL - 2)
//				if(c_bst_last == 1'b1)
//					c_st_nxt	= c_st_wra;
//				else
				c_st_nxt	= c_st_ready;
			else
				c_st_nxt		= c_st_wr_w;
		end
		default:	begin
			c_st_nxt			= c_st_wait;
		end
	endcase
end
endmodule
