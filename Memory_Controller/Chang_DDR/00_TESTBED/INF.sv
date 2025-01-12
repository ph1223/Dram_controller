`include "../00_TESTBED/userType_pkg.sv"
interface INF();
    import  userType_pkg::*;

    // Package.sv INPUT FROM PATTERN
    logic power_on_rst_n;
    logic clk;
    logic clk2;

    command_t command;
    logic valid;

    logic [DQ_BITS*8-1:0] write_data;

    logic [3:0] ba_cmd_pm;
    logic [DQ_BITS*8-1:0] read_data;
    logic read_data_valid;

    modport PATTERN_PORTS(
    input read_data,read_data_valid,ba_cmd_pm,
    output power_on_rst_n,clk,clk2,command,valid,write_data
    );

    modport PACKAGE_PORTS(
    input power_on_rst_n,clk,clk2,command,valid,write_data,
    output read_data,read_data_valid,ba_cmd_pm
    );

endinterface