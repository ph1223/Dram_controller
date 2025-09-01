`define SRAM_COL_BITS 4
`define SRAM_DQ_BITS 1024
`define SRAM_ROW_BITS 6
// `include "DW_fifo_s1_df.v"
`include "Virtual_DRAM_Bank.sv"
module Virtual_DRAM_logic_die (
    
    clk,
    rst_n,

    state,
    addr,
    wdata_fifo_ren,
    read_data_buf_valid,
    data_all_out,
    data_in
);

input wire clk;
input wire rst_n;
input main_state_t state;
input [`ADDR_BITS-1:0] addr;
input wdata_fifo_ren;
input read_data_buf_valid;
input [`SRAM_DQ_BITS-1:0] data_all_out;
output [`SRAM_DQ_BITS-1:0] data_in;

wire [`SRAM_COL_BITS + `SRAM_ROW_BITS:0] fifo_in, fifo_out;

wire push_n;
wire pop_n;
wire empty_inst;
wire almost_empty_inst;
wire half_full_inst;
wire almost_full_inst;
wire full_inst;
wire error_inst;

reg [`SRAM_DQ_BITS-1:0] data_all_out_reg;
reg [`SRAM_DQ_BITS-1:0] data_in_reg;
wire [`SRAM_DQ_BITS-1:0] SRAM_out;

reg read_data_flag;

reg web_reg;

reg run_new_request_flag;

reg first_flag;
reg wdata_fifo_ren_reg;

logic [`SRAM_COL_BITS + `SRAM_ROW_BITS:0] request_reg;
// wire [`SRAM_COL_BITS + `SRAM_ROW_BITS-1:0] sram_addr;
wire [`SRAM_COL_BITS + `SRAM_ROW_BITS - 1:0] sram_addr;

logic [`SRAM_ROW_BITS - 1:0] sram_row_reg;

assign fifo_in[`SRAM_COL_BITS+`SRAM_ROW_BITS] = state == FSM_READ ? 1'b0 : 1'b1;
assign fifo_in[`SRAM_COL_BITS + `SRAM_ROW_BITS-1:`SRAM_COL_BITS] = sram_row_reg;//row
assign fifo_in[`SRAM_COL_BITS-1:0] = addr[`SRAM_COL_BITS-1:0];//col

assign push_n = ((state == FSM_READ || state == FSM_WRITE) && !first_flag && !full_inst) ? 1'b0 : 1'b1;
assign pop_n = ((wdata_fifo_ren_reg || read_data_buf_valid) && !first_flag && !empty_inst) ? 1'b0 : 1'b1;////////////////////////////20250619


reg [1:0] fifo_num;
always_ff@(posedge clk or negedge rst_n) begin:FIFO_NUM_DEBUG
    if(!rst_n) begin
        fifo_num <= 1'b0; // default to empty
    end 
    else begin
        fifo_num <= fifo_num + (~push_n) - (~pop_n); // increment or decrement based on push/pop    
    end
end

always_ff@(posedge clk or negedge rst_n) begin:SRAM_ROW_ADDR
    if(!rst_n) begin
        sram_row_reg <= '0; // default to 0
    end else begin
        if(state == FSM_ACTIVE) begin
            sram_row_reg <= addr[`SRAM_ROW_BITS-1:0];
        end
    end
end


// assign sram_addr = request_reg[`SRAM_COL_BITS-1:0];
// assign sram_addr = request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS-1:0];
assign sram_addr = (request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS-1:`SRAM_COL_BITS] << `SRAM_COL_BITS) | request_reg[`SRAM_COL_BITS-1:0]; // concatenate row and column bits

// always_ff@(posedge clk ) begin
//     if(state == FSM_WRITE) begin

//         $display("WRITE request: backend addr: %d, sram addr: %d" ,addr, addr[`SRAM_COL_BITS-1:0]);
//     end
//     else if(state == FSM_READ) begin
//         $display("READ request: backend addr: %d, sram addr: %d" ,addr, addr[`SRAM_COL_BITS-1:0]);
//     end
// end




assign data_in = data_in_reg;


// request fifo (depth = 4)
//state+addr fifo
DW_fifo_s1_sf_inst #(.width(`SRAM_COL_BITS + `SRAM_ROW_BITS + 1),.depth(3),.err_mode(2),.rst_mode(0)) isu_fifo(
    .inst_clk(clk),
    .inst_rst_n(rst_n),
    .inst_push_req_n(push_n),
    .inst_pop_req_n(pop_n),
    .inst_diag_n(1'b1),
    .inst_data_in(fifo_in),
    .empty_inst(empty_inst),
    .almost_empty_inst(almost_empty_inst),
    .half_full_inst(half_full_inst),
    .almost_full_inst(almost_full_inst),
    .full_inst(full_inst),
    .error_inst(error_inst),
    .data_out_inst(fifo_out));


// Virtual DRAM Bank

Virtual_DRAM_Bank #(
    .NUM_SRAMS(8),
    .sram_ADDR_BITS(10),
    .sram_DQ_BITS(128)
) Virtual_DRAM_Bank_inst (
    .clk(clk),
    .rst_n(rst_n),
    .addr(sram_addr),
    .data_all_out(data_all_out_reg),
    .data_in(SRAM_out),
    .CEB(1'b0), // SRAM enable signal, set to 0 for always enabled
    .WEB(web_reg) // SRAM write enable signal, controlled by web_reg
);



//data_all_out_reg
always_ff@(posedge clk or negedge rst_n) begin:DATA_ALL_OUT_FF
    if(!rst_n) begin
        data_all_out_reg <= '0;
    end else begin
        data_all_out_reg <= data_all_out;
    end
end
always_ff@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_in_reg <= '0;
    end else begin
        data_in_reg <= SRAM_out;
    end
end

//web_reg
always_ff@(posedge clk or negedge rst_n) begin:WEB_SIGNAL_FF
    if(!rst_n) begin
        web_reg <= 1'b1; // default to write enable
    end else begin
        if(request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS] == 1'b1 && wdata_fifo_ren == 1'b1) begin
            web_reg <= 1'b0; // set to write enable when reading or writing
            // $$display("");
        end 
        else begin
            web_reg <= 1'b1; // set to read enable otherwise
        end
    end
end

reg read_done;

always_ff@(posedge clk or negedge rst_n) begin:READ_DONE_FLAG
    if(!rst_n) begin
        read_done <= 1'b0; // default to not done
    end 
    else begin
        if(request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS] == 1'b0 && read_done == 1'b0 && first_flag == 1'b0) begin
            read_done <= 1'b1; // set to done when reading
        end
        else if (read_done == 1'b1 && read_data_buf_valid) begin
            read_done <= 1'b0; // reset done flag when read data is valid
        end
    end
end

logic write_done;
// always_ff@(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin
//         write_done <= 1'b0; // default to not done
//     end 
//     else begin
//         if(request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS] == 1'b1 && write_done == 1'b0 && first_flag == 1'b0) begin
//             write_done <= 1'b1; // set to done when writing
//         end
//         else if (write_done == 1'b1 && wdata_fifo_ren_reg) begin
//             write_done <= 1'b0; // reset done flag when write data is valid
//         end
//     end
// end

//run_new_request_flag
always_ff@(posedge clk or negedge rst_n) begin:NEW_REQ_FLAG
    if(!rst_n) begin
        run_new_request_flag <= 1'b0; // default to not running new request
    end 
    else begin
        // if(first_flag == 1'b1){
        //     run_new_request_flag <= 1'b1;
        // }
        // else if((request_reg[`SRAM_COL_BITS] == 1'b0))begin// read request
        //     run_new_request_flag <= 1'b0; 
        // end
        // else if(request_reg[`SRAM_COL_BITS] == 1'b1 && wdata_fifo_ren_reg == 1'b1)begin // write request
        //     run_new_request_flag <= 1'b0; 
        // end
        // else if(run_new_request_flag == 1'b1 && ((request_reg[`SRAM_COL_BITS] == 1'b0)))

        if(run_new_request_flag == 1'b1) begin
            run_new_request_flag <= 1'b0; // reset flag after running new request
        end
        else begin
            if(request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS] == 1'b1 && wdata_fifo_ren == 1'b1) begin
                run_new_request_flag <= 1'b1;
            end
            else if(request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS] == 1'b0 && read_done == 1'b0) begin
                run_new_request_flag <= 1'b1; // set to run new request when reading data
            end

        end

    end
end

//first_flag
always_ff@(posedge clk or negedge rst_n) begin:INITIAL_REQ_FLAG
    if(!rst_n) begin
        first_flag <= 1'b1; // default to first request
    end else begin
        if((read_data_buf_valid || wdata_fifo_ren_reg) && empty_inst == 1'b1 && first_flag == 1'b0) begin
            first_flag <= 1'b1; // set to first request when read data buffer is valid or write data FIFO is ready
        end 

        else if((state == FSM_READ || state == FSM_WRITE)) begin ////////////////////////////////////20250619
        // if(read_data_buf_valid || wdata_fifo_ren_reg)begin
            first_flag <= 1'b0; // set to not first request when running new request
        end 
    end
end

// wdata_fifo_ren_reg
always_ff@(posedge clk or negedge rst_n) begin:WDATA_FIFO_REN_FF
    if(!rst_n) begin
        wdata_fifo_ren_reg <= '0;
    end else begin
        wdata_fifo_ren_reg <= wdata_fifo_ren;
    end
end


//request_reg
always_ff@(posedge clk or negedge rst_n) begin:REQ_FF
    if(!rst_n) begin
        request_reg <= '0;
    end else begin
        if(first_flag == 1'b1 && (state == FSM_READ || state == FSM_WRITE)) begin
            //request_reg <= {(state == FSM_READ ? 1'b0 : 1'b1), addr[`SRAM_COL_BITS-1:0]};
            // request_reg[`SRAM_COL_BITS] <= state == FSM_READ ? 1'b0 : 1'b1;
            // request_reg[`SRAM_COL_BITS-1:0] <= addr[`SRAM_COL_BITS-1:0];

            request_reg[`SRAM_COL_BITS+`SRAM_ROW_BITS] <= state == FSM_READ ? 1'b0 : 1'b1;
            request_reg[`SRAM_COL_BITS + `SRAM_ROW_BITS-1:`SRAM_COL_BITS] <= sram_row_reg;//row
            request_reg[`SRAM_COL_BITS-1:0] <= addr[`SRAM_COL_BITS-1:0];//col
        end
        else if((read_data_buf_valid || wdata_fifo_ren_reg)) begin
            request_reg <= fifo_out;
        end 
    end
end



endmodule
