
`include "define.sv"
`include "Usertype.sv"
`include "frontend_cmd_definition_pkg.sv"

`define ALL_ROW_BUFFER_CONFLICTS
// `define ZIGZAG_PATTERN
// `define CONSECUTIVE_READ_WRITE
// `define READ_WRITE_INTERLEAVE
// `define ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR

`ifdef ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   625
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 0 // Must be a multiple of 2
	`define TEST_COL_STRIDE 0 // Must be a multiple of 2
`elsif ZIGZAG_PATTERN
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   62500
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 2 // Must be a multiple of 2
	`define TEST_COL_STRIDE 8 // Must be a multiple of 2
`elsif READ_WRITE_INTERLEAVE
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   62500
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 0 // Must be a multiple of 2
	`define TEST_COL_STRIDE 0 // Must be a multiple of 2
`elsif CONSECUTIVE_READ_WRITE
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   625
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 1 // Must be a multiple of 2
	`define TEST_COL_STRIDE 1 // Must be a multiple of 2
`elsif ALL_ROW_BUFFER_CONFLICTS
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   1024
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 1 // Must be a multiple of 2
	`define TEST_COL_STRIDE 16 // Must be a multiple of 2
`else
	`define BEGIN_TEST_ROW 0
	`define END_TEST_ROW   16
	`define BEGIN_TEST_COL 0
	`define END_TEST_COL 16
	`define TEST_ROW_STRIDE 1 // Must be a multiple of 2
	`define TEST_COL_STRIDE 1 // Must be a multiple of 2
`endif

`ifdef ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR
	`define TOTAL_READ_TO_TEST ((`END_TEST_ROW-`BEGIN_TEST_ROW)*(`END_TEST_COL-`BEGIN_TEST_COL))
`elsif READ_WRITE_INTERLEAVE
	`define TOTAL_READ_TO_TEST ((`END_TEST_ROW-`BEGIN_TEST_ROW)*(`END_TEST_COL-`BEGIN_TEST_COL))
`else
	`define TOTAL_READ_TO_TEST ((`END_TEST_ROW-`BEGIN_TEST_ROW)*(`END_TEST_COL-`BEGIN_TEST_COL))/(`TEST_COL_STRIDE*`TEST_ROW_STRIDE)
`endif

`define TOTAL_CMD `TOTAL_READ_TO_TEST*2

// take the log of TOTAL_ROW using function of system verilog

module PATTERN(
         power_on_rst_n,
         clk           ,
         clk2          ,
         write_data    ,
         read_data     ,
         command       ,
         valid         ,
         ba_cmd_pm     ,
         read_data_valid,
		 backend_controller_ren
);

`include "2048Mb_ddr3_parameters.vh"

import usertype::*;
import frontend_command_definition_pkg::*;

//== I/O from System ===============
output  power_on_rst_n;
output  clk  ;
output  clk2 ;
//==================================
//== I/O from access command =======

output  [`DQ_BITS*8-1:0]   write_data;
output  backend_command_t command;
output  valid;
output backend_controller_ren;
input   [`DQ_BITS*8-1:0]   read_data;
input   ba_cmd_pm;
input   read_data_valid;
//==================================

reg  power_on_rst_n;
reg  clk;
reg  clk2;
reg backend_controller_ren;

reg  [DQ_BITS*8-1:0]   write_data;
reg  [`FRONTEND_CMD_BITS-1:0] command;
//command format = {read/write , row_addr , col_addr , bank } ;
//                  [31]         [30:17]    [16:3]     [2:0]
// new format

reg  valid;

always #(`CLK_DEFINE/2.0) clk = ~clk ;
always #(`CLK_DEFINE/4.0) clk2 = ~clk2 ;

backend_command_t command_table[`TOTAL_CMD*2-1:0];

reg [`DQ_BITS*8-1:0]write_data_table[`TOTAL_CMD*2-1:0];
reg pm_f;

reg rw_ctl ; //0:write ; 1:read
reg [`ROW_BITS-1:0]row_addr; // This now uses 16 bits
reg [`COL_BITS-1:0]col_addr;  // This now uses 4  bits only
reg bl_ctl;
reg auto_pre;
reg [`BA_BITS-1:0]bank;
reg [1:0]rank;

integer stall=0;
integer i=0,j=0,k=0;
integer read_data_count,random_rw_num;
integer FILE1,FILE2,cmd_count,wdata_count ;

integer ra,rr,cc,bb,bb_x,rr_x,cc_x,ra_x;
integer total_error=0;
frontend_command_t command_table_out;

reg [`DQ_BITS*8-1:0]mem[`TOTAL_ROW-1:0][`TOTAL_COL-1:0] ; //[rank][bank][row][col];
reg [`DQ_BITS*8-1:0]mem_back[`TOTAL_ROW-1:0][`TOTAL_COL-1:0] ; //[rank][bank][row][col];

reg [`DQ_BITS*8-1:0]write_data_temp ;
reg [`DQ_BITS*8-1:0]write_data_tt[0:3] ;
reg [`DQ_BITS*8-1:0]read_data_tt[0:3] ;

reg [31:0]bb_back,rr_back,cc_back;
reg [1:0] ra_back;
reg ran_rw;
reg [`TEST_ROW_WIDTH-1:0]ran_row;
reg [`TEST_COL_WIDTH-1:0]ran_col;
// reg [`TEST_BA_WIDTH-1:0]ran_ba;
reg [`TEST_COL_WIDTH-3-1:0]ran_col_div_8;
reg debug_on;
integer display_value;

integer additonal_counts;
integer test_row_end;
backend_command_t command_temp_in;
integer total_read_to_test_count;

integer test_row_begin;
integer test_row_stride;
integer test_col_stride;
wire all_data_read_f = read_data_count == `TOTAL_READ_TO_TEST;

integer setup_done;

// Creating 4 types of patterns, 1. All row buffer hits to one slot
// 								 2. Read Write Interleaving patterns
//                               3. Consecutive reads then Consecutive writes
//                               4. All row buffer conflicts patterns
//                               5. Random patterns

typedef enum integer {
	All_row_buffer_hits = 0,
	Read_Write_Interleaving = 1,
	Consecutive_read_write = 2,
	All_row_buffer_conflicts = 3,
	Random_pattern = 4
} pattern_type_t;

pattern_type_t pattern_type;

integer pattern_num_cnt;
integer total_cmd_to_test;

initial
begin

FILE1 = $fopen("pattern_cmd.txt","w");
FILE2 = $fopen("pattern_wdata.txt","w");
//FILE3 = $fopen("IN_C1_128.txt","r");
//FILE4 = $fopen("IN_C2_128.txt","r");
// $readmemh("IN_C1_128.txt", img0);
// $readmemh("IN_C2_128.txt", img1);
wdata_count=0;
cmd_count=0;
bb=0;
rr=0;
cc=0;
ra=0;
display_value=0;
pattern_num_cnt=0;
total_cmd_to_test=`TOTAL_CMD;

debug_on=0;

//
test_row_begin = `BEGIN_TEST_ROW;
test_row_end = `END_TEST_ROW;

test_row_stride = `TEST_ROW_STRIDE;
test_col_stride = `TEST_COL_STRIDE;

// test_row_end = `TOTAL_ROW;
total_read_to_test_count=(test_row_end-test_row_begin)*`TOTAL_COL;
setup_done = 0;
pattern_type = All_row_buffer_hits;

	$display("Toatl number of commands to test: %d",total_cmd_to_test);

	`ifdef ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR
	$display("==========================================================================");
    $display("= Start to Create ALL ROW BUFFER HITS on address 0  Patterns             =");
    $display("==========================================================================");
	debug_on = 1;
	for(rr=0;rr<`TOTAL_CMD;rr=rr+1)
	begin

		row_addr = 0;
		col_addr = 0;

		// Command assignements
		if(rr>=(`TOTAL_CMD/2))
			command_temp_in.op_type   = OP_READ;
		else
			command_temp_in.op_type   = OP_WRITE;

		command_temp_in.data_type = DATA_TYPE_WEIGHTS;
		command_temp_in.row_addr  = row_addr;
		command_temp_in.col_addr  = col_addr;

		command_table[cmd_count]=command_temp_in;
		write_data_table[wdata_count]  = rr;

		if(command_temp_in.op_type == OP_WRITE)
			mem[row_addr][col_addr] = rr;

		cmd_count=cmd_count+1 ;
		wdata_count=wdata_count+1 ;
	end

	`elsif READ_WRITE_INTERLEAVE
	$display("================================================================");
	$display("= Start to Create READ WRITE Interleaving Patterns             =");
	$display("================================================================");
	debug_on = 1;
	for(rr=0;rr<`TOTAL_CMD;rr=rr+1)
	begin

		row_addr = 0;
		col_addr = 0;

		// Command assignements
		if(rr%2 == 1)
			command_temp_in.op_type   = OP_READ;
		else
			command_temp_in.op_type   = OP_WRITE;

		command_temp_in.data_type = DATA_TYPE_WEIGHTS;
		command_temp_in.row_addr  = row_addr;
		command_temp_in.col_addr  = col_addr;

		command_table[cmd_count]=command_temp_in;

		if(command_temp_in.op_type == OP_WRITE)begin
			write_data_table[wdata_count]  = rr;
			mem[row_addr][col_addr] = rr;
		end

		cmd_count=cmd_count+1 ;
		wdata_count=wdata_count+1 ;
	end

	`else
	//===========================================
	//   WRITE
	//===========================================
    $display("========================================");
    $display("= Start to write the initial data!     =");
    $display("========================================");
	for(ra=0;ra<1;ra=ra+1) begin
		for(bb=0;bb<1;bb=bb+1) begin
			for(rr=test_row_begin;rr<test_row_end;rr=rr+test_row_stride) begin
				for(cc=0;cc<`TOTAL_COL;cc=cc+test_col_stride) begin
					// Read write interleave
					// if(rw_ctl == 0)
				  	// 	rw_ctl = 1 ;//read
					// else
					// 	rw_ctl = 0;//write

					// write
					rw_ctl = 0;

				  	row_addr = rr ;
				  	col_addr = cc ;
				  	bl_ctl = 1 ;

				  	rank = ra ;
				  	bank = bb ;


					// Command assignements
					command_temp_in.op_type   = OP_WRITE;
					command_temp_in.data_type = DATA_TYPE_WEIGHTS;
					command_temp_in.row_addr  = row_addr;
					command_temp_in.col_addr  = col_addr;

				    command_table[cmd_count]=command_temp_in;

					if(display_value == 1)
						$fdisplay(FILE1,"%31b",command_table[cmd_count]);

				    if(rw_ctl==0)
					begin
					  //write, the write should now be extended to 1024 bits data instead of only 128bits
					//   write_data_table[wdata_count] = {$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),
					//   $urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),
					//   $urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),
					//   $urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom(),$urandom()} ;
					  write_data_table[wdata_count] = row_addr*16+col_addr;
				    //   write_data_table[wdata_count] = {$urandom(),$urandom(),$urandom(),$urandom()} ;
					//   write_data_table[wdata_count] = img0[wdata_count] ;
				      write_data_temp = write_data_table[wdata_count] ;
				      write_data_tt[0] = write_data_temp[31:0] ;
				      write_data_tt[1] = write_data_temp[63:32] ;
				      write_data_tt[2] = write_data_temp[95:64] ;
				      write_data_tt[3] = write_data_temp[127:96];
					  if(display_value == 1)
				      	$fdisplay(FILE2,"%1024h",write_data_table[wdata_count]);

				      //`ifdef PATTERN_DISP_ON
					  if(debug_on==1 && display_value == 1) begin
				      	$write("PATTERN INFO. => WRITE;"); $write("COMMAND # %d; ",cmd_count);

				      	$write(" ROW:%16d; ",row_addr);$write(" COL:%8d; ",col_addr);$write(" BANK:%8d; ",bank);$write(" RANK:%8d; ",rank);$write("|");
					  end

					  if(display_value == 1)begin
				      	$display("Write data : ");
					  	$write(" %1024h ",write_data_temp);
					  end
				      //for(k=0;k<8;k=k+1) begin
				       //
				        //mem[bb][rr][cc+k] = write_data_temp[15:0] ;

					  mem[rr][cc] = write_data_temp;
				        //write_data_temp=write_data_temp>>16;
				      //end
				      if(display_value == 1)
				      	$display(" ");

				      wdata_count = wdata_count + 1 ;
				    end //end if rw_ctl

				  cmd_count=cmd_count+1 ;
				  pattern_num_cnt=pattern_num_cnt+1;
				end
			end
		end
		/*
		for(stall=0;stall<100;stall=stall+1) begin
			command_table[cmd_count]=34'b0;
			cmd_count=cmd_count+1 ;
		end
		*/
	end

   	debug_on=1;
	pattern_num_cnt=0;

    $display("========================================");
    $display("=   Start to read all data to test!    =");
    $display("========================================");
	//===========================================
	//   READ
	//===========================================
	for(ra=0;ra<1;ra=ra+1) begin
		for(bb=0;bb<1;bb=bb+1) begin
			for(rr=test_row_begin;rr<test_row_end;rr=rr+test_row_stride) begin
				for(cc=0;cc<`TOTAL_COL;cc=cc+test_col_stride)	begin

					//read
				  	rw_ctl = 1 ;
				  	row_addr = rr ;
				  	col_addr = cc ;
				  	bl_ctl = 1 ;

				  	auto_pre = 0 ;
				  	rank = ra;
				  	bank = bb ;

					command_temp_in = 'b0;

					// Command type assignements
					// Command assignements
					command_temp_in.op_type   = OP_READ;
					command_temp_in.data_type = DATA_TYPE_WEIGHTS;
					command_temp_in.row_addr  = row_addr;
					command_temp_in.col_addr  = col_addr;


				    command_table[cmd_count]=command_temp_in;
					if(display_value == 1)
				    	$fdisplay(FILE1,"%34b",command_table[cmd_count]);



				  cmd_count=cmd_count+1 ;
				  pattern_num_cnt=pattern_num_cnt+1;
				end
			end
		end
		/*
		for(stall=0;stall<100;stall=stall+1) begin
			command_table[cmd_count]=34'b0;
			cmd_count=cmd_count+1 ;
		end
		*/
	end
	`endif
	$display("========================================");
	$display("= Finish Creating Pattern              =");
	$display("========================================");

	setup_done = 1;
	wait(all_data_read_f == 1'b1);

	repeat(100) begin
	  @(negedge clk);
	end

	//===========================
	//    CHECK RESULT         //
	//===========================
	`ifdef ALL_ROW_BUFFER_HITS_PATTERN_SAME_ADDR
		for(rr_x = 0;rr_x<`TOTAL_CMD;rr_x=rr_x+1)begin
			cc_x = 0;
				if(mem[rr_x][cc_x] !== mem_back[rr_x][cc_x]) begin
					$display("mem[%2d][%2d] ACCESS FAIL ! , mem=%128h , mem_back=%128h",rr_x,cc_x,mem[rr_x][cc_x],mem_back[rr_x][cc_x]) ;
					total_error=total_error+1;
				end
				else
					$display("mem[%2d][%2d] ACCESS SUCCESS ! ",rr_x,cc_x) ;
		end
	`elsif READ_WRITE_INTERLEAVE
		rr_x = 0;
		cc_x = 0;
		if(mem[rr_x][cc_x] !== mem_back[rr_x][cc_x]) begin
			$display("mem[%2d][%2d] ACCESS FAIL ! , mem=%128h , mem_back=%128h",rr_x,cc_x,mem[rr_x][cc_x],mem_back[rr_x][cc_x]) ;
			total_error=total_error+1;
			end
		else
			$display("mem[%2d][%2d] ACCESS SUCCESS ! ",rr_x,cc_x) ;

	`else
	 for(rr_x=test_row_begin;rr_x<test_row_end;rr_x=rr_x+test_row_stride)begin
 	  	for(cc_x=0;cc_x<`TOTAL_COL;cc_x=cc_x+test_col_stride)begin

 	      if(mem[rr_x][cc_x] !== mem_back[rr_x][cc_x]) begin
 	        $display("mem[%2d][%2d] ACCESS FAIL ! , mem=%128h , mem_back=%128h",rr_x,cc_x,mem[rr_x][cc_x],mem_back[rr_x][cc_x]) ;
 	    	   total_error=total_error+1;
  	   	 end
  	   	 else
  	   	   $display("mem[%2d][%2d] ACCESS SUCCESS ! ",rr_x,cc_x) ;
  	 end
  	end
	`endif


	$display(" TOTAL design read data: %12d",read_data_count);
	$display("=====================================") ;
	$display(" TOTAL_ERROR: %12d",total_error);
	$display("=====================================") ;
	$display("Read data count: %d",read_data_count);
	$display("Total read data count: %d",`TOTAL_READ_TO_TEST);
	$display("Total Memory Simulation cycles:         %d",latency_counter);

	$finish;
end //end initial

initial
begin

clk = 1 ;
clk2 = 1 ;
power_on_rst_n = 1 ;
valid = 0 ;
wait(setup_done == 1);

repeat(10) @(negedge clk) ;
power_on_rst_n = 0 ;
repeat(100) @(negedge clk) ;
@(negedge clk) ;
power_on_rst_n = 1 ;

end


always@*
begin
  command_table_out = command_table[i];

  pm_f = ba_cmd_pm ;
end


wire command_sent_handshake_f = valid == 1'b1 && pm_f == 1'b1; // From first handshake
logic[31:0] latency_counter;
logic latency_counter_lock;

always_ff@(posedge clk or negedge power_on_rst_n)
begin: LATENCY_CLOCK_LOCK
  if(power_on_rst_n == 0)
  begin
	latency_counter_lock<=1'b1;
  end
  else begin
	if(command_sent_handshake_f && latency_counter_lock==1'b1)
		latency_counter_lock <= 1'b0;
  end
end

always_ff@(posedge clk or negedge power_on_rst_n)
begin: LATENCY_COUNTER
	if(power_on_rst_n == 0)
		latency_counter<=1;
	else if(latency_counter_lock==1'b0 && all_data_read_f == 1'b0)
		latency_counter<=latency_counter + 1;

	if(latency_counter % 100000 == 0) begin
		$display("CLK TICK: %d",latency_counter);
	end
end

wire command_sent_handshake_f = valid == 1'b1 && pm_f == 1'b1;

logic[15:0] stall_counter_ff;
wire release_stall_f = stall_counter_ff == 15;

always_ff@(posedge clk or negedge power_on_rst_n) begin
	if(power_on_rst_n == 0) begin
		stall_counter_ff <= 'd0;
	end else if(release_stall_f) begin
		stall_counter_ff <= 'd0;
	end else begin
		stall_counter_ff <= stall_counter_ff + 'd1;
	end
end

always_ff@(posedge clk or negedge power_on_rst_n) begin
	if(power_on_rst_n == 0) begin
		backend_controller_ren <= 1'b1;
	end
	else if(release_stall_f) begin
		backend_controller_ren <= (backend_controller_ren == 1'b1) ? 1'b0 : 1'b1;
	end
	else begin
		backend_controller_ren <= backend_controller_ren;
	end
end

//command output control
always@(posedge clk) begin
  if(pm_f) begin
  	if(i==`TOTAL_CMD) begin
  	    command <= 0 ;
	    i <= i ;
	    valid<=0 ;
	    write_data <= 0 ;
  	end
  	else begin
  		if(i<cmd_count) begin
	      command <= command_table[i] ;
	      valid   <= 1 ;

	      if(command_table_out.op_type == OP_WRITE) begin //write
	        write_data <= write_data_table[j];
	      end
	      else begin
	        write_data <= 0 ;
	      end

		  if(command_sent_handshake_f) // only if handshake can you send command
		  begin
		  	i<=i+1 ;
	        j<=j+1 ;
		  end
	    end
	    else begin
	      i<=i;
	      valid=0;
	    end
	  end

  end
  else begin
    command <= 'd0 ;
    i<=i ;
    valid=0 ;
  end
end

//read data receive control

always@(negedge clk)
begin
	if( backend_controller_ren == 1 && read_data_valid==1 && debug_on==1) begin
	  //$display("time: %t mem_back rank:%h  bank:%h  row:%h  col:%h data:%h \n",$time,ra_back, bb_back,rr_back,cc_back,read_data);
	  mem_back[rr_back][cc_back]   = read_data;
	end
end

always@(negedge clk or negedge power_on_rst_n) begin
  if(~power_on_rst_n)begin
	rr_back <= `BEGIN_TEST_ROW ;
  end
  else if(backend_controller_ren == 1 && read_data_valid==1 && debug_on==1) begin
  	if(rr_back==(`TOTAL_ROW-1) && cc_back==`TOTAL_COL-`TEST_COL_STRIDE)
  	  rr_back <= `BEGIN_TEST_ROW ;
  	else if(cc_back==`TOTAL_COL-`TEST_COL_STRIDE)
  	  rr_back <= rr_back + `TEST_ROW_STRIDE ;
  	else
  	  rr_back <= rr_back ;
	end
end

always@(negedge clk or negedge power_on_rst_n) begin
	if(~power_on_rst_n)begin
	  cc_back <= `BEGIN_TEST_COL ;
	end
	else if( backend_controller_ren == 1 && read_data_valid==1 && debug_on==1)
	    cc_back <= (cc_back + `TEST_COL_STRIDE) % `TOTAL_COL ;

end

always@(negedge clk or negedge power_on_rst_n) begin
if(power_on_rst_n==0) begin
  read_data_count=0;
end
else begin
  if( backend_controller_ren == 1 && read_data_valid==1 && debug_on==1)
    read_data_count=read_data_count+1;
end
end

initial begin
  #(`TOTAL_SIM_CYCLE*`CLK_DEFINE);
  $display("=====================================") ;
  $display(" MAX SIMULATION CYCLES REACHED") ;
  $display("=====================================") ;
  $finish;
end

endmodule