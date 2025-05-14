# Dependencies
- clone this folder to a linux environment, I suggest using WSL(Window Subsystem For Linux)

- chmod +x install_tools.sh, this installs the following tools and dependencies clangd, cmake, make, gnu, gdb, python3

# Folder structures
- Memory Controller -> Memory_Controllers has the RTL design of the project Bank Level Controller
- cacti, the 3D-DRAM Modeling tool for timing constraints and Power extraction of the target 3D-DRAM
- Ramulator2, Architectural Simulator for running the trace to evaluate the performance influence after modifying the Components within the DRAM system 

├── Memory_Controller
│   ├── Memory_Controllers
│   ├── References_&_Materials
│   ├── Thesis_Memory_Controller
│   ├── trace_analysis
│   └── zero_value_vrt
├── README.md
├── cacti
│   ├── 01_generate_cfgs.py
│   ├── 02_run_stats.py
│   ├── 03_extract_info.py
│   ├── 04_copy_csv_to_local.sh
│   ├── 05_run_all.tcl
│   ├── 09_clean_up.tcl
│   ├── 3DDRAM_example_configs
│   ├── README
│   ├── TSV.cc
│   ├── TSV.h
│   ├── Ucache.cc
│   ├── Ucache.h
│   ├── arbiter.cc
│   ├── arbiter.h
│   ├── area.cc
│   ├── area.h
│   ├── bank.cc
│   ├── bank.h
│   ├── basic_circuit.cc
│   ├── basic_circuit.h
│   ├── cache.cfg
│   ├── cacti
│   ├── cacti.i
│   ├── cacti.mk
│   ├── cacti_interface.cc
│   ├── cacti_interface.h
│   ├── component.cc
│   ├── component.h
│   ├── const.h
│   ├── contention.dat
│   ├── crossbar.cc
│   ├── crossbar.h
│   ├── ddr3.cfg
│   ├── decoder.cc
│   ├── decoder.h
│   ├── dram.cfg
│   ├── extio.cc
│   ├── extio.h
│   ├── extio_technology.cc
│   ├── extio_technology.h
│   ├── extract_info.py
│   ├── extracted_info.csv
│   ├── htree2.cc
│   ├── htree2.h
│   ├── install_dependencies.sh
│   ├── io.cc
│   ├── io.h
│   ├── lpddr.cfg
│   ├── main.cc
│   ├── makefile
│   ├── mat.cc
│   ├── mat.h
│   ├── memcad.cc
│   ├── memcad.h
│   ├── memcad_parameters.cc
│   ├── memcad_parameters.h
│   ├── memorybus.cc
│   ├── memorybus.h
│   ├── nuca.cc
│   ├── nuca.h
│   ├── obj_dbg
│   ├── outputLog
│   ├── parameter.cc
│   ├── parameter.h
│   ├── powergating.cc
│   ├── powergating.h
│   ├── regression.test
│   ├── router.cc
│   ├── router.h
│   ├── run_config.py
│   ├── sample_config_files
│   ├── scripts_design_space_exploration
│   ├── subarray.cc
│   ├── subarray.h
│   ├── tech_params
│   ├── technology.cc
│   ├── uca.cc
│   ├── uca.h
│   ├── version_cacti.h
│   ├── wire.cc
│   └── wire.h
├── install_tools.sh
├── ramulator2
│   ├── 00_setup.tcl
│   ├── 01_trace_to_vcd.py
│   ├── 02_copy_vcd_to_local_MC.tcl
│   ├── 09_clean_up.tcl
│   ├── CMakeLists.txt
│   ├── Design_Space_exploration
│   ├── LICENSE
│   ├── README.md
│   ├── Trace_Verification_RTL_C++
│   ├── config_files
│   ├── debug
│   ├── example_traces
│   ├── ext
│   ├── extracted_info.csv
│   ├── image.png
│   ├── keep.log
│   ├── output.vcd
│   ├── perf_comparison
│   ├── resources
│   ├── rh_study
│   ├── scripts
│   ├── src
│   ├── trace.v
│   └── verilog_verification
└── visualize_csv.py

