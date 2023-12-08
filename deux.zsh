#!/bin/bash
# Deux (Operating Systems): Linux on Android
# This script is used to run a Linux distribution in a chroot environment on any Android device.

# Print user and system information
uname -a

echo "You are $USER on ${HOST:-'localhost'}."

# clear

# Print user and system information

fastfetch || neofetch || screenfetch || echo "Couldn't fetch system information."
echo && echo # just for spacing

echo "Welcome to DuOS: Linux on Android."

echo "Type 'exit':"
echo " - once to exit the chroot environment."
echo " - twice to exit Termux."
