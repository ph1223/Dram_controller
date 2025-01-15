//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,bank row control module
//
//     2013/04/24  beta version 2.01
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module row_ctl(
    ddr3_mcb_clk,
    ddr3_mcb_rst_n,
    
    data_full,
    write_req,

    addr,
    read_req,
    
    ddr3_mcb_ba,
    ddr3_mcb_ra,
    ddr3_mcb_ca,

    ddr3_mcb_wr_n,
    row_hit0,
    row_miss0,
    row_empty0,
    c_ref,
    ddr3_mcb_i_ready
);

    parameter AXI_DW = 256;  //AXI data bus width          
    parameter AXI_AW = 32;  //AXI address bus width
    
    `include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
    
    input                       ddr3_mcb_clk;
    input                       ddr3_mcb_rst_n;
    
    output                      data_full;

    input                       write_req;
    
    input   [MCB_T_W-1:0]       addr;
    input                       read_req;
    
    output	[MCB_B_W-1:0]		ddr3_mcb_ba;
    output	[MCB_R_W-1:0]		ddr3_mcb_ra;
    output	[MCB_C_W-1:0]		ddr3_mcb_ca;

    output                      ddr3_mcb_wr_n;
    
    output                      row_hit0;
    output                      row_miss0;
    output                      row_empty0;
    input                       c_ref;
    input                       ddr3_mcb_i_ready;
    
    reg                         data_full;
    reg 	[MCB_B_W-1:0]		ddr3_mcb_ba;
    reg	    [MCB_R_W-1:0]		ddr3_mcb_ra;
    reg 	[MCB_C_W-1:0]		ddr3_mcb_ca;

    reg                         row_hit0;
    reg                         row_miss0;
    reg                         row_empty0;
    
    
    wire     [7:0]              row_hit;
    wire     [7:0]              row_miss;
    wire     [7:0]              row_empty;
    wire                        row_addr;
    
    reg                         flag;
    reg                         time_ctl;
    wire     [7:0]              ctl_enable;
    
    assign  row_addr = addr[22:10];
    assign  ddr3_mcb_wr_n = read_req ? 1'b1:1'b0;
    
    always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if(ddr3_mcb_rst_n == 1'b0) begin
            row_hit0    <=  'b0;
            row_miss0   <=  'b0;
            row_empty0  <=  'b0;
            time_ctl    <=  'b0;
            ddr3_mcb_ba <= 'd0;
            ddr3_mcb_ra <= 'd0;
            ddr3_mcb_ca <= 'd0;
            flag        <= 'b0;
        end
        else if ((read_req || write_req) && (flag == 1'b0)) begin
            ddr3_mcb_ba <= addr[25:23];
            ddr3_mcb_ra <= addr[22:10];
            ddr3_mcb_ca <= addr[9:0];
            flag        <= 1'b1;
            time_ctl    <=  1'b1;
        end
        else if (time_ctl == 1'b1) begin
            row_hit0    <=  |row_hit;
            row_miss0   <=  |row_miss;
            row_empty0  <=  |row_empty;
            time_ctl    <=  1'b0;
        end
        else if((read_req || write_req) != 1'b1) 
            flag        <= 1'b0;
        else begin
            row_hit0    <=  'b0;
            row_miss0   <=  'b0;
            row_empty0  <=  'b0;
            ddr3_mcb_ba <= 'd0;
            ddr3_mcb_ra <= 'd0;
            ddr3_mcb_ca <= 'd0;
        end
        

    bank_row_ctl bank_row_ctl0(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[0]),
    .row_addr(row_addr),
    .row_hit(row_hit[0]),
    .row_miss(row_miss[0]),
    .row_empty(row_empty[0]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl1(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[1]),
    .row_addr(row_addr),
    .row_hit(row_hit[1]),
    .row_miss(row_miss[1]),
    .row_empty(row_empty[1]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl2(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[2]),
    .row_addr(row_addr),
    .row_hit(row_hit[2]),
    .row_miss(row_miss[2]),
    .row_empty(row_empty[2]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl3(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[3]),
    .row_addr(row_addr),
    .row_hit(row_hit[3]),
    .row_miss(row_miss[3]),
    .row_empty(row_empty[3]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl4(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[4]),
    .row_addr(row_addr),
    .row_hit(row_hit[4]),
    .row_miss(row_miss[4]),
    .row_empty(row_empty[4]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl5(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[5]),
    .row_addr(row_addr),
    .row_hit(row_hit[5]),
    .row_miss(row_miss[5]),
    .row_empty(row_empty[5]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl6(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[6]),
    .row_addr(row_addr),
    .row_hit(row_hit[6]),
    .row_miss(row_miss[6]),
    .row_empty(row_empty[6]),
    .c_ref(c_ref)
    );
    
    bank_row_ctl bank_row_ctl7(
    .ddr3_mcb_clk(ddr3_mcb_clk),
    .ddr3_mcb_rst_n(ddr3_mcb_rst_n),
    
    .ctl_enable(ctl_enable[7]),
    .row_addr(row_addr),
    .row_hit(row_hit[7]),
    .row_miss(row_miss[7]),
    .row_empty(row_empty[7]),
    .c_ref(c_ref)
    );   
endmodule
