#!/bin/bash
# Deux (Operating Systems): Linux on Android
# This script is used to run a Linux distribution in a chroot environment on any Android device.

# Check if pRoot and pRoot-distro are installed
if ! command -v proot >/dev/null 2>&1 || ! command -v proot-distro >/dev/null 2>&1; then
    echo "pRoot and pRoot-distro are not installed."
    exit 1
fi

# Set aliases
alias which='$(command -v)'
alias login='proot-distro login'
alias fetch='fastfetch'

# Print user and system information
uname -a

echo -n "You are $(whoami) on $(hostname)."

# Make sure the user is in the right directory
cd $HOME

function duo() {
    echo "Welcome on Duo!"

    # Login to the chroot environment
    login $DUO_DISTRO
}

echo "Deux is ready to use."

echo "Type 'duo' to start the chroot environment."
