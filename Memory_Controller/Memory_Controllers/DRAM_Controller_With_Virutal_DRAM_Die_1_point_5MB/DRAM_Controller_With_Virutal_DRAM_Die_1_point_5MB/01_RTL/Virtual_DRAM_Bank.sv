


module Virtual_DRAM_Bank #(
    parameter NUM_SRAMS = 8,                    // SRAM 數量
    parameter sram_ADDR_BITS = 10,
    parameter sram_DQ_BITS = 128                      // 每組 SRAM 的 data width
)(
    input clk,
    input rst_n,
    input [sram_ADDR_BITS-1:0] addr,
    input [sram_DQ_BITS*NUM_SRAMS-1:0] data_all_out,

    output logic [sram_DQ_BITS*NUM_SRAMS-1:0] data_in ,

    input CEB,          // SRAM 使能信號
    input WEB        // SRAM 寫使能信號
);

    // 宣告 SRAM 所需的內部訊號
    wire [NUM_SRAMS-1:0] sleep, dsleep, sd;
    wire [NUM_SRAMS-1:0] pudelays;
    wire [sram_DQ_BITS-1:0] D[NUM_SRAMS-1:0];
    wire [sram_DQ_BITS-1:0] BWEB[NUM_SRAMS-1:0];
    wire [sram_DQ_BITS-1:0] Q[NUM_SRAMS-1:0];

    logic [sram_DQ_BITS*NUM_SRAMS-1:0] data_in_temp;

    

    genvar i;
    generate
        for (i = 0; i < NUM_SRAMS; i = i + 1) begin : SRAM_BANKS

            assign D[i] = data_all_out[sram_DQ_BITS*(i+1)-1:sram_DQ_BITS*i];

            TS1N16FFCLLULVTA640X128M4SWBSHO SRAM_inst (
                .SLP(1'b0),
                .DSLP(1'b0),
                .SD(1'b0),
                .PUDELAY(pudelays[i]),
                .CLK(clk),
                .CEB(CEB),
                .WEB(WEB),
                .BIST(1'b0),
                .CEBM(1'b0),
                .WEBM(1'b0),
                .A(addr),
                .D(D[i]),
                .BWEB(128'b0),
                .AM(10'b0),
                .DM(128'b0),
                .BWEBM(128'b0),
                .RTSEL(2'b01),
                .WTSEL(2'b01),
                .Q(Q[i])
            );

            always_comb begin
                data_in_temp[sram_DQ_BITS*(i+1)-1:sram_DQ_BITS*i] = Q[i]; // 每顆 SRAM 的輸出低位接到 data_in
            end 
        end
    endgenerate

    always_comb begin
        data_in = data_in_temp; // 將所有 SRAM 的輸出合併到 data_in
    end

    

endmodule
