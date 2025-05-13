//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end : avalon wrapper
//
//	2012/05/31	version beta2.7
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_AVL_WRAP(
	csi_clockreset_clk,
	csi_clockreset_reset_n,
	avs_s1_address,
	avs_s1_read,
	avs_s1_write,
	avs_s1_beginbursttransfer,
	avs_s1_waitrequest,
	avs_s1_burstcount,
	avs_s1_readdatavalid,
	avs_s1_readdata,
	avs_s1_byteenable,
	avs_s1_writedata,
	mcb_bb,
	mcb_wr_n,
	mcb_bl,
	mcb_ba,
	mcb_ra,
	mcb_ca,
	mcb_busy,
	mcb_rdat_vld,
	mcb_wdat_req,
	mcb_rdat,
	mcb_wdat,
	mcb_wbe,
	mcb_i_ready
);
`include "../rtl/SDRC_MCB_AVL_PAR.v"
// avalon interface signals
input						csi_clockreset_clk;
input						csi_clockreset_reset_n;
input	[AVL_A_W-1:0]		avs_s1_address;
input						avs_s1_read;
input						avs_s1_write;
input						avs_s1_beginbursttransfer;
output						avs_s1_waitrequest;
input	[4-1:0]				avs_s1_burstcount;
output						avs_s1_readdatavalid;
output	[AVL_D_W-1:0]		avs_s1_readdata;
input	[AVL_BE_W-1:0]		avs_s1_byteenable;
input	[AVL_D_W-1:0]		avs_s1_writedata;
// memory controller back-end interface signals 
output						mcb_bb;
output						mcb_wr_n;
output	[2-1:0]				mcb_bl;
output	[MCB_B_W-1:0]		mcb_ba;
output	[MCB_R_W-1:0]		mcb_ra;
output	[MCB_C_W-1:0]		mcb_ca;
input						mcb_busy;
input						mcb_rdat_vld;
input						mcb_wdat_req;
input	[MCB_D_W-1:0]		mcb_rdat;
output	[MCB_D_W-1:0]		mcb_wdat;
output	[MCB_BE_W-1:0]		mcb_wbe;
input						mcb_i_ready;
// internal wires
reg		[8-1:0]				axss_bc_msk;
reg		[12-1:0]			axss_msk;
wire	[MCB_B_W-1:0]		axss_ba;
wire	[MCB_R_W-1:0]		axss_ra;
wire	[MCB_C_W-1:0]		axss_ca;
reg		[2-1:0]				axss_bl;
wire	[(MCB_C_W-1)-1:0]	axss_ca_tst;
wire	[2-1:0]				rd_rx_cur_bl;
wire	[12-1:0]			rd_rx_cur_msk;
wire						ram14x4_clk;
wire						ram14x4_w_en;
wire	[2-1:0]				ram14x4_w_addr;
wire	[14-1:0]			ram14x4_w_dat;
wire	[2-1:0]				ram14x4_r_addr;
wire	[14-1:0]			ram14x4_r_dat;
// internal registers
reg		[AVL_D_W-1:0]		avs_s1_readdata;
reg							mcb_nxt_wr_n;
reg		[MCB_B_W-1:0]		mcb_nxt_ba;
reg		[MCB_R_W-1:0]		mcb_nxt_ra;
reg		[MCB_C_W-1:0]		mcb_nxt_ca;
reg		[2-1:0]				mcb_nxt_bl;				
reg							mcb_bb;
reg							mcb_wr_n;
reg		[1:0]				mcb_bl;
reg		[MCB_B_W-1:0]		mcb_ba;
reg		[MCB_R_W-1:0]		mcb_ra;
reg		[MCB_C_W-1:0]		mcb_ca;
reg		[MCB_BE_W-1:0]		mcb_wbe;
reg							axss_id;
reg							axss_mcb_id;
reg		[12-1:0]			axss_msk4wr0;
reg		[12-1:0]			axss_msk4wr1;
reg							axss_avl_wdat_req;
reg							axss_splt;
reg							axss_splt0_done;
reg							axss_splt1_done;
reg		[2-1:0]				axss_splt0_bl;
reg		[2-1:0]				axss_splt1_bl;
reg		[4-1:0]				rd_rx_cnt;
reg		[2-1:0]				rd_rx_pt;
reg		[2-1:0]				rd_tx_pt;
reg							rd_tx_set;
reg		[12-1:0]			rd_rx_cur_msk_sft;
reg							mcb_rdat_vld_dly1;
// 14x4 on chip ram
MCB_AVL_RAM14x4 MCB_AVL_RAM14x4_0(
	.ram14x4_clk			(ram14x4_clk),
	.ram14x4_w_en			(ram14x4_w_en),
	.ram14x4_w_addr			(ram14x4_w_addr),
	.ram14x4_w_dat			(ram14x4_w_dat),
	.ram14x4_r_addr			(ram14x4_r_addr),
	.ram14x4_r_dat			(ram14x4_r_dat)
);
// ram signals
assign ram14x4_clk				= csi_clockreset_clk;
assign ram14x4_w_en				= rd_tx_set;
assign ram14x4_w_addr			= rd_tx_pt;
assign ram14x4_w_dat			= {axss_bl, axss_msk};
assign ram14x4_r_addr			= rd_rx_pt;
assign rd_rx_cur_bl				= ram14x4_r_dat[13:12];
assign rd_rx_cur_msk			= ram14x4_r_dat[11:0];
// avs_s1_waitrequest
assign avs_s1_waitrequest		= (~mcb_i_ready) 
									| avs_s1_beginbursttransfer
									|(
										avs_s1_write & 
										(~axss_avl_wdat_req)
									)
									|(
										avs_s1_read &
										(
											mcb_busy 
											|(
												axss_splt & 
												(~axss_splt0_done)
											)
										)
									);
// avs_s1_readdatavalid
assign avs_s1_readdatavalid	= (mcb_rdat_vld_dly1 == 1'b0) ? 1'b0 :
								(rd_rx_cnt == 4'b1) ? rd_rx_cur_msk[11] : 
								rd_rx_cur_msk_sft[11];
// mcb_wdat
assign mcb_wdat					= avs_s1_writedata;
// axss addr
assign axss_ba					= avl_addr_to_mcb_ba(avs_s1_address);
assign axss_ra					= avl_addr_to_mcb_ra(avs_s1_address);
assign axss_ca					= avl_addr_to_mcb_ca(avs_s1_address);
// axss_ca_tst
assign axss_ca_tst				= {1'b0, axss_ca[MCB_C_W-1:2]} +
									{{((MCB_C_W-1)-2){1'b0}}, axss_bl};
// axss_bc_msk
always@(avs_s1_burstcount)
	case(avs_s1_burstcount)
		4'h1:		axss_bc_msk	= 8'b1000_0000;
		4'h2:		axss_bc_msk	= 8'b1100_0000;
		4'h3:		axss_bc_msk	= 8'b1110_0000;
		4'h4:		axss_bc_msk	= 8'b1111_0000;
		4'h5:		axss_bc_msk	= 8'b1111_1000;
		4'h6:		axss_bc_msk	= 8'b1111_1100;
		4'h7:		axss_bc_msk	= 8'b1111_1110;
		4'h8:		axss_bc_msk	= 8'b1111_1111;
		default:	axss_bc_msk	= 8'b0;
	endcase
// axss_msk
always@(axss_ca[1:0], axss_bc_msk)
	case(axss_ca[1:0])
		2'h0:		axss_msk	= {axss_bc_msk, 4'b0};
		2'h1:		axss_msk	= {1'b0, axss_bc_msk, 3'b0};
		2'h2:		axss_msk	= {2'b0, axss_bc_msk, 2'b0};
		2'h3:		axss_msk	= {3'b0, axss_bc_msk, 1'b0};
		default:	axss_msk	= 12'bx;
	endcase
// axss_bl
always@(axss_msk[7], axss_msk[3])
	case({axss_msk[7], axss_msk[3]})
		2'b00:			axss_bl	= 2'b00;
		2'b10:			axss_bl	= 2'b01;
		2'b11:			axss_bl	= 2'b10;
		default:		axss_bl	= 2'bx;
	endcase
// axss_id
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_id					<= 1'b0;
	else if(avs_s1_beginbursttransfer == 1'b1)
		axss_id					<= ~axss_id;
	else
		axss_id					<= axss_id;		
// axss_mcb_id
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_mcb_id				<= 1'b0;
	else if(((avs_s1_read == 1'b1) | (avs_s1_write == 1'b1)) & 
		(mcb_busy == 1'b0) & (avs_s1_beginbursttransfer == 1'b0))
		axss_mcb_id				<= axss_id;
	else
		axss_mcb_id				<= axss_mcb_id;	
// axss_msk4wr0
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_msk4wr0			<= 0;	
	else if(axss_mcb_id == 1'b0) begin
		if(mcb_wdat_req == 1'b1)
			axss_msk4wr0		<= {axss_msk4wr0[10:0], 1'b0};
		else
			axss_msk4wr0		<= axss_msk4wr0;
	end
	else begin
		if(avs_s1_beginbursttransfer == 1'b1)
			axss_msk4wr0		<= axss_msk;
		else
			axss_msk4wr0		<= axss_msk4wr0;
	end	
// axss_msk4wr1
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_msk4wr1			<= 0;	
	else if(axss_mcb_id == 1'b1) begin
		if(mcb_wdat_req == 1'b1)
			axss_msk4wr1		<= {axss_msk4wr1[10:0], 1'b0};
		else
			axss_msk4wr1		<= axss_msk4wr1;
	end
	else begin
		if(avs_s1_beginbursttransfer == 1'b1)
			axss_msk4wr1		<= axss_msk;
		else
			axss_msk4wr1		<= axss_msk4wr1;
	end	
// axss_avl_wdat_req
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_avl_wdat_req		<= 1'b0;
	else if(mcb_wdat_req == 1'b1)
		axss_avl_wdat_req		<= axss_mcb_id ? 
									axss_msk4wr1[11] : axss_msk4wr0[11];
	else
		axss_avl_wdat_req		<= 1'b0;
// mcb_nxt_wr_n
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		mcb_nxt_wr_n			<= 1'b0;
	else if((avs_s1_beginbursttransfer == 1'b1) & (avs_s1_read == 1'b1))
		mcb_nxt_wr_n			<= 1'b1;
	else if((avs_s1_beginbursttransfer == 1'b1) & (avs_s1_write == 1'b1))
		mcb_nxt_wr_n			<= 1'b0;
	else
		mcb_nxt_wr_n			<= mcb_nxt_wr_n;	
// nxt mcb transaction arguments (none split)
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0) begin
		mcb_nxt_bl				<= 0;
		mcb_nxt_ba				<= 0;
		mcb_nxt_ra				<= 0;
		mcb_nxt_ca				<= 0;
	end
	else if(avs_s1_beginbursttransfer == 1'b1) begin
		mcb_nxt_bl				<= axss_bl;
		mcb_nxt_ba				<= axss_ba;
		mcb_nxt_ra				<= axss_ra;
		mcb_nxt_ca				<= {axss_ca[MCB_C_W-1:2], 2'b00};
	end
	else begin
		mcb_nxt_bl				<= mcb_nxt_bl;
		mcb_nxt_ba				<= mcb_nxt_ba;
		mcb_nxt_ra				<= mcb_nxt_ra;
		mcb_nxt_ca				<= mcb_nxt_ca;
	end
// nxt mcb transaction arguments (split)
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0) begin
		axss_splt				<= 1'b0;
		axss_splt0_bl			<= 0;
		axss_splt1_bl			<= 0;
	end
	else if(avs_s1_beginbursttransfer == 1'b1) begin
		if(axss_ca_tst[(MCB_C_W-1)-1] == 1'b1) begin
			axss_splt			<= 1'b1;
			axss_splt0_bl		<= axss_bl - axss_ca_tst[1:0] - 2'b01;
			axss_splt1_bl		<= axss_ca_tst[1:0];						
		end
		else begin
			axss_splt			<= 1'b0;
			axss_splt0_bl		<= 0;
			axss_splt1_bl		<= 0;			
		end
	end
	else begin
		axss_splt				<= axss_splt;
		axss_splt0_bl			<= axss_splt0_bl;
		axss_splt1_bl			<= axss_splt1_bl;
	end
// axss_splt0_done
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_splt0_done			<= 1'b0;
	else if(avs_s1_beginbursttransfer == 1'b1)
		axss_splt0_done			<= 1'b0;
	else if(((avs_s1_read == 1'b1) | (avs_s1_write == 1'b1)) & (mcb_busy == 1'b0)
		& (avs_s1_beginbursttransfer == 1'b0) & (axss_splt == 1'b1)
		& (axss_splt0_done == 1'b0))
		axss_splt0_done			<= 1'b1;
	else
		axss_splt0_done			<= axss_splt0_done;
// axss_splt1_done
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		axss_splt1_done			<= 1'b0;
	else if(avs_s1_beginbursttransfer == 1'b1)
		axss_splt1_done			<= 1'b0;
	else if(((avs_s1_read == 1'b1) | (avs_s1_write == 1'b1)) & (mcb_busy == 1'b0)
		& (avs_s1_beginbursttransfer == 1'b0) & (axss_splt == 1'b1)
		& (axss_splt0_done == 1'b1))
		axss_splt1_done			<= 1'b1;
	else
		axss_splt1_done			<= axss_splt1_done;
// mcb transaction arguments
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0) begin
		mcb_bb					<= 1'b0;
		mcb_wr_n				<= 1'b0;
		mcb_bl					<= 0;
		mcb_ba					<= 0;
		mcb_ra					<= 0;
		mcb_ca					<= 0;
	end
	else if(((avs_s1_read == 1'b1) | (avs_s1_write == 1'b1)) & (mcb_busy == 1'b0)
		& (avs_s1_beginbursttransfer == 1'b0) & (axss_splt == 1'b0)) begin
		mcb_bb					<= 1'b1;
		mcb_wr_n				<= mcb_nxt_wr_n;
		mcb_bl					<= mcb_nxt_bl;
		mcb_ba					<= mcb_nxt_ba;
		mcb_ra					<= mcb_nxt_ra;
		mcb_ca					<= mcb_nxt_ca;
	end
	else if(((avs_s1_read == 1'b1) | (avs_s1_write == 1'b1)) & (mcb_busy == 1'b0)
		& (avs_s1_beginbursttransfer == 1'b0) & (axss_splt == 1'b1)) begin
		if(axss_splt0_done == 1'b0) begin
			mcb_bb				<= 1'b1;
			mcb_wr_n			<= mcb_nxt_wr_n;
			mcb_bl				<= axss_splt0_bl;
			mcb_ba				<= mcb_nxt_ba;
			mcb_ra				<= mcb_nxt_ra;
			mcb_ca				<= mcb_nxt_ca;
		end
		else if(axss_splt1_done == 1'b0) begin
			mcb_bb				<= 1'b1;
			mcb_wr_n			<= mcb_nxt_wr_n;
			mcb_bl				<= axss_splt1_bl;
			{mcb_ba, mcb_ra}	<= {mcb_nxt_ba, mcb_nxt_ra} +
									{{(MCB_B_W + MCB_R_W -1){1'b0}}, 1'b1};
			mcb_ca				<= 0;	
		end
		else begin
			mcb_bb					<= 1'b0;
			mcb_wr_n				<= mcb_wr_n;
			mcb_bl					<= mcb_bl;
			mcb_ba					<= mcb_ba;
			mcb_ra					<= mcb_ra;
			mcb_ca					<= mcb_ca;		
		end
	end
	else begin
		mcb_bb					<= 1'b0;
		mcb_wr_n				<= mcb_wr_n;
		mcb_bl					<= mcb_bl;
		mcb_ba					<= mcb_ba;
		mcb_ra					<= mcb_ra;
		mcb_ca					<= mcb_ca;
	end
// mcb_wbe signal
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		mcb_wbe					<= 0;
	else if(axss_mcb_id == 1'b0)
		mcb_wbe					<= axss_msk4wr0[11] ? 
									avs_s1_byteenable : {(MCB_BE_W){1'b0}};
	else
		mcb_wbe					<= axss_msk4wr1[11] ? 
									avs_s1_byteenable : {(MCB_BE_W){1'b0}};
// rd_tx_set
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		rd_tx_set				<= 1'b0;
	else if((avs_s1_beginbursttransfer == 1'b1) & (avs_s1_read == 1'b1))
		rd_tx_set				<= 1'b1;
	else
		rd_tx_set				<= 1'b0;
// rd_tx_pt
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		rd_tx_pt				<= 0;
	else if(rd_tx_set == 1'b1)
		rd_tx_pt				<= rd_tx_pt + 2'b01;
	else
		rd_tx_pt				<= rd_tx_pt;
// rd_rx_cnt
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		rd_rx_cnt				<= 1'b0;
	else if(mcb_rdat_vld == 1'b1)
		if(rd_rx_cnt == {rd_rx_cur_bl, 2'b11})
			rd_rx_cnt			<= 4'h0;
		else
			rd_rx_cnt			<= rd_rx_cnt + 4'h1;
	else
		rd_rx_cnt				<= rd_rx_cnt;
// rd_rx_pt
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		rd_rx_pt				<= 0;
	else if(rd_rx_cnt == {rd_rx_cur_bl, 2'b11})
		rd_rx_pt				<= rd_rx_pt + 2'b01;
	else
		rd_rx_pt				<= rd_rx_pt;
// rd_rx_cur_msk_sft
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		rd_rx_cur_msk_sft		<= 0;
	else if(rd_rx_cnt == 4'b1)
		rd_rx_cur_msk_sft		<= {rd_rx_cur_msk[10:0], 1'b0};
	else if(mcb_rdat_vld == 1'b1) 							// better plan?
		rd_rx_cur_msk_sft		<= {rd_rx_cur_msk_sft[10:0], 1'b0};
	else
		rd_rx_cur_msk_sft		<= rd_rx_cur_msk_sft;
// mcb_rdat_vld_dly1
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		mcb_rdat_vld_dly1		<= 1'b0;
	else
		mcb_rdat_vld_dly1		<= mcb_rdat_vld;
// avs_s1_readdata
always@(posedge csi_clockreset_clk, negedge csi_clockreset_reset_n)
	if(csi_clockreset_reset_n == 1'b0)
		avs_s1_readdata			<= 0;
	else
		avs_s1_readdata			<= mcb_rdat;	
endmodule
