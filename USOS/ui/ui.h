#ifndef USOS_UI_H
#define USOS_UI_H

void ui_init();
void ui_render_text(const char* msg);
void ui_render_box(int w, int h);
void ui_event(const char* evt);

#endif
