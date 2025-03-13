import os
import yaml  # YAML parsing provided with the PyYAML package

baseline_config_file = "./example_config.yaml"
nRCD_list = [10, 15, 20, 25]

base_config = None
with open(baseline_config_file, 'r') as f:
  base_config = yaml.safe_load(f)

for nRCD in nRCD_list:
  config["MemorySystem"]["DRAM"]["timing"]["nRCD"] = nRCD
  cmds = ["./ramulator2", str(config)]
  # Run the command with e.g., os.system(), subprocess.run(), ...