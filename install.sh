#!/bin/bash

# Define the installation directories
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install FSL 
#echo "FSL Installation"
#python3 fslinstaller.py

#echo "FSL installation done"

#echo 'export PATH="'${INSTALL_DIR}'/fsl/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="'${INSTALL_DIR}'/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

#echo $INSTALL_DIR
echo "tumorQuant installed successfully."
echo ""
echo "Run \"tumorQuant -h\" to check package information"

echo "Open a new terminal, or log out and log back in, for the environment
changes to take effect."


