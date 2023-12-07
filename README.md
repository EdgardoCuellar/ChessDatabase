# Chess PostgreSQL Extension

## Overview
This PostgreSQL extension provides functionalities for storing and retrieving chess games in a PostgreSQL database. It uses Portable Game Notation (PGN) for recording full games, Standard Algebraic Notation (SAN) for moves, and Forsyth–Edwards Notation (FEN) for board states.

## Features
- Store and retrieve complete chess games in PGN format.
- Extract board state at any point in a game using SAN and FEN notations.
- Perform various chess-related queries and analyses directly within PostgreSQL.

## Prerequisites
- PostgreSQL (version 16.0 or above)
- Python (version 3.11)
- Python `chess` library

## Installation

### Installing Postgresql

For installation check the official website with instructions : https://www.postgresql.org/download/linux/ubuntu/

### Using the Installation Shell Script
A shell script is provided to automate the installation of the necessary dependencies and the extension itself. Follow these steps to use the script:

1. **Use the Shell Script:**
   - Use `runall.sh` script from the repository.

2. **Make the Script Executable:**
   - Run the following command to make the script executable:
     ```bash
     chmod +x runall.sh
     ```

3. **Run the Script:**
   - Execute the script:
     ```bash
     ./runall.sh
     ```

   This script will install Python 3.11, the Python chess library, and build and install the extension.

### Manually Installing (Alternative Method)

If you prefer to install the dependencies and the extension manually, follow these steps:

#### Step 1: Install Python and the Python Chess Library
Ensure Python 3.11 and pip are installed and then install the Python chess library:

```bash
# Install Python 3.11 and pip
sudo apt-get install python3.11 python3-pip

# Install the chess library for Python
pip install chess
```


#### Step 2: Building and Installing the Extension
Navigate to the directory containing the extension's source code and run the following commands:

```bash
# Navigate to the extension source directory
cd path/to/your/extension

# Build the extension
make

# Install the extension
sudo make install
```

### Usage
Once the extension is installed (either via the script or manually), you can start storing and querying chess games in your PostgreSQL database using the provided functionalities.

You can open the file located at /Testing/Sql with all the queries to test the extension.