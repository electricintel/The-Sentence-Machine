#include <stdio.h>
#include <time.h>

int clock_now(char* out, size_t out_size) {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    if (!local) {
        return 0;
    }

    return strftime(out, out_size, "%Y-%m-%d %H:%M:%S", local) > 0;
}

void clock_start() {
    char buffer[64];

    if (clock_now(buffer, sizeof(buffer))) {
        printf("[CLOCK] %s\n", buffer);
    } else {
        printf("[CLOCK] Time unavailable.\n");
    }
}
