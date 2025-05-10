//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_INI_FSM(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	i_ini_w_done,
	i_ref_n_done,
	i_cmd_cnt,
	i_cmd_cnt_sclr,
	i_prea,
	i_ref,
	i_lmr,
	i_ready
);
`include "./SDRC_LITE_MCB_PAR.vh"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						i_ini_w_done;
input						i_ref_n_done;
input	[I_CMD_CNT_W-1:0]	i_cmd_cnt;
output						i_cmd_cnt_sclr;
output						i_prea;
output						i_ref;
output						i_lmr;
output						i_ready;
// internal wires
reg							i_cmd_cnt_sclr;
reg 						i_prea;
reg 						i_ref;
reg 						i_lmr;
reg 						i_ready;
reg		[2:0]				i_st_nxt;
// internal registers
reg		[2:0]				i_st_now;
// states
parameter	i_st_wait	= 3'b000;
parameter	i_st_prea	= 3'b001;
parameter	i_st_trp	= 3'b010;
parameter	i_st_ref	= 3'b011;
parameter	i_st_trfc	= 3'b100;
parameter	i_st_lmr	= 3'b101;
parameter	i_st_tmrd	= 3'b110;
parameter	i_st_ready	= 3'b111;
// load next state
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		i_st_now		<=	i_st_wait;
	else if(mcb_sclr_n == 1'b0)
		i_st_now		<=	i_st_wait;
	else
		i_st_now		<=	i_st_nxt;
// next state logic and output logic
always @ (i_st_now, i_ini_w_done, i_ref_n_done, i_cmd_cnt) begin
	i_prea				= 1'b0;
	i_ref				= 1'b0;
	i_lmr				= 1'b0;
	i_ready				= 1'b0;
	i_cmd_cnt_sclr		= 1'b0;
	case(i_st_now)
		i_st_wait:	begin
			if(i_ini_w_done == 1'b1)
				i_st_nxt		= i_st_prea;
			else
				i_st_nxt		= i_st_wait;
		end
		i_st_prea:	begin
			i_prea				= 1'b1;
			i_cmd_cnt_sclr		= 1'b1;
			if(CtRPm1 == 0)
				i_st_nxt		= i_st_ref;
			else
				i_st_nxt		= i_st_trp;
		end
		i_st_trp:	begin
			if(i_cmd_cnt == CtRPm1 - 1)
				i_st_nxt		= i_st_ref;
			else
				i_st_nxt		= i_st_trp;
		end
		i_st_ref:	begin
			i_ref				= 1'b1;
			i_cmd_cnt_sclr		= 1'b1;
			if(CtRFCm1 == 0)
				i_st_nxt		= (i_ref_n_done) ? i_st_lmr : i_st_ref;
			else
				i_st_nxt		= i_st_trfc;
		end
		i_st_trfc:	begin
			if(i_cmd_cnt == CtRFCm1 - 1)
				i_st_nxt		= (i_ref_n_done) ? i_st_lmr : i_st_ref;
			else
				i_st_nxt		= i_st_trfc;				
		end
		i_st_lmr:	begin
			i_lmr				= 1'b1;
			i_cmd_cnt_sclr		= 1'b1;
			if(CtMRDm1 == 0)
				i_st_nxt		= i_st_ready;
			else
				i_st_nxt		= i_st_tmrd;
		end
		i_st_tmrd:	begin
			if(i_cmd_cnt == CtMRDm1 - 1)
				i_st_nxt		= i_st_ready;
			else
				i_st_nxt		= i_st_tmrd;
		end
		i_st_ready:	begin
			i_ready				= 1'b1;
			i_st_nxt			= i_st_ready;
		end
		default:	begin
			i_st_nxt			= i_st_wait;
		end
	endcase
end
endmodule
