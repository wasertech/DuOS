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

# Make sure the user is in the right directory
cd $HOME

RELEASE=$(cat /etc/arch-release || echo "None" )

function init() {
    
    if [ $RELEASE == "Manjaro ARM" ] || [ $RELEASE == "arch" ]; then
            # update system
        $pkglist = "base-devel \
        git \
        neovim \
        fastfetch \
        zsh"
        pacman -Syyu
        pacman -S $pkglist

        fastfetch

        # create user interactively w/ administrative privileges
        DUO_USER=$(input "Enter the username of the user to create: ")
        useradd -m -G wheel -s /bin/bash $DUO_USER
        passwd $DUO_USER

        echo "export DUO_USER=${DUO_USER}" >> ~/.zshrc
        echo "User created successfully."

        # log in as user
        su $DUO_USER
    else
        echo "Unsupported Linux distribution."
        return 1
    fi

}

function duo() {
    if [ -z "$DUO_USER" ]; then
        echo "No user is set."
        return 1
    fi

    su $DUO_USER
}

if [ "$HOME" == '/root' ] && [ "$RELEASE" == "Manjaro ARM" ]; then
    if [ -z "$DUO_USER" ]; then
        init
    fi
    duo-user
elif [ ! -z "$DUO_USER" ]; then
    su "$DUO_USER"
fi
