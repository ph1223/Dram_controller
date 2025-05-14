 
****************************************
Report : resources
Design : DRAM_Controller
Version: U-2022.12
Date   : Thu May 15 02:36:37 2025
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


Resource Report for Ungrouped Hierarchy isu_fifo/U1/U2 in file
        ./DW_ram_r_w_s_dff__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| lt_x_1         | DW_cmp         | width=3    | lt_124                     |
| lt_x_3         | DW_cmp         | width=3    | lt_147                     |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1/U1/U1 in file
        ./DWsc_fifoctl_s1_df__rtl.v.e
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| add_x_1        | DW01_inc       | width=4    | add_208                    |
| add_x_3        | DW01_inc       | width=4    | add_213                    |
| sub_x_4        | DW01_dec       | width=3    | sub_226                    |
| add_x_5        | DW01_inc       | width=3    | add_228                    |
| gte_x_10       | DW_cmp         | width=3    | gte_241                    |
| lte_x_12       | DW_cmp         | width=3    | lte_249                    |
| gte_x_13       | DW_cmp         | width=3    | gte_254                    |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DWsc_fifoctl_s1_df | depth=5 | U1                        |
|                |                | err_mode=2 |                            |
|                |                | addr_width=3 |                          |
|                |                | gang_all_status=1 |                     |
=============================================================================


Resource Report for Ungrouped Hierarchy isu_fifo/U1
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| U1             | DW_fifoctl_s1_sf | depth=5  | U1                         |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| U2             | DW_ram_r_w_s_dff | data_width=24 | U2                    |
|                |                | depth=5    |                            |
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
| lte_x_57       | DW_cmp         | width=3    | lte_959 (Ctrl.sv:959)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1332 (Ctrl.sv:1332)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1332_2 (Ctrl.sv:1332)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1332_3 (Ctrl.sv:1332)  |
| gte_x_120      | DW_cmp         | width=10   | gte_1479 (Ctrl.sv:1479)    |
| gt_x_122       | DW_cmp         | width=3    | gt_1490 (Ctrl.sv:1490)     |
| gt_x_123       | DW_cmp         | width=3    | gt_1490_2 (Ctrl.sv:1490)   |
| gt_x_124       | DW_cmp         | width=3    | gt_1493 (Ctrl.sv:1493)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1493_2 (Ctrl.sv:1493)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1496 (Ctrl.sv:1496)     |
| gt_x_127       | DW_cmp         | width=3    | gt_1496_2 (Ctrl.sv:1496)   |
| add_x_138      | DW01_inc       | width=3    | add_1564 (Ctrl.sv:1564)    |
| add_x_139      | DW01_inc       | width=3    | add_1565 (Ctrl.sv:1565)    |
| add_x_140      | DW01_inc       | width=3    | add_1566 (Ctrl.sv:1566)    |
| add_x_144      | DW01_inc       | width=3    | add_1573 (Ctrl.sv:1573)    |
| isu_fifo/U1    | DW_fifo_s1_sf  | width=24   | isu_fifo/U1 (Ctrl.sv:1687) |
|                |                | depth=5    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| rw_cmd_out_fifo/U1              |            |                            |
|                | DW_fifo_s1_sf  | width=2    | rw_cmd_out_fifo/U1 (Ctrl.sv:1687) |
          |                | depth=4    |                            |
|                |                | ae_level=1 |                            |
|                |                | af_level=1 |                            |
|                |                | err_mode=2 |                            |
|                |                | rst_mode=0 |                            |
| gte_x_169      | DW_cmp         | width=3    | gte_1201 (Ctrl.sv:1201)    |
|                |                |            | gte_1259 (Ctrl.sv:1259)    |
| eq_x_170       | DW_cmp         | width=3    | eq_1336 (Ctrl.sv:1336)     |
|                |                |            | eq_1358 (Ctrl.sv:1358)     |
|                |                |            | eq_1573 (Ctrl.sv:1573)     |
| eq_x_171       | DW_cmp         | width=3    | tP_ba0/eq_104 (tP_counter.sv:104) |
          |                |            | tP_ba0/eq_105 (tP_counter.sv:105) |
          |                |            | tP_ba0/eq_106 (tP_counter.sv:106) |
          |                |            | tP_ba0/eq_67 (tP_counter.sv:67) |
            |                |            | tP_ba0/eq_69 (tP_counter.sv:69) |
            |                |            | tP_ba0/eq_77 (tP_counter.sv:77) |
            |                |            | tP_ba0/eq_85 (tP_counter.sv:85) |
            |                |            | tP_ba0/eq_99 (tP_counter.sv:99) |
| sub_x_156      | DW01_dec       | width=5    | tP_ba0/sub_67 (tP_counter.sv:67) |
           |                |            | tP_ba0/sub_75 (tP_counter.sv:75) |
           |                |            | tP_ba0/sub_83 (tP_counter.sv:83) |
           |                |            | tP_ba0/sub_85 (tP_counter.sv:85) |
           |                |            | tP_ba0/sub_86 (tP_counter.sv:86) |
| sub_x_102      | DW01_dec       | width=10   | sub_1307 (Ctrl.sv:1307)    |
|                |                |            | sub_1308 (Ctrl.sv:1308)    |
|                |                |            | sub_1310 (Ctrl.sv:1310)    |
|                |                |            | sub_1312 (Ctrl.sv:1312)    |
| sub_x_26       | DW01_dec       | width=5    | sub_601 (Ctrl.sv:601)      |
|                |                |            | sub_602 (Ctrl.sv:602)      |
|                |                |            | sub_603 (Ctrl.sv:603)      |
| sub_x_23       | DW01_dec       | width=3    | sub_583 (Ctrl.sv:583)      |
|                |                |            | sub_584 (Ctrl.sv:584)      |
| sub_x_20       | DW01_dec       | width=2    | sub_571 (Ctrl.sv:571)      |
|                |                |            | sub_572 (Ctrl.sv:572)      |
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
| lt_x_1             | DW_cmp           | apparch (area)     |                |
| lt_x_3             | DW_cmp           | apparch (area)     |                |
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
| gte_x_120          | DW_cmp           | apparch (area)     |                |
| gt_x_122           | DW_cmp           | apparch (area)     |                |
| gt_x_123           | DW_cmp           | apparch (area)     |                |
| gt_x_124           | DW_cmp           | apparch (area)     |                |
| gt_x_125           | DW_cmp           | apparch (area)     |                |
| gt_x_126           | DW_cmp           | apparch (area)     |                |
| gt_x_127           | DW_cmp           | apparch (area)     |                |
| add_x_138          | DW01_inc         | apparch (area)     |                |
| add_x_139          | DW01_inc         | apparch (area)     |                |
| add_x_140          | DW01_inc         | apparch (area)     |                |
| add_x_144          | DW01_inc         | apparch (area)     |                |
| isu_fifo/U1        | DW_fifo_s1_sf    | rtl                |                |
| rw_cmd_out_fifo/U1 | DW_fifo_s1_sf    | rtl                |                |
| gte_x_169          | DW_cmp           | apparch (area)     |                |
| eq_x_170           | DW_cmp           | apparch (area)     |                |
| eq_x_171           | DW_cmp           | apparch (area)     |                |
| sub_x_156          | DW01_dec         | apparch (area)     |                |
| sub_x_102          | DW01_dec         | apparch (area)     |                |
| sub_x_26           | DW01_dec         | apparch (area)     |                |
| sub_x_23           | DW01_dec         | apparch (area)     |                |
| sub_x_20           | DW01_dec         | apparch (area)     |                |
===============================================================================

1
