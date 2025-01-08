//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,read data path module
//
//     2013/04/24  beta version 2.01
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module data_path(
    read_data,
    data_ready,
    data_ready_clear,
    
    ddr3_mcb_rdat_vld,
    ddr3_mcb_wdat_req,
    
    write_data,
    write_wstrb,    
    ddr3_mcb_wdat,
    ddr3_mcb_wbe,
    ddr3_mcb_rdat,
    ddr3_mcb_clk,
    ddr3_mcb_rst_n
);

    parameter AXI_DW = 256;  //AXI data bus width          
    parameter AXI_AW = 32;  //AXI address bus width 
    
    `include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"
    
    output      [AXI_DW-1:0]    read_data;
    output                      data_ready;
    input                       data_ready_clear;
    
    input                       ddr3_mcb_wdat_req;
    input                       ddr3_mcb_rdat_vld;
    input                       ddr3_mcb_clk;
    input       [MCB_D_W-1:0]   ddr3_mcb_rdat;
    input                       ddr3_mcb_rst_n;
    
    input   [AXI_DW-1:0]        write_data;
    input   [AXI_DW/8-1:0]      write_wstrb;
    
    reg         [AXI_DW-1:0]    read_data;
    reg                         data_ready;
    
    output  [MCB_D_W-1:0]		ddr3_mcb_wdat;
    output  [MCB_BE_W-1:0]		ddr3_mcb_wbe;
    
    reg     [MCB_D_W-1:0]		ddr3_mcb_wdat;
    reg     [MCB_BE_W-1:0]		ddr3_mcb_wbe;
    
    reg         [2:0]           data_path_cnt;
    
    always@(negedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n) begin
        if(ddr3_mcb_rst_n == 1'b0)
            data_path_cnt <= 'd0;
        else if( ddr3_mcb_rdat_vld == 1'b1 )
            data_path_cnt <= data_path_cnt + 1;
        else if(data_ready_clear == 1'b1)
            data_path_cnt <= 'd0;
        else
            data_path_cnt <= data_path_cnt;
    end
    
    always@(negedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n) begin
        if(ddr3_mcb_rst_n == 1'b0)
            data_ready  <=  'b0;
        else if(data_ready_clear == 1'b1)
            data_ready  <=  'b0;
        else if(data_path_cnt == 'd4)
            data_ready  <=  'b1;
        else
            data_ready  <=  data_ready;
    end
    
    always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n) begin
        if(ddr3_mcb_rst_n == 1'b0)
            read_data   <=  'd0;
        else if ( ddr3_mcb_rdat_vld == 1'b1 ) 
            case(data_path_cnt)
            3'b001:     read_data[63:0]     <=  ddr3_mcb_rdat;
            3'b010:     read_data[127:64]   <=  ddr3_mcb_rdat;
            3'b011:     read_data[191:128]  <=  ddr3_mcb_rdat;
            3'b100:     read_data[255:192]  <=  ddr3_mcb_rdat;
            default:    read_data           <=  read_data;
            endcase
        else
            read_data   <=  read_data;
    end
    
    always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if(ddr3_mcb_rst_n == 1'b0) begin
            ddr3_mcb_wdat   <= 'd0;
            ddr3_mcb_wbe    <= 'd0;
        end
        else if ( ddr3_mcb_wdat_req == 1'b1 ) begin
            case (data_path_cnt)
            3'b000: begin
                    ddr3_mcb_wbe    <= write_wstrb[7:0];
                    ddr3_mcb_wdat   <= write_data[63:0];
                  end
            3'b001: begin
                    ddr3_mcb_wbe    <= write_wstrb[15:8];
                    ddr3_mcb_wdat   <= write_data[127:64];
                  end
            3'b010: begin
                    ddr3_mcb_wbe    <= write_wstrb[23:16];
                    ddr3_mcb_wdat   <= write_data[191:128];
                  end
            3'b011: begin
                    ddr3_mcb_wbe    <= write_wstrb[31:24];
                    ddr3_mcb_wdat   <= write_data[255:192];
                  end
            default:begin
                    ddr3_mcb_wbe    <= 'd0;
                    ddr3_mcb_wdat   <= 'd0;
                  end
            endcase
        end
        else begin
            ddr3_mcb_wdat   <= ddr3_mcb_wdat;
            ddr3_mcb_wbe    <= ddr3_mcb_wbe;
        end
endmodule
