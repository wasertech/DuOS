set -e

function input {
    echo -n '$1\n❯ '; read
}

# Check Termux version
if [ ! -f $PREFIX/bin/termux-info ]; then
    echo "Termux is not installed."
    return 1
fi

# Update Termux packages
pkg update -y

# Install dependencies
pkg install -y proot proot-distro git which

# Install selected Linux distribution

echo "Select a Linux distribution to install:"
proot-distro list
DUO_DISTRO=$(input "Enter the alias of the Linux distribution to install: ")
proot-distro install $DUO_DISTRO

# Clone deux.sh from GitHub

# Install deux.sh in $PREFIX/bin
if [ ! -f $PREFIX/bin/deux.sh ]; then
    git clone https://github.com/wasertech/deux-surfaces.git /tmp/deux-surfaces
    cp /tmp/deux-surfaces/deux.sh $PREFIX/bin/deux.sh
fi

# Make deux.sh executable
chmod +x $PREFIX/bin/deux.sh

# Make sure .bashrc exists
if [ ! -f $HOME/.bashrc ]; then
    touch $HOME/.bashrc
fi

# Check if DEUX_DISTRO is set in .bashrc

if grep -q "DEUX_DISTRO" $HOME/.bashrc; then
    echo "DEUX_DISTRO is already set in .bashrc."
    return 1
fi

# Set DEUX_DISTRO in .bashrc

if ! grep -q "DEUX_DISTRO" $HOME/.bashrc; then
    echo "export DEUX_DISTRO=$HOME/.deux" >> $HOME/.bashrc
fi

# Check if deux.sh is already sourced in .bashrc

if grep -q "deux.sh" $HOME/.bashrc; then
    echo "deux.sh is already sourced in .bashrc."
    return 1
fi

# Source deux.sh in .bashrc

if ! grep -q "deux.sh" $HOME/.bashrc; then
    echo "source $PREFIX/bin/deux.sh" >> $HOME/.bashrc
fi

proot-distro login $DUO_DISTRO

# update system, create user, install packages, etc.
# only if $DUO_DISTRO is manjaro

# Install packages
if [ $DUO_DISTRO == "manjaro" ]; then
    # we shoud be "root" in manjaro

    # update system
    $pkglist = "base-devel \
    git \
    nvim \
    neofetch"
    pacman -Syyu
    pacman -S $pkglist

    fastfetch

    # create user interactively w/ administrative privileges
    DUO_USER=$(input "Enter the username of the user to create: ")
    useradd -m -G wheel -s /bin/bash $DUO_USER
    passwd $DUO_USER

    # log in as user
    su $DUO_USER
else
    echo "The Linux distribution $DUO_DISTRO is not supported."
    return 1
fi

echo "Welcome to ${DUO_DISTRO} ${DUO_USER} !"
