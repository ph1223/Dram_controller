`ifdef TEST_MANAGER_H
`define TEST_MANAGER_H

typedef enum integer {
    FILE_IO,
    RD_WR_INTERLEAVE,
    RANDOM_ACCESS,
    IDEAL_SEQUENTIAL_ACCESS,
    SIMPLE_TEST_PATTERN
} pattern_mode_t;

// String controls
// Should use %0s
string reset_color       = "\033[1;0m";
string txt_black_prefix  = "\033[1;30m";
string txt_red_prefix    = "\033[1;31m";
string txt_green_prefix  = "\033[1;32m";
string txt_yellow_prefix = "\033[1;33m";
string txt_blue_prefix   = "\033[1;34m";

string bkg_black_prefix  = "\033[40;1m";
string bkg_red_prefix    = "\033[41;1m";
string bkg_green_prefix  = "\033[42;1m";
string bkg_yellow_prefix = "\033[43;1m";
string bkg_blue_prefix   = "\033[44;1m";
string bkg_white_prefix  = "\033[47;1m";

bool DEBUG_ON = 1;
integer NUM_OF_PATTERNS = 10;
pattern_mode_t PATTERN_MODE = SIMPLE_TEST_PATTERN;

//======================================
// DRAM PARAMETERS
//======================================
integer COLUMN_BITS = 10;
integer ROW_BITS = 13;
integer BANK_BITS = 3;

integer NO_OF_ROWS = 1 << ROW_BITS;
integer NO_OF_BANKS = 1 << BANK_BITS;
integer NO_OF_COLUMNS = 1 << COLUMN_BITS;

//======================================
// LOGGERS
//======================================
class logging;
    function new(string step);
        _step = step;
    endfunction

    function void info(string meesage);
        $display("[Info] %s - %s", this._step, meesage);
    endfunction

    function void error(string meesage);
        $display("[Error] %s - %s", this._step, meesage);
        $finish;
    endfunction
    string _step;
endclass

//======================================

`endif
