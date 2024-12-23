////////////////////////////////////////////////////////////////////////
// Project Name: eHome-IV 
// Task Name   : Package
// Module Name : Package
// File Name   : Package.v
// Description : External memory interface construction
// Author      : Chih-Yuan Chang
// Revision History:
// Date        : 2013.04.06
//
// Revised Author 	: Pei-Yu Ge
// Revised Date		: 2017.12.20
//
////////////////////////////////////////////////////////////////////////

`include "define.v"
`include "Ctrl.v"


module Package(   
               power_on_rst_n,
               clk,
               clk2,
			   command,
               write_data,
               read_data,
               valid,
               ba_cmd_pm,// 6 kinds of state in DRAM
               read_data_valid
);
    
`include "2048Mb_ddr3_parameters.vh"

   // Declare Ports
    
    //== I/O from System ===============
    input  power_on_rst_n;
    input  clk;
    input clk2;
    input  [`DQ_BITS*8-1:0]   write_data;
    output [`DQ_BITS*8-1:0]    read_data;
    input  [35:0] command;
	input  valid ;
     
    output [3:0] ba_cmd_pm; //{power_up,power_down,refresh,write,read,active}
    output read_data_valid;
    //==================================
    //== Output to slice controller =======
	
	reg [`DQ_BITS*8-1:0]    read_data;
	reg read_data_valid;
	reg [3:0]ba_cmd_pm ;
	
    reg  [31:0] command1,command2,command3,command4,command5,command6,command7,command8;
    reg  valid1,valid2,valid3,valid4,valid5,valid6,valid7,valid8;
    reg [`DQ_BITS*8-1:0]  write_data1,write_data2,write_data3,write_data4,write_data5,write_data6,write_data7,write_data8;
	wire  [`DQ_BITS*8-1:0]  read_data1,read_data2,read_data3,read_data4,read_data5,read_data6,read_data7,read_data8;
    wire [3:0] ba_cmd_pm1,ba_cmd_pm2,ba_cmd_pm3,ba_cmd_pm4,ba_cmd_pm5,ba_cmd_pm6,ba_cmd_pm7,ba_cmd_pm8; //{power_up,power_down,refresh,write,read,active}
    wire read_data_valid1,read_data_valid2,read_data_valid3,read_data_valid4,read_data_valid5,read_data_valid6,read_data_valid7,read_data_valid8;
   //===================================
 
 
 
//Slice Controller Module
    Ctrl Rank0 (
               power_on_rst_n,
               clk,
               clk2,
               write_data1,
               command1,
               read_data1,
               valid1,
               ba_cmd_pm1,
               read_data_valid1
    );

    Ctrl Rank1 (
               power_on_rst_n,
               clk,
               clk2,
               write_data2,
               command2,
               read_data2,
               valid2,
               ba_cmd_pm2,
               read_data_valid2
    );

    Ctrl Rank2 (
               power_on_rst_n,
               clk,
               clk2,
               write_data3,
               command3,
               read_data3,
               valid3,
               ba_cmd_pm3,
               read_data_valid3
    );
	
    Ctrl Rank3 (
               power_on_rst_n,
               clk,
               clk2,
               write_data4,
               command4,
               read_data4,
               valid4,
               ba_cmd_pm4,
               read_data_valid4
    );

    Ctrl Rank4 (
               power_on_rst_n,
               clk,
               clk2,
               write_data5,
               command5,
               read_data5,
               valid5,
               ba_cmd_pm5,
               read_data_valid5
    );

    Ctrl Rank5 (
               power_on_rst_n,
               clk,
               clk2,
               write_data6,
               command6,
               read_data6,
               valid6,
               ba_cmd_pm6,
               read_data_valid6
    );

    Ctrl Rank6 (
               power_on_rst_n,
               clk,
               clk2,
               write_data7,
               command7,
               read_data7,
               valid7,
               ba_cmd_pm7,
               read_data_valid7
    );
	
    Ctrl Rank7 (
               power_on_rst_n,
               clk,
               clk2,
               write_data8,
               command8,
               read_data8,
               valid8,
               ba_cmd_pm8,
               read_data_valid8
    );

always@* begin
if(command[32]==1'b0) begin
case(command[35:33])
  3'b000  : begin 
		   command1 = command[31:0] ;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   read_data = read_data1;
		   valid1 = valid;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   write_data1 = write_data;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm1;
		   read_data_valid = read_data_valid1;
		   end
  3'b001  : begin 
		   command2 = command[31:0] ;
		   command1 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   read_data = read_data2;
		   valid2 = valid;
		   valid1 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   write_data2 = write_data;
		   write_data1 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm2;
		   read_data_valid = read_data_valid2;
		   end
  3'b010  : begin 
		   command3 = command[31:0] ;
		   command1 = 32'b0;
		   command2 = 32'b0;
		   command4 = 32'b0;
		   read_data = read_data3;
		   valid3 = valid;
		   valid1 = 0;
		   valid2 = 0;
		   valid4 = 0;
		   write_data3 = write_data;
		   write_data1 = 128'b0;
		   write_data2 = 128'b0;
		   write_data4 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm3;
		   read_data_valid = read_data_valid3;
		   end
  3'b011  : begin 
		   command4 = command[31:0] ;
		   command1 = 32'b0;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   read_data = read_data4;
		   valid4 = valid;
		   valid1 = 0;
		   valid2 = 0;
		   valid3 = 0;
		   write_data4 = write_data;
		   write_data1 = 128'b0;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm4;
		   read_data_valid = read_data_valid4;
		   end
 3'b100  : begin 
		   command5 = command[31:0] ;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   command1 = 32'b0;
		   command6 = 32'b0;
		   command7 = 32'b0;
		   command8 = 32'b0;
		   read_data = read_data5;
		   valid5 = valid;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   valid1 = 0;
		   valid6 = 0;
		   valid7 = 0;
		   valid8 = 0;
		   write_data5 = write_data;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   write_data1 = 128'b0;
		   write_data6 = 128'b0;
		   write_data7 = 128'b0;
		   write_data8 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm5;
		   read_data_valid = read_data_valid5;
		   end
  3'b101  : begin 
		   command6 = command[31:0] ;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   command1 = 32'b0;
		   command5 = 32'b0;
		   command7 = 32'b0;
		   command8 = 32'b0;
		   read_data = read_data6;
		   valid6 = valid;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   valid1 = 0;
		   valid5 = 0;
		   valid7 = 0;
		   valid8 = 0;
		   write_data6 = write_data;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   write_data1 = 128'b0;
		   write_data5 = 128'b0;
		   write_data7 = 128'b0;
		   write_data8 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm6;
		   read_data_valid = read_data_valid6;
		   end
  3'b110  : begin 
		   command7 = command[31:0] ;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   command1 = 32'b0;
		   command6 = 32'b0;
		   command5 = 32'b0;
		   command8 = 32'b0;
		   read_data = read_data7;
		   valid7 = valid;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   valid1 = 0;
		   valid6 = 0;
		   valid5 = 0;
		   valid8 = 0;
		   write_data7 = write_data;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   write_data1 = 128'b0;
		   write_data6 = 128'b0;
		   write_data5 = 128'b0;
		   write_data8 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm7;
		   read_data_valid = read_data_valid7;
		   end
  3'b111  : begin 
		   command8 = command[31:0] ;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   command1 = 32'b0;
		   command6 = 32'b0;
		   command7 = 32'b0;
		   command5 = 32'b0;
		   read_data = read_data8;
		   valid8 = valid;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   valid1 = 0;
		   valid6 = 0;
		   valid7 = 0;
		   valid5 = 0;
		   write_data8 = write_data;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   write_data1 = 128'b0;
		   write_data6 = 128'b0;
		   write_data7 = 128'b0;
		   write_data5 = 128'b0;
		   ba_cmd_pm = ba_cmd_pm8;
		   read_data_valid = read_data_valid8;
		   end 
		   
  default  : begin 
		
		   command1 = 32'b0;
		   command2 = 32'b0;
		   command3 = 32'b0;
		   command4 = 32'b0;
		   command5 = 32'b0;
		   command6 = 32'b0;
		   command7 = 32'b0;
		   command8 = 32'b0;
		   //read_data = 128'b0;
		   valid1 = 0;
		   valid2 = 0;
		   valid3 = 0;
		   valid4 = 0;
		   valid5 = 0;
		   valid6 = 0;
		   valid7 = 0;
		   valid8 = 0;
		   write_data1 = 128'b0;
		   write_data2 = 128'b0;
		   write_data3 = 128'b0;
		   write_data4 = 128'b0;
		   write_data5 = 128'b0;
		   write_data6 = 128'b0;
		   write_data7 = 128'b0;
		   write_data8 = 128'b0;
		   ba_cmd_pm = 4'b0;
		   //read_data_valid = read_data_valid1;
		   end
endcase
end
else begin
	command1 = 32'b0;
	command2 = 32'b0;
	command3 = 32'b0;
	command4 = 32'b0;
	command5 = 32'b0;
	command6 = 32'b0;
	command7 = 32'b0;
	command8 = 32'b0;
	//read_data = 128'b0;
	valid1 = 0;
	valid2 = 0;
	valid3 = 0;
	valid4 = 0;
	valid5 = 0;
	valid6 = 0;
	valid7 = 0;
	valid8 = 0;
	write_data1 = 128'b0;
	write_data2 = 128'b0;
	write_data3 = 128'b0;
	write_data4 = 128'b0;
	write_data5 = 128'b0;
	write_data6 = 128'b0;
	write_data7 = 128'b0;
	write_data8 = 128'b0;
	ba_cmd_pm = 4'b0;
end
	
end


endmodule
