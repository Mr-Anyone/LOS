#include <stdint.h>
#include "screen.h"
#include "font.h"

void putPixel(int x, int y, unsigned char color)
{
    uint16_t offset = (y << 8) + (y<< 6) + x ;
    unsigned char* location = (unsigned char*) 0xA0000 + offset;
    *location = color;
}

static void drawChar(unsigned char* bitMap, uint16_t xOffset, uint16_t yOffset)
{
    for(uint16_t y = 0  ; y<CHARACTER_HEIGHT; ++y)
    {
        for(uint16_t x = 0; x<CHARACTER_WIDTH; ++x)
        {
            if(bitMap[CHARACTER_HEIGHT - y] & (0b1 << (CHARACTER_WIDTH - x)))
            { 
                unsigned char* location = (unsigned char*) 0xA0000 + ((y + yOffset) << 8) + ((y + yOffset)<< 6) + x + xOffset ;
                *location = DEFAULT_FONT_COLOR;
            }
        }
    }
}

void print(const char* string)
{
    static int16_t previousY = 0;
    uint16_t previousX = 0;
    while(*string)
    {
        unsigned char* bitMap = font[(int)(*string) - 32]; 
        drawChar(bitMap, previousX, previousY); 

        previousX += CHARACTER_WIDTH + 1;
        ++string;
    }
    previousY += CHARACTER_HEIGHT;
}

void fillBackground(const char color){
    for(uint16_t x = 0; x<VIDEO_WIDTH; ++x)
    {
        for(uint16_t y=0; y<VIDEO_HEIGHT; ++y)
        {
            uint16_t offset = (y << 8) + (y<< 6) + x ;
            unsigned char* location = (unsigned char*) 0xA0000 + offset;
            *location = color;   
        }
    }
}

void drawBlueBackground()
{
    fillBackground(3);
}


