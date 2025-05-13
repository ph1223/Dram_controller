//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/10	version beta2.3a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
// SDRAM Micron mt48lc4m16a2-7E SDR SDRAM AC spec (CL=3) in ns
parameter	integer pCL		= 3;					//CL is 3 !!!
localparam	tMRD			= 2*MCB_tCK;			//De facto standard
parameter	tRP				= 15;					//ns
parameter	tRFC			= 66;					//ns, usually equal to tRC
parameter	tRCD			= 15;					//ns
localparam	tWR				= 2*MCB_tCK;			//ns, a.k.a tDPL
localparam	tDAL			= tWR + tRP;			//ns
