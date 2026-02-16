moverte al folder driver

    cd linux-beagleboard/drivers/

buscar el "compatible" asociado a LED
    
    grep -r "gpio-leds" .

abrir
https://github.com/beagleboard/linux/blob/v6.12.34-ti-arm32-r12/drivers/leds/leds-gpio.c
