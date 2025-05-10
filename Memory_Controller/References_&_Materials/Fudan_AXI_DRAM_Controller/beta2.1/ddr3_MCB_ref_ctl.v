//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,refresh control module
//
//     2013/04/24  beta version 2.0
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_ref_ctl(
    ddr3_mcb_clk,
    ddr3_mcb_rst_n,
    
    i_ready,
    c_ready,
    c_ref,
    ref_req,
    ref_alert
);

`include "C:/Users/fudan/Desktop/rtl/DDR3_MCB_PAR.v"

    input           ddr3_mcb_clk;
    input           ddr3_mcb_rst_n;

    input           i_ready;
    input           c_ready;
    input           c_ref;
    output          ref_req;
    output          ref_alert;
    
    reg       [15:0]      ref_cnt;
    reg             ref_req;
    reg             ref_alert;
    
    always@ (posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if (ddr3_mcb_rst_n == 1'b0)
            ref_req <= 1'b0;
        else    
            ref_req <= c_ready & ref_alert;
    
    always@ (posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if (ddr3_mcb_rst_n == 1'b0)
            ref_cnt <= 'd0;
        else if( (ref_cnt == CtREFi)  || (i_ready == 1'b0) ) 
            ref_cnt <= 'd0;
        else
            ref_cnt <= ref_cnt + 1;
    
    always@ (posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if ( ddr3_mcb_rst_n == 1'b0 )
            ref_alert <= 1'b0;
		else if (i_ready == 1'b0)
			ref_alert <= 1'b0;
        else if(c_ref == 1'b1)
            ref_alert <= 1'b0;
        else if(ref_cnt == CtREFi)
            ref_alert <= 1'b1;
        else
            ref_alert <= ref_alert;

endmodule
