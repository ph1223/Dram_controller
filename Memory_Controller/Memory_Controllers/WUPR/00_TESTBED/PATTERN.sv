`define CLK_PERIOD 1.0
module PATTERN #(
    // Parameters
    parameter ROW_WIDTH = 16,
    parameter N = 16,
    parameter N_BITS = $clog2(N),
    parameter R_BITS = ROW_WIDTH - N_BITS
)
(
    // DUT Signals
    output logic clk,
    output logic rst_n,
    output logic Rt_write,
    output logic to_refresh,
    output logic [ROW_WIDTH-1:0] Ra,
    input  logic dref,
    output logic clk_enable
);

    localparam REFRESH_PERIOD = 3900; // Number of clock cycles to wait for refresh

    // Clock generation
    always #(`CLK_PERIOD/2) clk = ~clk;

    // Test sequence
    initial begin
        $display("=== WUPR Testbench Start ===");
        clk = 0;
        rst_n = 0;
        Rt_write = 0;
        to_refresh = 0;
        Ra = 0;
        clk_enable = 0; // Enable clock for the test

        // Reset
        #100;
        rst_n = 1;

        // === Write to segment 3 ===
        clk_enable = 1; // Enable clock for the test
        repeat(5) @(posedge clk); // Wait for clock cycles
        Rt_write = 1;
        Ra = {4'd3, {R_BITS{1'b0}}} + 10; // Write to row 10 in segment 3

        @(posedge clk);
        Rt_write = 0;
        clk_enable = 0; // Disable clock after write

        // === Trigger refresh on segment 3 with lower counter (dummy refresh expected) ===
        repeat (3) @(posedge clk); // Let r increment
        Ra = {4'd3, {R_BITS{1'b0}}}; // Point refresh to segment 3

        @(posedge clk);
        to_refresh = 0;

        @(posedge clk);
        to_refresh = 0;
        $display("[Time %0t] dref (should be 1 for dummy refresh): %0b", $time, dref);

        @(posedge clk);
        Ra = {4'd3, {R_BITS{1'b1}}};
        to_refresh = 0;

        @(posedge clk);
        to_refresh = 0;
        $display("[Time %0t] dref (should be 0 for auto refresh): %0b", $time, dref);

        for(int i=0;i<16;i++) begin
            repeat (REFRESH_PERIOD) @(posedge clk); // Wait for refresh Period
            to_refresh = 1; // Trigger refresh

            clk_enable = 1; // Enable clock for the write only
            repeat (5)@(posedge clk);
            Ra = {4'd2, {R_BITS{1'b0}}} + 5; // Write to row 5 in segment 2
            Rt_write = 1;
            @(posedge clk);
            clk_enable = 0; // Disable clock after write
            Rt_write = 0;
            @(posedge clk);
            Ra = {4'd2, {R_BITS{1'b0}}}; // Point refresh to segment 2
            to_refresh = 1;
            @(posedge clk);

        end

        $display("=== WUPR Testbench End ===");
        $finish;
    end

endmodule
