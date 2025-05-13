`timescale 1ns / 10ps
`include "PATTERN.sv"
`include "global_address_mapper.sv"
`include "ddr3.sv"
`include "../00_TESTBED/INF.sv"

module TESTBED;

`include "2048Mb_ddr3_parameters.vh"

import userType_pkg::*;

INF intf(); // Instantiate the interface

initial begin
	$fsdbDumpfile("Package.fsdb");
    $fsdbDumpvars(0,"+all");
    $fsdbDumpSVA;
end

global_address_mapper I_Mapper(
      .power_on_rst_n  (intf.power_on_rst_n ),
      .clk             (intf.clk            ),
      .clk2            (intf.clk2           ),

      .command         (intf.command        ),
      .write_data      (intf.write_data     ),
      .valid           (intf.valid          ),

      .ba_cmd_pm       (intf.ba_cmd_pm      ),
      .read_data       (intf.read_data      ),
      .read_data_valid (intf.read_data_valid)
); // Connect the interface to the module

PATTERN I_PATTERN(.inf(intf)); // Connect the interface to the program

endmodule
