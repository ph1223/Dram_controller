`include "command_definition_pkg.sv"
`include "define.sv"
import command_definition_pkg::*; // Import the command definition package
import initialization_state_pkg::*; // Import the initialization state package

module dram_initialization_fsm(
    input  logic clk,
    input  logic power_rst_n,
    input  logic rst_n,
    output command_t command_ff_o, // Example: Command width (adjust as needed)
    output logic initialization_done_ff_o,
    output logic[1:0] mode_register_cnt
);

    init_state_t state;
    logic[15:0] initialization_cnt;

    wire power_on_done_flag = initialization_cnt == `POWER_UP_200US_DELAY && state == FSM_POWER_UP;
    wire reset_done_flag = initialization_cnt == `RESET_PROCEDURE_500US_DELAY && state == FSM_RESET_PROCEDURE;
    wire wait_txpr_done_flag = initialization_cnt == `WAIT_TXPR_DELAY && state == FSM_WAIT_TXPR;
    wire zq_done_flag = initialization_cnt == `TZQ_INIT_DELAY && state == FSM_ZQ;
    wire lmr_done_flag = mode_register_cnt == 3'd3 && state == FSM_LMR;
    wire wait_tdllk_done_flag = initialization_cnt == `WAIT_TDLLK_DELAY && state == FSM_WAIT_TDLLK;
    wire mode_register_set_flag = initialization_cnt == `tMRD_DELAY && state == FSM_LMR;
    wire all_mode_register_set_flag = mode_register_cnt == 3'd3 && state == FSM_LMR;

    always_ff @(posedge clk or negedge power_rst_n or negedge rst_n) begin
        if(!power_rst_n) begin
            state <= FSM_POWER_UP;
            initialization_cnt <= 16'd0;
            command_ff_o <= CMD_NOP;
            initialization_done_ff_o <= 1'b0;
            mode_register_number_ff_o <= 2'd0;
        end else if (!rst_n) begin
            state <= FSM_RESET_PROCEDURE;
            initialization_cnt <= 16'd0;
            command_ff_o <= CMD_NOP;
            initialization_done_ff_o <= 1'b0;
            mode_register_number_ff_o <= 2'd0;
        end else begin
            case(state)
                FSM_POWER_UP:
                begin
                    if(power_on_done_flag) begin
                        state <= FSM_RESET_PROCEDURE;
                        initialization_cnt <= 16'd0;
                    end else begin
                        state <= FSM_POWER_UP;
                        initialization_cnt <= initialization_cnt + 16'd1;
                    end
                end
                FSM_WAIT_TXPR: begin
                    if(wait_txpr_done_flag) begin
                        state <= FSM_LMR;
                        initialization_cnt <= 16'd0;
                    end else begin
                        state <= FSM_WAIT_TXPR;
                        initialization_cnt <= initialization_cnt + 16'd1;
                    end
                end
                FSM_LMR: begin
                    if(all_mode_register_set_flag) begin
                        state <= FSM_WAIT_TDLLK;
                        initialization_cnt <= 16'd0;
                    end else if(mode_register_set_flag) begin
                        mode_register_cnt <= mode_register_cnt + 2'd1;
                        state <= FSM_LMR;
                        initialization_cnt <= 16'd0;
                    end else begin
                        state <= FSM_LMR;
                        initialization_cnt <= initialization_cnt + 16'd1;
                    end
                end
                FSM_WAIT_TDLLK: begin
                    if(wait_tdllk_done_flag) begin
                        state <= FSM_INIT_DONE;
                        initialization_cnt <= 16'd0;
                    end else begin
                        state <= FSM_WAIT_TDLLK;
                        initialization_cnt <= initialization_cnt + 16'd1;
                    end
                end
                FSM_INIT_DONE: begin
                    state <= FSM_INIT_DONE;
                    initialization_done_ff_o <= 1'b1;
                end
                default: begin
                    state <= FSM_POWER_UP;
                end
            endcase
        end
    end
endmodule
