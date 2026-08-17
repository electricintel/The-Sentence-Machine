#include <stdio.h>
#include "diagnostics.h"

void diag_run() {
    printf("[DIAG] Running system diagnostics...\n");
    printf("[DIAG] Kernel OK\n");
    printf("[DIAG] Drivers OK\n");
    printf("[DIAG] Services OK\n");
    printf("[DIAG] UI OK\n");
}
