#include <stdio.h>

int main()
{
    const char *str = "Hello World";

    for (const char* c = str; (*c) != 0; c++)
    {
        printf("%d ", *c);
    }

    printf("\n");

    return 0;
}