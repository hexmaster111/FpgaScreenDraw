#ifndef CIRCUIT_TOOLS_H
#define CIRCUIT_TOOLS_H

#include <raylib.h>
#include <raymath.h>
#include <stdint.h>
#include <unistd.h>
#include <stdbool.h>

void GuiText(int x, int y, const char *text, Color color);
Vector2 GuiMeasureText(const char *text);
bool GuiButton(int x, int y, const char *label);
bool GuiToggleButton(int x, int y, const char *label, bool *state);

typedef struct BusTrace
{
    uint64_t *data;
    int len, cap;
} BusTrace;
void TraceAppend(BusTrace *t, uint64_t value);
bool TraceDraw(const char *label, int x, int y, int64_t data, int bits, BusTrace *trace, int64_t *outdata);
#endif // CIRCUIT_TOOLS_H

#ifdef CIRCUIT_TOOLS_IMPL
#undef CIRCUIT_TOOLS_IMPL

int g_fontsize = 24;
const float g_gui_line_thickness = 2.0f;

void GuiText(int x, int y, const char *text, Color color) { DrawText(text, x, y, g_fontsize, color); }
Vector2 GuiMeasureText(const char *text) { return MeasureTextEx(GetFontDefault(), text, g_fontsize, 5.0f); }

bool GuiButton(int x, int y, const char *label)
{
    Vector2 size = GuiMeasureText(label);
    Rectangle rec = {(float)x, (float)y, size.x, size.y};

    bool hovered = CheckCollisionPointRec(GetMousePosition(), rec);
    bool clicked = hovered && IsMouseButtonReleased(MOUSE_LEFT_BUTTON);
    bool mayClick = hovered && IsMouseButtonDown(MOUSE_LEFT_BUTTON);

    DrawRectangleRec(rec, mayClick ? BLUE : GRAY);
    DrawRectangleLinesEx(rec, g_gui_line_thickness, hovered ? WHITE : GRAY);
    DrawText(label, x + g_gui_line_thickness, y, g_fontsize, clicked ? WHITE : BLACK);

    return clicked;
}

bool GuiToggleButton(int x, int y, const char *label, bool *state)
{
    Vector2 size = GuiMeasureText(label);
    Rectangle rec = {(float)x, (float)y, size.x + g_fontsize, size.y};
    Rectangle checkbox = {(float)x + .5f * g_gui_line_thickness, (float)y + .5f * g_gui_line_thickness,
                          g_fontsize - .5f * g_gui_line_thickness, g_fontsize - .5f * g_gui_line_thickness};

    bool hovered = CheckCollisionPointRec(GetMousePosition(), rec);
    bool clicked = hovered && IsMouseButtonReleased(MOUSE_LEFT_BUTTON);
    bool mayClick = hovered && IsMouseButtonDown(MOUSE_LEFT_BUTTON);

    DrawRectangleRec(rec, mayClick ? BLUE : GRAY);
    DrawRectangleLinesEx(rec, g_gui_line_thickness, hovered ? WHITE : GRAY);
    DrawRectangleLinesEx(checkbox, g_gui_line_thickness, YELLOW);

    if (*state)
    {
        DrawLineEx((Vector2){checkbox.x, checkbox.y}, (Vector2){checkbox.x + checkbox.width, checkbox.y + checkbox.height}, g_gui_line_thickness, YELLOW);
        DrawLineEx((Vector2){checkbox.x + checkbox.width, checkbox.y}, (Vector2){checkbox.x, checkbox.y + checkbox.height}, g_gui_line_thickness, YELLOW);
    }

    DrawText(label, x + g_gui_line_thickness + checkbox.width, y, g_fontsize, clicked ? WHITE : BLACK);

    if (clicked)
        *state = !(*state);

    return clicked;
}

void TraceAppend(BusTrace *t, uint64_t value)
{
    if (t->len + 1 > t->cap)
    {
        int newlen = (t->cap * 2) + 1;
        uint64_t *newData = (uint64_t *)realloc(t->data, sizeof(uint64_t) * newlen);
        assert(newData != NULL);
        t->cap = newlen;
        t->data = newData;
    }

    t->data[t->len] = value;
    t->len += 1;
}

bool TraceDraw(const char *label, int x, int y, int64_t data, int bits, BusTrace *trace, int64_t *outdata)
{
    const int trace_width = g_fontsize / 2;
    const int padding = 4;
    bool ret = false;

    for (size_t i = 0; i < bits; i++)
    {
        bool on = data & (1 << i);

        if (GuiButton(x, y + (i + 1) * g_fontsize, "B"))
        {
            if (outdata)
                *outdata ^= (1 << i); // Toggle the bit

                ret = true;
        }

        DrawRectangle(x,
                      y + (i + 1) * g_fontsize,
                      g_fontsize,
                      g_fontsize,
                      on ? YELLOW : GRAY);

        DrawText(TextFormat("%d", i), x, y + (i + 1) * g_fontsize, g_fontsize, on ? BLACK : WHITE);
    }

    GuiText(x, y, TextFormat("%s : %u",label, data), WHITE);

    if (!trace || !trace->data)
        return ret;

    Vector2 trace_start = {x + g_fontsize, y + g_fontsize * 2};

    for (size_t bit = 0; bit < bits; bit++)
    {
        bool last_state = false;
        Vector2 last_point = Vector2Add(trace_start, (Vector2){trace_width * 0, g_fontsize * bit});

        for (size_t i = 0; i < trace->len; i++)
        {
            bool on = trace->data[i] & (1 << bit);

            Vector2 zeropos = Vector2Add(trace_start, (Vector2){trace_width * i, g_fontsize * bit});
            Vector2 oneepos = Vector2Subtract(zeropos, (Vector2){0, g_fontsize - padding});

            zeropos.y -= padding;
            oneepos.y += padding;

            DrawLineV(last_point, on ? oneepos : zeropos, GREEN);

            last_point = on ? oneepos : zeropos;
            last_state = on;
        }
    }
    return ret;
}

#endif // CIRCUIT_TOOLS_IMPL