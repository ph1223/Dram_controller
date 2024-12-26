`ifndef USERTYPE_SV
`define USERTYPE_SV

package usertype;

typedef struct packed {
		logic r_w; //0:write, 1:read
		logic none_0; //reserved
		logic[12:0] row_addr; //row address
		logic none_1; //reserved
		logic burst_length; //burst length
		logic none_2; //reserved
		logic auto_precharge; //auto precharge
		logic[9:0] col_addr; //column address
		logic[2:0] bank_addr; //bank address
	} command_t;

endpackage

import usertype::*;

`endif
