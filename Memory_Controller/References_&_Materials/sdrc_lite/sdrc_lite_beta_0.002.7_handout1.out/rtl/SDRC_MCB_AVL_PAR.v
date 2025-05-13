//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller front-end : avalon wrapper
//
//	2012/05/31	version beta2.7
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`include "../rtl/SDRC_LITE_MCB_PAR.v"
// Avalon Memory-Mapped Interface
parameter	AVL_A_W			= 22;					// bits
localparam	AVL_D_W			= MCB_D_W;				// bits
localparam	AVL_BE_W		= AVL_D_W / 8;			// bits
localparam	AVL_BC_W		= 4;					// bits
// Avalon Memory-Mapped to MCB address covert
localparam	AVL_A_BA_LSB	= MCB_R_W + MCB_C_W;
localparam	AVL_A_BA_MSB	= AVL_A_BA_LSB + MCB_B_W - 1;
localparam	AVL_A_RA_LSB	= MCB_C_W;
localparam	AVL_A_RA_MSB	= AVL_A_RA_LSB + MCB_R_W - 1;
parameter	AVL_A_CA_LSB	= 0;
localparam	AVL_A_CA_MSB	= AVL_A_CA_LSB + MCB_C_W - 1;
// function: avl address to mcb bank address
function [MCB_B_W-1:0] avl_addr_to_mcb_ba(input [AVL_A_W-1:0] avl_addr);
	begin
		avl_addr_to_mcb_ba		= avl_addr[AVL_A_BA_MSB:AVL_A_BA_LSB];
	end
endfunction
// function: avl address to mcb row address
function [MCB_R_W-1:0] avl_addr_to_mcb_ra(input [AVL_A_W-1:0] avl_addr);
	begin
		avl_addr_to_mcb_ra		= avl_addr[AVL_A_RA_MSB:AVL_A_RA_LSB];
	end
endfunction
// function: avl address to mcb column address
function [MCB_C_W-1:0] avl_addr_to_mcb_ca(input [AVL_A_W-1:0] avl_addr);
	begin
		avl_addr_to_mcb_ca		= avl_addr[AVL_A_CA_MSB:AVL_A_CA_LSB];
	end
endfunction
// function: mcb address to avl address
function [AVL_A_W-1:0] mcb_addr_to_avl_addr(
	input	[MCB_B_W-1:0]	mcb_b_addr,
	input	[MCB_R_W-1:0]	mcb_r_addr,
	input	[MCB_C_W-1:0]	mcb_c_addr
);
	begin
		mcb_addr_to_avl_addr								= 0;
		mcb_addr_to_avl_addr[AVL_A_BA_MSB:AVL_A_BA_LSB]		= mcb_b_addr;
		mcb_addr_to_avl_addr[AVL_A_RA_MSB:AVL_A_RA_LSB]		= mcb_r_addr;
		mcb_addr_to_avl_addr[AVL_A_CA_MSB:AVL_A_CA_LSB]		= mcb_c_addr;
	end
endfunction
