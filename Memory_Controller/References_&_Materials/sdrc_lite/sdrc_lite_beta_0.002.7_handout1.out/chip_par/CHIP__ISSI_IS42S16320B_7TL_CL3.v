//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/10	version beta2.3a
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
// SDRAM ISSI IS42S16320B-7TL SDR SDRAM AC spec (CL=3) in ns
parameter	integer pCL		= 3;					//CL is 3 !!!
localparam	tMRD			= 2*MCB_tCK;			//De facto standard
parameter	tRP				= 20;					//ns
parameter	tRFC			= 70;					//ns, usually equal to tRC
parameter	tRCD			= 20;					//ns
localparam	tWR				= 2*MCB_tCK;			//ns, a.k.a tDPL
localparam	tDAL			= tWR + tRP;			//ns
