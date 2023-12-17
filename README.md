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
curl -o install https://raw.githubusercontent.com/wasertech/DuOS/master/scripts/install && chmod +x install && ./install || echo "Installation failed!"
```

After the installation is completed, run `duo --start`. The starting script will start Termux-X11 and show the start menu.

### Usage

Once installed, type `duo` to start :

```bash
duo
```
