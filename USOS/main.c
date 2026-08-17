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
