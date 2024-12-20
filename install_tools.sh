#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install clangd
echo "Installing clangd..."
sudo apt install clangd -y

# Install cmake
echo "Installing cmake..."
sudo apt install cmake -y

# Install make
echo "Installing make..."
sudo apt install make -y

# Install git
echo "Installing git..."
sudo apt install git -y

# Install gdb
echo "Installing gdb..."
sudo apt install gdb -y

# Install python3 and pip3
echo "Installing Python 3 and pip3..."
sudo apt install python3 python3-pip -y

# Verify installations
echo "Verifying installations..."
clangd --version
cmake --version
make --version
git --version
gdb --version
python3 --version
pip3 --version

echo "All tools installed successfully!"
