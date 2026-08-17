Write-Host "Populating Kernel Drivers..."

$drivers_h = @"
#ifndef USOS_DRIVERS_H
#define USOS_DRIVERS_H

void audio_init();
void display_init();
void input_init();
void bus_init();

#endif
"@
Set-Content "USOS/kernel/drivers/drivers.h" $drivers_h -Encoding UTF8

$audio_c = @"
#include <stdio.h>

void audio_init() {
    printf("[AUDIO] Driver initialized.\n");
}
"@
Set-Content "USOS/kernel/drivers/audio_driver.c" $audio_c -Encoding UTF8

$display_c = @"
#include <stdio.h>
#include "drivers.h"

void display_init() {
    printf("[DISPLAY] Driver initialized.\n");
}
"@
Set-Content "USOS/kernel/drivers/display_driver.c" $display_c -Encoding UTF8

$input_c = @"
#include <stdio.h>
#include "drivers.h"

void input_init() {
    printf("[INPUT] Driver initialized.\n");
}
"@
Set-Content "USOS/kernel/drivers/input_driver.c" $input_c -Encoding UTF8

$bus_c = @"
#include <stdio.h>
#include "drivers.h"

void bus_init() {
    printf("[BUS] Virtual bus online.\n");
}
"@
Set-Content "USOS/kernel/drivers/virtual_bus.c" $bus_c -Encoding UTF8

Write-Host "Kernel Drivers populated."