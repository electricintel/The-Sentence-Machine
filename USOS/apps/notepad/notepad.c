#include <stdio.h>
#include <string.h>

static char notebook[128] = "";

void notepad_set(const char* line) {
    strncpy(notebook, line, sizeof(notebook) - 1);
    notebook[sizeof(notebook) - 1] = '\0';
}

const char* notepad_get() {
    return notebook;
}

void notepad_start() {
    notepad_set("hello from notepad");

    printf("[NOTEPAD] Stored note: %s\n", notebook);
}
