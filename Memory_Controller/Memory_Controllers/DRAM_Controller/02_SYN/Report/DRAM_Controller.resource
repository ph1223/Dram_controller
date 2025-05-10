 
****************************************
Report : resources
Design : DRAM_Controller
Version: U-2022.12
Date   : Sat May 10 22:30:18 2025
****************************************


Resource Report for Ungrouped Hierarchy BackendController_3/Rank0 in file
        ../01_RTL/bank_FSM.sv
=============================================================================
| Cell           | Module         | Parameters | Contained Operations       |
=============================================================================
| eq_x_8         | DW_cmp         | width=16   | eq_169 (bank_FSM.sv:169)   |
| sub_x_14       | DW01_dec       | width=7    | ba0/sub_266 (bank_FSM.sv:266) |
| add_x_16       | DW01_inc       | width=12   | ba0/add_288 (bank_FSM.sv:288) |
| lte_x_57       | DW_cmp         | width=3    | lte_990 (Ctrl.sv:990)      |
| gte_x_105      | DW_cmp         | width=3    | gte_1362 (Ctrl.sv:1362)    |
| gte_x_106      | DW_cmp         | width=3    | gte_1362_2 (Ctrl.sv:1362)  |
| gte_x_107      | DW_cmp         | width=3    | gte_1362_3 (Ctrl.sv:1362)  |
| gte_x_120      | DW_cmp         | width=10   | gte_1509 (Ctrl.sv:1509)    |
| gt_x_122       | DW_cmp         | width=3    | gt_1520 (Ctrl.sv:1520)     |
| gt_x_123       | DW_cmp         | width=3    | gt_1520_2 (Ctrl.sv:1520)   |
| gt_x_124       | DW_cmp         | width=3    | gt_1523 (Ctrl.sv:1523)     |
| gt_x_125       | DW_cmp         | width=3    | gt_1523_2 (Ctrl.sv:1523)   |
| gt_x_126       | DW_cmp         | width=3    | gt_1526 (Ctrl.sv:1526)     |
| gt_x_127       | DW_cmp         | width=3    | gt_1526_2 (Ctrl.sv:1526)   |
| add_x_138      | DW01_inc       | width=3    | add_1594 (Ctrl.sv:1594)    |
| add_x_139      | DW01_inc       | width=3    | add_1595 (Ctrl.sv:1595)    |
| add_x_140      | DW01_inc       | width=3    | add_1596 (Ctrl.sv:1596)    |
| add_x_144      | DW01_inc       | width=3    | add_1603 (Ctrl.sv:1603)    |
| sub_x_169      | DW01_sub       | width=3    | isu_fifo/sub_1641 (Ctrl.sv:1641) |
| eq_x_170       | DW_cmp         | width=3    | isu_fifo/eq_1642 (Ctrl.sv:1642) |
| eq_x_171       | DW_cmp         | width=3    | isu_fifo/eq_1643 (Ctrl.sv:1643) |
| add_x_172      | DW01_inc       | width=3    | isu_fifo/add_1662 (Ctrl.sv:1662) |
| add_x_174      | DW01_inc       | width=3    | isu_fifo/add_1677 (Ctrl.sv:1677) |
| sub_x_175      | DW01_sub       | width=3    | rw_cmd_out_fifo/sub_1641 (Ctrl.sv:1641) |
| eq_x_176       | DW_cmp         | width=3    | rw_cmd_out_fifo/eq_1642 (Ctrl.sv:1642) |
| eq_x_177       | DW_cmp         | width=3    | rw_cmd_out_fifo/eq_1643 (Ctrl.sv:1643) |
| add_x_178      | DW01_inc       | width=3    | rw_cmd_out_fifo/add_1662 (Ctrl.sv:1662) |
| add_x_180      | DW01_inc       | width=3    | rw_cmd_out_fifo/add_1677 (Ctrl.sv:1677) |
| gte_x_181      | DW_cmp         | width=3    | gte_1231 (Ctrl.sv:1231)    |
|                |                |            | gte_1289 (Ctrl.sv:1289)    |
| eq_x_182       | DW_cmp         | width=3    | eq_1366 (Ctrl.sv:1366)     |
|                |                |            | eq_1388 (Ctrl.sv:1388)     |
|                |                |            | eq_1603 (Ctrl.sv:1603)     |
| eq_x_183       | DW_cmp         | width=3    | tP_ba0/eq_104 (tP_counter.sv:104) |
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
| sub_x_102      | DW01_dec       | width=10   | sub_1337 (Ctrl.sv:1337)    |
|                |                |            | sub_1338 (Ctrl.sv:1338)    |
|                |                |            | sub_1340 (Ctrl.sv:1340)    |
|                |                |            | sub_1342 (Ctrl.sv:1342)    |
| sub_x_26       | DW01_dec       | width=5    | sub_634 (Ctrl.sv:634)      |
|                |                |            | sub_635 (Ctrl.sv:635)      |
|                |                |            | sub_636 (Ctrl.sv:636)      |
| sub_x_23       | DW01_dec       | width=3    | sub_616 (Ctrl.sv:616)      |
|                |                |            | sub_617 (Ctrl.sv:617)      |
| sub_x_20       | DW01_dec       | width=2    | sub_604 (Ctrl.sv:604)      |
|                |                |            | sub_605 (Ctrl.sv:605)      |
=============================================================================


Implementation Report
===============================================================================
|                    |                  | Current            | Set            |
| Cell               | Module           | Implementation     | Implementation |
===============================================================================
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
| sub_x_169          | DW01_sub         | apparch (area)     |                |
| eq_x_170           | DW_cmp           | apparch (area)     |                |
| eq_x_171           | DW_cmp           | apparch (area)     |                |
| add_x_172          | DW01_inc         | apparch (area)     |                |
| add_x_174          | DW01_inc         | apparch (area)     |                |
| sub_x_175          | DW01_sub         | apparch (area)     |                |
| eq_x_176           | DW_cmp           | apparch (area)     |                |
| eq_x_177           | DW_cmp           | apparch (area)     |                |
| add_x_178          | DW01_inc         | apparch (area)     |                |
| add_x_180          | DW01_inc         | apparch (area)     |                |
| gte_x_181          | DW_cmp           | apparch (area)     |                |
| eq_x_182           | DW_cmp           | apparch (area)     |                |
| eq_x_183           | DW_cmp           | apparch (area)     |                |
| sub_x_156          | DW01_dec         | apparch (area)     |                |
| sub_x_102          | DW01_dec         | apparch (area)     |                |
| sub_x_26           | DW01_dec         | apparch (area)     |                |
| sub_x_23           | DW01_dec         | apparch (area)     |                |
| sub_x_20           | DW01_dec         | apparch (area)     |                |
===============================================================================

1
