//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//
//	sdrc_lite sdr sdram controller back-end
//
//	2012/05/17	version beta2.3
//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
`timescale 1ns/100ps
module MCB_AVL_IP_TOP_tb;
`include "../rtl/SDRC_MCB_AVL_PAR.v"
// avalon interface
reg							csi_clockreset_clk;
reg							csi_clockreset_reset_n;
reg		[AVL_A_W-1:0]		avs_s1_address;
reg							avs_s1_read;
reg							avs_s1_write;
reg							avs_s1_beginbursttransfer;
wire						avs_s1_waitrequest;
reg		[4-1:0]		avs_s1_burstcount;
wire						avs_s1_readdatavalid;
wire	[AVL_D_W-1:0]		avs_s1_readdata;
reg		[AVL_D_W-1:0]		avs_s1_writedata;
reg		[AVL_BE_W-1:0]		avs_s1_byteenable;
// sdram interface
wire						coe_sdr_cke;
wire						coe_sdr_cs_n;
wire						coe_sdr_ras_n;
wire						coe_sdr_cas_n;
wire						coe_sdr_we_n;
wire	[SDR_M_W-1:0]		coe_sdr_dqm;
wire	[SDR_B_W-1:0]		coe_sdr_ba;
wire	[SDR_A_W-1:0]		coe_sdr_addr;
// sdram data buffer interface
wire						coe_dbf_dq_ie;
wire	[SDR_D_W-1:0]		coe_dbf_dq_i;
wire						coe_dbf_dq_oe;
wire	[SDR_D_W-1:0]		coe_dbf_dq_o;
// sdram chip
wire						sdr_clk;
wire	[SDR_D_W-1:0]		sdr_dq;
// testbench variables
integer						tb_cnt0;
integer						tb_cnt1;
integer						avl_log_fl;
// sdr sdram memory controller with avalon-MM top instance
MCB_AVL_IP_TOP mcb_avl_ip_top0(
	.csi_clockreset_clk(csi_clockreset_clk),
	.csi_clockreset_reset_n(csi_clockreset_reset_n),
	.avs_s1_address(avs_s1_address),
	.avs_s1_read(avs_s1_read),
	.avs_s1_write(avs_s1_write),
	.avs_s1_beginbursttransfer(avs_s1_beginbursttransfer),
	.avs_s1_waitrequest(avs_s1_waitrequest),
	.avs_s1_burstcount(avs_s1_burstcount),
	.avs_s1_readdatavalid(avs_s1_readdatavalid),
	.avs_s1_readdata(avs_s1_readdata),
	.avs_s1_byteenable(avs_s1_byteenable),
	.avs_s1_writedata(avs_s1_writedata),
	.coe_sdr_cke(coe_sdr_cke),
	.coe_sdr_cs_n(coe_sdr_cs_n),
	.coe_sdr_ras_n(coe_sdr_ras_n),
	.coe_sdr_cas_n(coe_sdr_cas_n),
	.coe_sdr_we_n(coe_sdr_we_n),
	.coe_sdr_dqm(coe_sdr_dqm),
	.coe_sdr_ba(coe_sdr_ba),
	.coe_sdr_addr(coe_sdr_addr),
	.coe_dbf_dq_ie(coe_dbf_dq_ie),
	.coe_dbf_dq_i(coe_dbf_dq_i),
	.coe_dbf_dq_oe(coe_dbf_dq_oe),
	.coe_dbf_dq_o(coe_dbf_dq_o)
);
// micron mt48lc4m16a2
mt48lc4m16a2 sdram0(
	.Dq				(sdr_dq),
	.Addr			(coe_sdr_addr),
	.Ba				(coe_sdr_ba),
	.Clk			(sdr_clk),
	.Cke			(coe_sdr_cke),
	.Cs_n			(coe_sdr_cs_n),
	.Ras_n			(coe_sdr_ras_n),
	.Cas_n			(coe_sdr_cas_n),
	.We_n			(coe_sdr_we_n),
	.Dqm			(coe_sdr_dqm)
);
// Dq tristate
assign sdr_dq		= coe_dbf_dq_oe ? coe_dbf_dq_o : {(SDR_D_W){1'bz}};
assign coe_dbf_dq_i	= coe_dbf_dq_ie ? sdr_dq : {(SDR_D_W){1'bz}};
// csi_clockreset_clk
initial csi_clockreset_clk = 1'b0;
always #(MCB_tCK/2) csi_clockreset_clk = ~csi_clockreset_clk;
// sdr_clk (3ns ahead of mcb_clk(csi_clockreset_clk))
assign #(MCB_tCK*0.5 - 3) sdr_clk = ~csi_clockreset_clk;
// rst and conditions
initial begin
	tb_cnt0 = 0;
	tb_cnt1 = 0;
	csi_clockreset_reset_n				= 1'b1;
	avs_s1_read							= 1'b0;
	avs_s1_write						= 1'b0;
	avs_s1_beginbursttransfer			= 1'b0;
	avs_s1_address						= 0;
	avs_s1_burstcount					= 0;
	avs_s1_writedata					= 0;
	avs_s1_byteenable					= {AVL_BE_W{1'b1}};
	#(1 + MCB_tCK*0.5 - 3)
	csi_clockreset_reset_n				= 1'b0;
	#1
	csi_clockreset_reset_n				= 1'b1;
	#10
	avl_wr_4(mcb_addr_to_avl_addr(0, 0, 72), 4, 5, 7, 9);
	avl_wr_8(mcb_addr_to_avl_addr(0, 0, 76), 1, 3, 1, 7, 6, 2, 0, 8);
	avl_rd_8(mcb_addr_to_avl_addr(0, 0, 72));
	avl_rd_4(mcb_addr_to_avl_addr(0, 0, 80));
	avl_end;
	#1000
//	for(tb_cnt0 = 0; tb_cnt0 < 4; tb_cnt0 = tb_cnt0 + 1) begin
		for(tb_cnt1 = 0; tb_cnt1 < 4; tb_cnt1 = tb_cnt1 + 1) begin
			avl_wr_8(
				mcb_addr_to_avl_addr(tb_cnt0, tb_cnt1, tb_cnt1),
				tb_cnt1+1, tb_cnt1+3, tb_cnt1+1, tb_cnt1+7, 
				tb_cnt1+6, tb_cnt1+2, tb_cnt1+0, tb_cnt1+8
			);			
		end	
//	end
//	for(tb_cnt0 = 0; tb_cnt0 < 4; tb_cnt0 = tb_cnt0 + 1) begin
		for(tb_cnt1 = 0; tb_cnt1 < 4; tb_cnt1 = tb_cnt1 + 1) begin
			avl_rd_8(
				mcb_addr_to_avl_addr(tb_cnt0, tb_cnt1, tb_cnt1)
			);			
		end	
//	end
	avl_end;
	#1000
	avl_wr_8(
		mcb_addr_to_avl_addr(2, 5, {(SDR_C_W){1'b1}}),
		0, 7, 4, 8, 
		5, 3, 3, 2
	);			
	avl_wr_8(
		mcb_addr_to_avl_addr(
			2, 
			{(SDR_R_W){1'b1}}, 
			{{(SDR_C_W-2){1'b1}}, 2'b01}
		),
		1, 2, 4, 3, 
		7, 8, 0, 9
	);
	avl_rd_8(
		mcb_addr_to_avl_addr(2, 5, {(SDR_C_W){1'b1}})
	);
	avl_rd_8(
		mcb_addr_to_avl_addr(
			2, 
			{(SDR_R_W){1'b1}}, 
			{{(SDR_C_W-2){1'b1}}, 2'b01}
		)
	);	
	avl_end;	
	#100000
	$finish;
end
/*
initial begin
	#253000
	$finish;	
end
*/
// For Verdi or Debussy debugging
initial begin
	$fsdbDumpfile("MCB_AVL_IP_TOP_tb.fsdb");
	$fsdbDumpvars(0,MCB_AVL_IP_TOP_tb);
end
// avl logfile
initial begin
	avl_log_fl = $fopen("MCB_AVL_TOP_tb_log.txt");
end
// Tasks
// Task avalon end read/write
task avl_end;
	begin
		@(posedge csi_clockreset_clk) begin
			avs_s1_read					<= 1'b0;
			avs_s1_write				<= 1'b0;
			avs_s1_beginbursttransfer	<= 1'b0;
			avs_s1_address				<= 0;
			avs_s1_burstcount			<= 0;
			avs_s1_writedata			<= 0;
		end
	end
endtask
// Task avalon read 4
task avl_rd_4;
	input	[AVL_A_W-1:0]	raddr;
	integer					r_done;
	begin
		r_done							= 0;
		@(posedge csi_clockreset_clk) begin
			avs_s1_read					<= 1'b1;
			avs_s1_write				<= 1'b0;
			avs_s1_beginbursttransfer	<= 1'b1;
			avs_s1_address				<= raddr;
			avs_s1_burstcount			<= 4;
		end
		$fwrite(avl_log_fl, 
			"avs_s1_read:\tavl_addr = %x, sdr_ba = %x, sdr_ra = %x, sdr_ca = %x\n", 
			raddr,
			avl_addr_to_mcb_ba(raddr),
			avl_addr_to_mcb_ra(raddr),
			avl_addr_to_mcb_ca(raddr)
		);
		#1
		while(r_done == 0) begin
			@(posedge csi_clockreset_clk) begin
				avs_s1_beginbursttransfer	<= 1'b0;
				if(avs_s1_waitrequest == 1'b1)
					r_done				<= 0;					
				else
					r_done				<= 1;
			end
			#1						// delay for simulation purpose
			avs_s1_read					= avs_s1_read;
		end
	end
endtask
// Task avalon read 8
task avl_rd_8;
	input	[AVL_A_W-1:0]	raddr;
	integer					r_done;
	begin
		r_done							= 0;
		@(posedge csi_clockreset_clk) begin
			avs_s1_read					<= 1'b1;
			avs_s1_write				<= 1'b0;
			avs_s1_beginbursttransfer	<= 1'b1;
			avs_s1_address				<= raddr;
			avs_s1_burstcount			<= 8;
		end
		$fwrite(avl_log_fl, 
			"avs_s1_read:\tavl_addr = %x, sdr_ba = %x, sdr_ra = %x, sdr_ca = %x\n", 
			raddr,
			avl_addr_to_mcb_ba(raddr),
			avl_addr_to_mcb_ra(raddr),
			avl_addr_to_mcb_ca(raddr)
		);
		#1
		while(r_done == 0) begin
			@(posedge csi_clockreset_clk) begin
				avs_s1_beginbursttransfer	<= 1'b0;
				if(avs_s1_waitrequest == 1'b1)
					r_done				<= 0;					
				else
					r_done				<= 1;
			end
			#1						// delay for simulation purpose
			avs_s1_read					= avs_s1_read;
		end
	end		
endtask
// Task avalon write 4
task avl_wr_4;
	input	[AVL_A_W-1:0]	waddr;
	input	[AVL_D_W-1:0]	wdata1;
	input	[AVL_D_W-1:0]	wdata2;
	input	[AVL_D_W-1:0]	wdata3;
	input	[AVL_D_W-1:0]	wdata4;
	integer					w_cnt;
	begin
		w_cnt							= 0;
		@(posedge csi_clockreset_clk) begin
			avs_s1_read					<= 1'b0;
			avs_s1_write				<= 1'b1;
			avs_s1_beginbursttransfer	<= 1'b1;
			avs_s1_address				<= waddr;
			avs_s1_burstcount			<= 4;
			avs_s1_writedata			<= wdata1;
		end
		$fwrite(avl_log_fl, 
			"avs_s1_write:\tavl_addr = %x, sdr_ba = %x, sdr_ra = %x, sdr_ca = %x,", 
			waddr,
			avl_addr_to_mcb_ba(waddr),
			avl_addr_to_mcb_ra(waddr),
			avl_addr_to_mcb_ca(waddr)
		);
		$fwrite(avl_log_fl, 
			"data:%x,%x,%x,%x\n",
			wdata1, wdata2, wdata3, wdata4
		);
		@(posedge csi_clockreset_clk) begin
			avs_s1_beginbursttransfer	<= 1'b0;			
		end
		while(w_cnt != 3) begin
			@(posedge csi_clockreset_clk) begin
				if(avs_s1_waitrequest == 0) begin
					avs_s1_writedata	<= (w_cnt == 0) ? wdata2 :
											(w_cnt == 1) ? wdata3 :
											(w_cnt == 2) ? wdata4 :
											0;
					w_cnt				<= w_cnt + 1;
				end
				else begin
					avs_s1_writedata	<= avs_s1_writedata;
					w_cnt				<= w_cnt;
				end
			end
			#1						// delay for simulation purpose
			w_cnt						= w_cnt;
		end
	end
endtask
// Task avalon write 8
task avl_wr_8;
	input	[AVL_A_W-1:0]	waddr;
	input	[AVL_D_W-1:0]	wdata1;
	input	[AVL_D_W-1:0]	wdata2;
	input	[AVL_D_W-1:0]	wdata3;
	input	[AVL_D_W-1:0]	wdata4;
	input	[AVL_D_W-1:0]	wdata5;
	input	[AVL_D_W-1:0]	wdata6;
	input	[AVL_D_W-1:0]	wdata7;
	input	[AVL_D_W-1:0]	wdata8;
	integer					w_cnt;
	begin
		w_cnt							= 0;
		@(posedge csi_clockreset_clk) begin
			avs_s1_read					<= 1'b0;
			avs_s1_write				<= 1'b1;
			avs_s1_beginbursttransfer	<= 1'b1;
			avs_s1_address				<= waddr;
			avs_s1_burstcount			<= 8;
			avs_s1_writedata			<= wdata1;
		end
		$fwrite(avl_log_fl, 
			"avs_s1_write:\tavl_addr = %x, sdr_ba = %x, sdr_ra = %x, sdr_ca = %x,", 
			waddr,
			avl_addr_to_mcb_ba(waddr),
			avl_addr_to_mcb_ra(waddr),
			avl_addr_to_mcb_ca(waddr)
		);
		$fwrite(avl_log_fl, 
			"data:%x,%x,%x,%x,%x,%x,%x,%x\n",
			wdata1, wdata2, wdata3, wdata4, wdata5, wdata6, wdata7, wdata8 
		);
		@(posedge csi_clockreset_clk) begin
			avs_s1_beginbursttransfer	<= 1'b0;			
		end
		while(w_cnt != 7) begin
			@(posedge csi_clockreset_clk) begin
				if(avs_s1_waitrequest == 0) begin
					avs_s1_writedata	<= (w_cnt == 0) ? wdata2 :
											(w_cnt == 1) ? wdata3 :
											(w_cnt == 2) ? wdata4 :
											(w_cnt == 3) ? wdata5 :
											(w_cnt == 4) ? wdata6 :
											(w_cnt == 5) ? wdata7 :
											(w_cnt == 6) ? wdata8 :
											0;
					w_cnt				<= w_cnt + 1;
				end
				else begin
					avs_s1_writedata	<= avs_s1_writedata;
					w_cnt				<= w_cnt;
				end
			end
			#1						// delay for simulation purpose
			w_cnt						= w_cnt;
		end
	end
endtask
endmodule
