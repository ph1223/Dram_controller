//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//     DDR3 SDRAM Controller,initialization control module
//
//     2013/04/24   version beta 2.0
//
//     luyanheng
//
//\\//\\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

`timescale 1ns/100ps

module ddr3_mcb_init(
    ddr3_mcb_clk,
    ddr3_mcb_rst_n,
    init_begin,
    
    i_ready,
    i_rst,
    i_cke,
    i_odt,
    i_lmr0,
    i_lmr1,
    i_lmr2,
    i_lmr3,
    i_zq,
    i_cmd
);

    input           ddr3_mcb_clk;
    input           ddr3_mcb_rst_n;
    input           init_begin;
    
    output          i_odt;
    output          i_rst;
    output          i_cke;
    output          i_ready;
    output          i_lmr0;
    output          i_lmr1;
    output          i_lmr2;
    output          i_lmr3;
    output          i_zq;
    output          i_cmd;
    
    parameter I_IDLE = 'd0;
    parameter I_RESET = 'd1;
    parameter I_NOP7 = 'd2;
    parameter I_RST_CKE = 'd3;
    parameter I_NOP8 = 'd4;
    parameter I_CKE = 'd5;
    parameter I_NOP9 = 'd6;
    parameter I_CMD = 'd7;
    parameter I_NOP1 = 'd8;
    parameter I_MR2 = 'd9;
    parameter I_NOP2 = 'd10;
    parameter I_MR3 = 'd11;
    parameter I_NOP3 = 'd12;
    parameter I_MR1 = 'd13;
    parameter I_NOP4 = 'd14;
    parameter I_MR0 = 'd15;
    parameter I_NOP5 = 'd16;
    parameter I_ZQ = 'd17;
    parameter I_NOP6 = 'd18;
    parameter I_FINISH ='d19;
    
    reg i_odt;
    wire i_rst;
    wire i_cke;
    reg i_ready;
    wire i_lmr0;
    wire i_lmr1;
    wire i_lmr2;
    wire i_lmr3;
    wire i_zq;
    wire i_cmd;
    
    reg [15:0]  init_cnt;
    reg [4:0]   init_cst;
    reg [4:0]   init_nst;
    
    assign i_cmd = (init_nst == I_CMD) ? 1'b1 : 1'b0;
    assign i_lmr0 = (init_nst == I_MR2) ? 1'b1 : 1'b0;
    assign i_lmr1 = (init_nst == I_MR3) ? 1'b1 : 1'b0;
    assign i_lmr2 = (init_nst == I_MR1) ? 1'b1 : 1'b0;
    assign i_lmr3 = (init_nst == I_MR0) ? 1'b1 : 1'b0;
    assign i_zq = (init_nst == I_ZQ) ? 1'b1 : 1'b0;
    assign i_rst = ((init_nst == I_RESET)||(init_nst == I_RST_CKE)||(init_nst == I_NOP7)||(init_nst == I_NOP8)) ? 1'b1 : 1'b0;
    assign i_cke = ((init_nst == I_CKE)||(init_nst == I_RST_CKE)||(init_nst == I_NOP8)||(init_nst == I_NOP9)) ? 1'b1 : 1'b0;
    
    always@(posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n)
        if(ddr3_mcb_rst_n == 1'b0)
            init_cnt <= 'd0;
        else begin
          if( (init_cst == I_CMD) | (init_cst == I_MR0) | (init_cst == I_MR1) | (init_cst == I_MR2) | (init_cst == I_MR3))
            init_cnt <= 'd10;
          else if(init_cst == I_ZQ)
            init_cnt <= 'd513;
          else if(init_cst == I_RST_CKE)
            init_cnt <= 'd10;
           else if(init_cst == I_RESET)
             init_cnt <= 'd14000;
            else if(init_cst == I_CKE)
              init_cnt <= 'd35000;
            else if(init_cst != 'd0)
              init_cnt <= init_cnt - 1;
        end
        
    always @ (posedge ddr3_mcb_clk or negedge ddr3_mcb_rst_n) begin
      if (ddr3_mcb_rst_n == 1'b0) begin
         init_cst <= I_IDLE;
      end 
      else begin
         init_cst <= init_nst;
      end
   end
   
    always@(init_nst or init_cnt  or  init_begin)
        case(init_cst)
            I_IDLE: init_nst = (init_begin == 1'b1) ? I_RESET : I_IDLE;
            I_RESET: init_nst = I_NOP7;
            I_NOP7: init_nst = init_cnt == 'd1 ? I_RST_CKE : I_NOP7;
            I_RST_CKE: init_nst = I_NOP8;
            I_NOP8: init_nst = init_cnt == 'd1 ? I_CKE : I_NOP8;
            I_CKE: init_nst = I_NOP9; 
            I_NOP9: init_nst = init_cnt == 'd1 ? I_CMD : I_NOP9;
            I_CMD: init_nst = I_NOP1;
            I_NOP1: init_nst = init_cnt == 'd1 ? I_MR2 : I_NOP1;
            I_MR2: init_nst = I_NOP2;
            I_NOP2: init_nst = init_cnt == 'd1 ? I_MR3 : I_NOP2;
            I_MR3: init_nst = I_NOP3;
            I_NOP3: init_nst = init_cnt == 'd1 ? I_MR1 : I_NOP3;
            I_MR1: init_nst = I_NOP4;
            I_NOP4: init_nst = init_cnt == 'd1 ? I_MR0 : I_NOP4;
            I_MR0: init_nst = I_NOP5;
            I_NOP5: init_nst = init_cnt == 'd1 ? I_ZQ : I_NOP5;
            I_ZQ: init_nst = I_NOP6;
            I_NOP6: init_nst = init_cnt == 'd1 ? I_FINISH : I_NOP6;
            default: init_nst = I_IDLE;
        endcase
        
    
    /*always@ (init_cst)
        if(init_cst == I_RESET)
            i_rst <= 'd1;
        else if (init_cst == I_CKE)
            i_rst <= 'd0;
    
    always@ (init_cst)
        if(init_cst == I_RST_CKE)
            i_cke <= 'd1;
        else if(init_cst == I_CMD)
            i_cke <= 'd0;*/
            
    always@ (init_cst or ddr3_mcb_rst_n)
        if(init_cst == I_CKE)
            i_odt <='d0;
        else if(ddr3_mcb_rst_n)
            i_odt <= 'd1;
        else if(init_cst == I_FINISH)
            i_odt <= 'd1;
        else 
            i_odt <= i_odt;
            
    always@ (init_nst or ddr3_mcb_rst_n)
        if(ddr3_mcb_rst_n == 1'b0)
            i_ready <= 1'b0;
            else if (init_nst == I_FINISH)
                i_ready <= 1'b1;
                else
                    i_ready <= i_ready;
        
endmodule
