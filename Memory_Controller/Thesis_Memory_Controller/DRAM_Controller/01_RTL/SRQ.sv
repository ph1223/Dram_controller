// Give me a SRQ.sv with parametrized width, output full signal, output empty signal and input in_valid, output out_valid, input clk, input rst, input [width-1:0] data_in, output [width-1:0] data_out. The SRQ should be a synchronous FIFO with a depth of 16 and a width of 1024 bits. The SRQ should have a full signal that is high when the FIFO is full and an empty signal that is high when the FIFO is empty. The SRQ should have a write enable signal that is high when data can be written to the FIFO and a read enable signal that is high when data can be read from the FIFO. The SRQ should have a reset signal that resets the FIFO to an empty state. The SRQ should have a clock signal that is used to clock the FIFO. The SRQ should have a valid signal that indicates when data is valid.
// The SRQ should have a data input and a data output. The SRQ should have a parameterized width that can be set to any value. The SRQ should have a parameterized depth that can be set to any value. The SRQ should have a parameterized data type that can be set to any value. The SRQ should have a parameterized clock frequency that can be set to any value. The SRQ should have a parameterized reset type that can be set to any value. The SRQ should have a parameterized valid type that can be set to any value. The SRQ should have a parameterized write enable type that can be set to any value. The SRQ should have a parameterized read enable type that can be set to any value. The SRQ should have a parameterized full type that can be set to any value. The SRQ should have a parameterized empty type that can be set to any value. The SRQ should have a parameterized data input type that can be set to any value. The SRQ should have a parameterized data output type that can be set to any value.

module SRQ #(
    parameter WIDTH = 1024
)(
    input wire clk,
    input wire rst,
    input push,
    output reg out_valid,
    input wire [WIDTH-1:0] data_in,
    input wire pop,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty,
    output wire error_flag
);

    localparam DEPTH = 4;

    logic valid_shift_register_line[DEPTH-1:0];
    logic [WIDTH-1:0] data_shift_register_line[DEPTH-1:0];

    logic valid_shift_register_line_next[DEPTH-1:0];
    logic [WIDTH-1:0] data_shift_register_line_next[DEPTH-1:0];

    integer i;

    // flags
    assign full = valid_shift_register_line[0] ==1'b1 && valid_shift_register_line[1] == 1'b1 && valid_shift_register_line[2] == 1'b1 && valid_shift_register_line[3] == 1'b1;
    assign empty = valid_shift_register_line[0] == 1'b0 && valid_shift_register_line[1] == 1'b0 && valid_shift_register_line[2] == 1'b0 && valid_shift_register_line[3] == 1'b0;
    assign out_valid = valid_shift_register_line[DEPTH-1];
    assign data_out = data_shift_register_line[DEPTH-1];
    assign error_flag = (push && full) || (pop && empty && valid_shift_register_line[DEPTH-1] == 1'b0);

    always_ff @(posedge clk) begin:DATA_SHIFT_REGISTER_CHAIN
        for (int i = 0; i < DEPTH; i++) begin
            data_shift_register_line[i] <= data_shift_register_line_next[i];
        end
    end

    always_ff@(posedge clk or negedge rst) begin : VALID_LOGIC_SHIFT_REGISTER_CHAIN
        if (!rst) begin
            for (int i = 0; i < DEPTH; i++) begin
                valid_shift_register_line[i] <= 1'b0;
            end
        end else begin
            for (int i = 0; i < DEPTH; i++) begin
                valid_shift_register_line[i] <= valid_shift_register_line_next[i];
            end
        end
    end

    // HEAD    1 2    3
    // Tail   Middle  Tail 

    always_comb begin : NEXT_LOGIC
        //initialization
        for (int i = 0; i < DEPTH; i++) begin
            valid_shift_register_line_next[i] = valid_shift_register_line[i];
            data_shift_register_line_next[i] = data_shift_register_line[i];
        end
        // head, mark as arr[0]
        // Can only accept value if push is high and not full,
        // If the next register's valid is 0, and the current register's valid is 1, then we can push the value to the next register
        // If the next register's valid is 1, and the current register's valid is 0, then we can push the value to the current register
        
        data_shift_register_line_next[0] = data_in; // always accept the data in, but only push it if the conditions are met
        if(empty && push) begin
           // Push the data directly into the tail register, head register remains 0
            valid_shift_register_line_next[0] = 1'b0;
            // data_shift_register_line_next[0] = data_in;
        end
        else if(pop && !empty) begin
            if(push) 
            begin
                valid_shift_register_line_next[0] = 1'b1;
            end
            else
            begin
                // Unconditionally shifting, clear out the head register
                valid_shift_register_line_next[0] = 1'b0;
            end
        end 
        else if (push && !full) begin
            // Push the signal in, validates the head register
            valid_shift_register_line_next[0] = 1'b1;
        end 
        else if (valid_shift_register_line[0] == 1'b1 && valid_shift_register_line[1] == 1'b0) begin
            // Shift the data to the next stage, clear out the register
            valid_shift_register_line_next[0] = 1'b0;
        end else begin // remains
            valid_shift_register_line_next[0] = valid_shift_register_line[0];
            data_shift_register_line_next[0] = data_shift_register_line[0];
        end

        // middle shift register lines
        // During pop, shift the register data to next stage
        // If the next register's valid is 0, and the current register's valid is 1, then we can push the value to the next register
        // If the next register's valid is 1, and the current register's valid is 0, then we can push the value to the current register
        if(pop && !empty) begin
            // Unconditionally shifting, clear out the register
            valid_shift_register_line_next[1] = valid_shift_register_line[0];
            data_shift_register_line_next[1] = data_shift_register_line[0];
        end
        else if (valid_shift_register_line[1] == 1'b1 && valid_shift_register_line[2] == 1'b1) begin //Current register is not empty
            // remains
            valid_shift_register_line_next[1] = valid_shift_register_line[1];
            data_shift_register_line_next[1] = data_shift_register_line[1];
        end else begin
            // Current register is empty, so we can push the value from the previous stage in
            valid_shift_register_line_next[1] = valid_shift_register_line[0];
            data_shift_register_line_next[1] = data_shift_register_line[0];
        end

        // Shifts
        data_shift_register_line_next[2] = data_shift_register_line[1];
        // Follow the same logic as above for the next register
        if(pop && !empty) begin
            // Accept the value from the previous stage
            valid_shift_register_line_next[2] = valid_shift_register_line[1];
        end
        else if (valid_shift_register_line[2] == 1'b1 && valid_shift_register_line[3] == 1'b1) begin
            //remains
            valid_shift_register_line_next[2] = valid_shift_register_line[2];
            data_shift_register_line_next[2] = data_shift_register_line[2];
        end else begin
            //Current register is empty, so we can push the value from the previous stage in
            valid_shift_register_line_next[2] = valid_shift_register_line[1];
        end

        // tail as last register, mark as arr[3]
        // Can receive value if valid is low,
        // Can only receive value from the previous stage if pop is high and not empty,
        // If the next register's valid is 0, and the current register's valid is 1, then we can push the value to the next register
        if(empty && push) begin
            // push the in data directly to the last register
            valid_shift_register_line_next[3] = 1'b1;
            data_shift_register_line_next[3] = data_in;
        end
        else if(pop && !empty) begin
            // Unconditionally shifting Receive value from previous stage
            valid_shift_register_line_next[3] = valid_shift_register_line[2];
            data_shift_register_line_next[3]  = data_shift_register_line[2];
        end
        else if(valid_shift_register_line[3] == 1'b0) // This register is empty
        begin
            // Accepts the value from the previous stage
            valid_shift_register_line_next[3] = valid_shift_register_line[2];
            data_shift_register_line_next[3] = data_shift_register_line[2];
        end
        else begin
            valid_shift_register_line_next[3] = valid_shift_register_line[3];
            data_shift_register_line_next[3] = data_shift_register_line[3];
        end 
    end
endmodule






































