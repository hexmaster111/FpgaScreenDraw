#include <stdio.h>
#include <memory.h>

#define WIDTH 100
#define HEIGHT 50

int main()
{
    char array[WIDTH * HEIGHT] = {0};
    memcpy(array, "0 Hello world!", strlen("0 Hello world!"));
    memcpy(array + WIDTH, "1 Hello world!", strlen("1 Hello world!"));
    memcpy(array + WIDTH * 2, "2 Hello world!", strlen("2 Hello world!"));

    int x = 2,
        y = 1;

    char c = array[y * WIDTH + x];
    putchar(c);
}