#!/bin/bash
set -e

# Initial configuration
echo "Setting up environment..."
export PATH="/opt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin:$PATH"

# Verify compiler
if ! command -v arm-linux-gnueabihf-gcc &> /dev/null; then
    echo "ERROR: Compiler not found"
    exit 1
fi

# Create working directory
mkdir -p linux-beagleboard
cd linux-beagleboard

# Initialize Git repo if it doesn't exist
if [ ! -d ".git" ]; then
    echo "Initializing repository..."
    git init
    git remote add origin https://github.com/beagleboard/linux
    git fetch --depth 1 origin 6.12.34-ti-arm32-r12
    git checkout FETCH_HEAD
fi

# Configure kernel
echo "Configuring kernel..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bb.org_defconfig

# Compilation
echo "Compiling..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage dtbs modules

# Prepare output
echo "Preparing output..."
mkdir -p ../output
cp arch/arm/boot/zImage ../output/
mkdir -p ../output/dtbs
find arch/arm/boot/dts/ -name "*.dtb" -exec cp {} ../output/dtbs/ \;
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=../output/modules

echo "Compilation completed!"
