`timescale 1ns/10ps
`include "PATTERN.sv"
`ifdef RTL
    `include "WUPR.sv"
`endif
`ifdef GATE
    `include "WUPR_SYN.v"
`endif
module TESTBED;

    // Parameters
    parameter ROW_WIDTH = 16;
    parameter N = 16;
    parameter N_BITS = $clog2(N);
    parameter R_BITS = ROW_WIDTH - N_BITS;

    // DUT Signals
    logic clk;
    logic rst_n;
    logic Rt_write;
    logic to_refresh;
    logic [ROW_WIDTH-1:0] Ra;
    logic dref;
    logic clk_enable;

initial begin
    `ifdef RTL
        $fsdbDumpfile("WUPR.fsdb");
        $fsdbDumpvars(0,"+all");
        $fsdbDumpSVA;
    `endif
    `ifdef GATE
        $sdf_annotate("WUPR_SYN.sdf", u_WUPR);
        $fsdbDumpfile("WUPR_SYN.fsdb");
        $dumpfile("WUPR_SYN.vcd");
        $dumpvars(0, u_WUPR);
        $fsdbDumpvars(0,"+all");
        $fsdbDumpSVA;
    `endif
end

WUPR u_WUPR (
        .clk(clk),
        .rst_n(rst_n),
        .Rt_write(Rt_write),
        .to_refresh(to_refresh),
        .Ra(Ra),
        .dref(dref),
        .clk_enable(clk_enable) // Connect clk_enable signal
    );

PATTERN I_PATTERN
(
        .clk(clk),
        .rst_n(rst_n),
        .Rt_write(Rt_write),
        .to_refresh(to_refresh),
        .Ra(Ra),
        .dref(dref),
        .clk_enable(clk_enable)
);

endmodule
