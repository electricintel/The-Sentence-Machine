#include "kernel.h"
#include <stdio.h>

void klog(const char* msg) {
    printf("[KERNEL] %s\n", msg);
}

void kpanic(const char* msg) {
    printf("[PANIC] %s\n", msg);
    while (1) {}
}
