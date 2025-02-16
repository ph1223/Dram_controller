package command_definition_pkg;
    // read write control state
    typedef enum logic {
        TYPE_READ = 1'b1,
        TYPE_WRITE = 1'b0
    } rw_control_state_t;

    // Schedule command definition, the physical IO FSM controlled by current bank state and counters
    typedef enum logic [3:0] {
        CMD_NOP        = 4'd0,
        CMD_READ       = 4'd1,
        CMD_WRITE      = 4'd2,
        CMD_POWER_DOWN = 4'd3,
        CMD_POWER_UP   = 4'd4,
        CMD_REFRESH    = 4'd5,
        CMD_ACTIVE     = 4'd6,
        CMD_PRECHARGE  = 4'd7,
        CMD_ZQCAL      = 4'd8,
        CMD_MRS        = 4'd9,
        CMD_RESET      = 4'd10,
        CMD_LOAD_MODE  = 4'd11,
        CMD_ZQ_CALIBRATION = 4'd12
    } command_t;

    //burst length
    typedef enum logic	{
	BL_4 = 0,
	BL_8 = 1
    } burst_legnth_t;
    
    // command_schdeuler command type
    typedef struct packed {
      command_t cmd;
      burst_legnth_t burst_length;
      logic[13:0] row_addr;
      logic[13:0] col_addr;
      logic[2:0] bank_addr;
    } bank_command_t;
endpackage

