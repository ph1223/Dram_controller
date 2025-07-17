module WUPR #(
    parameter int ROW_WIDTH = 16,         // Total rows = 2^16
    parameter int N      = 16,               // Number of segments (must be power of 2)
    parameter int N_BITS = $clog2(N),     // log2(N)
    parameter int R_BITS = ROW_WIDTH - N_BITS, // log2(rows per segment)
    parameter int D_r = 1 << ROW_WIDTH    // Default to total number of rows
)(
    input  logic clk,
    input  logic rst_n,

    input  logic Rt_write,                         // Write flag
    input  logic to_refresh,                       // Refresh flag
    input  logic [ROW_WIDTH-1:0] Ra,               // Row address input

    output logic dref                              // Dummy (1) or Auto (0) refresh
);

    // Segment Peak Register
    logic [R_BITS-1:0] SPRi [0:N-1];               // SPRi[N segments]

    // Refresh counter
    logic [ROW_WIDTH-1:0] r;                       // 16-bit counter

    // Address decoding
    logic [N_BITS-1:0] Ri_write, Ri_refresh;
    logic [R_BITS-1:0] Rai, r_mod;

    // Address decoding (combinational)
    always_comb begin
        Ri_write = Ra[ROW_WIDTH-1:R_BITS];
        Rai = Ra[R_BITS-1:0];
        Ri_refresh = r[ROW_WIDTH-1:R_BITS];
        r_mod = r[R_BITS-1:0];
    end

    // Main sequential logic
    always_ff @(posedge clk or negedge rst_n) begin: WUPR_MAIN_LOGIC
        if (!rst_n) begin
            r <= 0;
            dref <= 0;
            for (int i = 0; i < N; i++)
                SPRi[i] <= '0;
        end else begin
            // === Write Path ===
            if (Rt_write) begin
                if (Rai > SPRi[Ri_write])
                    SPRi[Ri_write] <= Rai;
            end

            // === Refresh Path ===
            if (to_refresh) begin
                if (r_mod > SPRi[Ri_refresh])
                    dref <= 1;   // Dummy refresh
                else
                    dref <= 0;   // Auto refresh
            end

            // === Auto Refresh Counter ===
            r <= r + 1;
        end
    end

endmodule
