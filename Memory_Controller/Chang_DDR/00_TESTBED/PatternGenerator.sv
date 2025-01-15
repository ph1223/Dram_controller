`include "../00_TESTBED/TestManager.sv"
`include "../00_TESTBED/userType_pkg.sv"
`include "../00_TESTBED/logger.sv"

package PatternGenerator_pkg;

import userType_pkg::*;
import logger_pkg::*;
import TestManager_pkg::*;

class PatternGenerator;
    // logger
    local logging _logger;
    pattern_mode_t _mode;
    // Storage for generated input commands
    command_t _pattern[$];
    // Uses systemverilog queue
    data_t _data[$];

    function new(int seed,pattern_mode_t mode);
        this.srandom(seed);
        this._logger = new("PatternGenerator");
        this._mode = mode;
    endfunction

    function get_size_of_write_data();
        return _data.size();
    endfunction

    function get_size_of_command_q();
        return _pattern.size();
    endfunction

    function command_t get_command();
        // check if empty
        if(_pattern.size() == 0) begin
            this._logger.error("Pattern Queue is empty");
            return 0;
        end
        return _pattern.pop_front();
    endfunction

    function data_t get_data();
        // check if empty
        if(_data.size() == 0) begin
            this._logger.error("Data Queue is empty");
            return 0;
        end
        return _data.pop_front();
    endfunction

    function void generate_pattern();
        case(this._mode)
            RANDOM_ACCESS: generate_random_access_pattern();
            IDEAL_SEQUENTIAL_ACCESS: generate_ideal_sequential_access_pattern();
            SIMPLE_TEST_PATTERN: generate_simple_test_pattern();
            RD_WR_INTERLEAVE: generate_rd_wr_interleave_pattern();
            default: this._logger.error("Invalid Pattern Mode");
        endcase
    endfunction

    function void generate_random_access_pattern();
        this._logger.info("Generating Random Access Pattern");

        // data_t temp_data;

        for(int i=0; i<NUM_OF_PATTERNS; i++)
        begin
            // insert data only if it is a write command
            if(_pattern[i].r_w == WRITE)
            begin
                _data.push_back(1);
            end
        end
    endfunction

    function void generate_ideal_sequential_access_pattern();

        integer sequential_address;

        this._logger.info("Generating Ideal Sequential Access Pattern");
        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            _pattern[i].r_w = READ;
            _pattern[i].none_0 = 0;
            _pattern[i].row_addr = sequential_address / NO_OF_COLUMNS;
            _pattern[i].none_1 = 0;
            _pattern[i].burst_length = 0;
            _pattern[i].none_2 = 0;
            _pattern[i].auto_precharge = 0;
            _pattern[i].col_addr = sequential_address % NO_OF_COLUMNS;
            _pattern[i].bank_addr = 0;

            //write
            if(_pattern[i].r_w == WRITE)
                _data.push_back(1);

            sequential_address = (sequential_address + 1);
        end
    endfunction

    function void generate_simple_test_pattern();
        integer sequential_address;
        command_t temp_pattern;
        int num_of_simple_pattern;
        int read_write_boundary;

        num_of_simple_pattern = 40;
        read_write_boundary = 20;


        // 20 write commands, 20 read commands
        for(int i=0; i<num_of_simple_pattern; i++)
        begin

            if(i < read_write_boundary) begin
                temp_pattern.r_w = WRITE;
            end else begin
                temp_pattern.r_w = READ;
            end
            temp_pattern.none_0 = 0;
            temp_pattern.row_addr = sequential_address / NO_OF_COLUMNS;
            temp_pattern.none_1 = 0;
            temp_pattern.burst_length = 0;
            temp_pattern.none_2 = 0;
            temp_pattern.auto_precharge = 0;
            temp_pattern.col_addr = sequential_address % NO_OF_COLUMNS;
            temp_pattern.bank_addr = 0;

            _pattern.push_back(temp_pattern);

            if(_pattern[i].r_w == WRITE)
                _data.push_back(1);

            if(sequential_address == read_write_boundary)
                sequential_address = 0;
            else
                sequential_address = (sequential_address + 1);
        end
    endfunction

    function void generate_rd_wr_interleave_pattern();
        this._logger.info("Generating Read Write Interleave Pattern");
        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if(i % 2 == 0) begin
                _pattern[i].r_w = WRITE;
            end else begin
                _pattern[i].r_w = READ;
            end

            _pattern[i].none_0 = 0;
            _pattern[i].row_addr = $urandom_range(0,NO_OF_ROWS-1);
            _pattern[i].none_1 = 0;
            _pattern[i].burst_length = $urandom_range(0,1);
            _pattern[i].none_2 = 0;
            _pattern[i].auto_precharge = $urandom_range(0,1);
            _pattern[i].col_addr = $urandom_range(0,NO_OF_COLUMNS-1);
            _pattern[i].bank_addr = $urandom_range(0,NO_OF_BANKS-1);

            if(_pattern[i].r_w == WRITE)
                _data.push_back(1);
        end
    endfunction
endclass

endpackage
