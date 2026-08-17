#include "kernel.h"

static process_t* current = NULL;

void scheduler_init() {
    current = NULL;
}

void scheduler_add(process_t* proc) {
    if (!current) current = proc;
}

void scheduler_tick() {
    if (current && current->entry) {
        current->entry();
    }
}
