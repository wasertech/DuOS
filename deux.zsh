alias fetch="fastfetch"

function init() {
    
    release=$(cat /etc/os-release | grep -oP '(?<=^ID=).+' | tr -d '"')
    
    if [ $release == "manjaro" ] || [ $release == "arch" ]; then
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


echo "Welcome on Duo!"

# Print system information using fastfetch if available
if command -v fastfetch >/dev/null 2>&1; then
    fetch
else
    echo "Couldn't fetch system information."S
fi

if [ -z "$DUO_USER" ]; then
    init
fi

echo "Welcome to $DUO_DISTRO!"
echo "Type 'exit' twice to exit the chroot environment."

su $DUO_USER