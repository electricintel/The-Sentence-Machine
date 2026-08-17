#include <stdio.h>

void usp_init() {
    printf("[USP] Protocol online.\n");
}

void usp_send(const char* msg) {
    printf("[USP] SEND: %s\n", msg);
}

void usp_recv(const char* msg) {
    printf("[USP] RECV: %s\n", msg);
}
