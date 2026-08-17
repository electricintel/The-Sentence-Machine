Write-Host "Populating Kernel Core..."

# kernel.h
$kernel_h = @"
#ifndef USOS_KERNEL_H
#define USOS_KERNEL_H

#include <stddef.h>
#include <stdint.h>

typedef struct {
    void* start;
    size_t size;
} mem_region_t;

typedef struct {
    int pid;
    int state;
    void (*entry)(void);
} process_t;

void kmem_init();
void* kmalloc(size_t size);
void kfree(void* ptr);

void scheduler_init();
void scheduler_tick();
void scheduler_add(process_t* proc);

void ipc_send(int pid, const char* msg);
const char* ipc_recv(int pid);

void klog(const char* msg);
void kpanic(const char* msg);

#endif
"@
Set-Content "USOS/kernel/core/kernel.h" $kernel_h -Encoding UTF8

# memory.c
$memory_c = @"
#include "kernel.h"

#define KERNEL_HEAP_SIZE (1024 * 128)

static uint8_t kernel_heap[KERNEL_HEAP_SIZE];
static size_t heap_offset = 0;

void kmem_init() {
    heap_offset = 0;
}

void* kmalloc(size_t size) {
    if (heap_offset + size >= KERNEL_HEAP_SIZE) {
        return NULL;
    }
    void* ptr = &kernel_heap[heap_offset];
    heap_offset += size;
    return ptr;
}

void kfree(void* ptr) {
    (void)ptr;
}
"@
Set-Content "USOS/kernel/core/memory.c" $memory_c -Encoding UTF8

# process.c
$process_c = @"
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
"@
Set-Content "USOS/kernel/core/process.c" $process_c -Encoding UTF8

# scheduler.c
$scheduler_c = @"
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
"@
Set-Content "USOS/kernel/core/scheduler.c" $scheduler_c -Encoding UTF8

# ipc.c
$ipc_c = @"
#include "kernel.h"

static const char* msg_buffer[32];

void ipc_send(int pid, const char* msg) {
    msg_buffer[pid] = msg;
}

const char* ipc_recv(int pid) {
    return msg_buffer[pid];
}
"@
Set-Content "USOS/kernel/core/ipc.c" $ipc_c -Encoding UTF8

# logging.c
$logging_c = @"
#include "kernel.h"
#include <stdio.h>

void klog(const char* msg) {
    printf("[KERNEL] %s\n", msg);
}

void kpanic(const char* msg) {
    printf("[PANIC] %s\n", msg);
    while (1) {}
}
"@
Set-Content "USOS/kernel/core/logging.c" $logging_c -Encoding UTF8

Write-Host "Kernel Core populated."
