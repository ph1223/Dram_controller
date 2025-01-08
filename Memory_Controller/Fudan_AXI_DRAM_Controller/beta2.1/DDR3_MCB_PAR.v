//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	DDR3 controller parameter
//
//	2013/04/24	version beta0.0
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

parameter	integer pCL		= 9;					//CL is 9 !!!

// System Frequency
parameter	MCB_tCK	= 2;						//ns, 667MHz

parameter	tRP				= 15;					//ns
parameter	tRFC			= 51;					//ns, usually equal to tRC
parameter	tRCD			= 15;					//ns
parameter tMRD   = 4*MCB_tCK; //ns
localparam	tWR				= 15;			//ns, a.k.a tDPL
localparam	tDAL			= tWR + tRP;			//ns

parameter       MR_val0 = 13'b0101101011011;//17bit
parameter       MR_val1 = 13'b0000010000100;
parameter       MR_val2 = 13'b0001000100000;
parameter       MR_val3 = 13'b0000000000000;

parameter	SDR_A_W			= 13;					//address port width
parameter	SDR_B_W			= 3;					//2^2  = 4		banks
parameter	SDR_R_W			= 13;					//2^12 = 4096	rows
parameter	SDR_C_W			= 10;					//2^8  = 256	columns
parameter	SDR_D_W			= 32;					//data port width
parameter	SDR_M_W			= 4;					//data mask port width


// Memory controller back-end bus widths
parameter	MCB_B_W			= SDR_B_W;					//bits
parameter	MCB_R_W			= SDR_R_W;					//bits
parameter	MCB_C_W			= SDR_C_W;					//bits
parameter	MCB_D_W			= 2*SDR_D_W;					//bits
parameter   MCB_BE_W        = MCB_D_W/8;
parameter   MCB_T_W         = MCB_B_W+MCB_R_W+MCB_C_W;



// SDRAM Refrash interval
// All rows should be covered in 64ms for standard sdr sdram
// All rows should be covered in 16ms for automobile sdr sdram
parameter	integer tREFi	= 70313;	//ns
parameter	integer CtREFi	= 0.9*tREFi/MCB_tCK;		//clks, 0.9 for security

// SDRAM Power on initialization
// 8 refr & 200us wait in JEDEC/PC100
// 2 refr & 100us wait for Micron/ISSI
// 8 refr & 200us wait for Hynix/Elpida/WinBond/Nanya
//parameter	tINIw			= 200000;					//ns
//parameter	integer CtINIw	= 1.1*tINIw/MCB_tCK;		//clks, 1.1 for security

parameter   integer Ct = 3;



// SDRAM AC spec in clk cycles
parameter	integer CtMRDm1	= div(tMRD,MCB_tCK) - 1;	//clks
parameter	integer CtRPm1	= div(tRP,MCB_tCK) - 1;		//clks
parameter	integer CtRFCm1	= div(tRFC,MCB_tCK) - 1;	//clks
parameter	integer CtRCDm1	= div(tRCD,MCB_tCK) - 1;	//clks
parameter	integer CtWRm1	= div(tWR,MCB_tCK) - 1;		//clks
parameter	integer CtDALm1	= div(tDAL,MCB_tCK) - 1;	//clks

// SDRAM Mode register parameters
parameter	integer pBL		= 4;						//do not edit !!!
parameter	mr_rsv_val		= {(SDR_A_W-10){1'b0}};
parameter	[2:0] mr_cl_val	= pCL[2:0];					//CL should be 1,2,3
parameter	[2:0] mr_bl_val = (pBL == 1) ? 3'b000 :		// BL = 1
								(pBL == 2) ? 3'b001 :	// BL = 2
								(pBL == 4) ? 3'b010 :	// BL = 4
								(pBL == 8) ? 3'b011 :	// BL = 8
								3'b111;					// full page

// SDRAM Controller counters' widths
//parameter	I_INI_W_CNT_W	= log2(CtINIw);							//bits
//parameter	I_REF_N_CNT_W	= log2(IrefN);							//bits
//parameter	I_CMD_CNT_W		= log2(CtRFCm1);						//bits
parameter	C_CMD_CNT_W		= log2(max(CtRFCm1, pBL+CtDALm1-1-2));	//bits
parameter	D_CL_CNT_W		= log2(pCL);							//bits
parameter	D_BL_CNT_W		= log2(pBL);							//bits
parameter	R_REF_I_CNT_W	= log2(CtREFi);							//bits

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