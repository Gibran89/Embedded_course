# Embedded_course
Tools, documentation, examples, scripts for embedded linux with BBB course

Development Environment Setup Guide
1. Clone the repository

Run the following command to download the project:
bash

    git clone https://github.com/Gibran89/Embedded_course.git

2. Make scripts executable

Set execute permissions for the setup scripts:
bash

    chmod +x 1_setup_host.sh
    chmod +x build_kernel.sh

3. Configure your workspace

Execute the host setup script (this will install Docker, VS Code, and required extensions):
bash

    ./1_setup_host.sh

4. Restart your terminal

Close the current terminal window or open a new one.

5. Check container status

Verify the container exists in your Docker environment:
bash

    docker ps -a1

6. Build the kernel
bash

    docker ps -a

8. Execute container
bash

    docker ps -a

The container is preconfigured to:

    Download all required tools (Linaro toolchain)

    Clone the BeagleBone Black kernel repository

    Compile the kernel

Build artifacts will be available in the output folder:

    zImage (compressed kernel image)

    dtbs/ (device tree binaries)

    modules/ (kernel modules)
