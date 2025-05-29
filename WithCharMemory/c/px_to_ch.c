#include <stdio.h>
#include <string.h>

#define char_w 4
#define char_h 8
#define scr_w 640
#define scr_h 480
#define CH_H (scr_h / char_h)
#define CH_W (scr_w / char_w)

int main()
{
    char screen_data[CH_W * CH_H] = {"Hello world"};
    memcpy(screen_data + CH_W, "Other World", strlen("Other World"));

    for (size_t i = 0; i < 11 * char_w; i++)
    {
        int px = 0, py = 0;
        
        int ch = (py / char_h) * CH_W + (px / char_w);
        char c = screen_data[ch];

        printf("pw: %d, ph: %d, ch: %d, '%c'\n", px, py, ch, c);
    }
}