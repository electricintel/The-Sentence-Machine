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
