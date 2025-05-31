#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "font.c"
#define FRAME_HEIGHT (SPLEEN_6X12_FRAME_HEIGHT)
#define FRAME_WIDTH (SPLEEN_6X12_FRAME_WIDTH)
#define FONT_ARRAY (spleen_6x12_data)


int main(int argc, char *argv[])
{

    if (2 > argc)
    {
        fprintf(stderr, "USAGE: %s <foutputname.ext>", argv[0]);
        return 1;
    }

    FILE *output = fopen(argv[1], "w");

    if (output == NULL)
    {
        perror("fopen");
        return 1;
    }

#define CHECK(FN) if(0>(FN)) return -1

                // if(0>fputc(is_px_on(i, x, y) ? '1' : '0', output)) return -1;
    for (size_t i = 0; i < 127 - 33; i++)
    {
        // uint32_t w = miniwi_char(i);
        for (size_t y = 0; y < FRAME_HEIGHT; y++)
        {
            for (size_t x = 0; x < FRAME_WIDTH; x++)
            {
                int biton = FONT_ARRAY[i][(FRAME_HEIGHT - 1 - y) * FRAME_WIDTH + (FRAME_WIDTH - 1 - x)];

                CHECK(fputc(biton ? '1' : '0', output));
            }
            // CHECK(fputc('\n', output));
        }
        CHECK(fputc('\n', output));
    }

    fclose(output);
    puts("- font written");

    return 0;
}
