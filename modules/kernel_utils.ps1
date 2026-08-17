Write-Host "Populating Kernel Utils..."

$utils_h = @"
#ifndef USOS_UTILS_H
#define USOS_UTILS_H

int u_strlen(const char* s);
int u_abs(int x);
void u_sleep(int ms);

#endif
"@
Set-Content "USOS/kernel/utils/utils.h" $utils_h -Encoding UTF8

$math_c = @"
int u_abs(int x) {
    return x < 0 ? -x : x;
}
"@
Set-Content "USOS/kernel/utils/math.c" $math_c -Encoding UTF8

$string_c = @"
int u_strlen(const char* s) {
    int n = 0;
    while (*s++) n++;
    return n;
}
"@
Set-Content "USOS/kernel/utils/string.c" $string_c -Encoding UTF8

$time_c = @"
#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
extern int usleep(unsigned int);
#endif

void u_sleep(int ms) {
#ifdef _WIN32
    Sleep(ms);
#else
    usleep(ms * 1000);
#endif
}
"@
Set-Content "USOS/kernel/utils/time.c" $time_c -Encoding UTF8

Write-Host "Kernel Utils populated."