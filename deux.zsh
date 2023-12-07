function init() {
    
    release=$(cat /etc/os-release | grep -oP '(?<=^ID=).+' | tr -d '"')
    
    if [ $release == "manjaro" ] || [ $release == "arch" ]; then
            # update system
        $pkglist = "base-devel \
        git \
        neovim \
        fastfetch \
        xonsh"
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
su $DUO_USER