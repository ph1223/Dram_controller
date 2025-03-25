//synopsys translate_off

//synopsys translate_on

`timescale 1ns / 10ps
`include "PATTERN.sv"
`include "define.sv"
`include "ddr3.sv"

`ifdef RTL
      `include "Backend_Controller.sv"
`endif
`ifdef GATE
    `include "Backend_Controller_SYN.v"
`endif



module TESTBED;

`include "2048Mb_ddr3_parameters.vh"


wire power_on_rst_n ;
wire clk ;
wire clk2 ;
wire [`FRONTEND_CMD_BITS-1:0]command ;
wire valid;
wire ba_cmd_pm ;

wire  [`COL_BITS-1:0]  col_addr  ;
wire  [`ROW_BITS-1:0]  row_addr  ;
wire  [`DQ_BITS*8-1:0]  write_data;
wire  [`DQ_BITS*8-1:0]  read_data ;
wire read_data_valid ;

// instantiate the ddr3 interface signals
wire rst_n;
wire cke;
wire cs_n;
wire ras_n;
wire cas_n;
wire we_n;
wire [`DM_BITS-1:0]dm_tdqs;
wire [`BA_BITS-1:0] ba;
wire [`ADDR_BITS-1:0] addr;
wire [`DQ_BITS-1:0] data_in;
wire [`DQ_BITS-1:0] data_out;
wire [`DQ_BITS-1:0] dq;
wire [`DQ_BITS*8-1:0] dq_all;
wire [`DQS_BITS-1:0] dqs;
wire [`DQS_BITS-1:0] dqs_n;
wire [`DQS_BITS-1:0] tdqs_n;
wire odt;
wire ddr3_rw;
wire [`DQS_BITS-1:0] dqs_in;
wire [`DQS_BITS-1:0] dqs_out;
wire [`DQS_BITS-1:0] dqs_n_in;
wire [`DQS_BITS-1:0] dqs_n_out;
wire [`DQ_BITS*8-1:0] data_all_in;
wire [`DQ_BITS*8-1:0] data_all_out;


initial begin
    `ifdef RTL
        $fsdbDumpfile("Backend_Controller.fsdb");
        $fsdbDumpvars(0,"+mda");
        $fsdbDumpSVA;
    `endif
    `ifdef GATE
        $sdf_annotate("Backend_Controller_SYN.sdf", u_ISP);
        $fsdbDumpfile("Backend_Controller_SYN.fsdb");
        $fsdbDumpvars(0,"+mda"); 
    `endif
end

Backend_Controller I_BackendController(
//== I/O from System ===============
         .power_on_rst_n(power_on_rst_n),
         .clk         (clk            ),
         .clk2        (clk2           ),
//==================================

//== I/O from access command =======
//Command Channel
         .o_backend_controller_ready         (ba_cmd_pm),
         .i_frontend_write_data              (write_data     ),
         .i_frontend_command_valid           (valid          ),
         .i_frontend_command                 (command        ),
//Returned data channel
         .o_backend_read_data       (read_data      ),
         .o_backend_read_data_valid (read_data_valid),
         .i_backend_controller_stall(1'b0),
//==================================
//IO DDR3
        .rst_n(rst_n),
        .ck(ck),
        .ck_n(ck_n),
        .cke(cke),
        .cs_n(cs_n),
        .ras_n(ras_n),
        .cas_n(cas_n),
        .we_n(we_n),
        .dm_tdqs(dm_tdqs),
        .ba(ba),
        .addr(addr),
        .dq(dq),
        .dq_all(dq_all),
        .dqs(dqs),
        .dqs_n(dqs_n),
        .tdqs_n(tdqs_n),
        .odt(odt)
         );


PATTERN I_PATTERN(
         .power_on_rst_n  (power_on_rst_n ),
         .clk             (clk            ),
         .clk2            (clk2           ),


         .write_data      (write_data     ),
         .read_data       (read_data      ),
         .command         (command        ),
         .valid           (valid          ),
         .ba_cmd_pm  (ba_cmd_pm ),
         .read_data_valid (read_data_valid)
);

// use port connection to connect the ddr3 bank
ddr3 Bank(
    .rst_n(rst_n),
    .ck(clk),
    .ck_n(ck_n),
    .cke(cke),
    .cs_n(cs_n),
    .ras_n(ras_n),
    .cas_n(cas_n),
    .we_n(we_n),
    .dm_tdqs(dm_tdqs),
    .ba(ba),
    .addr(addr),
    .dq(dq),
    .dq_all(dq_all),
    .dqs(dqs),
    .dqs_n(dqs_n),
    .tdqs_n(tdqs_n),

    .odt(odt)
);


endmodule