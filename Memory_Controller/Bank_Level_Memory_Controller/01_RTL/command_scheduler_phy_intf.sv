interface CMD_SCHDULER_PHY_INTF();
    //command_ff
    logic [CMD_WIDTH-1:0] command;
    logic [BANK_STATE_WIDTH-1:0] current_bank_state;
    logic [ROW_ADDR_WIDTH-1:0] activated_row_addr;
    //data controls
    logic [RW_CONTROL_WIDTH-1:0] rw_control_state;
    logic [DATA_WIDTH-1:0] data_wr_phy;
    logic [DATA_WIDTH-1:0] data_read_phy;
    logic data_full_write_phy;
    logic [IO_CNT_WIDTH-1:0] read_write_io_cnt;
endinterface // cmd_scheduler_phy_intf
