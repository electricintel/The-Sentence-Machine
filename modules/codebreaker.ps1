Write-Host "Populating Codebreaker..."

$codebreaker_h = @"
#ifndef USOS_CODEBREAKER_H
#define USOS_CODEBREAKER_H

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

#endif
"@
Set-Content "USOS/apps/codebreaker/codebreaker.h" $codebreaker_h -Encoding UTF8

$codebreaker_c = @"
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "codebreaker.h"

static char decode_morse_token(const char* token) {
    if (strcmp(token, ".-") == 0) return 'A';
    if (strcmp(token, "-...") == 0) return 'B';
    if (strcmp(token, "-.-.") == 0) return 'C';
    if (strcmp(token, "-..") == 0) return 'D';
    if (strcmp(token, ".") == 0) return 'E';
    if (strcmp(token, "..-.") == 0) return 'F';
    if (strcmp(token, "--.") == 0) return 'G';
    if (strcmp(token, "....") == 0) return 'H';
    if (strcmp(token, "..") == 0) return 'I';
    if (strcmp(token, ".---") == 0) return 'J';
    if (strcmp(token, "-.-") == 0) return 'K';
    if (strcmp(token, ".-..") == 0) return 'L';
    if (strcmp(token, "--") == 0) return 'M';
    if (strcmp(token, "-.") == 0) return 'N';
    if (strcmp(token, "---") == 0) return 'O';
    if (strcmp(token, ".--.") == 0) return 'P';
    if (strcmp(token, "--.-") == 0) return 'Q';
    if (strcmp(token, ".-.") == 0) return 'R';
    if (strcmp(token, "...") == 0) return 'S';
    if (strcmp(token, "-") == 0) return 'T';
    if (strcmp(token, "..-") == 0) return 'U';
    if (strcmp(token, "...-") == 0) return 'V';
    if (strcmp(token, ".--") == 0) return 'W';
    if (strcmp(token, "-..-") == 0) return 'X';
    if (strcmp(token, "-.--") == 0) return 'Y';
    if (strcmp(token, "--..") == 0) return 'Z';
    return '?';
}

static void decode_binary_byte(const char* token, char* out) {
    unsigned value = 0;
    for (int i = 0; token[i] && i < 8; ++i) {
        value <<= 1;
        if (token[i] == '1') {
            value |= 1u;
        }
    }
    *out = (char)value;
}

static void decode_hex_pair(const char* token, char* out) {
    unsigned value = 0;
    sscanf(token, "%2x", &value);
    *out = (char)value;
}

static void decode_base64_block(const char* token, char* out, int* count) {
    static const char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    unsigned value = 0;
    int bits = 0;

    for (int i = 0; token[i]; ++i) {
        if (token[i] == '=') {
            break;
        }

        const char* found = strchr(alphabet, token[i]);
        if (!found) {
            continue;
        }

        value = (value << 6) | (unsigned)(found - alphabet);
        bits += 6;

        while (bits >= 8) {
            bits -= 8;
            out[(*count)++] = (char)((value >> bits) & 0xFFu);
        }
    }
}

void cb_init() {
    printf("[CODEBREAKER] Ready.\n");
}

void cb_menu() {
    printf("[CODEBREAKER] Select decoder:\n");
    printf("1. Morse\n");
    printf("2. Caesar\n");
    printf("3. Vigenere\n");
    printf("4. Pigpen\n");
    printf("5. Binary\n");
    printf("6. Hex\n");
    printf("7. ASCII\n");
    printf("8. Base64\n");
}

void cb_run_console() {
    char choice[16];

    cb_menu();
    printf("[CODEBREAKER] Choice: ");
    if (!fgets(choice, sizeof(choice), stdin)) {
        puts("[CODEBREAKER] Input unavailable.");
        return;
    }

    switch (choice[0]) {
        case '1':
            cb_decode_morse(".... . .-.. .-.. ---");
            break;
        case '2':
            cb_decode_caesar("khoor zruog", 3);
            break;
        case '3':
            cb_decode_vigenere("rijvs uyvjn", "key");
            break;
        case '4':
            cb_decode_pigpen("uryyb");
            break;
        case '5':
            cb_decode_binary("01010011 01010100 01001101");
            break;
        case '6':
            cb_decode_hex("54 53 4d");
            break;
        case '7':
            cb_decode_ascii("TSM");
            break;
        case '8':
            cb_decode_base64("VFNN");
            break;
        default:
            puts("[CODEBREAKER] Unknown selection.");
            break;
    }
}

void cb_decode_morse(const char* msg) {
    char decoded[128];
    int index = 0;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1;) {
        while (*p == ' ') {
            ++p;
        }

        char token[8] = {0};
        int token_index = 0;
        while (*p && *p != ' ' && token_index < 7) {
            token[token_index++] = *p++;
        }

        decoded[index++] = decode_morse_token(token);
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] MORSE: %s -> %s\n", msg, decoded);
}

void cb_decode_caesar(const char* msg, int shift) {
    char decoded[128];
    int index = 0;
    int normalized = shift % 26;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1; ++p) {
        char ch = *p;
        if (isalpha((unsigned char)ch)) {
            int base = isupper((unsigned char)ch) ? 'A' : 'a';
            decoded[index++] = (char)(base + (ch - base - normalized + 26) % 26);
        } else {
            decoded[index++] = ch;
        }
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] CAESAR(%d): %s -> %s\n", shift, msg, decoded);
}

void cb_decode_vigenere(const char* msg, const char* key) {
    char decoded[128];
    int index = 0;
    int key_index = 0;
    int key_len = (int)strlen(key);

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1; ++p) {
        char ch = *p;
        if (isalpha((unsigned char)ch) && key_len > 0) {
            int base = isupper((unsigned char)ch) ? 'A' : 'a';
            int key_shift = toupper((unsigned char)key[key_index % key_len]) - 'A';
            decoded[index++] = (char)(base + (ch - base - key_shift + 26) % 26);
            ++key_index;
        } else {
            decoded[index++] = ch;
        }
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] VIGENERE[%s]: %s -> %s\n", key, msg, decoded);
}

void cb_decode_pigpen(const char* msg) {
    char decoded[128];
    int index = 0;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1; ++p) {
        char ch = *p;
        if (isalpha((unsigned char)ch)) {
            decoded[index++] = (char)('A' + ((toupper((unsigned char)ch) - 'A') + 13) % 26);
        } else {
            decoded[index++] = ch;
        }
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] PIGPEN: %s -> %s\n", msg, decoded);
}

void cb_decode_binary(const char* msg) {
    char decoded[128];
    int index = 0;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1;) {
        while (*p == ' ') {
            ++p;
        }

        char token[9] = {0};
        int token_index = 0;
        while (*p && *p != ' ' && token_index < 8) {
            token[token_index++] = *p++;
        }

        decode_binary_byte(token, &decoded[index++]);
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] BINARY: %s -> %s\n", msg, decoded);
}

void cb_decode_hex(const char* msg) {
    char decoded[128];
    int index = 0;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1;) {
        while (*p == ' ') {
            ++p;
        }

        char token[3] = {0};
        int token_index = 0;
        while (*p && *p != ' ' && token_index < 2) {
            token[token_index++] = *p++;
        }

        decode_hex_pair(token, &decoded[index++]);
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] HEX: %s -> %s\n", msg, decoded);
}

void cb_decode_ascii(const char* msg) {
    char decoded[128];
    int index = 0;

    for (const char* p = msg; *p && index < (int)sizeof(decoded) - 1; ++p) {
        decoded[index++] = (char)((unsigned char)*p);
    }

    decoded[index] = '\0';
    printf("[CODEBREAKER] ASCII: %s -> %s\n", msg, decoded);
}

void cb_decode_base64(const char* msg) {
    char decoded[128];
    int index = 0;

    decode_base64_block(msg, decoded, &index);
    decoded[index] = '\0';
    printf("[CODEBREAKER] BASE64: %s -> %s\n", msg, decoded);
}
"@
Set-Content "USOS/apps/codebreaker/codebreaker.c" $codebreaker_c -Encoding UTF8

$decoder_templates = @{
    'morse.c' = @'
#include "codebreaker.h"
'@;
    'caesar.c' = @'
#include "codebreaker.h"
'@;
    'vigenere.c' = @'
#include "codebreaker.h"
'@;
    'pigpen.c' = @'
#include "codebreaker.h"
'@;
    'binary.c' = @'
#include "codebreaker.h"
'@;
    'hex.c' = @'
#include "codebreaker.h"
'@;
    'ascii.c' = @'
#include "codebreaker.h"
'@;
    'base64.c' = @'
#include "codebreaker.h"
'@;
}

foreach ($entry in $decoder_templates.GetEnumerator()) {
    Set-Content (Join-Path "USOS/apps/codebreaker" $entry.Key) $entry.Value -Encoding UTF8
}

Write-Host "Codebreaker populated."