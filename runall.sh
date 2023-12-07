#!/bin/bash

# Script to install dependencies and build a PostgreSQL extension

# Define the path to your extension source code
EXTENSION_DIR="./Src"

echo "Starting installation of dependencies..."

# Update package list
sudo apt-get update

# Upgrade system
sudo apt-get upgrade -y

# Install Python 3 and pip
sudo apt-get install -y python3 python3-pip

# Install the chess library for Python
pip install chess

echo "Dependencies installed."

echo "Building and installing the PostgreSQL extension..."

# Navigate to the extension directory
cd "$EXTENSION_DIR"

# Clean previous builds
make clean

# Build the extension
make

# Install the extension
sudo make install

echo "Extension build and installation completed."
