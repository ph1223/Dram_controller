# ZERO_MAPPING

- In order to ultilize multi-rate refresh, more zeroes need to be created, to do so tries to create am optimal mapping scheme toward a data. Gather their distribution and remapping the values

- Due to the VRT effect on DRAM, cell tends to jump between different retention time. However, if the cell is originally stored with 0, having a worsen retention time is not a problem. Thus in order to increase the error resilience of the DRAM, one can remap the values within DRAM to create more zeroes.


## Algorithm
- Given a random size of dataset in int8 representations,values ranging from 0~255, find the optimal mapping strategy that increase the maximum number of difference of with and without using the mapping strategy.

### Metric
- The number of differences of 1 should be maximized

# Solution

## Naive
- Assign 0s according to the ranking scheme

## According to differences assign the bits
- Assign 0s according to differences, use the optimization algorithm to find the best solution
