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
