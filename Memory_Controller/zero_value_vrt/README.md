# Zero Value ZRT
## Key Ideas & Comments
- The key idea is to increase the number of 0 in the whole DRAM data distribution by reencoding the data due to preknown weights distribution to save energy during DRAM TSV transfer and increase the error resilience due to DRAM VRT(Variable Retention Time) error, this experiment is not yet analyzed thoroughly.

- Due to the data similiarity of local weights dataset, data can usually be re-encoded or compressed into better data format with more 0 or even space reduction to ultilize the DRAM capacity.

- int4,fp16,int8 these data format usually has similiar data format thus enable the chance of re-encoding them into better format for energy reduction and system performance improvement by further using data compression like RLE or Canonical Huffman Coding. 

- Pre-encoding weights before run-time can also save energy.

## Challenges
- The challenges lies in the DRAM energy model analysis , data compression address remapping and the hardware overhead cost analysis.

## References

- [Data Compression & Data Re-encoding](https://drive.google.com/drive/folders/1MtegBwd1npmS1kp4JLacp7ie62jid3z-)
