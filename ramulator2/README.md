## Run the project
1. chmod +x 00_setup.tcl, ./00_setup.tcl
2. Create a "build" folder under ramulator2 directory
3. cd build
4. cmake ..
5. make -j8
6. cd scripts
7. python3 latency_verification_pattern.py, this generates the LD ST traces
8. cd ../build
9. ./ramulator2 -f ../Trace_Verification_RTL_C++/testing_latency_verification_Read_Write_Interleaving.yaml , *.yaml is the configuration file to run the whole system

## How to start? 
- [Ramulator2](https://github.com/CMU-SAFARI/ramulator2) is the successor of [Ramulator](https://github.com/CMU-SAFARI/ramulator), for in-depth understanding of how the whole system works, understanding Ramulator2 & Ramulator is key!
- Further documentations and sequence diagrams can be found in the Ramulator2 github website and their papers.
- [Ramulator2 Paper](https://arxiv.org/abs/2308.11030), [Ramulator Paper](https://users.ece.cmu.edu/~omutlu/pub/ramulator_dram_simulator-ieee-cal15.pdf)
- Use the gdb or udb debugger to trace through the hierarchy of the whole complex system, starting from main()
- Within each major block, tick() function is the core function for tracing, it governs how a certain object behaves within each clock cycles.
- Print statement and modify the yaml file or Ramulator2 Constructer to better understand it

## Ramualator2 Lab & Notes
- Finish this [Lab 5: Memory Request Scheduling](https://safari.ethz.ch/architecture/fall2024/doku.php?id=labs) to gain insight about how Ramulator2 works and understand how Scheduling Policy influence the whole DRAM Memory System
- ![alt text](image.png)
- Notes of [Lab3](https://www.notion.so/Lab3-Ramulator2-Notes-10d7a87918dd8028a0e7d706ae32cc72)

## Bank Level Controller & DRAM Bank
- Simple bank level controller with unified model is created in C++ as a cycle accurate model for the project.
- The DRAM Bank is modified using the DDR4 timing constraint and interfaces provided within the Ramulator2, the timing Constraints are obtained from [CACTI-3DD](https://ieeexplore.ieee.org/document/6176428),within the whole folder structure as cacti, using the Architectural 3D-DRAM simulator modeling TSV, DRAM Banks and DRAM Organisaztion Developed by HP lab.
- Refresh Period refered to Micron HBM datasheets.

## Global Controller
- Global Controller is modeled with read-order queue to ensure the correct ordering of the returned data to prevent Out of order issues. Thus a reorder queue is implemented to check for the correct ordering of the returned requests.

## Power Model
- Power model is derived from CACTI-3DD, the energy requires for each RD,WR,ACT,PRE,REF for each commands. Idle currents & voltages are taken from [VAMPIRE](https://github.com/CMU-SAFARI/VAMPIRE) and [DRAMPower](https://github.com/tukl-msd/DRAMPower)
- To understand how the power model works, please refer to the papers of [VAMPIRE_Paper](https://arxiv.org/abs/1807.05102)

## References
1. [Ramulator2](https://github.com/CMU-SAFARI/ramulator2)
2. [Ramulator](https://github.com/CMU-SAFARI/ramulator)
3. [HBM2E](Micron Technology, Inc., "Integrating and Operating HBM2E Memory," 2021)
4. [VAMPIRE](https://github.com/CMU-SAFARI/VAMPIRE)
5. [DRAMPower](https://github.com/tukl-msd/DRAMPower)

