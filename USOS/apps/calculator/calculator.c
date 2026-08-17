#include <stdio.h>

int calc_add(int left, int right) {
    return left + right;
}

int calc_mul(int left, int right) {
    return left * right;
}

void calc_start() {
    int left = 7;
    int right = 6;
    int sum = calc_add(left, right);
    int product = calc_mul(left, right);

    printf("[CALC] %d + %d = %d\n", left, right, sum);
    printf("[CALC] %d * %d = %d\n", left, right, product);
}
