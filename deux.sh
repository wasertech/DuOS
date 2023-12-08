#!/bin/bash
# DuOS (Duo Operating Systems): Linux on Android
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

function duo-update() {
    echo "Updating DuOS..."
    
    # Check Termux version
    if [ ! -f $PREFIX/bin/termux-info ]; then
        echo "Termux is not installed."
        return 1
    fi

    # Update Termux packages
    pkg update -y

    # Install dependencies
    pkg install -y proot proot-distro git which

    # Install deux.sh in $PREFIX/bin
    mkdir -p $PREFIX/bin
    tmpdir=$(mktemp -d XXXXXX)
    duodir=${tmpdir}/deux-surfaces
    git clone https://github.com/wasertech/deux-surfaces.git ${duodir}
    rm -rf ${PREFIX}/bin/deux.sh && \
    rm -rf ${PREFIX}/bin/deux.zsh && \
    cp ${duodir}/deux.sh ${PREFIX}/bin/deux.sh && \
    cp ${duodir}/deux.zsh ${PREFIX}/bin/deux.zsh && \
    rm -rf ${tmpdir} || echo "Couldn't install deux."

    # Make deux.sh executable
    chmod +x $PREFIX/bin/deux.sh
    chmod +x $PREFIX/bin/deux.zsh

    # Make sure Temrmux's default user's .bashrc exists
    if [ ! -f $HOME/.bashrc ]; then
        touch $HOME/.bashrc
    fi

    if grep -q "DUO_DISTRO" $HOME/.bashrc; then
        echo "DUO_DISTRO is already set in .bashrc."
    fi

    if ! grep -q "DUO_DISTRO" $HOME/.bashrc; then
        echo "export DUO_DISTRO='${DUO_DISTRO}'" >> $HOME/.bashrc
    fi

    # Check if deux.sh is already sourced in .bashrc

    if grep -q "deux.sh" $HOME/.bashrc; then
        echo "deux.sh is already sourced in .bashrc."
    fi

    # Source deux.sh in .bashrc

    if ! grep -q "deux.sh" $HOME/.bashrc; then
        echo "source deux.sh" >> $HOME/.bashrc
    fi

    echo "Update complete."
    echo "DuOS has been updated successfully."
    echo "Type 'duo' or restart Termux, to start using it."
    echo

    return true
}

function init() {
    echo "Initializing the chroot environment..."
    login $DUO_DISTRO -- pacman -Syyu
    login $DUO_DISTRO -- pacman -S base-devel git neovim fastfetch zsh

    login $DUO_DISTRO -- groupadd -g 100 users 
    login $DUO_DISTRO -- groupadd -g 10 wheel
    
    login $DUO_DISTRO -- mkdir -p /etc/default /etc/sudoers.d
    
    if [ ! -f /etc/default/groupadd ]; then
        login $DUO_DISTRO -- awk 'BEGIN { print "GROUP=users" >> "/etc/default/groupadd" }'
    fi
    
    if [ ! -f /etc/sudoers.d/10-installer ]; then
        login $DUO_DISTRO -- awk 'BEGIN { print "%wheel ALL=(ALL) ALL" >> "/etc/sudoers.d/10-installer" }'
    fi

    echo "User creation"
    # create user interactively w/ administrative privileges
    read -p "Enter the username of the user to create: " DUO_USER false
    
    if [ -z "$DUO_USER" ]; then
        echo "Please enter a username."
        return 1
    fi

    if ! grep -q "export DUO_USER=$DUO_USER" ~/.bashrc; then
        sed -i '/source deux.sh/d' ~/.bashrc
        echo "export DUO_USER=$DUO_USER" >> ~/.bashrc
        echo "source deux.sh" >> ~/.bashrc
    fi

    login $DUO_DISTRO -- useradd -m -G wheel -s /bin/zsh $DUO_USER && \
    login $DUO_DISTRO -- passwd $DUO_USER && \
    echo "User created successfully." || echo "Couldn't create user (probably already exists)."

    login $DUO_DISTRO -- usermod -aG wheel $DUO_USER
    echo "User account is ready."

    echo "Setting up the shell..."
    if [ -z "$DUO_USER" ]; then
        echo "No user is set."
        init
    fi

    login $DUO_DISTRO --user $DUO_USER -- awk -v user="$DUO_USER" 'BEGIN { print "export DUO_USER=" user >> "/home/" user "/.zshrc" }'
    login $DUO_DISTRO --user $DUO_USER -- awk -v user="$DUO_USER" 'BEGIN { print "source deux.zsh" >> "/home/" user "/.zshrc" }'

    echo "Initialisation complete."
    return true
}

function duo() {
    echo "Welcome on DuOS!"

    # Make sure $DUO_{USER,DISTRO} are set

    if [ -z "$DUO_DISTRO" ]; then
        echo "No distribution is set."
        DUO_DISTRO="manjaro"
    fi
    
    if [ -z "$DUO_USER" ]; then
        echo "No user is set."
        init
    fi

    # Login to the chroot environment
    login $DUO_DISTRO --user $DUO_USER
}

echo "DuOS is ready to use."
echo "You can type:"
echo " - 'duo' to log into DuOS"
echo " - 'duo-update' to update DuOS"
echo " - 'init' to initialize DuOS"
echo

# duo
