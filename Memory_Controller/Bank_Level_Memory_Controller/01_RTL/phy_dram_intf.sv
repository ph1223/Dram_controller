`include "userType.sv"
import command_definition_pkg::*; // Import the command definition package
import initialization_state_pkg::*; // Import the initialization state package

interface PHY_DRAM_INTF();
    // Connections from phy to dram
    logic i_data_full_write_phy;                      // Full write PHY data path
    logic [IO_CNT_WIDTH-1:0] i_read_write_io_cnt;     // Read/Write IO counter

    // Connections from dram to phy
    logic ck, ck_n, cke, cs_n, ras_n, cas_n, we_n, dm_tdqs;
    logic [2:0] ba;
    logic [15:0] addr;
    logic [15:0] dq;
    logic [15:0] dq_all;
    logic [1:0] dqs, dqs_n, tdqs_n;
    logic odt;

    // Connections from command scheduler to phy
    logic [BANK_STATE_WIDTH-1:0] i_current_bank_state; // Current bank state
    logic [ROW_ADDR_WIDTH-1:0] i_activated_row_addr;   // Activated row address

    // Connections from phy to command scheduler
    command_t i_command; // Input command signal

    // Connections from data controls to phy
    logic [RW_CONTROL_WIDTH-1:0] i_rw_control_state;   // Read/Write control state
    logic [DATA_WIDTH-1:0] i_data_wr_phy;             // Data for write PHY
    logic [DATA_WIDTH-1:0] o_data_read_phy;           // Data from read PHY
endinterface // phy_dram_intf
