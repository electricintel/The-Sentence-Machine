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

    puts("[USOS] Boot complete.");
    return 0;
}
"@
Set-Content "USOS/main.c" $main_c -Encoding UTF8

$app_stubs = @{
    "calculator" = @"
#include <stdio.h>

void calc_start() {
    int left = 7;
    int right = 6;
    int sum = left + right;
    int product = left * right;

    printf("[CALC] %d + %d = %d\n", left, right, sum);
    printf("[CALC] %d * %d = %d\n", left, right, product);
}
"@;
    "clock" = @"
#include <stdio.h>
#include <time.h>

void clock_start() {
    time_t now = time(NULL);
    struct tm* local = localtime(&now);
    char buffer[64];

    if (local && strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", local)) {
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

void notepad_start() {
    const char* line = "hello from notepad";
    strncpy(notebook, line, sizeof(notebook) - 1);
    notebook[sizeof(notebook) - 1] = '\0';

    printf("[NOTEPAD] Stored note: %s\n", notebook);
}
"@;
    "terminal" = @"
#include <stdio.h>
#include <string.h>

void terminal_start() {
    const char* command = "help";

    printf("[TERMINAL] > %s\n", command);
    if (strcmp(command, "help") == 0) {
        printf("[TERMINAL] Available commands: help, echo, exit\n");
    }
}
"@;
    "translator" = @"
#include <stdio.h>
#include <string.h>

static const char* translate_word(const char* word) {
    if (strcmp(word, "hello") == 0) return "hola";
    if (strcmp(word, "world") == 0) return "mundo";
    if (strcmp(word, "goodbye") == 0) return "adios";
    return word;
}

void translator_start() {
    const char* input = "hello world";

    printf("[TRANSLATOR] %s -> %s %s\n", input, translate_word("hello"), translate_word("world"));
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

void sentence_lab_start() {
    const char* sentence = "TSM keeps moving forward";
    int vowels = 0;

    for (const char* p = sentence; *p; ++p) {
        char ch = (char)tolower((unsigned char)*p);
        if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u') {
            ++vowels;
        }
    }

    printf("[SENTENCE_LAB] words=%d vowels=%d\n", count_words(sentence), vowels);
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