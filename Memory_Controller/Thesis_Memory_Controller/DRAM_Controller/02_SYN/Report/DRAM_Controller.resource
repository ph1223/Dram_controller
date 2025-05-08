 
****************************************
Report : resources
Design : DRAM_Controller
Version: U-2022.12
Date   : Fri May  9 00:57:03 2025
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


Resource Report for Ungrouped Hierarchy BackendController_0/Rank0 in file
        ../01_RTL/bank_FSM.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| eq_x_8         | DW_cmp         | width=16   | eq_169 (bank_FSM.sv:169)   |
| sub_x_14       | DW01_dec       | width=7    | ba0/sub_266 (bank_FSM.sv:266) |
| add_x_16       | DW01_inc       | width=12   | ba0/add_288 (bank_FSM.sv:288) |
| lte_x_57       | DW_cmp         | width=3    | lte_974 (Ctrl.sv:974)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1348 (Ctrl.sv:1348)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1348_2 (Ctrl.sv:1348)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1348_3 (Ctrl.sv:1348)  |
| gte_x_108      | DW_cmp         | width=3    | gte_1348_4 (Ctrl.sv:1348)  |
| gte_x_109      | DW_cmp         | width=3    | gte_1348_5 (Ctrl.sv:1348)  |
| gte_x_122      | DW_cmp         | width=10   | gte_1512 (Ctrl.sv:1512)    |
| gt_x_124       | DW_cmp         | width=3    | gt_1523 (Ctrl.sv:1523)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1523_2 (Ctrl.sv:1523)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1523_3 (Ctrl.sv:1523)   |
| gt_x_127       | DW_cmp         | width=3    | gt_1523_4 (Ctrl.sv:1523)   |
| gt_x_128       | DW_cmp         | width=3    | gt_1528 (Ctrl.sv:1528)     |
| gt_x_129       | DW_cmp         | width=3    | gt_1528_2 (Ctrl.sv:1528)   |
| gt_x_130       | DW_cmp         | width=3    | gt_1528_3 (Ctrl.sv:1528)   |
| gt_x_131       | DW_cmp         | width=3    | gt_1528_4 (Ctrl.sv:1528)   |
| gt_x_132       | DW_cmp         | width=3    | gt_1533 (Ctrl.sv:1533)     |
| gt_x_133       | DW_cmp         | width=3    | gt_1533_2 (Ctrl.sv:1533)   |
| gt_x_134       | DW_cmp         | width=3    | gt_1533_3 (Ctrl.sv:1533)   |
| gt_x_135       | DW_cmp         | width=3    | gt_1533_4 (Ctrl.sv:1533)   |
| gt_x_136       | DW_cmp         | width=3    | gt_1538 (Ctrl.sv:1538)     |
| gt_x_137       | DW_cmp         | width=3    | gt_1538_2 (Ctrl.sv:1538)   |
| gt_x_138       | DW_cmp         | width=3    | gt_1538_3 (Ctrl.sv:1538)   |
| gt_x_139       | DW_cmp         | width=3    | gt_1538_4 (Ctrl.sv:1538)   |
| gt_x_140       | DW_cmp         | width=3    | gt_1543 (Ctrl.sv:1543)     |
| gt_x_141       | DW_cmp         | width=3    | gt_1543_2 (Ctrl.sv:1543)   |
| gt_x_142       | DW_cmp         | width=3    | gt_1543_3 (Ctrl.sv:1543)   |
| gt_x_143       | DW_cmp         | width=3    | gt_1543_4 (Ctrl.sv:1543)   |
| add_x_157      | DW01_inc       | width=3    | add_1611 (Ctrl.sv:1611)    |
| add_x_158      | DW01_inc       | width=3    | add_1612 (Ctrl.sv:1612)    |
| add_x_159      | DW01_inc       | width=3    | add_1613 (Ctrl.sv:1613)    |
| add_x_160      | DW01_inc       | width=3    | add_1614 (Ctrl.sv:1614)    |
| add_x_161      | DW01_inc       | width=3    | add_1615 (Ctrl.sv:1615)    |
| add_x_167      | DW01_inc       | width=3    | add_1622 (Ctrl.sv:1622)    |
| isu_fifo/U1    | DW_fifo_s1_sf  | width=24   | isu_fifo/U1 (Ctrl.sv:1731) |
|                |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| rw_cmd_out_fifo/U1              |            |                            |
|                | DW_fifo_s1_sf  | width=2    | rw_cmd_out_fifo/U1 (Ctrl.sv:1731) |
          |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| gte_x_192      | DW_cmp         | width=3    | gte_1215 (Ctrl.sv:1215)    |
|                |                |            | gte_1273 (Ctrl.sv:1273)    |
| eq_x_193       | DW_cmp         | width=3    | eq_1354 (Ctrl.sv:1354)     |
|                |                |            | eq_1379 (Ctrl.sv:1379)     |
|                |                |            | eq_1622 (Ctrl.sv:1622)     |
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
| sub_x_102      | DW01_dec       | width=10   | sub_1321 (Ctrl.sv:1321)    |
|                |                |            | sub_1322 (Ctrl.sv:1322)    |
|                |                |            | sub_1324 (Ctrl.sv:1324)    |
|                |                |            | sub_1326 (Ctrl.sv:1326)    |
| sub_x_26       | DW01_dec       | width=5    | sub_615 (Ctrl.sv:615)      |
|                |                |            | sub_616 (Ctrl.sv:616)      |
|                |                |            | sub_617 (Ctrl.sv:617)      |
| sub_x_23       | DW01_dec       | width=3    | sub_597 (Ctrl.sv:597)      |
|                |                |            | sub_598 (Ctrl.sv:598)      |
| sub_x_20       | DW01_dec       | width=2    | sub_585 (Ctrl.sv:585)      |
|                |                |            | sub_586 (Ctrl.sv:586)      |
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
