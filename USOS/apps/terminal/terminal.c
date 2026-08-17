#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int calc_add(int left, int right);
int calc_mul(int left, int right);
int clock_now(char* out, size_t out_size);
void notepad_set(const char* line);
const char* notepad_get();
const char* translator_word(const char* word);
void sentence_analyze(const char* text);
void diag_run();
void ui_event(const char* evt);
void cb_decode_morse(const char* msg);
void cb_decode_caesar(const char* msg, int shift);
void cb_decode_vigenere(const char* msg, const char* key);
void cb_decode_pigpen(const char* msg);
void cb_decode_binary(const char* msg);
void cb_decode_hex(const char* msg);
void cb_decode_ascii(const char* msg);
void cb_decode_base64(const char* msg);

static int shell_command_count = 0;

static void codebreaker_demo_for_mode(int mode) {
    switch (mode) {
        case 1: cb_decode_morse(".... . .-.. .-.. ---"); break;
        case 2: cb_decode_caesar("khoor zruog", 3); break;
        case 3: cb_decode_vigenere("rijvs uyvjn", "key"); break;
        case 4: cb_decode_pigpen("uryyb"); break;
        case 5: cb_decode_binary("01010011 01010100 01001101"); break;
        case 6: cb_decode_hex("54 53 4d"); break;
        case 7: cb_decode_ascii("TSM"); break;
        case 8: cb_decode_base64("VFNN"); break;
        default: printf("[TERMINAL] Unknown codebreaker mode. Use 1-8.\n"); break;
    }
}

void terminal_start() {
    printf("[TERMINAL] Run with 'usos.exe shell' for interactive commands.\n");
}

void terminal_shell() {
    char line[256];

    printf("[TSM-SHELL] Interactive mode ready. Type 'help' or 'exit'.\n");

    while (1) {
        printf("[TSM-SHELL:%d] > ", ++shell_command_count);

        if (!fgets(line, sizeof(line), stdin)) {
            printf("\n[TSM-SHELL] Input stream closed.\n");
            break;
        }

        line[strcspn(line, "\r\n")] = '\0';

        if (line[0] == '\0') {
            continue;
        }

        if (strcmp(line, "help") == 0) {
            puts("[TSM-SHELL] Commands:");
            puts("  help");
            puts("  clock");
            puts("  calc <a> <b>");
            puts("  note set <text>");
            puts("  note show");
            puts("  translate <word>");
            puts("  sentence <text>");
            puts("  codebreaker <1-8>");
            puts("  diag");
            puts("  ui <event>");
            puts("  exit");
        } else if (strcmp(line, "clock") == 0) {
            char buffer[64];
            if (clock_now(buffer, sizeof(buffer))) {
                printf("[TSM-SHELL] CLOCK: %s\n", buffer);
            } else {
                puts("[TSM-SHELL] CLOCK: unavailable");
            }
        } else if (strncmp(line, "calc ", 5) == 0) {
            int left = 0;
            int right = 0;
            if (sscanf(line + 5, "%d %d", &left, &right) == 2) {
                printf("[TSM-SHELL] CALC add=%d mul=%d\n", calc_add(left, right), calc_mul(left, right));
            } else {
                puts("[TSM-SHELL] Usage: calc <a> <b>");
            }
        } else if (strncmp(line, "note set ", 9) == 0) {
            notepad_set(line + 9);
            printf("[TSM-SHELL] NOTE saved: %s\n", notepad_get());
        } else if (strcmp(line, "note show") == 0) {
            printf("[TSM-SHELL] NOTE: %s\n", notepad_get());
        } else if (strncmp(line, "translate ", 10) == 0) {
            const char* word = line + 10;
            printf("[TSM-SHELL] TRANSLATE %s -> %s\n", word, translator_word(word));
        } else if (strncmp(line, "sentence ", 9) == 0) {
            sentence_analyze(line + 9);
        } else if (strncmp(line, "codebreaker ", 12) == 0) {
            int mode = atoi(line + 12);
            codebreaker_demo_for_mode(mode);
        } else if (strcmp(line, "diag") == 0) {
            diag_run();
        } else if (strncmp(line, "ui ", 3) == 0) {
            ui_event(line + 3);
        } else if (strcmp(line, "exit") == 0 || strcmp(line, "quit") == 0) {
            puts("[TSM-SHELL] Bye.");
            break;
        } else {
            puts("[TSM-SHELL] Unknown command. Type 'help'.");
        }
    }
}
