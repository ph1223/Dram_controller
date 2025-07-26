#======================================================
#
# PrimeTime  Scripts (dctcl mode)
#
#======================================================

#======================================================
#  1. Set the Power Analysis Mode
#======================================================

set power_enable_analysis true
set power_analysis_mode averaged
set power_report_leakage_breakdowns true
set power_clock_network_include_register_clock_pin_power false


set SW_Activity 10


set search_path {	./ \
                    ./../02_SYN \
			        /usr/cad/synopsys/synthesis/2019.12/libraries/syn/ }
				   
set synthetic_library {dw_foundation.sldb}
set link_library {* dw_foundation.sldb standard.sldb slow.db asap7sc7p5t_AO_RVT_TT_08302018.db asap7sc7p5t_OA_RVT_TT_08302018.db asap7sc7p5t_INVBUF_RVT_TT_08302018.db asap7sc7p5t_SEQ_RVT_TT_08302018.db asap7sc7p5t_SIMPLE_RVT_TT_08302018.db asap7sc7p5t_AO_RVT_TT_08302018.db  asap7sc7p5t_OA_RVT_TT_08302018.db}
set target_library {slow.db asap7sc7p5t_INVBUF_RVT_TT_08302018.db asap7sc7p5t_SIMPLE_RVT_TT_08302018.db asap7sc7p5t_SEQ_RVT_TT_08302018.db }


read_verilog ../02_SYN/Netlist/post_acc_sram_SYN.v
current_design post_acc_sram
link

read_sdc ../02_SYN/post_acc_sram.sdc


set_switching_activity -static_probability 0.2 -toggle_rate SW_Activity -period 100 [all_input]    
# 10 %

report_power



