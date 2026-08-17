Write-Host "Populating UI System..."

$ui_h = @"
#ifndef USOS_UI_H
#define USOS_UI_H

void ui_init();
void ui_render_text(const char* msg);
void ui_render_box(int w, int h);
void ui_event(const char* evt);

#endif
"@
Set-Content "USOS/ui/ui.h" $ui_h -Encoding UTF8

$ui_core_c = @"
#include <stdio.h>
#include "ui.h"

void ui_init() {
    printf("[UI] System initialized.\n");
}
"@
Set-Content "USOS/ui/ui_core.c" $ui_core_c -Encoding UTF8

$ui_render_c = @"
#include <stdio.h>
#include <string.h>
#include "ui.h"

void ui_render_text(const char* msg) {
    printf("[UI] TEXT: %s\n", msg);
}

void ui_render_box(int w, int h) {
    printf("[UI] BOX %dx%d\n", w, h);
    for (int y = 0; y < h; ++y) {
        for (int x = 0; x < w; ++x) {
            if (y == 0 || y == h - 1 || x == 0 || x == w - 1) {
                putchar('*');
            } else {
                putchar(' ');
            }
        }
        putchar('\n');
    }
}
"@
Set-Content "USOS/ui/ui_render.c" $ui_render_c -Encoding UTF8

$ui_events_c = @"
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "ui.h"

void ui_event(const char* evt) {
    const char* category = "custom";

    if (strncmp(evt, "key:", 4) == 0) {
        category = "input";
    } else if (strncmp(evt, "click:", 6) == 0) {
        category = "pointer";
    } else if (strncmp(evt, "system:", 7) == 0) {
        category = "system";
    }

    printf("[UI] EVENT[%s]: %s\n", category, evt);
}
"@
Set-Content "USOS/ui/ui_events.c" $ui_events_c -Encoding UTF8

Write-Host "UI System populated."