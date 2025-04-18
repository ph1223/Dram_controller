# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/Dram_controller/ramulator2

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/Dram_controller/ramulator2/build

# Include any dependencies generated for this target.
include CMakeFiles/ramulator.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/ramulator.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/ramulator.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ramulator.dir/flags.make

# Object files for target ramulator
ramulator_OBJECTS =

# External object files for target ramulator
ramulator_EXTERNAL_OBJECTS = \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/factory.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/logging.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/utils.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/config.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/stats.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/base/CMakeFiles/ramulator-base.dir/request.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/test/CMakeFiles/ramulator-test.dir/test_impl.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/loadstore_trace.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/readwrite_trace.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/loadstore_stall_trace.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/multi_loadstore_stall.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/simpleO3.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/core.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/llc.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/trace.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhO3.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhcore.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhllc.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/frontend/CMakeFiles/ramulator-frontend.dir/impl/external_wrapper/gem5_frontend.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/translation/CMakeFiles/ramulator-translation.dir/impl/no_translation.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/translation/CMakeFiles/ramulator-translation.dir/impl/random_translation.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/bh_DRAM_system.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/dummy_memory_system.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/generic_DRAM_system.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/addr_mapper/CMakeFiles/ramulator-addrmapper.dir/impl/linear_mappers.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/addr_mapper/CMakeFiles/ramulator-addrmapper.dir/impl/rit.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR3.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4-VRR.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4-RVRR.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5-VRR.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5-RVRR.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/LPDDR5.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM2.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM3.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/bh_dram_controller.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/dummy_controller.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/generic_dram_controller.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/prac_dram_controller.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/bank_level_dram_controller.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/bh_scheduler.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/blocking_scheduler.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/generic_scheduler.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/bliss_scheduler.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/prac_scheduler.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/refresh/all_bank_refresh.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/rowpolicy/basic_rowpolicies.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/trace_recorder.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/cmd_counter.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/para.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/graphene.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/oracle_rh.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/twice.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/hydra.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/rrs.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/aqua.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/rfm_manager.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/blockhammer/blockhammer.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/device_config/device_config.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/bliss/bliss.cpp.o" \
"/home/Dram_controller/ramulator2/build/src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/prac/prac.cpp.o"

/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/factory.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/logging.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/utils.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/config.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/stats.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/base/CMakeFiles/ramulator-base.dir/request.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/test/CMakeFiles/ramulator-test.dir/test_impl.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/loadstore_trace.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/readwrite_trace.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/loadstore_stall_trace.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/memory_trace/multi_loadstore_stall.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/simpleO3.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/core.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/llc.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/simpleO3/trace.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhO3.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhcore.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/processor/bhO3/bhllc.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/frontend/CMakeFiles/ramulator-frontend.dir/impl/external_wrapper/gem5_frontend.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/translation/CMakeFiles/ramulator-translation.dir/impl/no_translation.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/translation/CMakeFiles/ramulator-translation.dir/impl/random_translation.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/bh_DRAM_system.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/dummy_memory_system.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/memory_system/CMakeFiles/ramulator-memorysystem.dir/impl/generic_DRAM_system.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/addr_mapper/CMakeFiles/ramulator-addrmapper.dir/impl/linear_mappers.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/addr_mapper/CMakeFiles/ramulator-addrmapper.dir/impl/rit.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR3.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4-VRR.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR4-RVRR.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5-VRR.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/DDR5-RVRR.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/LPDDR5.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM2.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram/CMakeFiles/ramulator-dram.dir/impl/HBM3.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/bh_dram_controller.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/dummy_controller.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/generic_dram_controller.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/prac_dram_controller.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/bank_level_dram_controller.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/bh_scheduler.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/blocking_scheduler.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/generic_scheduler.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/bliss_scheduler.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/scheduler/prac_scheduler.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/refresh/all_bank_refresh.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/rowpolicy/basic_rowpolicies.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/trace_recorder.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/cmd_counter.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/para.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/graphene.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/oracle_rh.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/twice.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/hydra.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/rrs.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/aqua.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/rfm_manager.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/blockhammer/blockhammer.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/device_config/device_config.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/bliss/bliss.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: src/dram_controller/CMakeFiles/ramulator-controller.dir/impl/plugin/prac/prac.cpp.o
/home/Dram_controller/ramulator2/libramulator.so: CMakeFiles/ramulator.dir/build.make
/home/Dram_controller/ramulator2/libramulator.so: _deps/yaml-cpp-build/libyaml-cppd.a
/home/Dram_controller/ramulator2/libramulator.so: _deps/spdlog-build/libspdlogd.a
/home/Dram_controller/ramulator2/libramulator.so: CMakeFiles/ramulator.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/Dram_controller/ramulator2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Linking CXX shared library /home/Dram_controller/ramulator2/libramulator.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ramulator.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ramulator.dir/build: /home/Dram_controller/ramulator2/libramulator.so
.PHONY : CMakeFiles/ramulator.dir/build

CMakeFiles/ramulator.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ramulator.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ramulator.dir/clean

CMakeFiles/ramulator.dir/depend:
	cd /home/Dram_controller/ramulator2/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/Dram_controller/ramulator2 /home/Dram_controller/ramulator2 /home/Dram_controller/ramulator2/build /home/Dram_controller/ramulator2/build /home/Dram_controller/ramulator2/build/CMakeFiles/ramulator.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/ramulator.dir/depend

