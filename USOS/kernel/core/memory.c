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
