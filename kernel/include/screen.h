#ifndef SCREEN_H
#define SCREEN_H

// video mode 0x13 
#define VIDEO_WIDTH     320
#define VIDEO_HEIGHT    200
#define VGA_MODE        0x13

// going to write a printf functions later on
void putPixel(int x, int y, unsigned char color);

void print(const char* string);
void drawBlueBackground(); 
void fillBackground(const char color);

#endif