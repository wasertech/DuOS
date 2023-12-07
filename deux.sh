#!/bin/bash
# Deux (Operating Systems): Linux on Android
# This script is used to run a Linux distribution in a chroot environment on any Android device.

# Check if pRoot and pRoot-distro are installed
if ! command -v proot >/dev/null 2>&1 || ! command -v proot-distro >/dev/null 2>&1; then
    echo "pRoot and pRoot-distro are not installed."
    return 1
fi

# Set aliases
alias which='$(command -v)'
alias login='proot-distro login'
alias fetch='fastfetch'

# Clear the terminal
clear

# Print user and system information
uname -a

echo -n "You are $(whoami) on $(hostname)."

# Make sure the user is in the right directory
cd $HOME

# Check if the chroot environment exists
if [ ! -d $DUO_DISTRO ]; then
    echo "The chroot environment does not exist."
    return 1
fi

function duo() {
    echo "Welcome on Duo!"

    # Login to the chroot environment
    login $DUO_DISTRO

    # Print system information using fastfetch if available
    if command -v fastfetch >/dev/null 2>&1; then
        fetch
    else
        echo "Couldn't fetch system information."
    fi

    # log in as user
    su $DUO_USER

    echo "Welcome to $DUO_DISTRO!"
    echo "Type 'exit' twice to exit the chroot environment."
}

echo "Deux is ready to use."
echo "Type 'duo' to start the chroot environment."
