`timescale 1ns / 10ps
`include "PATTERN.sv"
`include "Package.sv"
`include "ddr3.sv"
`include "INF.sv"


module TESTBED;

`include "2048Mb_ddr3_parameters.vh"

import Usertype::*;

INF inf();

initial begin
	  $fsdbDumpfile("Package.fsdb");
      $fsdbDumpvars(0,"+all");
      $fsdbDumpSVA;
end

Package I_Package(
//== I/O from System ===============
         .power_on_rst_n(inf.PACKAGE_PORTS.power_on_rst_n),
         .clk         (inf.PACKAGE_PORTS.clk            ),
         .clk2        (inf.PACKAGE_PORTS.clk2           ),
//==================================

//== I/O from access command =======
         .write_data      (inf.PACKAGE_PORTS.write_data     ),
         .read_data       (inf.PACKAGE_PORTS.read_data      ),
         .command         (inf.PACKAGE_PORTS.command        ),
         .valid           (inf.PACKAGE_PORTS.valid          ),
         .ba_cmd_pm  (inf.PACKAGE_PORTS.ba_cmd_pm ),
         .read_data_valid (inf.PACKAGE_PORTS.read_data_valid)
//==================================

         );

PATTERN I_PATTERN(
         .power_on_rst_n  (inf.PATTERN_PORTS.power_on_rst_n ),
         .clk             (inf.PATTERN_PORTS.clk            ),
         .clk2            (inf.PATTERN_PORTS.clk2           ),
         .write_data      (inf.PATTERN_PORTS.write_data     ),
         .read_data       (inf.PATTERN_PORTS.read_data      ),
         .command         (inf.PATTERN_PORTS.command        ),
         .valid           (inf.PATTERN_PORTS.valid          ),
         .ba_cmd_pm  (inf.PATTERN_PORTS.ba_cmd_pm ),
         .read_data_valid (inf.PATTERN_PORTS.read_data_valid)
         );

endmodule
