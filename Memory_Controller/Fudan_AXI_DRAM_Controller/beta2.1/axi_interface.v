//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,axi interface module
//
//     2013/04/24  beta version 2.01
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module axi_interface(
//AXI master i/f 
    axi_clk,
    axi_rstn,

    saccept,
    sdata,
    sresp,
	svalid,
	maddr,
	mburst,
	mdata,
	mlast,
	mlen,
	mread,
	mready,
	msize,
	mwrite,
	mwstrb,
        
// data pool i/f
    data_full,
    write_data,
    write_addr,
    write_wstrb,
    write_req,
    data_ready,
    data_ready_clear,
    read_addr,
    read_req,
    read_data
);

    parameter AXI_DW = 256;  //AXI data bus width          
    parameter AXI_AW = 32;  //AXI address bus width 

    parameter IDLE = 0;
    parameter READ = 1;
    parameter WRITE = 2;
//    parameter READ_SEND = 3;
//    parameter WRITE_SEND = 4;

    input                   axi_clk;
    input                   axi_rstn;
    
    input   [AXI_AW-1:0]    maddr;
    input                   mread;
    input                   mwrite;
    input   [2:0]           msize;
    input   [1:0]           mburst;
    input   [3:0]           mlen;
    input                   mlast;
    input   [AXI_DW-1:0]    mdata;
    input   [AXI_DW/8-1:0]  mwstrb;
    output                  saccept;

    output                  svalid;
    output  [AXI_DW-1:0]    sdata;
    output  [1:0]           sresp;
    input                   mready;

    input                   data_full;
    output  [AXI_DW-1:0]    write_data;
    output  [AXI_AW-1:0]    write_addr;
    output  [AXI_DW/8-1:0]  write_wstrb;
    output                  write_req;
    input                   data_ready;
    output                  data_ready_clear;
    input   [AXI_DW-1:0]    read_data;
    output                  read_req;
    output  [AXI_AW-1:0]    read_addr;
    
    wire                    saccept;
    reg                     svalid;
    reg     [AXI_DW-1:0]    sdata;
    reg     [1:0]           sresp;
    reg     [AXI_DW-1:0]    write_data;
    reg     [AXI_DW/8-1:0]  write_wstrb;
    reg                     write_req;
    reg                     data_ready_clear;
    reg                     read_req;
    reg     [AXI_AW-1:0]    read_addr;
    reg     [AXI_AW-1:0]    write_addr;
    
    reg [1:0]               state;
    reg [1:0]               state_next;
    
    assign saccept = axi_rstn && data_full && (~data_full) && (state == IDLE);
    
    always@(posedge axi_clk or negedge axi_rstn)
    begin
        if(axi_rstn==1'b0) begin
            state <= IDLE;
        end     
        else
            state <= state_next;
    end
    
    always@(*)
    if(state == IDLE) begin
        if ((mread == 1'b1) && (saccept == 1'b1)) 
        begin
            state_next = READ;
        end
        if ((mwrite == 1'b1) && (data_full =='b0) && (saccept == 1'b1)) 
        begin
            state_next = WRITE;
        end
    end 
        else if ((state == READ) ) begin
        if((mready == 1'b1) && ((data_ready == 1'd1)))
            state_next = IDLE;
        else 
            state_next = READ;
        end
    else if (state == WRITE) begin
        if (data_ready == 1'b1)
            state_next = IDLE;
        else 
            state_next = WRITE;
        end
    else 
        state_next = IDLE;
        
    always@(posedge axi_clk or negedge axi_rstn) begin
        if(axi_rstn == 1'b0) begin
            sdata <= 'd0;
            sresp <= 'd0;
            svalid <= 1'b0;
            write_data <= 'd0;
            write_addr <= 'd0;
            write_wstrb<= 'd0;
            write_req   <='b0;
            data_ready_clear    <=  'd0;
            read_req   <=1'b0;
            read_addr  <= 'd0;
        end
        else if (state_next == READ) begin
            if (data_ready == 1'b1)begin
                read_addr <= maddr;
                sresp <= 'd0;
                svalid <= 1'b1;
                sdata  <= read_data;
                data_ready_clear <= 1'b1;
            end
            else if (state == IDLE)
                read_addr <= maddr;
                read_req  <= 1'b1;
        end
        else if (state_next == WRITE) begin
            svalid  <=  1'b1;
            sresp <= 'd1;
            write_addr <= maddr;
            write_data <= mdata;
            write_wstrb<= mwstrb;
            write_req   <=  1'b1;
        end
        else if (state_next == IDLE) begin    //write & read finish
            sdata <= 'd0;
            sresp <= 'd0;
            svalid <= 1'b0;
            data_ready_clear <= 1'b0;
            read_req         <= 1'b0;
            write_req       <=  1'b0;
        end
    end
endmodule

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    