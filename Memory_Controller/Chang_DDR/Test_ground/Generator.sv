`include "TestManager.sv"

import TestManager::*;
import usertype::*;

class FileReader;
    local logging _logger;
    string _file_directory;
    int _file;
    command_t _pattern[0:NUM_OF_PATTERNS-1];
    data_t _data[0:NUM_OF_PATTERNS-1];
    data_t _golden_data[0:NUM_OF_PATTERNS-1];

    function new(string file_directory);
        this._logger = new("FileReader");
        this._file_directory = file_directory;
    endfunction

    function void read_file_command(string command_file_directory);
        this._logger.info("Reading Command File");
        this._file = $fopen(command_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            $fscanf(this._file,"%h %h %h %h %h %h %h %h %h",_pattern[i].r_w,_pattern[i].none_0,_pattern[i].row_addr,_pattern[i].none_1,_pattern[i].burst_length,_pattern[i].none_2,_pattern[i].auto_precharge,_pattern[i].col_addr,_pattern[i].bank_addr);
        end
        $fclose(this._file);
    endfunction

    function void read_file_data(string data_file_directory);
        this._logger.info("Reading Data File");
        this._file = $fopen(data_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            for(int j=0; j<8; j++) begin
                $fscanf(this._file,"%h",_data[i][j]);
            end
        end
        $fclose(this._file);
    endfunction

    function void read_file_golden_data(string golden_data_file_directory);
        this._logger.info("Reading Golden Data File");
        this._file = $fopen(golden_data_file_directory,"r");
        if(this._file == 0) begin
            this._logger.error("File not found");
            return;
        end

        for(int i=0; i<NUM_OF_PATTERNS; i++) begin
            if($feof(this._file)) begin
                this._logger.error("End of file reached");
                break;
            end
            for(int j=0; j<8; j++) begin
                $fscanf(this._file,"%h",_golden_data[i][j]);
            end
        end
        $fclose(this._file);
    endfunction
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
        integer sequential_address;

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

            for(int j=0; j<8; j++) begin
                _data[i][j] = $urandom;
            end

            sequential_address = (sequential_address + 1);
        end
    endfunction

    function void generate_simple_test_pattern(int num_of_simple_pattern,int read_write_boundary);
        this._logger.info("Generating Simple Test Pattern");
        integer sequential_address;
        // 20 write commands, 20 read commands
        for(int i=0; i<num_of_simple_pattern; i++) begin
            if(i < read_write_boundary) begin
                _pattern[i].r_w = WRITE;
            end else begin
                _pattern[i].r_w = READ;
            end
            _pattern[i].none_0 = 0;
            _pattern[i].row_addr = sequential_address / NO_OF_COLUMNS;
            _pattern[i].none_1 = 0;
            _pattern[i].burst_length = 0;
            _pattern[i].none_2 = 0;
            _pattern[i].auto_precharge = 0;
            _pattern[i].col_addr = sequential_address % NO_OF_COLUMNS;
            _pattern[i].bank_addr = 0;

            for(int j=0; j<8; j++) begin
                _data[i][j] = $urandom;
            end

            if(sequential_address == read_write_boundary) begin
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

            for(int j=0; j<8; j++) begin
                _data[i][j] = $urandom;
            end
        end
    endfunction
endclass