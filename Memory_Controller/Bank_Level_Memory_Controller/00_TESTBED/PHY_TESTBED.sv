`timescale 1ns / 10ps
`include "PHY_PATTERN.sv"
`include "phy_layer.sv"
`include "phy_dram_intf.sv"
`include "ddr3.sv"

module TESTBED;

`include "2048Mb_ddr3_parameters.vh"

import userType_pkg::*;

initial begin
	$fsdbDumpfile("Initialization.fsdb");
    $fsdbDumpvars(0,"+all");
    $fsdbDumpSVA;
end

// Clock and Reset
logic clk1, clk2;
logic power_rst_n, rst_n;

// DRAM Interface Ports
PHY_DRAM_INTF phy_dram_intf();
CMD_SCHDULER_PHY_INTF cmd_scheduler_phy_intf();

// Instantiate initialization,phy_layer, pattern and ddr3
initialization_fsm I_FSM(
    .clk(clk1),
    .power_rst_n(power_rst_n),
    .rst_n(rst_n),
    .command_ff_o(cmd_scheduler_phy_intf.command),
    .initialization_done_ff_o(cmd_scheduler_phy_intf.initialization_done),
    .mode_register_cnt(cmd_scheduler_phy_intf.mode_register_cnt),
);

phy_layer PHY_LAYER(
    .clk1(clk1),
    .clk2(clk2),
    .rst_n(power_on_rst_n),
    // DRAM Interface Ports
    .ck(phy_dram_intf.ck),
    .ck_n(phy_dram_intf.ck_n),
    .cke(phy_dram_intf.cke),
    .cs_n(phy_dram_intf.cs_n),
    .ras_n(phy_dram_intf.ras_n),
    .cas_n(phy_dram_intf.cas_n),
    .we_n(phy_dram_intf.we_n),
    .dm_tdqs(phy_dram_intf.dm_tdqs),
    .ba(phy_dram_intf.ba),
    .addr(phy_dram_intf.addr),
    .dq(phy_dram_intf.dq),
    .dq_all(phy_dram_intf.dq_all),
    .dqs(phy_dram_intf.dqs),
    .dqs_n(phy_dram_intf.dqs_n),
    .tdqs_n(phy_dram_intf.tdqs_n),
    .odt(phy_dram_intf.odt),
    // Interface with command scheduler
    .i_command(cmd_scheduler_phy_intf.command),
    .i_current_bank_state(cmd_scheduler_phy_intf.current_bank_state),
    .i_activated_row_addr(cmd_scheduler_phy_intf.activated_row_addr),
    // Interface with data io controls
    .i_rw_control_state(cmd_scheduler_phy_intf.rw_control_state),
    .i_data_wr_phy(cmd_scheduler_phy_intf.data_wr_phy),
    .o_data_read_phy(cmd_scheduler_phy_intf.data_read_phy),
    .i_data_full_write_phy(cmd_scheduler_phy_intf.data_full_write_phy),
    .i_read_write_io_cnt(cmd_scheduler_phy_intf.read_write_io_cnt)
);

ddr3 DRAM_BANK(
    .clk(clk),
    .ck(phy_dram_intf.ck),
    .ck_n(phy_dram_intf.ck_n),
    .cke(phy_dram_intf.cke),
    .cs_n(phy_dram_intf.cs_n),
    .ras_n(phy_dram_intf.ras_n),
    .cas_n(phy_dram_intf.cas_n),
    .we_n(phy_dram_intf.we_n),
    .dm_tdqs(phy_dram_intf.dm_tdqs),
    .ba(phy_dram_intf.ba),
    .addr(phy_dram_intf.addr),
    .dq(phy_dram_intf.dq),
    .dq_all(phy_dram_intf.dq_all),
    .dqs(phy_dram_intf.dqs),
    .dqs_n(phy_dram_intf.dqs_n),
    .tdqs_n(phy_dram_intf.tdqs_n),
    .odt(phy_dram_intf.odt)
);

// Instantiate the pattern
PATTERN PATTERN(
    .clk(clk),
    .clk2(clk2),
    .power_on_rst_n(power_on_rst_n),
    .command(command_ff_o),
    .valid(valid),
    .write_data(data_wr_phy),
    .ba_cmd_pm(ba_cmd_pm),
    .read_data(data_read_phy),
    .read_data_valid(read_data_valid)
);

endmodule
