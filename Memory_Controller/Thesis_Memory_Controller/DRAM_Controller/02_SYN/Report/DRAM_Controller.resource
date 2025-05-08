 
****************************************
Report : resources
Design : DRAM_Controller
Version: U-2022.12
Date   : Thu May  8 17:46:02 2025
****************************************


Resource Report for Ungrouped Hierarchy rw_cmd_out_fifo/U1/U1/U1 in file
        ./DWsc_fifoctl_s1_df__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_1        | DW01_inc       | width=3    | add_208                    |
| add_x_3        | DW01_inc       | width=3    | add_213                    |
| sub_x_4        | DW01_dec       | width=2    | sub_226                    |
| add_x_5        | DW01_inc       | width=2    | add_228                    |
| lte_x_11       | DW_cmp         | width=2    | lte_246                    |
| gte_x_12       | DW_cmp         | width=2    | gte_254                    |
=============================================================================


Resource Report for Ungrouped Hierarchy rw_cmd_out_fifo/U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DWsc_fifoctl_s1_df | depth=4 | U1                        |
|                |                | err_mode=2 |                            |
|                |                | addr_width=2 |                          |
|                |                | gang_all_status=1 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy rw_cmd_out_fifo/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifoctl_s1_sf | depth=4  | U1                         |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1/U1/U1 in file
        ./DWsc_fifoctl_s1_df__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_1        | DW01_inc       | width=3    | add_208                    |
| add_x_3        | DW01_inc       | width=3    | add_213                    |
| sub_x_4        | DW01_dec       | width=2    | sub_226                    |
| add_x_5        | DW01_inc       | width=2    | add_228                    |
| lte_x_11       | DW_cmp         | width=2    | lte_246                    |
| gte_x_12       | DW_cmp         | width=2    | gte_254                    |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DWsc_fifoctl_s1_df | depth=4 | U1                        |
|                |                | err_mode=2 |                            |
|                |                | addr_width=2 |                          |
|                |                | gang_all_status=1 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifoctl_s1_sf | depth=4  | U1                         |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| U2             | DW_ram_r_w_s_dff | data_width=24 | U2                    |
|                |                | depth=4    |                            |
|                |                | rst_mode=0 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy U1/U1/U1 in file
        ./DWsc_fifoctl_s1_df__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_1        | DW01_inc       | width=3    | add_208                    |
| add_x_3        | DW01_inc       | width=3    | add_213                    |
| sub_x_4        | DW01_dec       | width=2    | sub_226                    |
| add_x_5        | DW01_inc       | width=2    | add_228                    |
| lte_x_11       | DW_cmp         | width=2    | lte_246                    |
| gte_x_12       | DW_cmp         | width=2    | gte_254                    |
=============================================================================


Resource Report for Ungrouped Hierarchy U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DWsc_fifoctl_s1_df | depth=4 | U1                        |
|                |                | err_mode=2 |                            |
|                |                | addr_width=2 |                          |
|                |                | gang_all_status=1 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifoctl_s1_sf | depth=4  | U1                         |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=1 |                            |
| U2             | DW_ram_r_w_s_dff | data_width=1024 | U2                  |
|                |                | depth=4    |                            |
|                |                | rst_mode=1 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy
        BackendController_0/Rank0/rdata_out_fifo
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifo_s1_sf  | width=1024 | U1 (Ctrl.sv:1729)          |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy BackendController_0/Rank0 in file
        ../01_RTL/bank_FSM.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| eq_x_8         | DW_cmp         | width=16   | eq_169 (bank_FSM.sv:169)   |
| sub_x_14       | DW01_dec       | width=7    | ba0/sub_266 (bank_FSM.sv:266) |
| add_x_16       | DW01_inc       | width=12   | ba0/add_288 (bank_FSM.sv:288) |
| lte_x_57       | DW_cmp         | width=3    | lte_972 (Ctrl.sv:972)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1346 (Ctrl.sv:1346)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1346_2 (Ctrl.sv:1346)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1346_3 (Ctrl.sv:1346)  |
| gte_x_108      | DW_cmp         | width=3    | gte_1346_4 (Ctrl.sv:1346)  |
| gte_x_109      | DW_cmp         | width=3    | gte_1346_5 (Ctrl.sv:1346)  |
| gte_x_122      | DW_cmp         | width=10   | gte_1510 (Ctrl.sv:1510)    |
| gt_x_124       | DW_cmp         | width=3    | gt_1521 (Ctrl.sv:1521)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1521_2 (Ctrl.sv:1521)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1521_3 (Ctrl.sv:1521)   |
| gt_x_127       | DW_cmp         | width=3    | gt_1521_4 (Ctrl.sv:1521)   |
| gt_x_128       | DW_cmp         | width=3    | gt_1526 (Ctrl.sv:1526)     |
| gt_x_129       | DW_cmp         | width=3    | gt_1526_2 (Ctrl.sv:1526)   |
| gt_x_130       | DW_cmp         | width=3    | gt_1526_3 (Ctrl.sv:1526)   |
| gt_x_131       | DW_cmp         | width=3    | gt_1526_4 (Ctrl.sv:1526)   |
| gt_x_132       | DW_cmp         | width=3    | gt_1531 (Ctrl.sv:1531)     |
| gt_x_133       | DW_cmp         | width=3    | gt_1531_2 (Ctrl.sv:1531)   |
| gt_x_134       | DW_cmp         | width=3    | gt_1531_3 (Ctrl.sv:1531)   |
| gt_x_135       | DW_cmp         | width=3    | gt_1531_4 (Ctrl.sv:1531)   |
| gt_x_136       | DW_cmp         | width=3    | gt_1536 (Ctrl.sv:1536)     |
| gt_x_137       | DW_cmp         | width=3    | gt_1536_2 (Ctrl.sv:1536)   |
| gt_x_138       | DW_cmp         | width=3    | gt_1536_3 (Ctrl.sv:1536)   |
| gt_x_139       | DW_cmp         | width=3    | gt_1536_4 (Ctrl.sv:1536)   |
| gt_x_140       | DW_cmp         | width=3    | gt_1541 (Ctrl.sv:1541)     |
| gt_x_141       | DW_cmp         | width=3    | gt_1541_2 (Ctrl.sv:1541)   |
| gt_x_142       | DW_cmp         | width=3    | gt_1541_3 (Ctrl.sv:1541)   |
| gt_x_143       | DW_cmp         | width=3    | gt_1541_4 (Ctrl.sv:1541)   |
| add_x_157      | DW01_inc       | width=3    | add_1609 (Ctrl.sv:1609)    |
| add_x_158      | DW01_inc       | width=3    | add_1610 (Ctrl.sv:1610)    |
| add_x_159      | DW01_inc       | width=3    | add_1611 (Ctrl.sv:1611)    |
| add_x_160      | DW01_inc       | width=3    | add_1612 (Ctrl.sv:1612)    |
| add_x_161      | DW01_inc       | width=3    | add_1613 (Ctrl.sv:1613)    |
| add_x_167      | DW01_inc       | width=3    | add_1620 (Ctrl.sv:1620)    |
| isu_fifo/U1    | DW_fifo_s1_sf  | width=24   | isu_fifo/U1 (Ctrl.sv:1729) |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| rw_cmd_out_fifo/U1              |            |                            |
|                | DW_fifo_s1_sf  | width=2    | rw_cmd_out_fifo/U1 (Ctrl.sv:1729) |
          |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| gte_x_192      | DW_cmp         | width=3    | gte_1213 (Ctrl.sv:1213)    |
|                |                |            | gte_1271 (Ctrl.sv:1271)    |
| eq_x_193       | DW_cmp         | width=3    | eq_1352 (Ctrl.sv:1352)     |
|                |                |            | eq_1377 (Ctrl.sv:1377)     |
|                |                |            | eq_1620 (Ctrl.sv:1620)     |
| eq_x_194       | DW_cmp         | width=3    | tP_ba0/eq_102 (tP_counter.sv:102) |
          |                |            | tP_ba0/eq_107 (tP_counter.sv:107) |
          |                |            | tP_ba0/eq_108 (tP_counter.sv:108) |
          |                |            | tP_ba0/eq_109 (tP_counter.sv:109) |
          |                |            | tP_ba0/eq_67 (tP_counter.sv:67) |
            |                |            | tP_ba0/eq_69 (tP_counter.sv:69) |
            |                |            | tP_ba0/eq_77 (tP_counter.sv:77) |
            |                |            | tP_ba0/eq_88 (tP_counter.sv:88) |
| sub_x_179      | DW01_dec       | width=5    | tP_ba0/sub_67 (tP_counter.sv:67) |
           |                |            | tP_ba0/sub_75 (tP_counter.sv:75) |
           |                |            | tP_ba0/sub_86 (tP_counter.sv:86) |
           |                |            | tP_ba0/sub_88 (tP_counter.sv:88) |
           |                |            | tP_ba0/sub_89 (tP_counter.sv:89) |
| sub_x_102      | DW01_dec       | width=10   | sub_1319 (Ctrl.sv:1319)    |
|                |                |            | sub_1320 (Ctrl.sv:1320)    |
|                |                |            | sub_1322 (Ctrl.sv:1322)    |
|                |                |            | sub_1324 (Ctrl.sv:1324)    |
| sub_x_26       | DW01_dec       | width=5    | sub_613 (Ctrl.sv:613)      |
|                |                |            | sub_614 (Ctrl.sv:614)      |
|                |                |            | sub_615 (Ctrl.sv:615)      |
| sub_x_23       | DW01_dec       | width=3    | sub_595 (Ctrl.sv:595)      |
|                |                |            | sub_596 (Ctrl.sv:596)      |
| sub_x_20       | DW01_dec       | width=2    | sub_583 (Ctrl.sv:583)      |
|                |                |            | sub_584 (Ctrl.sv:584)      |
=============================================================================


Resource Report for Ungrouped Hierarchy
        BackendController_3/Rank0/rdata_out_fifo
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifo_s1_sf  | width=1024 | U1 (Ctrl.sv:1729)          |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy BackendController_3/Rank0 in file
        ../01_RTL/bank_FSM.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| eq_x_8         | DW_cmp         | width=16   | eq_169 (bank_FSM.sv:169)   |
| sub_x_14       | DW01_dec       | width=7    | ba0/sub_266 (bank_FSM.sv:266) |
| add_x_16       | DW01_inc       | width=12   | ba0/add_288 (bank_FSM.sv:288) |
| lte_x_57       | DW_cmp         | width=3    | lte_972 (Ctrl.sv:972)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1346 (Ctrl.sv:1346)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1346_2 (Ctrl.sv:1346)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1346_3 (Ctrl.sv:1346)  |
| gte_x_108      | DW_cmp         | width=3    | gte_1346_4 (Ctrl.sv:1346)  |
| gte_x_109      | DW_cmp         | width=3    | gte_1346_5 (Ctrl.sv:1346)  |
| gte_x_122      | DW_cmp         | width=10   | gte_1510 (Ctrl.sv:1510)    |
| gt_x_124       | DW_cmp         | width=3    | gt_1521 (Ctrl.sv:1521)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1521_2 (Ctrl.sv:1521)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1521_3 (Ctrl.sv:1521)   |
| gt_x_127       | DW_cmp         | width=3    | gt_1521_4 (Ctrl.sv:1521)   |
| gt_x_128       | DW_cmp         | width=3    | gt_1526 (Ctrl.sv:1526)     |
| gt_x_129       | DW_cmp         | width=3    | gt_1526_2 (Ctrl.sv:1526)   |
| gt_x_130       | DW_cmp         | width=3    | gt_1526_3 (Ctrl.sv:1526)   |
| gt_x_131       | DW_cmp         | width=3    | gt_1526_4 (Ctrl.sv:1526)   |
| gt_x_132       | DW_cmp         | width=3    | gt_1531 (Ctrl.sv:1531)     |
| gt_x_133       | DW_cmp         | width=3    | gt_1531_2 (Ctrl.sv:1531)   |
| gt_x_134       | DW_cmp         | width=3    | gt_1531_3 (Ctrl.sv:1531)   |
| gt_x_135       | DW_cmp         | width=3    | gt_1531_4 (Ctrl.sv:1531)   |
| gt_x_136       | DW_cmp         | width=3    | gt_1536 (Ctrl.sv:1536)     |
| gt_x_137       | DW_cmp         | width=3    | gt_1536_2 (Ctrl.sv:1536)   |
| gt_x_138       | DW_cmp         | width=3    | gt_1536_3 (Ctrl.sv:1536)   |
| gt_x_139       | DW_cmp         | width=3    | gt_1536_4 (Ctrl.sv:1536)   |
| gt_x_140       | DW_cmp         | width=3    | gt_1541 (Ctrl.sv:1541)     |
| gt_x_141       | DW_cmp         | width=3    | gt_1541_2 (Ctrl.sv:1541)   |
| gt_x_142       | DW_cmp         | width=3    | gt_1541_3 (Ctrl.sv:1541)   |
| gt_x_143       | DW_cmp         | width=3    | gt_1541_4 (Ctrl.sv:1541)   |
| add_x_157      | DW01_inc       | width=3    | add_1609 (Ctrl.sv:1609)    |
| add_x_158      | DW01_inc       | width=3    | add_1610 (Ctrl.sv:1610)    |
| add_x_159      | DW01_inc       | width=3    | add_1611 (Ctrl.sv:1611)    |
| add_x_160      | DW01_inc       | width=3    | add_1612 (Ctrl.sv:1612)    |
| add_x_161      | DW01_inc       | width=3    | add_1613 (Ctrl.sv:1613)    |
| add_x_167      | DW01_inc       | width=3    | add_1620 (Ctrl.sv:1620)    |
| isu_fifo/U1    | DW_fifo_s1_sf  | width=24   | isu_fifo/U1 (Ctrl.sv:1729) |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| rw_cmd_out_fifo/U1              |            |                            |
|                | DW_fifo_s1_sf  | width=2    | rw_cmd_out_fifo/U1 (Ctrl.sv:1729) |
          |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| gte_x_192      | DW_cmp         | width=3    | gte_1213 (Ctrl.sv:1213)    |
|                |                |            | gte_1271 (Ctrl.sv:1271)    |
| eq_x_193       | DW_cmp         | width=3    | eq_1352 (Ctrl.sv:1352)     |
|                |                |            | eq_1377 (Ctrl.sv:1377)     |
|                |                |            | eq_1620 (Ctrl.sv:1620)     |
| eq_x_194       | DW_cmp         | width=3    | tP_ba0/eq_102 (tP_counter.sv:102) |
          |                |            | tP_ba0/eq_107 (tP_counter.sv:107) |
          |                |            | tP_ba0/eq_108 (tP_counter.sv:108) |
          |                |            | tP_ba0/eq_109 (tP_counter.sv:109) |
          |                |            | tP_ba0/eq_67 (tP_counter.sv:67) |
            |                |            | tP_ba0/eq_69 (tP_counter.sv:69) |
            |                |            | tP_ba0/eq_77 (tP_counter.sv:77) |
            |                |            | tP_ba0/eq_88 (tP_counter.sv:88) |
| sub_x_179      | DW01_dec       | width=5    | tP_ba0/sub_67 (tP_counter.sv:67) |
           |                |            | tP_ba0/sub_75 (tP_counter.sv:75) |
           |                |            | tP_ba0/sub_86 (tP_counter.sv:86) |
           |                |            | tP_ba0/sub_88 (tP_counter.sv:88) |
           |                |            | tP_ba0/sub_89 (tP_counter.sv:89) |
| sub_x_102      | DW01_dec       | width=10   | sub_1319 (Ctrl.sv:1319)    |
|                |                |            | sub_1320 (Ctrl.sv:1320)    |
|                |                |            | sub_1322 (Ctrl.sv:1322)    |
|                |                |            | sub_1324 (Ctrl.sv:1324)    |
| sub_x_26       | DW01_dec       | width=5    | sub_613 (Ctrl.sv:613)      |
|                |                |            | sub_614 (Ctrl.sv:614)      |
|                |                |            | sub_615 (Ctrl.sv:615)      |
| sub_x_23       | DW01_dec       | width=3    | sub_595 (Ctrl.sv:595)      |
|                |                |            | sub_596 (Ctrl.sv:596)      |
| sub_x_20       | DW01_dec       | width=2    | sub_583 (Ctrl.sv:583)      |
|                |                |            | sub_584 (Ctrl.sv:584)      |
=============================================================================


Resource Report for Ungrouped Hierarchy
        BackendController_2/Rank0/rdata_out_fifo
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifo_s1_sf  | width=1024 | U1 (Ctrl.sv:1729)          |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=3 |                            |
=============================================================================


Resource Report for Ungrouped Hierarchy BackendController_2/Rank0 in file
        ../01_RTL/bank_FSM.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| eq_x_8         | DW_cmp         | width=16   | eq_169 (bank_FSM.sv:169)   |
| sub_x_14       | DW01_dec       | width=7    | ba0/sub_266 (bank_FSM.sv:266) |
| add_x_16       | DW01_inc       | width=12   | ba0/add_288 (bank_FSM.sv:288) |
| lte_x_57       | DW_cmp         | width=3    | lte_972 (Ctrl.sv:972)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1346 (Ctrl.sv:1346)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1346_2 (Ctrl.sv:1346)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1346_3 (Ctrl.sv:1346)  |
| gte_x_108      | DW_cmp         | width=3    | gte_1346_4 (Ctrl.sv:1346)  |
| gte_x_109      | DW_cmp         | width=3    | gte_1346_5 (Ctrl.sv:1346)  |
| gte_x_122      | DW_cmp         | width=10   | gte_1510 (Ctrl.sv:1510)    |
| gt_x_124       | DW_cmp         | width=3    | gt_1521 (Ctrl.sv:1521)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1521_2 (Ctrl.sv:1521)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1521_3 (Ctrl.sv:1521)   |
| gt_x_127       | DW_cmp         | width=3    | gt_1521_4 (Ctrl.sv:1521)   |
| gt_x_128       | DW_cmp         | width=3    | gt_1526 (Ctrl.sv:1526)     |
| gt_x_129       | DW_cmp         | width=3    | gt_1526_2 (Ctrl.sv:1526)   |
| gt_x_130       | DW_cmp         | width=3    | gt_1526_3 (Ctrl.sv:1526)   |
| gt_x_131       | DW_cmp         | width=3    | gt_1526_4 (Ctrl.sv:1526)   |
| gt_x_132       | DW_cmp         | width=3    | gt_1531 (Ctrl.sv:1531)     |
| gt_x_133       | DW_cmp         | width=3    | gt_1531_2 (Ctrl.sv:1531)   |
| gt_x_134       | DW_cmp         | width=3    | gt_1531_3 (Ctrl.sv:1531)   |
| gt_x_135       | DW_cmp         | width=3    | gt_1531_4 (Ctrl.sv:1531)   |
| gt_x_136       | DW_cmp         | width=3    | gt_1536 (Ctrl.sv:1536)     |
| gt_x_137       | DW_cmp         | width=3    | gt_1536_2 (Ctrl.sv:1536)   |
| gt_x_138       | DW_cmp         | width=3    | gt_1536_3 (Ctrl.sv:1536)   |
| gt_x_139       | DW_cmp         | width=3    | gt_1536_4 (Ctrl.sv:1536)   |
| gt_x_140       | DW_cmp         | width=3    | gt_1541 (Ctrl.sv:1541)     |
| gt_x_141       | DW_cmp         | width=3    | gt_1541_2 (Ctrl.sv:1541)   |
| gt_x_142       | DW_cmp         | width=3    | gt_1541_3 (Ctrl.sv:1541)   |
| gt_x_143       | DW_cmp         | width=3    | gt_1541_4 (Ctrl.sv:1541)   |
| add_x_157      | DW01_inc       | width=3    | add_1609 (Ctrl.sv:1609)    |
| add_x_158      | DW01_inc       | width=3    | add_1610 (Ctrl.sv:1610)    |
| add_x_159      | DW01_inc       | width=3    | add_1611 (Ctrl.sv:1611)    |
| add_x_160      | DW01_inc       | width=3    | add_1612 (Ctrl.sv:1612)    |
| add_x_161      | DW01_inc       | width=3    | add_1613 (Ctrl.sv:1613)    |
| add_x_167      | DW01_inc       | width=3    | add_1620 (Ctrl.sv:1620)    |
| isu_fifo/U1    | DW_fifo_s1_sf  | width=24   | isu_fifo/U1 (Ctrl.sv:1729) |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| rw_cmd_out_fifo/U1              |            |                            |
|                | DW_fifo_s1_sf  | width=2    | rw_cmd_out_fifo/U1 (Ctrl.sv:1729) |
          |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| gte_x_192      | DW_cmp         | width=3    | gte_1213 (Ctrl.sv:1213)    |
|                |                |            | gte_1271 (Ctrl.sv:1271)    |
| eq_x_193       | DW_cmp         | width=3    | eq_1352 (Ctrl.sv:1352)     |
|                |                |            | eq_1377 (Ctrl.sv:1377)     |
|                |                |            | eq_1620 (Ctrl.sv:1620)     |
| eq_x_194       | DW_cmp         | width=3    | tP_ba0/eq_102 (tP_counter.sv:102) |
          |                |            | tP_ba0/eq_107 (tP_counter.sv:107) |
          |                |            | tP_ba0/eq_108 (tP_counter.sv:108) |
          |                |            | tP_ba0/eq_109 (tP_counter.sv:109) |
          |                |            | tP_ba0/eq_67 (tP_counter.sv:67) |
            |                |            | tP_ba0/eq_69 (tP_counter.sv:69) |
            |                |            | tP_ba0/eq_77 (tP_counter.sv:77) |
            |                |            | tP_ba0/eq_88 (tP_counter.sv:88) |
| sub_x_179      | DW01_dec       | width=5    | tP_ba0/sub_67 (tP_counter.sv:67) |
           |                |            | tP_ba0/sub_75 (tP_counter.sv:75) |
           |                |            | tP_ba0/sub_86 (tP_counter.sv:86) |
           |                |            | tP_ba0/sub_88 (tP_counter.sv:88) |
           |                |            | tP_ba0/sub_89 (tP_counter.sv:89) |
| sub_x_102      | DW01_dec       | width=10   | sub_1319 (Ctrl.sv:1319)    |
|                |                |            | sub_1320 (Ctrl.sv:1320)    |
|                |                |            | sub_1322 (Ctrl.sv:1322)    |
|                |                |            | sub_1324 (Ctrl.sv:1324)    |
| sub_x_26       | DW01_dec       | width=5    | sub_613 (Ctrl.sv:613)      |
|                |                |            | sub_614 (Ctrl.sv:614)      |
|                |                |            | sub_615 (Ctrl.sv:615)      |
| sub_x_23       | DW01_dec       | width=3    | sub_595 (Ctrl.sv:595)      |
|                |                |            | sub_596 (Ctrl.sv:596)      |
| sub_x_20       | DW01_dec       | width=2    | sub_583 (Ctrl.sv:583)      |
|                |                |            | sub_584 (Ctrl.sv:584)      |
=============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
| add_x_1            | DW01_inc         | apparch (area)     |                |
| add_x_3            | DW01_inc         | apparch (area)     |                |
| sub_x_4            | DW01_dec         | apparch (area)     |                |
| add_x_5            | DW01_inc         | apparch (area)     |                |
| U1                 | DWsc_fifoctl_s1_df | rtl              |                |
| U1                 | DW_fifoctl_s1_sf | rtl                |                |
| add_x_1            | DW01_inc         | apparch (area)     |                |
| add_x_3            | DW01_inc         | apparch (area)     |                |
| sub_x_4            | DW01_dec         | apparch (area)     |                |
| add_x_5            | DW01_inc         | apparch (area)     |                |
| U1                 | DWsc_fifoctl_s1_df | rtl              |                |
| U1                 | DW_fifoctl_s1_sf | rtl                |                |
| U2                 | DW_ram_r_w_s_dff | rtl                |                |
| add_x_1            | DW01_inc         | apparch (area)     |                |
| add_x_3            | DW01_inc         | apparch (area)     |                |
| sub_x_4            | DW01_dec         | apparch (area)     |                |
| add_x_5            | DW01_inc         | apparch (area)     |                |
| U1                 | DWsc_fifoctl_s1_df | rtl              |                |
| U1                 | DW_fifoctl_s1_sf | rtl                |                |
| U1                 | DW_fifo_s1_sf    | rtl                |                |
| eq_x_8             | DW_cmp           | apparch (area)     |                |
| sub_x_14           | DW01_dec         | apparch (area)     |                |
| add_x_16           | DW01_inc         | apparch (area)     |                |
| lte_x_57           | DW_cmp           | apparch (area)     |                |
| gte_x_105          | DW_cmp           | apparch (area)     |                |
| gte_x_106          | DW_cmp           | apparch (area)     |                |
| gte_x_107          | DW_cmp           | apparch (area)     |                |
| gte_x_108          | DW_cmp           | apparch (area)     |                |
| gte_x_109          | DW_cmp           | apparch (area)     |                |
| gte_x_122          | DW_cmp           | apparch (area)     |                |
| gt_x_124           | DW_cmp           | apparch (area)     |                |
| gt_x_125           | DW_cmp           | apparch (area)     |                |
| gt_x_126           | DW_cmp           | apparch (area)     |                |
| gt_x_127           | DW_cmp           | apparch (area)     |                |
| gt_x_128           | DW_cmp           | apparch (area)     |                |
| gt_x_129           | DW_cmp           | apparch (area)     |                |
| gt_x_130           | DW_cmp           | apparch (area)     |                |
| gt_x_131           | DW_cmp           | apparch (area)     |                |
| gt_x_132           | DW_cmp           | apparch (area)     |                |
| gt_x_133           | DW_cmp           | apparch (area)     |                |
| gt_x_134           | DW_cmp           | apparch (area)     |                |
| gt_x_135           | DW_cmp           | apparch (area)     |                |
| gt_x_136           | DW_cmp           | apparch (area)     |                |
| gt_x_137           | DW_cmp           | apparch (area)     |                |
| gt_x_138           | DW_cmp           | apparch (area)     |                |
| gt_x_139           | DW_cmp           | apparch (area)     |                |
| gt_x_140           | DW_cmp           | apparch (area)     |                |
| gt_x_141           | DW_cmp           | apparch (area)     |                |
| gt_x_142           | DW_cmp           | apparch (area)     |                |
| gt_x_143           | DW_cmp           | apparch (area)     |                |
| add_x_157          | DW01_inc         | apparch (area)     |                |
| add_x_158          | DW01_inc         | apparch (area)     |                |
| add_x_159          | DW01_inc         | apparch (area)     |                |
| add_x_160          | DW01_inc         | apparch (area)     |                |
| add_x_161          | DW01_inc         | apparch (area)     |                |
| add_x_167          | DW01_inc         | apparch (area)     |                |
| isu_fifo/U1        | DW_fifo_s1_sf    | rtl                |                |
| rw_cmd_out_fifo/U1 | DW_fifo_s1_sf    | rtl                |                |
| gte_x_192          | DW_cmp           | apparch (area)     |                |
| eq_x_193           | DW_cmp           | apparch (area)     |                |
| eq_x_194           | DW_cmp           | apparch (area)     |                |
| sub_x_179          | DW01_dec         | apparch (area)     |                |
| sub_x_102          | DW01_dec         | apparch (area)     |                |
| sub_x_26           | DW01_dec         | apparch (area)     |                |
| sub_x_23           | DW01_dec         | apparch (area)     |                |
| sub_x_20           | DW01_dec         | apparch (area)     |                |
| U1                 | DW_fifo_s1_sf    | rtl                |                |
| eq_x_8             | DW_cmp           | apparch (area)     |                |
| sub_x_14           | DW01_dec         | apparch (area)     |                |
| add_x_16           | DW01_inc         | apparch (area)     |                |
| lte_x_57           | DW_cmp           | apparch (area)     |                |
| gte_x_105          | DW_cmp           | apparch (area)     |                |
| gte_x_106          | DW_cmp           | apparch (area)     |                |
| gte_x_107          | DW_cmp           | apparch (area)     |                |
| gte_x_108          | DW_cmp           | apparch (area)     |                |
| gte_x_109          | DW_cmp           | apparch (area)     |                |
| gte_x_122          | DW_cmp           | apparch (area)     |                |
| gt_x_124           | DW_cmp           | apparch (area)     |                |
| gt_x_125           | DW_cmp           | apparch (area)     |                |
| gt_x_126           | DW_cmp           | apparch (area)     |                |
| gt_x_127           | DW_cmp           | apparch (area)     |                |
| gt_x_128           | DW_cmp           | apparch (area)     |                |
| gt_x_129           | DW_cmp           | apparch (area)     |                |
| gt_x_130           | DW_cmp           | apparch (area)     |                |
| gt_x_131           | DW_cmp           | apparch (area)     |                |
| gt_x_132           | DW_cmp           | apparch (area)     |                |
| gt_x_133           | DW_cmp           | apparch (area)     |                |
| gt_x_134           | DW_cmp           | apparch (area)     |                |
| gt_x_135           | DW_cmp           | apparch (area)     |                |
| gt_x_136           | DW_cmp           | apparch (area)     |                |
| gt_x_137           | DW_cmp           | apparch (area)     |                |
| gt_x_138           | DW_cmp           | apparch (area)     |                |
| gt_x_139           | DW_cmp           | apparch (area)     |                |
| gt_x_140           | DW_cmp           | apparch (area)     |                |
| gt_x_141           | DW_cmp           | apparch (area)     |                |
| gt_x_142           | DW_cmp           | apparch (area)     |                |
| gt_x_143           | DW_cmp           | apparch (area)     |                |
| add_x_157          | DW01_inc         | apparch (area)     |                |
| add_x_158          | DW01_inc         | apparch (area)     |                |
| add_x_159          | DW01_inc         | apparch (area)     |                |
| add_x_160          | DW01_inc         | apparch (area)     |                |
| add_x_161          | DW01_inc         | apparch (area)     |                |
| add_x_167          | DW01_inc         | apparch (area)     |                |
| isu_fifo/U1        | DW_fifo_s1_sf    | rtl                |                |
| rw_cmd_out_fifo/U1 | DW_fifo_s1_sf    | rtl                |                |
| gte_x_192          | DW_cmp           | apparch (area)     |                |
| eq_x_193           | DW_cmp           | apparch (area)     |                |
| eq_x_194           | DW_cmp           | apparch (area)     |                |
| sub_x_179          | DW01_dec         | apparch (area)     |                |
| sub_x_102          | DW01_dec         | apparch (area)     |                |
| sub_x_26           | DW01_dec         | apparch (area)     |                |
| sub_x_23           | DW01_dec         | apparch (area)     |                |
| sub_x_20           | DW01_dec         | apparch (area)     |                |
| U1                 | DW_fifo_s1_sf    | rtl                |                |
| eq_x_8             | DW_cmp           | apparch (area)     |                |
| sub_x_14           | DW01_dec         | apparch (area)     |                |
| add_x_16           | DW01_inc         | apparch (area)     |                |
| lte_x_57           | DW_cmp           | apparch (area)     |                |
| gte_x_105          | DW_cmp           | apparch (area)     |                |
| gte_x_106          | DW_cmp           | apparch (area)     |                |
| gte_x_107          | DW_cmp           | apparch (area)     |                |
| gte_x_108          | DW_cmp           | apparch (area)     |                |
| gte_x_109          | DW_cmp           | apparch (area)     |                |
| gte_x_122          | DW_cmp           | apparch (area)     |                |
| gt_x_124           | DW_cmp           | apparch (area)     |                |
| gt_x_125           | DW_cmp           | apparch (area)     |                |
| gt_x_126           | DW_cmp           | apparch (area)     |                |
| gt_x_127           | DW_cmp           | apparch (area)     |                |
| gt_x_128           | DW_cmp           | apparch (area)     |                |
| gt_x_129           | DW_cmp           | apparch (area)     |                |
| gt_x_130           | DW_cmp           | apparch (area)     |                |
| gt_x_131           | DW_cmp           | apparch (area)     |                |
| gt_x_132           | DW_cmp           | apparch (area)     |                |
| gt_x_133           | DW_cmp           | apparch (area)     |                |
| gt_x_134           | DW_cmp           | apparch (area)     |                |
| gt_x_135           | DW_cmp           | apparch (area)     |                |
| gt_x_136           | DW_cmp           | apparch (area)     |                |
| gt_x_137           | DW_cmp           | apparch (area)     |                |
| gt_x_138           | DW_cmp           | apparch (area)     |                |
| gt_x_139           | DW_cmp           | apparch (area)     |                |
| gt_x_140           | DW_cmp           | apparch (area)     |                |
| gt_x_141           | DW_cmp           | apparch (area)     |                |
| gt_x_142           | DW_cmp           | apparch (area)     |                |
| gt_x_143           | DW_cmp           | apparch (area)     |                |
| add_x_157          | DW01_inc         | apparch (area)     |                |
| add_x_158          | DW01_inc         | apparch (area)     |                |
| add_x_159          | DW01_inc         | apparch (area)     |                |
| add_x_160          | DW01_inc         | apparch (area)     |                |
| add_x_161          | DW01_inc         | apparch (area)     |                |
| add_x_167          | DW01_inc         | apparch (area)     |                |
| isu_fifo/U1        | DW_fifo_s1_sf    | rtl                |                |
| rw_cmd_out_fifo/U1 | DW_fifo_s1_sf    | rtl                |                |
| gte_x_192          | DW_cmp           | apparch (area)     |                |
| eq_x_193           | DW_cmp           | apparch (area)     |                |
| eq_x_194           | DW_cmp           | apparch (area)     |                |
| sub_x_179          | DW01_dec         | apparch (area)     |                |
| sub_x_102          | DW01_dec         | apparch (area)     |                |
| sub_x_26           | DW01_dec         | apparch (area)     |                |
| sub_x_23           | DW01_dec         | apparch (area)     |                |
| sub_x_20           | DW01_dec         | apparch (area)     |                |
===============================================================================

1
