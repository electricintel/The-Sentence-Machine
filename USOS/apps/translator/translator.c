#include <stdio.h>
#include <string.h>

const char* translator_word(const char* word) {
    if (strcmp(word, "hello") == 0) return "hola";
    if (strcmp(word, "world") == 0) return "mundo";
    if (strcmp(word, "goodbye") == 0) return "adios";
    return word;
}

void translator_start() {
    const char* input = "hello world";

    printf("[TRANSLATOR] %s -> %s %s\n", input, translator_word("hello"), translator_word("world"));
}
