Write-Host "Populating Applications..."

$diagnostics_h = @"
#ifndef USOS_DIAGNOSTICS_H
#define USOS_DIAGNOSTICS_H

void diag_run();

#endif
"@
Set-Content "USOS/apps/diagnostics/diagnostics.h" $diagnostics_h -Encoding UTF8

$diagnostics_c = @"
#include <stdio.h>
#include "diagnostics.h"

void diag_run() {
    printf("[DIAG] Running system diagnostics...\n");
    printf("[DIAG] Kernel OK\n");
    printf("[DIAG] Drivers OK\n");
    printf("[DIAG] Services OK\n");
    printf("[DIAG] UI OK\n");
}
"@
Set-Content "USOS/apps/diagnostics/diagnostics.c" $diagnostics_c -Encoding UTF8

$main_c = @"
#include <stdio.h>
#include <string.h>

void system_init();
void comms_init();
void hud_init();
void ir_init();
void usp_init();
void ui_init();
void diag_run();
void cb_init();
void cb_menu();
void cb_run_console();
void cb_decode_morse(const char* msg);
void cb_decode_caesar(const char* msg, int shift);
void cb_decode_vigenere(const char* msg, const char* key);
void cb_decode_pigpen(const char* msg);
void cb_decode_binary(const char* msg);
void cb_decode_hex(const char* msg);
void cb_decode_ascii(const char* msg);
void cb_decode_base64(const char* msg);
void calc_start();
void clock_start();
void hud_console_start();
void notepad_start();
void terminal_start();
void translator_start();
void sentence_lab_start();
void ui_render_text(const char* msg);
void ui_render_box(int w, int h);
void ui_event(const char* evt);
void terminal_shell();

int main(int argc, char** argv) {
    puts("[USOS] Booting executable...");

    system_init();
    comms_init();
    hud_init();
    ir_init();
    usp_init();
    ui_init();
    diag_run();
    cb_init();

    calc_start();
    clock_start();
    hud_console_start();
    notepad_start();
    terminal_start();
    translator_start();
    sentence_lab_start();

    if (argc > 1 && strcmp(argv[1], "codebreaker") == 0) {
        cb_run_console();
    } else if (argc > 1 && strcmp(argv[1], "shell") == 0) {
        terminal_shell();
    } else {
        cb_menu();
        cb_decode_morse(".... . .-.. .-.. ---");
        cb_decode_caesar("khoor zruog", 3);
        cb_decode_vigenere("rijvs uyvjn", "key");
        cb_decode_pigpen("uryyb");
        cb_decode_binary("01010011 01010100 01001101");
        cb_decode_hex("54 53 4d");
        cb_decode_ascii("TSM");
        cb_decode_base64("VFNN");
    }

    ui_render_text("Boot diagnostics complete");
    ui_render_box(12, 4);
    ui_event("system:boot_complete");
    ui_render_text("Tip: run usos.exe shell for interactive mode");

    puts("[USOS] Boot complete.");
    return 0;
}
"@
Set-Content "USOS/main.c" $main_c -Encoding UTF8

$app_stubs = @{
    "calculator" = @"
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
"@;
    "clock" = @"
#include <stdio.h>
#include <time.h>

int clock_now(char* out, size_t out_size) {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);

    if (!local) {
        return 0;
    }

    return strftime(out, out_size, "%Y-%m-%d %H:%M:%S", local) > 0;
}

void clock_start() {
    char buffer[64];

    if (clock_now(buffer, sizeof(buffer))) {
        printf("[CLOCK] %s\n", buffer);
    } else {
        printf("[CLOCK] Time unavailable.\n");
    }
}
"@;
    "notepad" = @"
#include <stdio.h>
#include <string.h>

static char notebook[128] = "";

void notepad_set(const char* line) {
    strncpy(notebook, line, sizeof(notebook) - 1);
    notebook[sizeof(notebook) - 1] = '\0';
}

const char* notepad_get() {
    return notebook;
}

void notepad_start() {
    notepad_set("hello from notepad");

    printf("[NOTEPAD] Stored note: %s\n", notebook);
}
"@;
    "terminal" = @"
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
"@;
    "translator" = @"
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
"@;
    "sentence_lab" = @"
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
"@;
    "hud_console" = @"
#include <stdio.h>

void hud_console_start() {
    printf("[HUD_CONSOLE] status=online mode=active\n");
}
"@;
}

foreach ($entry in $app_stubs.GetEnumerator()) {
    $appPath = Join-Path "USOS/apps" $entry.Key
    Set-Content (Join-Path $appPath ($entry.Key + ".c")) $entry.Value -Encoding UTF8
}

Write-Host "Applications populated."