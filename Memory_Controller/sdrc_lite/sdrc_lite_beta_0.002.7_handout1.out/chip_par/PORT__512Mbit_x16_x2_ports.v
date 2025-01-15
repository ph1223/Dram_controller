//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/07	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
// 512Mbit SDR SDRAM ports spec
parameter	SDR_A_W			= 13;					//address port width
parameter	SDR_B_W			= 2;					//2^2  = 4		banks
parameter	SDR_R_W			= 13;					//2^13 = 8192	rows
parameter	SDR_C_W			= 10;					//2^10 = 1024	columns
parameter	SDR_D_W			= 32;					//data port width
parameter	SDR_M_W			= 2;					//data mask port width
