#!/bin/bash
# Deux (Operating Systems): Linux on Android
# This script is used to run a Linux distribution in a chroot environment on any Android device.

set -e

# Check if pRoot and pRoot-distro are installed
if ! command -v proot >/dev/null 2>&1 || ! command -v proot-distro >/dev/null 2>&1; then
    echo "pRoot and pRoot-distro are not installed."
    exit 1
fi

# Set aliases
alias fetch='fastfetch'

# Print user and system information
uname -a

echo "You are $USER on ${HOST:-'localhost'}."

clear

# Print user and system information

fetch

echo "Type 'exit' twice to exit."
