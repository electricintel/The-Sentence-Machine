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
