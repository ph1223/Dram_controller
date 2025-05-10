//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/07	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
module SDRC_MCB_TOP_TST_TRX16(
	mcb_clk,
	mcb_rst_n,
	tst_tx_en,
	tst_tx_sclr_n,
	tst_tx_done,
	tst_rx_done,
	mcb_bb,
	mcb_wr_n,
	mcb_bl,
	mcb_ba,
	mcb_ra,
	mcb_ca,
	mcb_busy,
	mcb_wdat_req,
	mcb_wdat
);
`include "../rtl/SDRC_LITE_MCB_PAR.v"
//parameters
parameter DAT_L			= 16;
parameter DAT_CNT_W		= 5;
parameter DAT_W			= 16;
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						tst_tx_en;
input						tst_tx_sclr_n;
output						tst_tx_done;
output						tst_rx_done;
output						mcb_bb;
output						mcb_wr_n;
output	[1:0]				mcb_bl;
output	[MCB_B_W-1:0]		mcb_ba;
output	[MCB_R_W-1:0]		mcb_ra;
output	[MCB_C_W-1:0]		mcb_ca;
input						mcb_busy;
input						mcb_wdat_req;
output	[MCB_D_W-1:0]		mcb_wdat;
// data to transmit
reg 	[DAT_W-1:0]			byte_mem[0:DAT_L-1];
// internal wires
wire	[MCB_B_W-1:0]		tst_tx_ba;
wire	[MCB_R_W-1:0]		tst_tx_ra;
wire	[MCB_C_W-1:0]		tst_tx_ca;
wire	[MCB_B_W-1:0]		tst_rx_ba;
wire	[MCB_R_W-1:0]		tst_rx_ra;
wire	[MCB_C_W-1:0]		tst_rx_ca;
// internal registers
reg							mcb_bb;
reg							mcb_wr_n;
reg		[1:0]				mcb_bl;
reg		[MCB_B_W-1:0]		mcb_ba;
reg		[MCB_R_W-1:0]		mcb_ra;
reg		[MCB_C_W-1:0]		mcb_ca;
reg		[MCB_D_W-1:0]		mcb_wdat;
reg		[DAT_CNT_W-1:0]		tst_tx_dat_pt;
reg		[DAT_CNT_W-1:0]		tst_rx_dat_pt;
reg		[3:0]				tst_tx_bst_cnt;
reg							tst_tx_wrting;
// get data from file
initial begin
	$readmemb("../bitstream/tx_tst_mem16x16.txt", byte_mem);
end
// memory map
assign {tst_tx_ba, tst_tx_ra, tst_tx_ca} = tst_tx_dat_pt;
assign {tst_rx_ba, tst_rx_ra, tst_rx_ca} = tst_rx_dat_pt;
// tst_tx_done signal
assign tst_tx_done = (tst_tx_dat_pt == DAT_L);
// tst_rx_done signal
assign tst_rx_done = (tst_rx_dat_pt == DAT_L);
// tst_tx_wrting state
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		tst_tx_wrting				<= 1'b0;
	else if(tst_tx_en == 1'b1)
		if(tst_tx_sclr_n == 1'b0)
			tst_tx_wrting			<= 1'b0;
		else
			if(tst_tx_wrting == 1'b0)
				if((mcb_busy == 1'b0) & (tst_tx_done == 1'b0))
					tst_tx_wrting	<= 1'b1;
				else
					tst_tx_wrting	<= 1'b0;
			else // [if(tst_tx_wrting == 1'b1)]
				tst_tx_wrting		<= ~(tst_tx_bst_cnt == 4'b0111);
	else
		tst_tx_wrting				<= tst_tx_wrting;
// mcb request signal & address sending
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		mcb_bb						<= 1'b0;
		mcb_wr_n					<= 1'b0;
		mcb_bl						<= 2'b00;
		mcb_ba						<= 0;
		mcb_ra						<= 0;
		mcb_ca						<= 0;
	end
	else if(tst_tx_en == 1'b1)
		if(tst_tx_sclr_n == 1'b0) begin // do TX
			mcb_bb				<= 1'b0;
			mcb_wr_n			<= 1'b0;
			mcb_bl				<= 2'b00;
			mcb_ba				<= 0;
			mcb_ra				<= 0;
			mcb_ca				<= 0;
		end
		else
			if(tst_tx_done == 1'b0)
				if((tst_tx_wrting == 1'b0) & (mcb_busy == 1'b0)) begin
					mcb_bb			<= 1'b1;
					mcb_wr_n		<= 1'b0;
					mcb_bl			<= 2'b01;
					mcb_ba			<= tst_tx_ba;
					mcb_ra			<= tst_tx_ra;
					mcb_ca			<= tst_tx_ca;
				end
				else begin
					mcb_bb			<= 1'b0;
					mcb_wr_n		<= mcb_wr_n;
					mcb_bl			<= mcb_bl;
					mcb_ba			<= mcb_ba;
					mcb_ra			<= mcb_ra;
					mcb_ca			<= mcb_ca;
				end
			else begin // TX done, so let's do RX
				if((mcb_busy == 1'b0) & (tst_rx_done == 1'b0)) begin
					mcb_bb			<= 1'b1;
					mcb_wr_n		<= 1'b1;
					mcb_bl			<= 2'b01;
					mcb_ba			<= tst_rx_ba;
					mcb_ra			<= tst_rx_ra;
					mcb_ca			<= tst_rx_ca;
				end
				else begin
					mcb_bb			<= 1'b0;
					mcb_wr_n		<= mcb_wr_n;
					mcb_bl			<= mcb_bl;
					mcb_ba			<= mcb_ba;
					mcb_ra			<= mcb_ra;
					mcb_ca			<= mcb_ca;
				end
			end
	else begin
		mcb_bb						<= 1'b0;
		mcb_wr_n					<= mcb_wr_n;
		mcb_bl						<= mcb_bl;
		mcb_ba						<= mcb_ba;
		mcb_ra						<= mcb_ra;
		mcb_ca						<= mcb_ca;
	end
// mcb wdat sending
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		mcb_wdat					<= 0;
	else if(tst_tx_en == 1'b1)
		if(tst_tx_sclr_n == 1'b0)
			mcb_wdat				<= 0;
		else
			if((tst_tx_wrting == 1'b1) & (mcb_wdat_req == 1'b1))
				mcb_wdat			<= byte_mem[tst_tx_dat_pt];
			else
				mcb_wdat			<= mcb_wdat;
	else
		mcb_wdat					<= mcb_wdat;
// transmit burst counter
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		tst_tx_bst_cnt		<= 0;
	else if((tst_tx_sclr_n == 1'b0) | (mcb_bb == 1'b1))
		tst_tx_bst_cnt		<= 0;		
	else if((tst_tx_wrting == 1'b1) & (mcb_wdat_req == 1'b1))
		tst_tx_bst_cnt		<= tst_tx_bst_cnt + 1;
	else
		tst_tx_bst_cnt		<= tst_tx_bst_cnt;				
// pointer of data to transmit
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		tst_tx_dat_pt		<= 0;
	else if(tst_tx_sclr_n == 1'b0)
		tst_tx_dat_pt		<= 0;		
	else if((tst_tx_wrting == 1'b1) & (mcb_wdat_req == 1'b1))
		tst_tx_dat_pt		<= tst_tx_dat_pt + 1;
	else
		tst_tx_dat_pt		<= tst_tx_dat_pt;
// pointer of data to receive
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0)
		tst_rx_dat_pt		<= 0;
	else if(tst_tx_sclr_n == 1'b0)
		tst_rx_dat_pt		<= 0;		
	else if((mcb_bb == 1'b1) & (mcb_wr_n == 1'b1))
		tst_rx_dat_pt		<= tst_rx_dat_pt + 8;
	else
		tst_rx_dat_pt		<= tst_rx_dat_pt;
endmodule
