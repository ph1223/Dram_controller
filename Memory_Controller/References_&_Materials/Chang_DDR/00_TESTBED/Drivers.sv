`ifdef DRIVERS_SV
`define DRIVERS_SV

// Responsible for high level to low level signal conversion
task send_command_data();
    //send command
    //wait for command to be sent
    //wait for command to be acknowledged
endtask

task random_delay(input int SEED);
    repeat( ({$random(SEED)} % 4 + 0) ) @(negedge clk);
endtask

task create_constant_delays(input int number_of_delays);
    repeat(number_of_delays) @(negedge clk);
endtask

task wait_ready();

endtask

task wait_initialization();

endtask

task wait_power_up();

endtask

`endif