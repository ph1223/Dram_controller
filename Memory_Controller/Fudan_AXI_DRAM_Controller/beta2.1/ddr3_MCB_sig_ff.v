//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 SDRAM Controller,signal ff module
//
//	2013/04/24	version beta2.0
//
//  luyanheng
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

module ddr3_mcb_sig_ff(
	ddr3_mcb_clk,
	ddr3_mcb_rst_n,

	ddr3_mcb_bb,
	ddr3_mcb_ba,
	ddr3_mcb_ra,
	ddr3_mcb_ca,
    
	i_lmr0,
    i_lmr1,
    i_lmr2,
    i_lmr3,
    i_rst,
    i_cke,
    i_odt,
    i_zq,
    i_cmd,
    
    c_prea,
	c_ref,
    c_prec,
	c_act,
//	c_rda,
	c_rd,
//	c_wra,
	c_wr,
    
	ddr3_cke,
    ddr3_odt,
    ddr3_rst,
	ddr3_cs_n,
	ddr3_ras_n,
	ddr3_cas_n,
	ddr3_we_n,
	ddr3_ba,
	ddr3_addr
);
`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
// interface signals
input						ddr3_mcb_clk;
input						ddr3_mcb_rst_n;

input						ddr3_mcb_bb;
input	[MCB_B_W-1:0]		ddr3_mcb_ba;
input	[MCB_R_W-1:0]		ddr3_mcb_ra;
input	[MCB_C_W-1:0]		ddr3_mcb_ca;

input                   	i_lmr0;
input                       i_lmr1;
input                       i_lmr2;
input                       i_lmr3;
input                       i_rst;
input                       i_cke;
input                       i_odt;
input                       i_zq;
input                       i_cmd;

input                       c_prea;
input						c_ref;
input                       c_prec;
input						c_act;
//input						c_rda;
input						c_rd;
//input						c_wra;
input						c_wr;

output						ddr3_cke;
output                      ddr3_odt;
output                      ddr3_rst;
output						ddr3_cs_n;
output						ddr3_ras_n;
output						ddr3_cas_n;
output						ddr3_we_n;
output	[SDR_B_W-1:0]		ddr3_ba;
output	[SDR_A_W-1:0]		ddr3_addr;

reg                         ddr3_cke;
reg                         ddr3_odt;
reg                         ddr3_rst;
wire			            ddr3_cs_n;
wire			            ddr3_ras_n;
wire			            ddr3_cas_n;
wire			            ddr3_we_n;
wire	[SDR_B_W-1:0]		ddr3_ba;
wire	[SDR_A_W-1:0]		ddr3_addr;

// internal wires
reg		[3:0]				ddr3_cmd_nxt;
reg		[SDR_B_W-1:0]		ddr3_ba_nxt;
reg		[SDR_A_W-1:0]		ddr3_addr_nxt;
// internal registers
reg		[MCB_B_W-1:0]		ddr3_mcb_ba_rg;
reg		[MCB_R_W-1:0]		ddr3_mcb_ra_rg;
reg		[MCB_C_W-1:0]		ddr3_mcb_ca_rg;
reg		[3:0]				ddr3_cmd_rg;
reg		[SDR_B_W-1:0]		ddr3_ba_rg;
reg		[SDR_A_W-1:0]		ddr3_addr_rg;

// sdram command parameter {sdr_cs_n, sdr_ras_n, sdr_cas_n, sdr_we_n}
parameter	DDR3_LMR		= 4'b0000;			// sdr load mode register
parameter	DDR3_REF		= 4'b0001;			// sdr refresh
parameter	DDR3_PRE		= 4'b0010;			// sdr precharge
parameter	DDR3_ACT		= 4'b0011;			// sdr row activate
parameter	DDR3_WR		    = 4'b0100;			// sdr column write
parameter	DDR3_RD		    = 4'b0101;			// sdr column read
parameter	DDR3_ZQ		    = 4'b0110;			// sdr zq control
parameter	DDR3_NOP		= 4'b0111;			// sdr no operation
parameter	DDR3_DSEL	    = 4'b1000;			// sdr deselect
// sdram clock enable output
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
    if(ddr3_mcb_rst_n == 1'b0)
        ddr3_cke <= 1'b1;
    else if(i_cke == 1'b1)
        ddr3_cke <= 1'b0;
        else
        ddr3_cke <= 1'b1;
        
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
    if(ddr3_mcb_rst_n == 1'b0)
        ddr3_rst <= 1'b1;
    else if(i_rst == 1'b1)
        ddr3_rst <= 1'b0;
        else
        ddr3_rst <= 1'b1;
        
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
    if(ddr3_mcb_rst_n == 1'b0)
        ddr3_odt <= 1'b1;
        else if(i_cke || c_wr)
            ddr3_odt <= 1'b0;
            else if(c_rd)
                ddr3_odt <= 1'b1;



// sdram command/address outputs
assign {ddr3_cs_n, ddr3_ras_n, ddr3_cas_n, ddr3_we_n} = ddr3_cmd_rg;
assign ddr3_ba = ddr3_ba_rg;
assign ddr3_addr = ddr3_addr_rg;
// memory controller back-end address registers
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0) begin
		ddr3_mcb_ba_rg		<= 0;
		ddr3_mcb_ra_rg		<= 0;
		ddr3_mcb_ca_rg		<= 0;
	end
	else if(ddr3_mcb_bb == 1'b1) begin
		ddr3_mcb_ba_rg		<= ddr3_mcb_ba;
		ddr3_mcb_ra_rg		<= ddr3_mcb_ra;
		ddr3_mcb_ca_rg		<= ddr3_mcb_ca;
	end
	else begin
		ddr3_mcb_ba_rg		<= ddr3_mcb_ba_rg;
		ddr3_mcb_ra_rg		<= ddr3_mcb_ra_rg;
		ddr3_mcb_ca_rg		<= ddr3_mcb_ca_rg;
	end
// sdram command/address registers
always@(posedge ddr3_mcb_clk, negedge ddr3_mcb_rst_n)
	if(ddr3_mcb_rst_n == 1'b0) begin
		ddr3_ba_rg		    <= 0;
		ddr3_addr_rg		<= 0;
		ddr3_cmd_rg		    <= DDR3_NOP;
	end
	else begin
		ddr3_ba_rg		    <= ddr3_ba_nxt;
		ddr3_addr_rg		<= ddr3_addr_nxt;
		ddr3_cmd_rg		    <= ddr3_cmd_nxt;	
	end
// sdram next command/address logic
always@(i_cmd, i_lmr0, i_lmr1, i_lmr2, i_lmr3, i_zq, c_prea, c_ref, c_prec, c_act, c_rd, c_wr, 
	ddr3_mcb_ba_rg, ddr3_mcb_ra_rg, ddr3_mcb_ca_rg)
	case({i_cmd, i_lmr0, i_lmr1, i_lmr2, i_lmr3, i_zq, c_prea, c_ref, c_prec, c_act, c_rd, c_wr})
		12'b1000_0000_0000: 	begin			//i_cmd
			ddr3_ba_nxt		= 0;
			ddr3_addr_nxt	= 0;		
			ddr3_cmd_nxt		= DDR3_WR;
		end
		12'b0100_0000_0000: 	begin			//i_lmr0
			ddr3_ba_nxt		= 010;
			ddr3_addr_nxt	= MR_val2;
			ddr3_cmd_nxt		= DDR3_LMR;			
		end
		12'b0010_0000_0000: 	begin			//i_lmr1
			ddr3_ba_nxt		= 011;
			ddr3_addr_nxt	= MR_val3;
			ddr3_cmd_nxt		= DDR3_LMR;			
		end
        12'b0001_0000_0000: 	begin			//i_lmr2
			ddr3_ba_nxt		= 001;
			ddr3_addr_nxt	= MR_val1;
			ddr3_cmd_nxt		= DDR3_LMR;			
		end
        12'b0000_1000_0000: 	begin			//i_lmr3
			ddr3_ba_nxt		= 000;
			ddr3_addr_nxt	= MR_val0;
			ddr3_cmd_nxt		= DDR3_LMR;			
		end
        12'b0000_0100_0000: 	begin			//i_zq
			ddr3_ba_nxt		= 0;
			ddr3_addr_nxt	= MR_val3;
			ddr3_cmd_nxt		= DDR3_ZQ;			
		end
        1212'b0000_0010_0000: 	begin			//c_prea
			ddr3_ba_nxt		    = 0;
			ddr3_addr_nxt	    = col_addr_gen(ddr3_mcb_ca_rg, 1'b1);
			ddr3_cmd_nxt		= DDR3_PRE;			
		end
		12'b0000_0001_0000: 	begin			//c_ref
			ddr3_ba_nxt		    = 0;
			ddr3_addr_nxt	    = 0;
			ddr3_cmd_nxt		= DDR3_REF;			
		end
        12'b0000_0000_1000: 	begin			//c_prec
			ddr3_ba_nxt		    = ddr3_mcb_ba_rg;
			ddr3_addr_nxt	    = col_addr_gen(ddr3_mcb_ca_rg, 1'b1);
			ddr3_cmd_nxt		= DDR3_PRE;			
		end
		12'b0000_0000_0100: 	begin			//c_act
			ddr3_ba_nxt		    = ddr3_mcb_ba_rg;
			ddr3_addr_nxt	    = ddr3_mcb_ra_rg;
			ddr3_cmd_nxt		= DDR3_ACT;
		end
//		12'b0000_0000_1000: 	begin			//c_rda
//			ddr3_ba_nxt		= ddr3_mcb_ba_rg;
//			ddr3_addr_nxt	= col_addr_gen(ddr3_mcb_ca_rg, 1'b1);//MCB_PAR
//			ddr3_cmd_nxt		= DDR3_RD;
//		end
		12'b0000_0000_0010: 	begin			//c_rd
			ddr3_ba_nxt		= ddr3_mcb_ba_rg;
			ddr3_addr_nxt	= col_addr_gen(ddr3_mcb_ca_rg, 1'b0);
			ddr3_cmd_nxt		= DDR3_RD;
		end
//		12'b0000_0000_0010: 	begin			//c_wra
//			ddr3_ba_nxt		= ddr3_mcb_ba_rg;
//			ddr3_addr_nxt	= col_addr_gen(ddr3_mcb_ca_rg, 1'b1);
//			ddr3_cmd_nxt		= DDR3_WR;
//		end
		12'b0000_0000_0001: 	begin			//c_wr
			ddr3_ba_nxt		= ddr3_mcb_ba_rg;
			ddr3_addr_nxt	= col_addr_gen(ddr3_mcb_ca_rg, 1'b0);
			ddr3_cmd_nxt		= DDR3_WR;
		end
		default: 			begin			//nop
			ddr3_ba_nxt		= 0;
			ddr3_addr_nxt	= 0;
			ddr3_cmd_nxt		= DDR3_NOP;
		end
	endcase
endmodule