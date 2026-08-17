#include <stdio.h>
#include <ctype.h>

static int count_words(const char* text) {
    int words = 0;
    int in_word = 0;

    for (const char* p = text; *p; ++p) {
        if (isspace((unsigned char)*p)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            ++words;
        }
    }

    return words;
}

int sentence_count_vowels(const char* text) {
    int vowels = 0;

    for (const char* p = text; *p; ++p) {
        char ch = (char)tolower((unsigned char)*p);
        if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u') {
            ++vowels;
        }
    }

    return vowels;
}

void sentence_analyze(const char* sentence) {
    printf("[SENTENCE_LAB] words=%d vowels=%d\n", count_words(sentence), sentence_count_vowels(sentence));
}

void sentence_lab_start() {
    const char* sentence = "TSM keeps moving forward";
    sentence_analyze(sentence);
}
