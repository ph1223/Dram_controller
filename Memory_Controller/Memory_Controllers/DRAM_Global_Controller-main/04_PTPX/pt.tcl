#======================================================
#
# PrimeTime  Scripts (dctcl mode)
#
#======================================================
source .synopsys_dc.setup
#======================================================
#  1. Set the Power Analysis Mode
#======================================================

set power_enable_analysis true
set power_analysis_mode time_based
set power_report_leakage_breakdowns true
set power_clock_network_include_register_clock_pin_power false

#======================================================
#  2. Read and link the design
#======================================================
set DESIGN DRAM_Controller

read_verilog $DESIGN\_SYN.v
current_design $DESIGN
link
#======================================================
#  3. Set transition time / annotate parasitics
#======================================================
set_input_transition .5 [all_inputs]
read_sdc $DESIGN\_SYN.sdc

#======================================================
#  4. Read Switching Activity File
#======================================================
# read_vcd -strip_path TESTBED/u_$DESIGN $DESIGN\_SYN.fsdb
read_vcd -strip_path TESTBED/u_$DESIGN $DESIGN\_SYN.vcd

#======================================================
#  5. Perform power analysis
#======================================================
check_power
update_power

#======================================================
#  6. Generate Power Report
#======================================================

set_power_analysis_options -waveform_interval 1 -waveform_format out -waveform_output vcd
# vcd.out
report_power > Report/$DESIGN\_POWER
report_power

# exit