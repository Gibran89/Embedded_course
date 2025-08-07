#!/bin/bash
set -e

# BeagleBone Black Kernel Build Script
# Automates kernel compilation in Docker containers

# 1. Toolchain environment setup
echo "Setting up build environment..."
export PATH="/opt/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin:$PATH"

# Verify cross-compiler is available
if ! command -v arm-linux-gnueabihf-gcc &> /dev/null; then
    echo "ERROR: Cross-compiler arm-linux-gnueabihf-gcc not found"
    echo "Current PATH: $PATH"
    exit 1
fi

echo "Starting BeagleBone Black kernel compilation process..."

# 2. Secure Git repository configuration
git config --global --add safe.directory /workspace/linux-beagleboard

# 3. Clone kernel repository if it doesn't exist
if [ ! -d "linux-beagleboard" ]; then
    echo "Cloning kernel repository (optimized download)..."
    git clone https://github.com/beagleboard/linux \
        --depth=1 \
        --no-single-branch \
        linux-beagleboard
fi

cd linux-beagleboard

# 4. Switch to correct kernel branch
TARGET_BRANCH="6.12.34-ti-arm32-r12"
echo "Checking out branch ${TARGET_BRANCH}..."
git checkout ${TARGET_BRANCH}

# 5. Configure the kernel
echo "Configuring kernel with bb.org_defconfig..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bb.org_defconfig

# 6. Menuconfig option
if [ "$1" == "--menuconfig" ]; then
    echo "Starting kernel configuration interface..."
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
fi

# 7. Compile kernel and device trees
echo "Compiling kernel (this may take a while)..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) zImage
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) dtbs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j$(nproc) modules

# 8. Prepare output directory
echo "Preparing build artifacts..."
mkdir -p /build/output

# 9. Copy build artifacts
echo "Copying kernel image..."
cp arch/arm/boot/zImage /build/output/

echo "Copying device tree binaries..."
mkdir -p /build/output/dtbs
find arch/arm/boot/dts/ -name "*.dtb" -exec cp {} /build/output/dtbs/ \;

echo "Building modules..."
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=/build/output/modules

# 10. Verification and output
echo "Build completed! Generated files:"
echo "--------------------------------"
echo "Kernel image:"
ls -lh /build/output/zImage
echo "--------------------------------"
echo "Device trees:"
ls -lh /build/output/dtbs/
echo "--------------------------------"
echo "Kernel modules:"
du -sh /build/output/modules/lib/modules/*
echo "--------------------------------"

# 11. Final compiler verification
echo "Compiler information used:"
arm-linux-gnueabihf-gcc --version | head -n 1
echo "--------------------------------"
