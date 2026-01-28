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

    docker ps -a

6. Build the kernel
bash

        docker compose build

7. Execute container
bash

        docker compose up

8. move to container
bash

        docker compose exec embedded_course_dev bash

The container is preconfigured to:

    Download all required tools (Linaro toolchain)

    Clone the BeagleBone Black kernel repository

    Compile the kernel

Build artifacts will be available in the output folder:

    zImage (compressed kernel image)

    dtbs/ (device tree binaries)

    modules/ (kernel modules)

zip output folder and sent to /home/debian for example, BBB is not able to send directly to /boot folder directly even with SUDO rights
copy zImage to /boot
copy dtbs/ to /boot/dbts/
copy modules to /lib/modules

remove old symb link

    sudo rm -f /boot/zImage
create new symblink

    sudo ln -s /boot/vmlinuz-6.12.34+ /boot/zImage

pasos para cargar el nuevo kernel:
1. Desconectar la alimentacion
2. Presiar el boton (y mantenerlo presionado)
3. Connectar la alimentacion
4. Esperar 5 segundos y solar el boton
5. esperar 1 minuto
6. 
