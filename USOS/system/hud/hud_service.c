#include <stdio.h>

void hud_init() {
    printf("[HUD] Ready.\n");
}

void hud_render(const char* msg) {
    printf("[HUD] %s\n", msg);
}
