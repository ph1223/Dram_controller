//==============================================
//==============================================
//												
//	2017/12/19	PATTERN for DRAM controller					
//	Author			: Chih-Yuan Chang
//	Revised Author	: Pei-Yu Ge				
//												
//----------------------------------------------
//												
//	File Name		:	PATTERN.v					
//	Module Name		:	PATTERN						
//	Release version	:	v1.0				
//												
//==============================================
//==============================================
//Revised : 4 ranks change to 8 ranks
//			Increase no operation time
//			Add power management(dynamic clock frequency to save power and latency
//			2 mode(on or off) and 3 mode(high speed, low power, off)
//			change frequency to fit my application 

`include "define.v"


`define TOTAL_CMD 80000

`define TOTAL_ROW 128 //9-bit  (MAX:14-bit)
`define TOTAL_COL 32  //10-bit (MAX:10-bit)
`define TEST_ROW_WIDTH 4
`define TEST_COL_WIDTH 6
`define TEST_BA_WIDTH 3

//`define PATTERN_NUM 2000

module PATTERN(
         power_on_rst_n,             
         clk           ,
         clk2          , 
         write_data    ,             
         read_data     ,
         command       ,
         valid         ,
         ba_cmd_pm     ,
         read_data_valid     
);

`include "2048Mb_ddr3_parameters.vh"

//== I/O from System ===============
output  power_on_rst_n;
output  clk  ;
output  clk2 ;
//==================================
//== I/O from access command =======

output  [DQ_BITS*8-1:0]   write_data;
output  [35:0] command;
output  valid;
input   [DQ_BITS*8-1:0]   read_data;
input   [3:0] ba_cmd_pm;
input read_data_valid;
//==================================

reg  power_on_rst_n;
reg  clk;
reg  clk1;
reg  clk2;
reg  clklow;
// ADD clk gating?

reg  [DQ_BITS*8-1:0]   write_data;
reg  [35:0] command;
//command format = {read/write , row_addr , col_addr , bank } ;
//                  [32:31]         [30:17]    [16:3]     [2:0]

reg  valid;

always #(`CLK_DEFINE/2.0) clk1 = ~clk1 ;//one cycle=3ns
always #(`CLK_DEFINE*3/2.0) clklow = ~clklow ;//one cycle=9ns
always #(`CLK_DEFINE/4.0) clk2 = ~clk2 ;//one cycle=1.5ns

reg [35:0]command_table[`TOTAL_CMD-1:0];

reg [DQ_BITS*8-1:0]write_data_table[`TOTAL_CMD-1:0];
reg pm_f;

reg [1:0]rw_ctl ; //00:write ; 01:read ; 10:NO operation
reg [12:0]row_addr;
reg [9:0]col_addr;
reg bl_ctl;
reg auto_pre;
reg [2:0]bank;
reg [2:0]rank;

integer stall=0;
integer j=0,k=0,z=0;
integer read_data_count,random_rw_num;
integer FILE1,FILE2,cmd_count,wdata_count ;

integer ra,rr,cc,bb,bb_x,rr_x,cc_x,ra_x;
integer total_error=0;
integer total_latency,total_BWU,total_out;

reg [35:0]command_t ;

reg [127:0]mem[2:0][2:0][`TOTAL_ROW-1:0][`TOTAL_COL-1:0] ; //[rank][bank][row][col];
reg [127:0]mem_back[2:0][2:0][`TOTAL_ROW-1:0][`TOTAL_COL-1:0] ; //[rank][bank][row][col];

reg [DQ_BITS*8-1:0]write_data_temp ;
reg [DQ_BITS-1:0]write_data_tt ;
reg [DQ_BITS-1:0]read_data_tt ;

reg [31:0]bb_back,rr_back,cc_back;
reg [2:0] ra_back;
reg ran_rw;
reg [`TEST_ROW_WIDTH-1:0]ran_row;
reg [`TEST_COL_WIDTH-1:0]ran_col;
reg [`TEST_BA_WIDTH-1:0]ran_ba;
reg [`TEST_COL_WIDTH-3-1:0]ran_col_div_8;
reg debug_on;


reg     [127:0]    img0[0:38015];
reg     [127:0]    img1[0:38015];
reg [`TOTAL_CMD-1:0] i;

initial begin
i=64'b0;
FILE1 = $fopen("pattern_cmd.txt","w");
FILE2 = $fopen("pattern_wdata.txt","w");
//FILE3 = $fopen("IN_C1_128.txt","r");
//FILE4 = $fopen("IN_C2_128.txt","r");
$readmemh("IN_C1_128.txt", img0);
$readmemh("IN_C2_128.txt", img1);
wdata_count=0;
cmd_count=0;
bb=0;
rr=0;
cc=0;
ra=0;

bb_back=0;
rr_back=0;
cc_back=0;
ra_back=0;

for(a=0;a<`TOTAL_ROW*`TOTAL_COL/8;a=a+1)
begin
	write_task;
	read_task;
end
	

/*	debug_on=0;
//===========================================
//   stall and wating command
//===========================================  
    $display("========================================");
    $display("= Start to stall and wating command!   =");
    $display("========================================");
	
	for(ra=0;ra<1;ra=ra+1) begin
		for(bb=0;bb<1;bb=bb+1) begin
			for(rr=0;rr<`TOTAL_ROW;rr=rr+1) begin
				for(cc=0;cc<`TOTAL_COL*3;cc=cc+8) begin	

				  	rw_ctl = 2'b10 ;//NO
				  	row_addr = rr ;
				  	col_addr = cc ;
				  	bl_ctl = 1 ;
					
				  	auto_pre = 0 ;
				  	rank = ra ; 
				  	bank = bb ;
				    command_table[cmd_count]={rank,rw_ctl,31'b0};
				    $fdisplay(FILE1,"%36b",command_table[cmd_count]);
				        
				    if(rw_ctl==2'b10) begin//write
				      $write("PATTERN INFO. => WAITING;"); $write("COMMAND # %d; ",cmd_count);
				
				    end 
			    
				  cmd_count=cmd_count+1 ;
				end    
			end
		end		
	end
*/	
   
  
  
end //end initial

task write_task;
begin
	debug_on=0;
 
//===========================================
//   WRITE
//===========================================  
//    $display("========================================");
//    $display("= Start to write the initial data!     =");
//    $display("========================================");
	for(ra=0;ra<1;ra=ra+1) begin
		for(bb=0;bb<1;bb=bb+1) begin
			for(rr=0;rr<1;rr=rr+1) begin
				for(cc=0;cc<`TOTAL_COL;cc=cc+8) begin	

				  	rw_ctl = 2'b00 ;//write
				  	row_addr = rr ;
				  	col_addr = cc ;
				  	bl_ctl = 1 ;
				  	  auto_pre = 0 ;
				  	rank = ra ; 
				  	bank = bb ;
				    command_table[cmd_count]={rank,rw_ctl,1'b0,row_addr,1'b0,bl_ctl,1'b0,auto_pre,col_addr,bank};
				    $fdisplay(FILE1,"%36b",command_table[cmd_count]);
				        
				    if(rw_ctl==2'b00) begin//write
				      //write_data_table[wdata_count] = {$random,$random,$random,$random} ;  
					  write_data_table[wdata_count] = img0[wdata_count] ;  
				      write_data_temp = write_data_table[wdata_count] ;
				      write_data_tt[0] = write_data_temp[31:0] ;
				      write_data_tt[1] = write_data_temp[63:32] ;
				      write_data_tt[2] = write_data_temp[95:64] ;
				      write_data_tt[3] = write_data_temp[127:96] ;
				      $fdisplay(FILE2,"%128b",write_data_table[wdata_count]);
					 
				      //`ifdef PATTERN_DISP_ON
				      $write("PATTERN INFO. => WRITE;"); $write("COMMAND # %d; ",cmd_count);
				        
				      $write(" ROW:%d; ",row_addr);$write(" COL:%d; ",col_addr);$write(" BANK:%d; ",bank);$write(" RANK:%d; ",rank);$write("|");

				        
				      if(auto_pre==0)
				        $display("AUTO PRE:Disable ");     
				      else 
				        $display("AUTO PRE:Enable ");			  
				      //`endif

				      $display("Write data : ");  
					  $write(" %h ",write_data_temp);
						mem[ra][bb][rr][cc] = write_data_temp;
				      $display(" "); 
				      
				      wdata_count = wdata_count + 1 ;
				    end //end if rw_ctl
				    

			    
				  cmd_count=cmd_count+1 ;
				end    
			end
		end		
	end

end endtask

task read_task;
begin
	debug_on=1;
   
//    $display("========================================");
//    $display("=   Start to read all data to test!    =");
//    $display("========================================");
//===========================================
//   READ
//===========================================
	for(z=0;z<4;z=z+1) begin
	for(ra=0;ra<1;ra=ra+1) begin
		for(bb=0;bb<1;bb=bb+1) begin
			for(rr=0;rr<1;rr=rr+1) begin
				for(cc=0;cc<`TOTAL_COL;cc=cc+8)	begin
		  	
		  		
				  	rw_ctl = 2'b01 ;//read
				  	row_addr = rr ;
				  	col_addr = cc ;
				  	bl_ctl = 1 ;
				  	
				  	  auto_pre = 0 ;
				  	rank = ra;  
				  	bank = bb ;
				    command_table[cmd_count]={rank,rw_ctl,1'b0,row_addr,1'b0,bl_ctl,1'b0,auto_pre,col_addr,bank};
				    $fdisplay(FILE1,"%36b",command_table[cmd_count]);

				  cmd_count=cmd_count+1 ;
				end    
			end
		end	  
	end
	end

end endtask

initial begin
clk = 1 ;
clk1 = 1 ;
clk2 = 1 ;
clklow = 1;
power_on_rst_n = 1 ;
valid = 0 ;

@(negedge clk) ;
power_on_rst_n = 0 ;
@(negedge clk) ;
power_on_rst_n = 1 ;

end


always@* begin
command_t <= command_table[i];

case(command_t[2:0])
  0:pm_f = ba_cmd_pm[0] ;
  1:pm_f = ba_cmd_pm[1] ;
  2:pm_f = ba_cmd_pm[2] ;
  3:pm_f = ba_cmd_pm[3] ;
endcase

if(i<14080)
	clk = clk1;
else
	clk = clk1;
end

//command output control
always@(negedge clk) begin

  if(pm_f) begin
 	
  	if(i==`TOTAL_CMD) begin
  	  command <= 0 ;
	    i<=i ;
	    valid<=0 ;
	    write_data <= 0 ;
  	end 
  	
  	else begin
  		if(i<cmd_count) begin
	      command <= command_table[i] ;
	      i<=i+1 ;
	      valid=1 ;
	      if(command_t[32:31]==2'b00) begin //write
	        write_data <= write_data_table[j];
	        j<=j+1 ;
	      end
	      else begin 
	        write_data <= 0 ;
	        j = j ;
	      end
	    end
	    else begin
	      i<=i;
	      valid=0;
	    end
	  end
	  
  end
  else begin
    command <= 35'd0 ;
    i<=i ;
    valid=0 ;
  end
end

//read data receive control

always@(negedge clk) begin

	
if(read_data_valid==1 && debug_on==1) begin
  //$display("time: %t mem_back rank:%h  bank:%h  row:%h  col:%h data:%h \n",$time,ra_back, bb_back,rr_back,cc_back,read_data);
  mem_back[ra_back][bb_back][rr_back][cc_back]   = read_data;
end
    	 
end

always@(negedge clk) begin
if(read_data_valid==1 && debug_on==1) begin
  if(rr_back==(`TOTAL_ROW-1) && cc_back==(`TOTAL_COL-8))
    rr_back <= 0;
  else if(cc_back==(`TOTAL_COL-8))
    rr_back <= rr_back + 1 ;
  else
    rr_back <= rr_back ;
end
end

always@(negedge clk) begin
if(read_data_valid==1 && debug_on==1)
  if(cc_back==(`TOTAL_COL-8))
    //if(bb_back==3)
      cc_back <= 0 ;
    //else
    //  cc_back <= cc_back ;
  else
    //if(bb_back==3)
      cc_back <= cc_back + 8;
    //else
     // cc_back <= cc_back ;

end

always@(negedge clk) begin
if(read_data_valid==1 && debug_on==1)
  if(rr_back==(`TOTAL_ROW-1) && cc_back==(`TOTAL_COL-8) && bb_back==3)
    bb_back <= 0;
  else if (rr_back==(`TOTAL_ROW-1) && cc_back==(`TOTAL_COL-8))	
    bb_back <= bb_back + 1;
  else
    bb_back <= bb_back;

end

always@(negedge clk) begin
if(read_data_valid==1 && debug_on==1)
  if(bb_back==3 && rr_back==(`TOTAL_ROW-1) && cc_back==(`TOTAL_COL-8))
    ra_back <= ra_back + 1;
  else
    ra_back <= ra_back;

end

always@(negedge clk) begin
if(power_on_rst_n==0) begin
  read_data_count=0;	 
end
else begin
  if(read_data_valid==1 && debug_on==1)
    read_data_count=read_data_count+1;
end  

end

always@(negedge clk) begin
if(power_on_rst_n==0) begin
  total_latency=0;	
  total_BWU=0;
  total_out=0;
end
else begin
	if(valid && command[32]==1'b0)
		total_out=total_out+1;
		
	total_latency=total_latency+3.3;
	total_BWU=(total_out*3.3/total_latency)*100;
end  
end


initial begin
		
#(`CLK_DEFINE*`TOTAL_ROW*`TOTAL_COL*5) ;
//FILE1 = $fopen("mem.txt","w");

//===========================
//    CHECK RESULT         //
//===========================
for(ra_x=0;ra_x<1;ra_x=ra_x+1)
 for(bb_x=0;bb_x<1;bb_x=bb_x+1)
  for(rr_x=0;rr_x<`TOTAL_ROW;rr_x=rr_x+1)
   for(cc_x=0;cc_x<`TOTAL_COL;cc_x=cc_x+8)
     
	   
       if(mem[ra_x][bb_x][rr_x][cc_x] !== mem_back[ra_x][bb_x][rr_x][cc_x]) begin
         if(command_t[32:31]==2'b10)
			$display("WAITING SUCCESS ! ") ;
		 else begin
		 $display("mem[%1d][%1d][%2d][%2d] ACCESS FAIL ! , mem=%4h , mem_back=%4h",ra_x,bb_x,rr_x,cc_x,mem[ra_x][bb_x][rr_x][cc_x],mem_back[ra_x][bb_x][rr_x][cc_x]) ;
     	   total_error=total_error+1;
		 end
       end
     	 else
     	   $display("mem[%1d][%1d][%2d][%2d] ACCESS SUCCESS ! ",ra_x,bb_x,rr_x,cc_x) ;

$display(" TOTAL design read data: %12d",read_data_count/4);     	   
$display("=====================================") ;
$display(" TOTAL_ERROR: %12d",total_error);
$display("=====================================") ;  
$display(" TOTAL Latency: %.1f",total_latency);
$display("=====================================") ;     
$display(" TOTAL Bandwidth Utilization: %.1f",total_BWU);
$display("=====================================") ;    

$finish;   


end
endmodule


