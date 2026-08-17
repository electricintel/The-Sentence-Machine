#include <stdio.h>
#include <string.h>

static char notebook[128] = "";

void notepad_start() {
    const char* line = "hello from notepad";
    strncpy(notebook, line, sizeof(notebook) - 1);
    notebook[sizeof(notebook) - 1] = '\0';

    printf("[NOTEPAD] Stored note: %s\n", notebook);
}
