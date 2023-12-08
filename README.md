# DuOS: Deux Surfaces (Surface Duo)

My favorite GNU/Linux flavor on the Microsoft Surface Duo.

## What is this?

This is a collection of scripts and instructions to install GNU/Linux on the Microsoft Surface Duo.

## What is the Microsoft Surface Duo?

The Microsoft Surface Duo is a dual-screen device with two 5.6" screens that fold out to an 8.1" screen. It runs Android 10 and has a Qualcomm Snapdragon 855 processor.

## Can I use those scripts and instructions on other devices?

Maybe, I don't know. I only have a Surface Duo, so I can't test it on other devices. If you want to try it on other devices, you can try to adapt the scripts and instructions to your device. Let me know if it works (or not)!

## Installation

### Prerequisites

- A Surface Duo

### Instructions

1. Install the latest version of [Termux](https://termux.com/).
2. Open Termux and run the following commands:

```bash
# If you haven't installed wget yet
pkg install wget

# Install and run the installer
wget -O install.sh https://raw.githubusercontent.com/wasertech/deux-surfaces/master/install.sh && \
bash install.sh || echo "Installation failed!"
```

Or clone the repository and run the installer:

```bash
# If you haven't installed git yet
pkg install git make

# Clone the repository and run the installer
git clone https://github.com/wasertech/deux-surfaces.git && \
cd deux-surfaces && \
make install || echo "Installation failed!"
```

3. Follow the instructions on the screen.
4. Enjoy!
5. (Optional) If you want to install a graphical environment, run the following commands:

```bash
wget https://raw.githubusercontent.com/Deux-Surfaces/Deux-Surfaces/main/install-gui.sh
bash install-gui.sh
```

### Usage

Once installed, type `duo` to start :

```bash
duo
```

### Useful considerations

DuOS will only install a minimal GNU/Linux system. No dotfiles (appart from DuOS ones) will be installed. You can install your own dotfiles or use the default ones.