# Secure Boot for Tegra

This project contains a set of scripts to automate the secure boot process outlined
in the [Nvidia L4T Development Guide](https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%2520Linux%2520Driver%2520Package%2520Development%2520Guide%2Fsecurity.html%23)

The scripts are currently hard-coded to use Jetson NX as the target.

The scripts are for the ``32.5.0`` (``Jetpack 4.5``) release. To change the version, make changes to the ``downloadfilenames`` file.

CAUTION: These scripts are only known to be good and run on a bare-metal Ubuntu 18.04 system. A virtual machine or other distribution is not recommended and may lead to unexpected behavior and "brick" your board.
## Install Prerequisites

```shell
sudo apt-get update
sudo apt-get install device-tree-compiler qemu-user-static
```	
## Downloading Packages and preparing for use

Run

```shell
./download-and-prepare-files.sh
```

## Flashing stock image (optional)

Put your device in recovery mode, then run

To flash Jetson NX with SD card
```shell
./flashing-and-booting.sh -t SD
```

To flash Jetson NX with EMMC memory
```shell
./flashing-and-booting.sh -t EMMC
```

Verify your device boots successfully

