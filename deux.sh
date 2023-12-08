#!/bin/bash
# Deux (Operating Systems): Linux on Android
# This script is used to run a Linux distribution in a chroot environment on any Android device.

# set -e

# Check if pRoot and pRoot-distro are installed
if ! command -v proot >/dev/null 2>&1 || ! command -v proot-distro >/dev/null 2>&1; then
    echo "pRoot and pRoot-distro are not installed."
    exit 1
fi

if [ -z "$DUO_DISTRO" ]; then
    echo "No distribution is set."
    DUO_DISTRO="manjaro"
    echo "export DUO_DISTRO=$DUO_DISTRO" >> ~/.bashrc
fi

# Set aliases
alias which='$(command -v)'
alias login='proot-distro login'
alias fetch='fastfetch'

# Print user and system information
uname -a

echo "You are $(whoami) on $(hostname)."

function init() {
    echo "User creation"
    # create user interactively w/ administrative privileges
    read -p "Enter the username of the user to create: " DUO_USER false
    
    if [ -z "$DUO_USER" ]; then
        echo "Please enter a username."
        return 1
    fi

    echo "export DUO_USER=$DUO_USER" >> ~/.bashrc

    login $DUO_DISTRO -- pacman -Syyu
    login $DUO_DISTRO -- pacman -S base-devel git neovim fastfetch zsh

    login $DUO_DISTRO -- groupadd -g 100 users 
    login $DUO_DISTRO -- groupadd -g 10 wheel

    login $DUO_DISTRO -- mkdir -p /etc/default /etc/sudoers.d
    login $DUO_DISTRO -- echo "GROUP=users" >> /etc/default/groupadd
    login $DUO_DISTRO -- echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/10-installer

    login $DUO_DISTRO -- useradd -m -G wheel -s /bin/zsh $DUO_USER
    login $DUO_DISTRO -- passwd $DUO_USER

    login $DUO_DISTRO -- usermod -aG wheel $DUO_USER
    login $DUO_DISTRO -- usermod -aG sudo $DUO_USER
    
    login $DUO_DISTRO -- echo "export DUO_USER=$DUO_USER" >> ~/.bashrc
    login $DUO_DISTRO -- echo "source deux.sh" >> ~/.bashrc
    login $DUO_DISTRO --user $DUO_USER -- echo "export DUO_USER=$DUO_USER" >> ~/.zshrc
    login $DUO_DISTRO --user $DUO_USER -- echo "source deux.zsh" >> ~/.zshrc
    echo "User created successfully."
}

function duo() {
    echo "Welcome on Duo!"

    # Make sure $DUO_{USER,DISTRO} are set
    if [ -z "$DUO_USER" ]; then
        echo "No user is set."
        init
    fi

    if [ -z "$DUO_DISTRO" ]; then
        echo "No distribution is set."
        DUO_DISTRO="manjaro"
    fi

    # Login to the chroot environment
    login $DUO_DISTRO --user $DUO_USER
}

echo "Running duo..."
echo "Type 'exit' twice to exit."
echo "You can also type 'duo' to login to the chroot environment."

duo
