`include "TestManager.sv"

import TestManager::*;
import usertype::*;

class FileReader;


endclass

class PatternGenerator;
    // logger
    local logging _logger;
    pattern_mode_t _mode;
    // Storage for generated input commands
    command_t _pattern[0:NUM_OF_PATTERNS-1];
    // Storage for generated datas
    data_t _data[0:NUM_OF_PATTERNS-1];

    function new(int seed,pattern_mode_t mode);
        this.srandom(seed);
        this._logger = new("PatternGenerator");
        this._mode = mode;
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

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            _pattern[i].r_w = $urandom_range(0,1);
            _pattern[i].none_0 = 0;
            _pattern[i].row_addr = $urandom_range(0,NO_OF_ROWS-1);
            _pattern[i].none_1 = 0;
            _pattern[i].burst_length = $urandom_range(0,1);
            _pattern[i].none_2 = 0;
            _pattern[i].auto_precharge = $urandom_range(0,1);
            _pattern[i].col_addr = $urandom_range(0,NO_OF_COLUMNS-1);
            _pattern[i].bank_addr = $urandom_range(0,NO_OF_BANKS-1);

            for(int j=0; j<8; j++) begin
                _data[i][j] = $urandom;
            end
        end
    endfunction

    function void generate_ideal_sequential_access_pattern();
        this._logger.info("Generating Ideal Sequential Access Pattern");
    endfunction

    function void generate_simple_test_pattern();
        this._logger.info("Generating Simple Test Pattern");
    endfunction

    function void generate_rd_wr_interleave_pattern();
        this._logger.info("Generating Read Write Interleave Pattern");
    endfunction


endclass