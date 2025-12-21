zip output folder and sent to /home/debian for example.
BBB is not able to send directly to /boot folder directly even with SUDO rights,
copy zImage to /boot copy dtbs/ to /boot/dbts/ copy modules to /lib/modules

remove old symb link

    sudo rm -f /boot/zImage

create new symblink

sudo ln -s /boot/vmlinuz-6.12.34+ /boot/zImage
