`ifndef USERTYPE_SV
`define USERTYPE_SV

`include "define.v"

package userType_pkg;

typedef logic[8*`DQ_BITS-1:0] data_t;



typedef enum integer {
    FILE_IO,
    RD_WR_INTERLEAVE,
    RANDOM_ACCESS,
    IDEAL_SEQUENTIAL_ACCESS,
    SIMPLE_TEST_PATTERN
} pattern_mode_t;

typedef enum logic
		{ READ = 1,
		WRITE = 0 }
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

typedef struct packed {
  r_w_t r_w;
  logic[13:0] row_addr;
  logic[13:0] col_addr;
  logic[2:0] bank_addr;
} bank_command_t;

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
  FSM_WAIT_TWR,
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
  B_INITIAL,
  B_IDLE,
  B_ACTIVE,
  B_ACT_CHECK,
  B_WRITE,
  B_READ,
  B_WRITE_CHECK,
  B_READ_CHECK,
  B_PRE,
  B_PRE_CHECK,
  B_ACT_STANDBY
} bank_state_t;

typedef enum [2:0] {
  PROC_NO = 0,
  PROC_READ = 2,
  PROC_WRITE = 1
 } process_cmd_t;

 typedef enum [3:0] {
  ATCMD_NOP,
  ATCMD_READ,
  ATCMD_WRITE,
  ATCMD_POWER_D,
  ATCMD_POWER_U,
  ATCMD_REFRESH,
  ATCMD_ACTIVE,
  ATCMD_PRECHARGE
 } sch_cmd_t;

endpackage

`endif