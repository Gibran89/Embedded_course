# Guía Completa para Flashear BeagleBone Black
Pasos Completos de Flasheo

1. Preparación de la imagen

        unxz am335x-debian-12.11-base-vscode-v6.12-armhf-2025-05-29-4gb.img.xz

2. Identificación de la SD card

       lsblk
Ejemplo de salida esperada:

    sdb      8:16   1  58.2G  0 disk 
    ├─sdb1   8:17   1    36M  0 part 
    ├─sdb2   8:18   1   512M  0 part 
    └─sdb3   8:19   1     3G  0 part

4. Desmontaje de particiones
   
        sudo umount /dev/sdb1 /dev/sdb2 /dev/sdb3

5. Escritura de la imagen en la SD card
bash

        sudo dd if=am335x-debian-12.11-base-vscode-v6.12-armhf-2025-05-29-4gb.img of=/dev/sdb bs=4M status=progress oflag=sync

6. Verificación de las particiones creadas
bash

        sudo blkid /dev/sdb1 /dev/sdb2 /dev/sdb3

7. Montar las particiones
   
        sudo mount /dev/sdb1 /mnt/boot

        sudo mount /dev/sdb2 /mnt/data

        sudo mount /dev/sdb3 /mnt/rootfs
6. Configuración de contraseñas

        sudo nano /mnt/boot/sysconf.txt
   
Editar las siguientes líneas:
    
    root_password=tu_password_root
    user_name=debian
    user_password=tu_password_usuario

7. Verificación de la configuración del kernel

        sudo nano /mnt/boot/uEnv.txt
   
Asegurarse de que contiene:
uname_r=6.12.32-bone28

8. Desmontaje seguro
bash

        sudo umount /mnt/boot /mnt/data /mnt/rootfs
        sync

9. Conexión serial (para debugging)

       sudo screen /dev/ttyUSB0 115200
o alternativa:

    sudo minicom -D /dev/ttyUSB0 -b 115200

