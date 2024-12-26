`ifndef USERTYPE_SV
`define USERTYPE_SV

package usertype;

typedef enum logic
		{ READ = 0,
		WRITE = 1 }
r_w_t;

// burst length
typedef enum logic	{
	BL_4 = 0,
	BL_8 = 1
} bl_t;

typedef struct packed {
		r_w_t r_w; //0:write, 1:read
		logic none_0; //reserved
		logic[12:0] row_addr; //row address
		logic none_1; //reserved
		bl_t burst_length; //burst length
		logic none_2; //reserved
		logic auto_precharge; //auto precharge
		logic[9:0] col_addr; //column address
		logic[2:0] bank_addr; //bank address
	} command_t;

typedef enum logic[`FSM_WIDTH1-1:0]{
  FSM_POWER_UP,
  FSM_WAIT_TXPR,
  FSM_ZQ,
  FSM_LMR0,
  FSM_LMR1,
  FSM_LMR2,
  FSM_LMR3,
  FSM_WAIT_TMRD,
  FSM_WAIT_TDLLK,
  FSM_IDLE,
  FSM_READY,
  FSM_ACTIVE,
  FSM_POWER_D,
  FSM_REF,
  FSM_WRITE,
  FSM_READ,
  FSM_PRE,
  FSM_WAIT_TRRD,
  FSM_WAIT_TCCD,
  FSM_DLY_WRITE,
  FSM_DLY_READ,
  FSM_WAIT_TRCD,
  FSM_WAIT_TRTW,
  FSM_WAIT_OUT_F,
  FSM_WAIT_TWTR,
  FSM_WAIT_TRTP,
  FSM_WAIT_TW,
  FSM_WAIT_TRP,
  FSM_WAIT_TRAS,
  FSM_WAIT_TRC
} main_state_t;

typedef enum logic[`FSM_WIDTH3-1:0]{
  D_IDLE,
  D_WAIT_CL_WRITE,
  D_WAIT_CL_READ,
  D_WRITE1,
  D_WRITE2,
  D_WRITE_F,
  D_READ1,
  D_READ2,
  D_READ_F
} d_state_t;


typedef enum logic[`DQ_BITS-1:0]{
  DQ_IDLE,
  DQ_WAIT_CL_WRITE,
  DQ_WAIT_CL_READ,
  DQ_WRITE1,
  DQ_WRITE2,
  DQ_WRITE_F,
  DQ_READ1,
  DQ_READ2,
  DQ_READ_F
} dq_state_t;


typedef enum logic[`FSM_WIDTH2-1:0] {
                         B_INITIAL = 0,
                         B_IDLE = 1,
                         B_ACT_CHECK = 2,
                         B_ACTIVE = 3,
                         B_READ_CHECK = 4,
                         B_READ = 5,
                         B_WRITE_CHECK = 6,
                         B_WRITE = 7,
                         B_PRE_CHECK = 8,
                         B_PRE = 9,
                         B_ACT_STANDBY = 10
} bank_state_t;

typedef enum [2:0] {
  PROC_NO = 0,
  PROC_READ = 1,
  PROC_WRITE = 2
 } process_cmd_t;

endpackage

import usertype::*;

`endif
