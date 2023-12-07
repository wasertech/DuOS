# Deux Surfaces (Surface Duo)

My favorite GNU/Linux flavor on the Microsoft Surface Duo.

## What is this?

This is a collection of scripts and instructions to install GNU/Linux on the Microsoft Surface Duo.

## What is the Microsoft Surface Duo?

The Microsoft Surface Duo is a dual-screen device with two 5.6" screens that fold out to an 8.1" screen. It runs Android 10 and has a Qualcomm Snapdragon 855 processor.

## Can I use those scripts and instructions on other devices?

Maybe, I don't know. I only have a Surface Duo, so I can't test it on other devices. If you want to try it on other devices, you can try to adapt the scripts and instructions to your device.

## Installation

### Prerequisites

- A Surface Duo

### Instructions

1. Install the latest version of [Termux](https://termux.com/) from the Google Play Store.
2. Open Termux and run the following commands:

```bash
pkg install wget
wget https://raw.githubusercontent.com/Deux-Surfaces/Deux-Surfaces/main/install.sh
bash install.sh
```

Or clone the repository and run the installer:

```bash
git clone https://github.com/wasertech/deux-surfaces.git /tmp/deux-surfaces
cd /tmp/deux-surfaces
make install
```

3. Follow the instructions on the screen.
4. Reboot your device.
5. Enjoy!
6. (Optional) If you want to install a graphical environment, run the following commands:

```bash
wget https://raw.githubusercontent.com/Deux-Surfaces/Deux-Surfaces/main/install-gui.sh
bash install-gui.sh
```
