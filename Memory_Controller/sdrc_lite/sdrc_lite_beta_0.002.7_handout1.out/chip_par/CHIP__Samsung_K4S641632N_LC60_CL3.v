//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/04	version beta2.2c
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
// SDRAM Samsung K4S641632N-LC60 SDR SDRAM AC spec (CL=3) in ns
parameter	integer pCL		= 3;					//CL is 3 !!!
localparam	tMRD			= 2*MCB_tCK;			//De facto standard
parameter	tRP				= 18;					//ns
parameter	tRFC			= 60;					//ns, usually equal to tRC
parameter	tRCD			= 18;					//ns
localparam	tWR				= 2*MCB_tCK;			//ns, a.k.a tDPL
localparam	tDAL			= tWR + tRP;			//ns
