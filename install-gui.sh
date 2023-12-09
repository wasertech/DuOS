#!/bin/bash

# echo "Not implemented yet."
# exit 1

# Check Termux version
if [ ! -f $PREFIX/bin/termux-info ]; then
    echo "Termux is not installed."
    return 1
fi

# Update Termux packages
pkg update -y

# Install Gnome dependencies
pkg install wget -y

# Install and run the installer
wget -O install.sh https://raw.githubusercontent.com/wasertech/deux-surfaces/master/install.sh && \
. install.sh || echo "Installation failed!" && exit 1

source ~/.bashrc

init

source ~/.bashrc

if [ -z "$DUO_DISTRO" ]; then
    echo "No distribution is set."
    DUO_DISTRO="manjaro"
fi

if [ -z "$DUO_USER" ]; then
    echo "No user is set."
    exit 1
fi

# switch to unstable branch (may not be required anymore)
# pacman-mirrors --api --set-branch unstable
# pacman-mirrors --fasttrack 5 && pacman -Syyu

# Install GDM
login $DUO_DISTRO --user $DUO_USER -- pacman -S gdm --noconfirm

# Install Gnome Shell Mobile
login $DUO_DISTRO --user $DUO_USER -- pacman -S gnome-shell-mobile --noconfirm

# Install pamac
login $DUO_DISTRO --user $DUO_USER -- pacman -S --noconfirm \
libpamac \
pamac-gtk \
pamac-cli \
pamac-flatpak-plugin \
pamac-gnome-integration

login $DUO_DISTRO --user $DUO_USER -- vncpasswd
login $DUO_DISTRO --user $DUO_USER --  '
    # Configure VNC to use GNOME Mobile Shell
    echo "session=gnome-shell-mobile" > ~/.vnc/config
    echo "geometry=1920x1080" >> ~/.vnc/config

    # Create a new systemd service file for TigerVNC
    SERVICE_FILE="/etc/systemd/system/tigervnc@:1.service"
    bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=simple
User=$USER
PAMName=login
PIDFile=/home/$USER/.vnc/%H%i.pid
ExecStart=/usr/bin/vncserver :1
ExecStop=/usr/bin/vncserver -kill %i

[Install]
WantedBy=multi-user.target
    EOF
'

# Enable GDM
login $DUO_DISTRO --user $DUO_USER -- systemctl enable gdm.service
login $DUO_DISTRO --user $DUO_USER -- systemctl start gdm.service

login $DUO_DISTRO --user $DUO_USER -- systemctl enable tigervnc@:1.service
login $DUO_DISTRO --user $DUO_USER -- systemctl start tigervnc@:1.service

echo "Everything should be ready."