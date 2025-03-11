////////////////////////////////////////////////////////////////////////
// Project Name: eHome-IV
// Task Name   : Bank Finite State Machine
// Module Name : bank_FSM
// File Name   : bank_FSM.v
// Description : bank state control
// Author      : Chih-Yuan Chang
// Revision History:
// Date        : 2012.12.11
////////////////////////////////////////////////////////////////////////
`include "Usertype.sv"
`include "define.sv"
module bank_FSM(state         ,
                stall         ,
                valid         ,
                command       ,
                number        ,
                rst_n         ,
                clk           ,
                ba_state      ,
                ba_busy       ,
                ba_addr       ,
                ba_issue      ,
                process_cmd   ,
                bank_refresh_completed
                );

input stall ; // Stall signal comes from the cmd_scheduler
input valid ;
input [`MEM_CTR_COMMAND_BITS-1:0]command;

input [2:0]number ;
input rst_n ;
input clk ;

input  [`FSM_WIDTH1-1:0] state ;
output [`FSM_WIDTH2-1:0] ba_state ;
output ba_busy ;
output [`ADDR_BITS-1:0] ba_addr;
output ba_issue ;
output [2:0]process_cmd ;
output bank_refresh_completed ;

import usertype::*;

reg [4:0]ba_counter_nxt,ba_counter ;
bank_state_t ba_state,ba_state_nxt;

reg ba_busy ;
reg [`ADDR_BITS-1:0] ba_addr;
reg ba_issue ;
reg [`ADDR_BITS-1:0] active_row_addr;
reg [`ADDR_BITS-1:0] col_addr_buf;
reg [`ADDR_BITS-1:0] row_addr_buf;

command_t command_buf;
command_t command_in;

always_comb begin :INPUT_CMD
  command_in = command;
end

// Using new command_in format
wire [`ADDR_BITS-1:0]row_addr = command_in.row_addr;
wire [`ADDR_BITS-1:0]col_addr = command_in.col_addr;
wire [`BA_BITS-1:0]bank = command_in.bank_addr ;
reg [`ADDR_BITS-1:0]col_addr_t ;
process_cmd_t process_cmd ;

logic[`ROW_BITS-1:0] tREF_period_counter;

logic[`ROW_BITS-1:0] tREFI_counter;


wire refresh_flag = tREF_period_counter == `CYCLE_REFRESH_PERIOD - 1;
wire refresh_finished_f = tREFI_counter == 0;

logic refresh_bit_f;


//command_in format = {read/write , row_addr , col_addr , bank } ;
//                  [31]         [30:17]    [16:3]     [2:0]

reg[4:0]counter;

reg rw ;

always@(posedge clk) begin
if(rst_n==0)
  ba_state <= B_INITIAL ;
else
  ba_state <= ba_state_nxt ;
end


always@(posedge clk) begin
if(ba_state_nxt == B_ACTIVE)
  active_row_addr <= command_buf.row_addr ; //row_addr
else
  active_row_addr <= active_row_addr ;
end

always@(posedge clk) begin
if(valid==1)
  command_buf <= command_in ;
else
  command_buf <= command_buf ;
end

always@(posedge clk) begin
if(rst_n==0)
  process_cmd <= PROC_NO ;
else
	if(valid==1)
	  process_cmd <= (command_in.r_w == READ)? PROC_READ : PROC_WRITE ;
	else
	  if(ba_state == B_ACT_STANDBY)
	    process_cmd <= PROC_NO ;
	  else
	    process_cmd <= process_cmd ;
end


always@* begin
case(ba_state)
  B_ACTIVE : ba_addr <= command_buf.row_addr ; //row
  B_READ   : ba_addr <= command_buf.col_addr ;  //col
  B_WRITE  : ba_addr <= command_buf.col_addr ;  //col
  B_PRE    : ba_addr <= 0 ;
  default   : ba_addr <= 0 ;
endcase
end



always@* begin
  rw = command_buf.r_w;
end

always@* begin
case(ba_state)
  B_IDLE        : ba_busy = 0 ;
  B_ACT_STANDBY : ba_busy = 0 ;
  default        : ba_busy = 1 ;
endcase
end

wire refresh_issued_f = state == FSM_REFRESH;

always@* 
begin
  case(ba_state)
   B_INITIAL    : ba_state_nxt = (state == FSM_IDLE) ? B_IDLE : B_INITIAL ;
   B_IDLE       :  
                  if(refresh_flag||refresh_bit_f)
                    ba_state_nxt = B_PRE_CHECK ;
                  else if(valid==1)
                     ba_state_nxt = B_ACT_CHECK ;
                   else
                     ba_state_nxt = ba_state ;

   B_ACT_CHECK:  ba_state_nxt = (stall)?B_ACT_CHECK : B_ACTIVE ;

   B_ACTIVE   :   
                  if(rw==1)
                    ba_state_nxt = B_READ_CHECK ;
                  else
                    ba_state_nxt = B_WRITE_CHECK ;

   B_WRITE_CHECK : ba_state_nxt = (stall)? B_WRITE_CHECK : B_WRITE ;
   B_READ_CHECK  : ba_state_nxt = (stall)? B_READ_CHECK : B_READ ;
   B_PRE_CHECK   : ba_state_nxt = (stall)? B_PRE_CHECK  : B_PRE ;
   B_ACT_STANDBY : // Can only receive command in standby mode
                    if(refresh_flag||refresh_bit_f)
                      ba_state_nxt = B_PRE_CHECK;
                    else if(valid==1)
                         if(row_addr == active_row_addr)// Row buffer hits
		                       ba_state_nxt = (command_in.r_w == READ) ? B_READ_CHECK : B_WRITE_CHECK ;
		                     else // Row buffer conflicts, close the row buffer
		                       ba_state_nxt = B_PRE_CHECK ;
		                   else
		                     ba_state_nxt = ba_state ;


   B_READ,
   B_WRITE     : if(command_buf.auto_precharge==1'b1)//auto-precharge on !
                   ba_state_nxt = B_IDLE ;
                 else
                   ba_state_nxt = B_ACT_STANDBY ;

   B_PRE      :  ba_state_nxt = refresh_bit_f ? B_REFRESH_CHECK : B_ACT_CHECK ;
   // Additional refresh control
   B_REFRESH :    ba_state_nxt = refresh_issued_f ? B_REFRESHING : B_REFRESH;
   B_REFRESH_CHECK : ba_state_nxt =  B_REFRESH;
   B_REFRESHING : ba_state_nxt = refresh_finished_f ? B_IDLE :B_REFRESHING; // Refresh is completed
   default : ba_state_nxt = ba_state ;
  endcase
end

assign bank_refresh_completed = refresh_finished_f && B_REFRESHING;

always@* begin
if(ba_state == B_ACTIVE || ba_state == B_READ || ba_state == B_WRITE || ba_state == B_PRE || ba_state == B_REFRESH)
  ba_issue = 1 ;
else
  ba_issue = 0 ;
end

// REFRESH Control
always@(posedge clk) 
begin:REFI_CNT 
if(rst_n == 0)
  tREFI_counter <= `CYCLE_TO_REFRESH-1 ;
else
  case(ba_state)
    B_REFRESHING: tREFI_counter <= tREFI_counter - 1;
    default  : tREFI_counter <= `CYCLE_TO_REFRESH-1;
  endcase
end



always_ff @( posedge clk ) 
begin: TREF_PERIOD_CNT
  // Issues a refresh every 3900 cycles
  if ( rst_n == 0 )
    tREF_period_counter <= 0 ;
  else
    tREF_period_counter <= refresh_flag ? 0 : tREF_period_counter + 1 ;
end

always_ff @( posedge clk )
begin: REFRESH_BIT
  // Refresh bit is toggled every 3900 cycles
  if ( rst_n == 0 )
    refresh_bit_f <= 0 ;
  else if(refresh_finished_f)
    refresh_bit_f <= 0 ;
  else
    refresh_bit_f <= refresh_flag ? 1'b1 : refresh_bit_f ;
end

assign issue_refresh_f = refresh_bit_f;

endmodule
