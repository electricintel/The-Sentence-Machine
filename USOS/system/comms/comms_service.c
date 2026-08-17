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
