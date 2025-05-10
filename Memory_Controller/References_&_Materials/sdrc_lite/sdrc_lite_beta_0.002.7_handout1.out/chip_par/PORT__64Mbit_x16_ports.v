//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/05	version beta2.2c
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
// 64Mbit SDR SDRAM ports spec
parameter	SDR_A_W			= 12;					//address port width
parameter	SDR_B_W			= 2;					//2^2  = 4		banks
parameter	SDR_R_W			= 12;					//2^12 = 4096	rows
parameter	SDR_C_W			= 8;					//2^8  = 256	columns
parameter	SDR_D_W			= 16;					//data port width
parameter	SDR_M_W			= 2;					//data mask port width
