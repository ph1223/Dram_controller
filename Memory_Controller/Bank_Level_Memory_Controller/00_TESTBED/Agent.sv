`ifndef AGENT_SV
`define AGENT_SV
`include "TestManager.sv"
`include "Generator.sv"
`include "Scoreboard.sv"
`include "Drivers.sv"

import usertype::*;

task run_agent();
    // create the generator
    PatternGenerator pg = new(SEED,PATTERN_MODE);
    // create the scoreboard
    Scoreboard scoreboard = new();

    data_t data_to_send;
    command_t cmd;
    // from the size of command queue, we can know how many commands are generated
    for(int i=0; i<pg.get_size_of_command_q(); i++)
    begin
        command_t cmd = pg.get_command();
        // only if write command, we need to send data
        if(cmd == WRITE) begin
            data_to_send = pg.get_data();
        end
        else begin
            data_to_send = 0;
        end

        // write to scoreboard
        scoreboard.write_data(data_to_send,cmd.row_addr,cmd.col_addr);
        // send the command and data to the memory controller
        send_command_data(cmd,data_to_send);
    end
endtask

`endif