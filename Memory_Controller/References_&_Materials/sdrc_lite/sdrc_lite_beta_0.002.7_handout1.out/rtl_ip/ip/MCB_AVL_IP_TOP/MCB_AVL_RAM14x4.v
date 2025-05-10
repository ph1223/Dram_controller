//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end : FPGA test
//
//	2012/05/30	version beta2.6
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
module MCB_AVL_RAM14x4(
	ram14x4_clk,
	ram14x4_w_en,
	ram14x4_w_addr,
	ram14x4_w_dat,
	ram14x4_r_addr,
	ram14x4_r_dat
);
// interface signals
input						ram14x4_clk;
input						ram14x4_w_en;
input	[2-1:0]				ram14x4_w_addr;
input	[14-1:0]			ram14x4_w_dat;
input	[2-1:0]				ram14x4_r_addr;
output	[14-1:0]			ram14x4_r_dat;
// internal regsiters
reg		[14-1:0]			ram14x4_r_dat;
// ram memory
reg		[14-1:0]			ram14x4[4-1:0];
// ram value update and output
always@(posedge ram14x4_clk) begin
	if(ram14x4_w_en)
		ram14x4[ram14x4_w_addr]		<= ram14x4_w_dat;
	ram14x4_r_dat 					<= ram14x4[ram14x4_r_addr];
end
endmodule
