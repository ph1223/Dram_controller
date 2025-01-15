//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,row control for each bank module
//
//     2013/04/24  beta version 2.01
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module bank_row_ctl(
    ddr3_mcb_clk,
    ddr3_mcb_rst_n,
    
    ctl_enable,
    row_addr,
    row_hit,
    row_miss,
    row_empty,
    c_ref
);

`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
    
    input                       ddr3_mcb_clk;
    input                       ddr3_mcb_rst_n;
    
    input                       ctl_enable;
    input   [MCB_R_W-1:0]       row_addr;
    output                      row_miss;
    output                      row_hit;
    output                      row_empty;
    input                       c_ref;
    
    reg                         row_hit;
    reg                         row_miss;
    reg                         row_empty;
    
    reg     [MCB_R_W-1:0]       row_reg;
    reg                         empty_flag;
    
    always@(negedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if(ddr3_mcb_rst_n == 1'b0) begin
            row_miss    <= 1'b0;
            row_hit     <= 1'b0;
            row_empty   <= 1'b0;
            row_reg     <= 'd0;
            empty_flag  <= 1'b1;
        end
        else if ( c_ref == 1'b1) begin
            empty_flag  <= 1'b0;
            row_reg     <= 'd0;
        end
        else if ( ctl_enable == 1'b0 ) begin
            row_miss    <= 1'b0;
            row_hit     <= 1'b0;
            row_empty   <= 1'b0;
        end
        else if ( empty_flag == 1'b1 ) begin
            row_empty   <=  1'b1;
            empty_flag  <=  1'b0;
            row_reg     <=  row_addr;
        end
        else if ( row_reg == row_addr ) begin
            row_hit     <=  1'b1;
        end
        else begin
            row_miss    <=  1'b1;
            row_reg     <=  row_addr;
        end
endmodule        