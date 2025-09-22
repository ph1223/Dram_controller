# Write Updated Partial Refresh

- Key idea: Some rows are not written to in the DRAM, so we can skip their refreshes Due to Sequential Access property of the workload uses segment pointers to track the last row written to in each segment ,the segment pointer is updated when a write command is issued
,the segment pointer is used to determine if a refresh is needed,if the segment pointer is less than the refresh row tracker for the corresponding segment, we can skip the refresh
- If the segment is not needed anymore, the segment pointer can simply be reseted by the controller according to frone-end T-Core information.

- I got this idea from some old state-of-art paper and some row-pointer based region refresh from the self-refresh scheme
- SRA[1] is the first paper to propose selective refresh architecture in DRAM
- ESKIMO[2] uses semantic information to skips unused rows which used bits to track the used space condition of the DRAM row space using condition this consumes huge area.
- PASR(Partial Array Self-refresh)[3] is a set single pointer based method used in self-refresh mode to skips ununsed regions.
- PAAR(Partial Array Auto-Refresh) is another single pointer based method used in RTC(Refresh-Triggered Computation[4] Paper) to skips unused region.
- WUPR is the generalization of PAAR + PASR + SRA + ESKIMO
- WUPR works because in AI Acclerator trace, the workload behaviour is usually sequential and can be known in adavance, compared to random access pattern and unexpected user behaviour of the CPU & GPU trace.

# Algorithm

![alt text](image.png)
![alt text](image-1.png)

# References
- [1] Ohsawa, T., Kai, K., & Murakami, K. (1998). Optimizing the DRAM refresh count for merged DRAM/logic LSIs. In Proceedings of the 1998 International Symposium on Low Power Electronics and Design (ISLPED ’98)
- [2] C. Isen and L. K. John, “ESKIMO: Energy savings using semantic knowledge of inconsequential memory occupancy for DRAM subsystem,” in Proc. 42nd Annual IEEE/ACM International Symposium on Microarchitecture (MICRO-42), New York, NY, USA, Dec. 2009
- [3] JEDEC Solid State Technology Association, “JESD209-5C: Low Power Double Data Rate (LPDDR) 5/5X Standard,” JEDEC, June 1, 2023.
- [4] Jafri, S. M. A. H., Hassan, H., Hemani, A., & Mutlu, O. (2020). Refresh Triggered Computation: Improving the Energy Efficiency of Convolutional Neural Network Accelerators. ACM Transactions on Architecture and Code Optimization