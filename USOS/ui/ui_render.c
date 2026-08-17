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
