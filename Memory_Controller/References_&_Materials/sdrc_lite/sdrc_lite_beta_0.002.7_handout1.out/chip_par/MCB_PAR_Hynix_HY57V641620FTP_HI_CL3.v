//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/10	version beta2.3a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

//SDRAM ports spec
`include "../chip_par/PORT__64Mbit_x16_ports.v"

// Memory controller back-end bus widths
localparam	MCB_B_W			= SDR_B_W;					//bits
localparam	MCB_R_W			= SDR_R_W;					//bits
localparam	MCB_C_W			= SDR_C_W;					//bits
localparam	MCB_D_W			= SDR_D_W;					//bits
localparam	MCB_BE_W		= MCB_D_W / 8;				//bits

// System Frequency
parameter	integer MCB_tCK	= 10;						//ns, 100MHz

// SDRAM Refrash interval
// All rows should be covered in 64ms for standard sdr sdram
// All rows should be covered in 16ms for automobile sdr sdram
localparam	integer tREFi	= 64000000/(2**SDR_R_W);	//ns
localparam	integer CtREFi	= 0.9*tREFi/MCB_tCK;		//clks, 0.9 for security

// SDRAM Power on initialization
// 8 refr & 200us wait in JEDEC/PC100
// 2 refr & 100us wait for Micron/ISSI
// 8 refr & 200us wait for Hynix/Elpida/WinBond/Nanya
parameter	tINIw			= 200000;					//ns
localparam	integer CtINIw	= 1.1*tINIw/MCB_tCK;		//clks, 1.1 for security
parameter	IrefN			= 8;						//times

// SDRAM Hynix HY57V641620FTP-HI SDR SDRAM AC spec (CL=3) in ns
`include "../chip_par/CHIP__Hynix_HY57V641620FTP_HI_CL3.v"

// SDRAM AC spec in clk cycles
localparam	integer CtMRDm1	= div(tMRD,MCB_tCK) - 1;	//clks
localparam	integer CtRPm1	= div(tRP,MCB_tCK) - 1;		//clks
localparam	integer CtRFCm1	= div(tRFC,MCB_tCK) - 1;	//clks
localparam	integer CtRCDm1	= div(tRCD,MCB_tCK) - 1;	//clks
localparam	integer CtWRm1	= div(tWR,MCB_tCK) - 1;		//clks
localparam	integer CtDALm1	= div(tDAL,MCB_tCK) - 1;	//clks

// SDRAM Mode register parameters
parameter	integer pBL		= 4;						//do not edit !!!
localparam	mr_rsv_val		= {(SDR_A_W-10){1'b0}};
localparam	[2:0] mr_cl_val	= pCL[2:0];					//CL should be 1,2,3
localparam	[2:0] mr_bl_val = (pBL == 1) ? 3'b000 :		// BL = 1
								(pBL == 2) ? 3'b001 :	// BL = 2
								(pBL == 4) ? 3'b010 :	// BL = 4
								(pBL == 8) ? 3'b011 :	// BL = 8
								3'b111;					// full page
localparam	MR_val			= {mr_rsv_val, 1'b0, 2'b00, 
	mr_cl_val, 1'b0 ,mr_bl_val};					//SDRAM mode register val

// SDRAM Controller counters' widths
localparam	I_INI_W_CNT_W	= log2(CtINIw);							//bits
localparam	I_REF_N_CNT_W	= log2(IrefN);							//bits
localparam	I_CMD_CNT_W		= log2(CtRFCm1);						//bits
localparam	C_CMD_CNT_W		= log2(max(CtRFCm1, pBL+CtDALm1-1-2));	//bits
localparam	D_CL_CNT_W		= log2(pCL);							//bits
localparam	D_BL_CNT_W		= log2(4*pBL);							//bits
localparam	R_REF_I_CNT_W	= log2(CtREFi);							//bits

// Functions
// log2 and ceiling it
function integer log2(input integer n);
	integer i;
	begin
		log2 = 1;
		for(i=0; 2**i<n; i = i + 1)
			log2 = i + 1;
	end
endfunction
// div and ceiling it
function integer div(input integer a, input integer b);
	integer i;
	begin
		div = 1;
		for(i=0; b*i<a; i = i + 1)
			div = i + 1;
	end
endfunction
// max of two numbers
function integer max(input integer s, input integer t);
	begin
		max = s;
		if(t > s)
			max = t;
	end
endfunction
//function: column address gen
function [SDR_A_W-1:0] col_addr_gen(input [SDR_C_W-1:0] ca, input [0:0] a10);
	reg		[SDR_A_W-2:0]	ca_ext;
	begin
		ca_ext				= {{(SDR_A_W-SDR_C_W-1){1'b0}},ca};
		col_addr_gen		= {ca_ext[SDR_A_W-2:10], a10, ca_ext[9:0]};
	end
endfunction
