`include "define.sv"
`include "userType_pkg.sv"
import command_definition_pkg::*; // Import the command definition package

module command_scheduler (
    // Clock and Reset
    input logic clk1,
    input logic clk2,
    input logic rst_n,

    // Initialization signal
    input logic init_done_flag, // Indicating that the initialization is done, state machine can starts

    // CMD CHANNEL FROM ISSUE FIFO
    input bank_command_t i_issue_command,
    output o_issue_queue_ren,
    input i_issue_queue_empty,

    // DATA CHANNEL FROM DATA FIFO
    input logic [8*`DQ_BITS-1:0] i_write_data,
    output o_write_data_ren,
    input i_write_data_queue_empty,
    output logic read_data_valid,
    output logic [8*`DQ_BITS-1:0] read_data,
    
    // CMD CHANNEL TO PHY
    output bank_command_t o_commands,
    output logic [2:0] o_mode_register_num,
    output logic [`BA_BITS-1:0] o_bank_address,
    output logic [`ROW_ADDR_WIDTH-1:0] o_activated_row_address,
    
    // DATA CHANNEL FROM PHY
    output rw_control_state_t o_data_type,
    output logic [`DQ_BITS-1:0] o_write_data,
    input logic [8*`DQ_BITS-1:0] i_full_read_data,
    output logic [8*`DQ_BITS-1:0] o_full_write_data
);

    // Module implementation goes here

endmodule