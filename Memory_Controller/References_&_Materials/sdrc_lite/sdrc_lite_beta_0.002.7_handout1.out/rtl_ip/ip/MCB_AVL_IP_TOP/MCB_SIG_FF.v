//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/15	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_SIG_FF(
	mcb_clk,
	mcb_rst_n,
	mcb_sclr_n,
	mcb_bb,
	mcb_ba,
	mcb_ra,
	mcb_ca,
	i_prea,
	i_ref,
	i_lmr,
	c_ref,
	c_act,
	c_rda,
	c_rd,
	c_wra,
	c_wr,
	sdr_cke,
	sdr_cs_n,
	sdr_ras_n,
	sdr_cas_n,
	sdr_we_n,
	sdr_ba,
	sdr_addr
);
`include "./SDRC_LITE_MCB_PAR.vh"
// interface signals
input						mcb_clk;
input						mcb_rst_n;
input						mcb_sclr_n;
input						mcb_bb;
input	[MCB_B_W-1:0]		mcb_ba;
input	[MCB_R_W-1:0]		mcb_ra;
input	[MCB_C_W-1:0]		mcb_ca;
input						i_prea;
input						i_ref;
input						i_lmr;
input						c_ref;
input						c_act;
input						c_rda;
input						c_rd;
input						c_wra;
input						c_wr;
output						sdr_cke;
output						sdr_cs_n;
output						sdr_ras_n;
output						sdr_cas_n;
output						sdr_we_n;
output	[SDR_B_W-1:0]		sdr_ba;
output	[SDR_A_W-1:0]		sdr_addr;
// internal wires
reg		[3:0]				sdr_cmd_nxt;
reg		[SDR_B_W-1:0]		sdr_ba_nxt;
reg		[SDR_A_W-1:0]		sdr_addr_nxt;
// internal registers
reg		[MCB_B_W-1:0]		mcb_ba_rg;
reg		[MCB_R_W-1:0]		mcb_ra_rg;
reg		[MCB_C_W-1:0]		mcb_ca_rg;
reg		[3:0]				sdr_cmd_rg;
reg		[SDR_B_W-1:0]		sdr_ba_rg;
reg		[SDR_A_W-1:0]		sdr_addr_rg;
// sdram command parameter {sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}
parameter	SDR_LMR		= 4'b0000;			// sdr load mode register
parameter	SDR_REF		= 4'b0001;			// sdr refresh
parameter	SDR_PRE		= 4'b0010;			// sdr precharge
parameter	SDR_ACT		= 4'b0011;			// sdr row activate
parameter	SDR_WR		= 4'b0100;			// sdr column write
parameter	SDR_RD		= 4'b0101;			// sdr column read
parameter	SDR_BT		= 4'b0110;			// sdr burst terminate
parameter	SDR_NOP		= 4'b0111;			// sdr no operation
parameter	SDR_DSEL	= 4'b1000;			// sdr deselect
// sdram clock enable output
assign sdr_cke = 1'b1;
// sdram command/address outputs
assign {sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n} = sdr_cmd_rg;
assign sdr_ba = sdr_ba_rg;
assign sdr_addr = sdr_addr_rg;
// memory controller back-end address registers
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		mcb_ba_rg		<= 0;
		mcb_ra_rg		<= 0;
		mcb_ca_rg		<= 0;
	end
	else if(mcb_sclr_n == 1'b0) begin
		mcb_ba_rg		<= 0;
		mcb_ra_rg		<= 0;
		mcb_ca_rg		<= 0;
	end
	else if(mcb_bb == 1'b1) begin
		mcb_ba_rg		<= mcb_ba;
		mcb_ra_rg		<= mcb_ra;
		mcb_ca_rg		<= mcb_ca;
	end
	else begin
		mcb_ba_rg		<= mcb_ba_rg;
		mcb_ra_rg		<= mcb_ra_rg;
		mcb_ca_rg		<= ((c_rd == 1'b1) | (c_wr == 1'b1)) ? 
			(mcb_ca_rg + {{(MCB_C_W-3){1'b0}}, 3'b100}) : mcb_ca_rg;
	end
// sdram command/address registers
always@(posedge mcb_clk, negedge mcb_rst_n)
	if(mcb_rst_n == 1'b0) begin
		sdr_ba_rg		<= 0;
		sdr_addr_rg		<= 0;
		sdr_cmd_rg		<= SDR_NOP;
	end
	else if(mcb_sclr_n == 1'b0) begin
		sdr_ba_rg		<= 0;
		sdr_addr_rg		<= 0;
		sdr_cmd_rg		<= SDR_NOP;
	end
	else begin
		sdr_ba_rg		<= sdr_ba_nxt;
		sdr_addr_rg		<= sdr_addr_nxt;
		sdr_cmd_rg		<= sdr_cmd_nxt;	
	end
// sdram next command/address logic
always@(i_prea, i_ref, i_lmr, c_ref, c_act, c_rda, c_rd, c_wra, c_wr, 
	mcb_ba_rg, mcb_ra_rg, mcb_ca_rg)
	case({i_prea, i_ref, i_lmr, c_ref, c_act, c_rda, c_rd, c_wra, c_wr})
		9'b1_0000_0000: 	begin			//i_prea
			sdr_ba_nxt		= 0;
			sdr_addr_nxt	= {SDR_A_W{1'b1}};		//A10 should be 1
			sdr_cmd_nxt		= SDR_PRE;
		end
		9'b0_1000_0000: 	begin			//i_ref
			sdr_ba_nxt		= 0;
			sdr_addr_nxt	= 0;
			sdr_cmd_nxt		= SDR_REF;			
		end
		9'b0_0100_0000: 	begin			//i_lmr
			sdr_ba_nxt		= 0;
			sdr_addr_nxt	= MR_val;
			sdr_cmd_nxt		= SDR_LMR;			
		end
		9'b0_0010_0000: 	begin			//c_ref
			sdr_ba_nxt		= 0;
			sdr_addr_nxt	= 0;
			sdr_cmd_nxt		= SDR_REF;			
		end
		9'b0_0001_0000: 	begin			//c_act
			sdr_ba_nxt		= mcb_ba_rg;
			sdr_addr_nxt	= mcb_ra_rg;
			sdr_cmd_nxt		= SDR_ACT;
		end
		9'b0_0000_1000: 	begin			//c_rda
			sdr_ba_nxt		= mcb_ba_rg;
			sdr_addr_nxt	= col_addr_gen(mcb_ca_rg, 1'b1);
			sdr_cmd_nxt		= SDR_RD;
		end
		9'b0_0000_0100: 	begin			//c_rd
			sdr_ba_nxt		= mcb_ba_rg;
			sdr_addr_nxt	= col_addr_gen(mcb_ca_rg, 1'b0);
			sdr_cmd_nxt		= SDR_RD;
		end
		9'b0_0000_0010: 	begin			//c_wra
			sdr_ba_nxt		= mcb_ba_rg;
			sdr_addr_nxt	= col_addr_gen(mcb_ca_rg, 1'b1);
			sdr_cmd_nxt		= SDR_WR;
		end
		9'b0_0000_0001: 	begin			//c_wr
			sdr_ba_nxt		= mcb_ba_rg;
			sdr_addr_nxt	= col_addr_gen(mcb_ca_rg, 1'b0);
			sdr_cmd_nxt		= SDR_WR;
		end
		default: 			begin			//nop
			sdr_ba_nxt		= 0;
			sdr_addr_nxt	= 0;
			sdr_cmd_nxt		= SDR_NOP;
		end
	endcase
endmodule
