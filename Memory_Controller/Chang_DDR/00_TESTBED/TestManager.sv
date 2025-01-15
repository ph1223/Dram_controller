`include "../00_TESTBED/userType_pkg.sv"
package TestManager_pkg;
import userType_pkg::*;
//======================================
// DEBUG OPTIONS
//======================================
integer DEBUG_ON = 1;
integer NUM_OF_PATTERNS = 100;
pattern_mode_t PATTERN_MODE = SIMPLE_TEST_PATTERN;
int SEED = 1234;

//======================================
// DRAM PARAMETERS
//======================================
parameter COLUMN_BITS = 10;
parameter ROW_BITS = 13;
parameter BANK_BITS = 3;

// parameter NO_OF_ROWS = 1 << ROW_BITS;
parameter NO_OF_ROWS = 1024;
parameter NO_OF_BANKS = 1 << BANK_BITS;
parameter NO_OF_COLUMNS = 1 << COLUMN_BITS;

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


endpackage