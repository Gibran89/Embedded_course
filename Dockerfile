# BeagleBone Black Kernel Build Environment
# Optimized for Ubuntu 24.04 host with proper user permissions

FROM ubuntu:22.04

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
    WORKDIR=/workspace \
    LINARO_TOOLCHAIN=gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf

# Create a non-root user and working directory
RUN useradd -m builder && \
    mkdir -p ${WORKDIR} && \
    chown builder:builder ${WORKDIR} && \
    mkdir /build && \
    chown builder:builder /build

WORKDIR ${WORKDIR}

# Install essential build dependencies (optimized layers)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git make gcc wget xz-utils tar \
    libncurses-dev pkg-config flex bison \
    libssl-dev bc python3 python3-pip \
    kmod cpio libgmp3-dev libmpc-dev \
    libmpfr-dev g++-multilib gcc-multilib \
    gdb-multiarch rsync sshpass \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Linaro ARM toolchain (modified section)
RUN mkdir -p /opt/toolchain && \
    wget -q https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/${LINARO_TOOLCHAIN}.tar.xz \
    && tar -xf ${LINARO_TOOLCHAIN}.tar.xz -C /opt/toolchain \
    && rm ${LINARO_TOOLCHAIN}.tar.xz

# Set up environment variables (modified PATH)
ENV PATH="/opt/toolchain/${LINARO_TOOLCHAIN}/bin:${PATH}" \
    ARCH=arm \
    CROSS_COMPILE=arm-linux-gnueabihf-

# Copy build script with proper permissions
COPY --chown=builder:builder build_kernel.sh /build/
RUN chmod +x /build/build_kernel.sh

# Configure Git safety (for volume-mounted repos)
RUN git config --global --add safe.directory ${WORKDIR}/linux-beagleboard

# Set entry point and default command
ENTRYPOINT ["/build/build_kernel.sh"]
