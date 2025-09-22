-> define the cache model using cache.cfg
-> run the "cacti" binary <./cacti -infile cache.cfg>

### To recreate the work
1. make
2. ./cacti -infile Used_config_For_Thesis/tsv_1024_Page16384_Stack4_Size4_Bank1024_UCA1_Ndbl_1024.cfg (Constraints,Energy will be generated based on the configuration)

CACTI also provides a command line interface similar to earlier versions. The command line interface can be used as

./cacti  cache_size line_size associativity rw_ports excl_read_ports excl_write_ports
  single_ended_read_ports search_ports banks tech_node output_width specific_tag tag_width
  access_mode cache main_mem obj_func_delay obj_func_dynamic_power obj_func_leakage_power
  obj_func_cycle_time obj_func_area dev_func_delay dev_func_dynamic_power dev_func_leakage_power
  dev_func_area dev_func_cycle_time ed_ed2_none temp wt data_arr_ram_cell_tech_flavor_in
  data_arr_peri_global_tech_flavor_in tag_arr_ram_cell_tech_flavor_in tag_arr_peri_global_tech_flavor_in
  interconnect_projection_type_in wire_inside_mat_type_in wire_outside_mat_type_in
  REPEATERS_IN_HTREE_SEGMENTS_in VERTICAL_HTREE_WIRES_OVER_THE_ARRAY_in
  BROADCAST_ADDR_DATAIN_OVER_VERTICAL_HTREES_in PAGE_SIZE_BITS_in BURST_LENGTH_in
  INTERNAL_PREFETCH_WIDTH_in force_wiretype wiretype force_config ndwl ndbl nspd ndcm
  ndsam1 ndsam2 ecc

For complete documentation of the tool, please refer
to the following publications and reports.

CACTI-5.3 & 6 reports - Details on Meory/cache organizations and tradeoffs.

Latency/Energy tradeoffs for large caches and NUCA design:
  "Optimizing NUCA Organizations and Wiring Alternatives for Large Caches With CACTI 6.0", that appears in MICRO 2007.

Memory IO design:  CACTI-IO: CACTI With OFF-chip Power-Area-Timing Models,
     MemCAD: An Interconnect Exploratory Tool for Innovative Memories Beyond DDR4
     CACTI-IO Technical Report - http://www.hpl.hp.com/techreports/2013/HPL-2013-79.pdf

3D model:
     CACTI-3DD: Architecture-level modeling for 3D die-stacked DRAM main memory

We are still improving the tool and refining the code. If you
have any comments, questions, or suggestions please write to
us.

Naveen Muralimanohar
naveen.muralimanohar@hpe.com

Ali Shafiee
shafiee@cs.utah.edu

Vaishnav Srinivas
vaishnav.srinivas@gmail.com
