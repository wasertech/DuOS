set -e

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

echo "Enter the alias of the Linux distribution to install..."
echo "Default: manjaro"
echo "Just hit enter if this option sounds appealing."

read -p '❯  ' DUO_DISTRO

if [ !$DUO_DISTRO ]; then
    DUO_DISTRO='manjaro'
fi

proot-distro install $DUO_DISTRO || true

# Clone deux.sh from GitHub

# Install deux.sh in $PREFIX/bin
if [ ! -f $PREFIX/bin/deux.sh ]; then
    mkdir -p $PREFIX/bin
    tmpdir=$(mktemp -d XXXXXX)
    duodir='${tmpdir}/deux-surfaces'
    git clone https://github.com/wasertech/deux-surfaces.git ${duodir}
    cp ${duodir}/deux.sh ${PREFIX}/bin/deux.sh && \
    cp ${duodir}/deux.zsh ${PREFIX}/bin/deux.zsh && \
    rm -rf ${tmpdir} || echo "Couldn't install deux.sh." && exit 1
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
fi

# Set DEUX_DISTRO in .bashrc

if ! grep -q "DEUX_DISTRO" $HOME/.bashrc; then
    echo "export DEUX_DISTRO=$HOME/.deux" >> $HOME/.bashrc
fi

# Check if deux.sh is already sourced in .bashrc

if grep -q "deux.sh" $HOME/.bashrc; then
    echo "deux.sh is already sourced in .bashrc."
fi

# Source deux.sh in .bashrc

if ! grep -q "deux.sh" $HOME/.bashrc; then
    echo "source $PREFIX/bin/deux.sh" >> $HOME/.bashrc
fi

if grep -q "deux.zsh" $HOME/.zshrc; then
    echo "deux.sh is already sourced in .zshrc."
    exit 1
fi

if ! grep -q "deux.zsh" $HOME/.zshrc; then
    echo "source $PREFIX/bin/deux.sh" >> $HOME/.zshrc
fi

echo "Deux has been installed successfully."