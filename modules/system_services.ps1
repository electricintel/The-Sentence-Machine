Write-Host "Populating System Services..."

$init_c = @"
#include <stdio.h>

void system_init() {
    printf("[SYSTEM] Initialization started...\n");
    printf("[SYSTEM] Loading kernel services...\n");
    printf("[SYSTEM] Loading drivers...\n");
    printf("[SYSTEM] Loading communication stack...\n");
    printf("[SYSTEM] Initialization complete.\n");
}
"@
Set-Content "USOS/system/init/init.c" $init_c -Encoding UTF8

$hud_c = @"
#include <stdio.h>

void hud_init() {
    printf("[HUD] Ready.\n");
}

void hud_render(const char* msg) {
    printf("[HUD] %s\n", msg);
}
"@
Set-Content "USOS/system/hud/hud_service.c" $hud_c -Encoding UTF8

$ir_c = @"
#include <stdio.h>

void ir_init() {
    printf("[IR] Sensor initialized.\n");
}

int ir_read() {
    return 42;
}
"@
Set-Content "USOS/system/ir/ir_service.c" $ir_c -Encoding UTF8

$usp_c = @"
#include <stdio.h>

void usp_init() {
    printf("[USP] Protocol online.\n");
}

void usp_send(const char* msg) {
    printf("[USP] SEND: %s\n", msg);
}

void usp_recv(const char* msg) {
    printf("[USP] RECV: %s\n", msg);
}
"@
Set-Content "USOS/system/usp/usp_service.c" $usp_c -Encoding UTF8

$comms_c = @"
#include <stdio.h>

void comms_init() {
    printf("[COMMS] Stack initialized.\n");
}

void comms_broadcast(const char* msg) {
    printf("[COMMS] BROADCAST: %s\n", msg);
}

void comms_direct(const char* msg, int pid) {
    printf("[COMMS] DIRECT to %d: %s\n", pid, msg);
}
"@
Set-Content "USOS/system/comms/comms_service.c" $comms_c -Encoding UTF8

Write-Host "System Services populated."