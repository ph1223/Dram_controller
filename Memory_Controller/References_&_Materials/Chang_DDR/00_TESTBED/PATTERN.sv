`include "../00_TESTBED/PatternGenerator.sv"
`include "../00_TESTBED/TestManager.sv"
`include "../00_TESTBED/Scoreboard.sv"
`include "../00_TESTBED/Drivers.sv"
`include "../00_TESTBED/logger.sv"

program automatic PATTERN(INF.PATTERN_PORTS inf);
import userType_pkg::*;
import PatternGenerator_pkg::*;
import Scoreboard_pkg::*;
import logger_pkg::*;
import TestManager_pkg::*;

//======================================
//              INSTANTIATION
//======================================
// create the generator
PatternGenerator pg = new(SEED, PATTERN_MODE); // Ensure PatternGenerator is correctly defined and imported
// create the scoreboard
ScoreBoard scoreboard = new();

// Use a queue to store the output store
// to be compared with the output from the memory controller
data_t output_read_queue[$];
data_t output_golden_read_queue[$];
command_t input_command_queue[$];
data_t    input_data_queue[$];


data_t data_to_send;
command_t cmd;
integer OUTPUT_READ_Q_FILE, OUTPUT_GOLDEN_READ_Q_FILE;

initial exe_task;
initial receiver;
initial gen_clk;
initial gen_clk2;
//======================================
//              MAIN
//======================================
task exe_task;
    reset_task();
    wait_initialization();
    run_agent();
    check_golden();
    congratulation();
endtask

//======================================
//              TASKS
//======================================
task open_file_task;
    OUTPUT_READ_Q_FILE = $fopen("output_read_queue.txt");
    OUTPUT_GOLDEN_READ_Q_FILE =  $fopen("output_golden_read_queue.txt");

    // check if file is opened correctly
    if(OUTPUT_READ_Q_FILE == 0 || OUTPUT_GOLDEN_READ_Q_FILE == 0)begin
        $display("ERROR: File not opened correctly");
        $finish;
    end
endtask


task reset_task;
    inf.power_on_rst_n = 0;
    inf.clk = 0;
    inf.clk2 = 0;
    inf.write_data = 'bx;
    inf.command = 'bx;
    inf.valid = 1'b0;

    #(`CLK_DEFINE*10) inf.power_on_rst_n = 0;
    #(`CLK_DEFINE*10) inf.power_on_rst_n = 1;

endtask

task wait_initialization;
    forever begin
        if(inf.ba_cmd_pm == 4'b1111) // MEANING all the banks are now ready
            break;
        @(negedge inf.clk);
    end
endtask

task gen_clk;
    forever begin
        #(`CLK_DEFINE/2.0) inf.clk = ~inf.clk;
    end
endtask

task gen_clk2;
    forever begin
        #(`CLK_DEFINE/4.0) inf.clk2 = ~inf.clk2;
    end
endtask

task run_agent();
    // display running agent
    $display("Running agent\n");
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

        // Cache the command and data for later comparison
        input_command_queue.push_back(cmd);
        input_data_queue.push_back(data_to_send);

        // send the command and data to the memory controller
        send_command_data(cmd,data_to_send);
    end
endtask

task send_command_data(command_t cmd, data_t data_to_send);
    wait_ready();
    //send command
    inf.command = cmd;
    inf.write_data = data_to_send;
    inf.valid = 1;
    @(negedge inf.clk);
endtask

task wait_ready;
    forever begin
        // according to the bank command wants to send
        // wait for the bank to be ready
        case(cmd.bank_addr)
        0:begin
            if(inf.ba_cmd_pm[0] == 1'b1)
                break;
        end
        1:begin
            if(inf.ba_cmd_pm[1] == 1'b1)
                break;
        end
        2:begin
            if(inf.ba_cmd_pm[2] == 1'b1)
                break;
        end
        3:begin
            if(inf.ba_cmd_pm[3] == 1'b1)
                break;
        end
        endcase
        @(negedge inf.clk);
    end
endtask

task receiver;
    forever
    begin
        if(inf.read_data_valid == 1)
            output_read_queue.push_back(inf.read_data);
        @(negedge inf.clk);
    end
endtask


task check_golden;
    data_t data;
    data_t golden_read;
    integer error_counts;
    open_file_task();

    // While the input command queue is not empty, commit the command to the scoreboard
    while(input_command_queue.size() != 0)
    begin
        command_t cmd = input_command_queue.pop_front();
        // write only if cmd is write command
        if(cmd == WRITE)begin
            data = input_data_queue.pop_front();
            scoreboard.write_data(data,cmd.row_addr,cmd.col_addr);
        end else begin
            golden_read = scoreboard.read_data(cmd.row_addr,cmd.col_addr);
            output_golden_read_queue.push_back(golden_read);
        end
    end

    // Compare the output read queue with the golden read queue
    if(output_read_queue.size() != output_golden_read_queue.size())
        $display("ERROR: output_read_queue.size() != output_golden_read_queue.size()");
    else

    error_counts = 0;

    // Compare the values
    for(int i=0; i<output_read_queue.size(); i++)
    begin
        // set a miaximum of 10 errors before break

        if(output_read_queue[i] != output_golden_read_queue[i])begin
            error_counts++;
            $display("ERROR: output_read_queue[%0d] != output_golden_read_queue[%0d]",i,i);
        end

        if(error_counts > 10)
        begin
            // More than 10 errors
            $display("ERROR: More than 10 errors detected");
            // Write the output read queue and the golden read queue to a file
            $fopen("output_read_queue.txt");
            $fopen("output_golden_read_queue.txt");
            for(int i=0; i<output_read_queue.size(); i++)
            begin
                $fwrite(OUTPUT_READ_Q_FILE,"%h\n",output_read_queue[i]);
                $fwrite(OUTPUT_GOLDEN_READ_Q_FILE,"%h\n",output_golden_read_queue[i]);
            end

            //CLOSE THE FILES
            $fclose(OUTPUT_READ_Q_FILE);
            $fclose(OUTPUT_GOLDEN_READ_Q_FILE);

            $finish;
        end
    end

endtask


task congratulation;
    $display("Congratulations! All tests passed");
    $finish;
endtask

endprogram
