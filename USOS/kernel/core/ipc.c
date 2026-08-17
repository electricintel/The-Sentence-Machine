#include "kernel.h"

static const char* msg_buffer[32];

void ipc_send(int pid, const char* msg) {
    msg_buffer[pid] = msg;
}

const char* ipc_recv(int pid) {
    return msg_buffer[pid];
}
