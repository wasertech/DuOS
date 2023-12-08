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
alias which='$(command -v)'
alias login='proot-distro login'
alias fetch='fastfetch'

# Print user and system information
uname -a

echo "You are $(whoami) on $(hostname)."

function init() {
    echo "User creation"
    # create user interactively w/ administrative privileges
    read -p "Enter the username of the user to create: " DUO_USER
    useradd -m -G wheel -s /bin/bash $DUO_USER
    passwd $DUO_USER

    login $DUO_DISTRO -- -c echo "export DUO_USER=$DUO_USER" >> ~/.bashrc
    login $DUO_DISTRO -- -c echo "source deux.sh" >> ~/.bashrc
    login $DUO_DISTRO -- -c echo "export DUO_USER=$DUO_USER" >> ~/.zshrc
    login $DUO_DISTRO -- -c echo "source deux.zsh" >> ~/.zshrc
    echo "User created successfully."
}

function duo() {
    echo "Welcome on Duo!"

    # Login to the chroot environment
    login $DUO_DISTRO --user $USER
}

function duo-user() {
    if [ -z "$DUO_USER" ]; then
        echo "No user is set."
        return 1
    fi

    su $DUO_USER
}

if [[ "$HOME" == '/root' && "$RELEASE" == "Manjaro ARM" ]]; then
    if [ -z "$DUO_USER" ]; then
        init
    fi
    duo-user
elif [ "$RELEASE" != "Manjaro ARM" ]; then
    # echo "Deux is ready to use."
    # echo "Type 'duo' to start the chroot environment."
    clear
    duo
elif [ -z "$DUO_USER" ] && [ "$RELEASE" == "Manjaro ARM" ]; then
    su "$DUO_USER"
fi
