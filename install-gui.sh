#!/bin/bash

set -xe

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
bash install.sh


# . ~/.bashrc && \
# init && \
# . ~/.bashrc || echo "Installation failed!" && exit 1


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

# Install Gnome Shell Mobile
proot-distro login $DUO_DISTRO -- pacman -S gnome-shell-mobile --noconfirm

# Install pamac
proot-distro login $DUO_DISTRO -- pacman -S --noconfirm \
libpamac \
pamac-gtk \
pamac-cli \
pamac-flatpak-plugin \
pamac-gnome-integration

proot-distro login $DUO_DISTRO -- pacman -S --noconfirm tigervnc

proot-distro login $DUO_DISTRO -- vncpasswd

DISPLAY_SIZE="1920x1080"

proot-distro login $DUO_DISTRO --user $DUO_USER -- mkdir -p /home/$DUO_USER/.vnc/
proot-distro login $DUO_DISTRO --user $DUO_USER -- awk -v user="$DUO_USER" 'BEGIN { print "session=gnome-shell-mobile" > "/home/" user "/.vnc/config" }'
proot-distro login $DUO_DISTRO --user $DUO_USER -- awk -v geometry="$DISPLAY_SIZE" -v user="$DUO_USER" 'BEGIN { print "geometry=" geometry >> "/home/" user "/.vnc/config" }'

# Create a new systemd service file for TigerVNC
SERVICE_FILE="/etc/systemd/system/tigervnc@:1.service"

proot-distro login $DUO_DISTRO -- awk -v sfile="$SERVICE_FILE" 'BEGIN { print "[Unit]\nDescription=Remote desktop service (VNC)\nAfter=syslog.target network.target\n\n[Service]\nType=simple\nUser=$USER\nPAMName=login\nPIDFile=/home/$USER/.vnc/%H%i.pid\nExecStart=/usr/bin/vncserver :1\nExecStop=/usr/bin/vncserver -kill %i\n\n[Install]\nWantedBy=multi-user.target\n" > sfile }'

# Enable GDM Mobile
proot-distro login $DUO_DISTRO -- systemctl enable gdb-mobile.service
proot-distro login $DUO_DISTRO -- systemctl start gdb-mobile.service

proot-distro login $DUO_DISTRO -- systemctl enable tigervnc@:1.service
proot-distro login $DUO_DISTRO -- systemctl start tigervnc@:1.service

echo "Everything should be ready."