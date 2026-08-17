#include <stdio.h>
#include <time.h>

void clock_start() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);
    char buffer[64];

    if (local && strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local)) {
        printf("[CLOCK] %s\n", buffer);
    } else {
        printf("[CLOCK] Time unavailable.\n");
    }
}
