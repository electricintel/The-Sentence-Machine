#include "kernel.h"

#define MAX_PROCS 32
static process_t proc_table[MAX_PROCS];

void process_init() {
    for (int i = 0; i < MAX_PROCS; i++) {
        proc_table[i].pid = -1;
        proc_table[i].state = 0;
        proc_table[i].entry = NULL;
    }
}

process_t* process_create(void (*entry)(void)) {
    for (int i = 0; i < MAX_PROCS; i++) {
        if (proc_table[i].pid == -1) {
            proc_table[i].pid = i;
            proc_table[i].state = 1;
            proc_table[i].entry = entry;
            return &proc_table[i];
        }
    }
    return NULL;
}
