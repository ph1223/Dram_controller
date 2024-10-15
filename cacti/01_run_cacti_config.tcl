#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <config_file_name>"
    exit 1
fi

# Extract the base name of the config file (without extension)
config_file="$1"
base_name=$(basename "$config_file" .cfg)

# Create the outputLog directory if it doesn't exist
mkdir -p ./outputLog

# Run the cacti command and redirect the output to the log file
./cacti -infile "./3DDRAM_configs/$config_file" > "./outputLog/${base_name}_cfg.log"

echo "Execution completed. Log file: ./outputLog/${base_name}_cfg.log"