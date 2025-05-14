# Dependencies
- clone this folder to a linux environment, I suggest using WSL(Window Subsystem For Linux)

- chmod +x install_tools.sh, this installs the following tools and dependencies clangd, cmake, make, gnu, gdb, python3

# Folder structures
- Memory Controller -> Memory_Controllers has the RTL design of the project Bank Level Controller, DRAM_Controller is the final version with Global Controller and baackend Controller connected to form a workable DRAM system for the interaction with the frontend Core.
- cacti, the 3D-DRAM Modeling tool for timing constraints and Power extraction of the target 3D-DRAM
- Ramulator2, Architectural Simulator for running the trace to evaluate the performance influence after modifying the Components within the DRAM system 

