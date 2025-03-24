# Firmware Mod Kit FAST Usage Guide

![Platform](https://img.shields.io/badge/platform-Linux-blueviolet)
![Forks](https://img.shields.io/github/forks/N1nEmAn/fmk-fast)
![Stars](https://img.shields.io/github/stars/N1nEmAn/fmk-fast)
![wmremove-transformed-removebg-preview](https://github.com/user-attachments/assets/b7322269-4242-416f-a912-5a45a59e9c0c)

- **🚀 Quick and Easy Firmware Extraction**: This tool allows you to use the Firmware Mod Kit (FMK) for firmware extraction with ease.
- **🔧 No Configuration Needed**: No need to worry about GCC, binwalk, or Python version incompatibilities.
- **📦 Ready to Use Out of the Box**: Start extracting firmware immediately without any setup hassles.
- **⚡ Efficient Extraction**: Quickly extract kernel images, file systems, and more from your firmware.
- **⭐ Star Us on GitHub**: If you find this tool useful, please give us a star!

## Why I Created It

The motivation for creating this tool stemmed from my personal experiences with the original Firmware Mod Kit (FMK). Despite its potential, the original FMK often failed to work for me due to various compatibility issues.

In my quest for a solution, I discovered a reliable Docker image from the repository bnzm5270/firmware-mod-kit. This image worked well initially and served as a valuable reference point.

To ensure greater stability and control, I decided to adapt and copy the Docker setup to my own Docker account. This adaptation was crucial in creating a more reliable and user-friendly tool.

I deeply appreciate the original work done by bnzm5270, which laid the foundation for this project. Without their contributions, this tool would not have been possible. 🙏

## Dependencies

This project relies on Docker for firmware extraction. Install Docker based on your operating system:

### Ubuntu

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

### macOS

Download and install Docker Desktop from the [Docker website](https://www.docker.com/products/docker-desktop).

### Arch Linux

```bash
sudo pacman -S docker
sudo systemctl start docker
sudo systemctl enable docker
```

## Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/N1nEmAn/firmware-mod-kit-fast.git
    cd firmware-mod-kit-fast
    ```

2. **Run the installation script**

    To install the `fmk` tool to `/usr/bin`, run:

    ```bash
    ./install.sh
    ```

    This will create a `fmk` command for easy use.

## Usage

**Extract firmware**

The first time Docker is used, it may take some time to download the required Docker image. Once downloaded, firmware extraction will be faster. Use the following command to extract firmware:

```bash
fmk example_DIR_815
```

Here, `example_DIR_815` should be replaced with the actual firmware path.

**Debug Mode**

To enable debugging output, use the `-d` flag. This will provide detailed logs and help troubleshoot any issues:

```bash
fmk -d example_DIR_815
```

**Note**: If the `fmk` command fails, try running it with `sudo`:

```bash
sudo fmk example_DIR_815
```

## Example

```bash
# Clone the repository
git clone https://github.com/N1nEmAn/firmware-mod-kit-fast.git
cd firmware-mod-kit-fast

# Run the installation script
./install.sh

# Extract firmware
fmk example_DIR_815

# Extract firmware with debugging output
fmk -d example_DIR_815

# Build firmware
fmk -b your_folder

```
