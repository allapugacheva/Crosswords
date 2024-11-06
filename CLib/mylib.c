#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
#else
    #define EXPORT
#endif

EXPORT const char* getNewMops() {
    return "https://i.ibb.co/wcFdyx9/11.png";
}