#include <stdio.h>
#include <string.h>

void terminal_start() {
    const char* command = "help";

    printf("[TERMINAL] > %s\n", command);
    if (strcmp(command, "help") == 0) {
        printf("[TERMINAL] Available commands: help, echo, exit\n");
    }
}
