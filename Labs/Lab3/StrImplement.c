/*
Implementing strlen and strsep
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
unsigned int myStrlen(char* source)
{
    unsigned int len = 0;
    while (source[len])
    {
        len++;
    }
    return len;
}

char* myStrsep(char** source, char separator)
{
    char *output = *source;
    if (NULL == *source)
    {
        return output;
    }
    while ((**source) != separator && (**source) != 0)
    {
        (*source)+=1;
    }
    if ((**source) == separator)
    {
        **source = '\0';
        *source = *source+1;
    }
    else
    {
        *source = 0;
    }
    
    //*iter = 0;
    return output;
}

int main()
{
    printf("%d\n", myStrlen("123456789"));
    
    printf("%d\n", (int)strlen("123456789"));
    
    char* token;
    char string1[] = "this is a test";
    char* string2 = "this is a test too";
    
    while ((token = myStrsep(&string1, ' ')))
    {
        printf("[%s]", token);
    }

    
    //printf("[%s]",token+15);
    //free(token);
    
    return 0;
}
