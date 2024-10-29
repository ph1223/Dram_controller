import os
import subprocess

def execute_cacti(cfg_files, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    for cfg_file in cfg_files:
        output_file = os.path.join(output_dir, os.path.basename(cfg_file).replace('.cfg', '.log'))
        with open(output_file, 'w') as outfile:
            subprocess.run(['./cacti', '-infile', cfg_file], stdout=outfile, stderr=subprocess.STDOUT)

if __name__ == "__main__":
    # Example usage
    cfg_output_dir = 'python_script_testing/3DDRAM_Design_Exploration/Configs'
    log_output_dir = 'python_script_testing/3DDRAM_Design_Exploration/Logs'

    # List all .cfg files in the cfg_output_dir
    cfg_files = [os.path.join(cfg_output_dir, f) for f in os.listdir(cfg_output_dir) if f.endswith('.cfg')]

    execute_cacti(cfg_files, log_output_dir)