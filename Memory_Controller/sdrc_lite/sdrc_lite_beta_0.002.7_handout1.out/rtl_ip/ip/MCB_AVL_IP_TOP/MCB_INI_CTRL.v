//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_INI_CTRL(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
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
output						i_prea;
output						i_ref;
output						i_lmr;
output						i_ready;
// internal wires
wire						i_cmd_cnt_sclr;
// internal registers
reg		[I_INI_W_CNT_W-1:0]	i_ini_w_cnt;
reg							i_ini_w_done;
reg		[I_CMD_CNT_W-1:0]	i_cmd_cnt;
reg		[I_REF_N_CNT_W-1:0]	i_ref_n_cnt;
reg							i_ref_n_done;
// INI_FSM instance
MCB_INI_FSM mcb_ini_fsm0(
	.mcb_clk(mcb_clk),
	.mcb_rst_n(mcb_rst_n),
	.mcb_sclr_n(mcb_sclr_n),
	.i_ini_w_done(i_ini_w_done),
	.i_ref_n_done(i_ref_n_done),
	.i_cmd_cnt(i_cmd_cnt),
	.i_cmd_cnt_sclr(i_cmd_cnt_sclr),
	.i_prea(i_prea),
	.i_ref(i_ref),
	.i_lmr(i_lmr),
	.i_ready(i_ready)
);
// initialization 100/200us wait counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		i_ini_w_cnt		<=	0;
		i_ini_w_done	<=	0;
	end
	else if(mcb_sclr_n == 1'b0) begin
		i_ini_w_cnt		<=	0;
		i_ini_w_done	<=	0;
	end
	else if(i_ini_w_done == 1'b0) begin
		i_ini_w_cnt		<=	i_ini_w_cnt + {{(I_INI_W_CNT_W-1){1'b0}}, 1'b1};
		i_ini_w_done	<=	(i_ini_w_cnt == CtINIw) ? 1'b1 : 1'b0;
	end
	else begin
		i_ini_w_cnt		<=	i_ini_w_cnt;
		i_ini_w_done	<=	i_ini_w_done;
	end
// initialization refresh number counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		i_ref_n_cnt		<=	0;
		i_ref_n_done	<=	0;
	end
	else if(mcb_sclr_n == 1'b0) begin
		i_ref_n_cnt		<=	0;
		i_ref_n_done	<=	0;
	end
	else if((i_ref_n_done == 1'b0) & (i_ref == 1'b1)) begin
		i_ref_n_cnt		<=	i_ref_n_cnt + {{(I_REF_N_CNT_W-1){1'b0}}, 1'b1};
		i_ref_n_done	<=	(i_ref_n_cnt == IrefN - 1) ? 1'b1 : 1'b0;
	end
	else begin
		i_ref_n_cnt		<=	i_ref_n_cnt;
		i_ref_n_done	<=	i_ref_n_done;
	end
// initialization command interval counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		i_cmd_cnt		<=	0;
	else if((mcb_sclr_n == 1'b0) | (i_cmd_cnt_sclr == 1'b1))
		i_cmd_cnt		<=	0;
	else
		i_cmd_cnt		<=	i_cmd_cnt + {{(I_CMD_CNT_W-1){1'b0}}, 1'b1};
endmodule
