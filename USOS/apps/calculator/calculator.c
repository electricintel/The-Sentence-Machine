#include <stdio.h>

void calc_start() {
    int left = 7;
    int right = 6;
    int sum = left + right;
    int product = left * right;

    printf("[CALC] %d + %d = %d\n", left, right, sum);
    printf("[CALC] %d * %d = %d\n", left, right, product);
}
