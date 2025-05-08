module Q_srl #(
    parameter depth = 16,   // greatest number of items in queue (2 <= depth <= 256)
    parameter width = 16   // width of data (i_d, o_d)
) (
    input clock,
    input reset,
    input [width-1:0] i_d,  // input stream data (concat data + eos)
    input i_v,              // input stream valid
    output i_b,             // input stream back-pressure
    output [width-1:0] o_d, // output stream data
    output o_v,             // output stream valid
    input o_b               // output stream back-pressure
);
   
    // Compute log2(depth) for address width
    parameter addrwidth = 
        (((depth)) == 0) ? 0 :
        (((depth-1)>>0)==0) ? 0 :
        (((depth-1)>>1)==0) ? 1 :
        (((depth-1)>>2)==0) ? 2 :
        (((depth-1)>>3)==0) ? 3 :
        (((depth-1)>>4)==0) ? 4 :
        (((depth-1)>>5)==0) ? 5 :
        (((depth-1)>>6)==0) ? 6 :
        (((depth-1)>>7)==0) ? 7 : 8;

    reg [addrwidth-1:0] addr, addr_;            // SRL16 address
    reg [width-1:0] srl [depth-1:0];            // SRL16 memory
    reg shift_en_;                              // SRL16 shift enable

    // State encoding
    parameter state_empty = 1'b0;
    parameter state_nonempty = 1'b1;

    reg state, state_;                          // state register

    // Address boundary checks
    wire addr_full_ = (addr == depth-1);        // queue is full
    wire addr_zero_ = (addr == 0);              // queue contains 1 element

    // Outputs
    assign o_d = srl[addr];
    assign o_v = (state == state_empty) ? 0 : 1;
    assign i_b = addr_full_;

    // Sequential block: state and address update
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            state <= state_empty;
            addr <= 0;
        end else begin
            state <= state_;
            addr <= addr_;
        end
    end

    integer a_ ;

    // Shift register logic
    always @(posedge clock or negedge reset) begin
        if (shift_en_) begin
            // Shift data
            for (a_ = depth-1; a_ > 0; a_ = a_ - 1) begin
                srl[a_] <= srl[a_-1];
            end
            srl[0] <= i_d;
        end
    end

    // Combinational logic: control state machine
    always @* begin
        shift_en_ = 0; // Default value
        addr_ = addr; // Default value
        state_ = state; // Default value

        case (state)
            state_empty: begin
                if (i_v) begin
                    // Consume input
                    shift_en_ = 1;
                    addr_ = 0;
                    state_ = state_nonempty;
                end else begin
                    // Idle
                    shift_en_ = 0;
                    addr_ = 0;
                    state_ = state_empty;
                end
            end

            state_nonempty: begin
                if (addr_full_) begin
                    if (o_b) begin
                        // Full & can't produce
                        shift_en_ = 0;
                        addr_ = addr;
                        state_ = state_nonempty;
                    end else begin
                        // Full & can produce
                        shift_en_ = 0;
                        addr_ = addr - 1;
                        state_= state_nonempty;
                    end
                end else begin
                    if (i_v && o_b) begin
                        // Consume only
                        shift_en_ = 1;
                        addr_ = addr + 1;
                        state_ = state_nonempty;
                    end else if (i_v && !o_b) begin
                        // Consume and produce
                        shift_en_ = 1;
                        addr_ = addr;
                        state_ = state_nonempty;
                    end else if (!i_v && o_b) begin
                        // Idle
                        shift_en_ = 0;
                        addr_ = addr;
                        state_ = state_nonempty;
                    end else if (!i_v && !o_b) begin
                        // Produce only
                        shift_en_ = 0;
                        addr_ = addr_zero_ ? 0 : addr - 1;
                        state_ = addr_zero_ ? state_empty : state_nonempty;
                    end
                end
            end
        endcase
    end
endmodule
