/*
 * lcdDisplay.c
 *
 *  Created on: 16 thg 3, 2019
 *      Author: Big Boy
 */

#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include "lcdDisplay.h"

/* Definitions for LCD Driver */

/* LCD memory map for numeric digits (Byte Access) */
const char digit[10][4] =
{
    {0xC, 0xF, 0x8, 0x2},  /* "0" LCD segments a+b+c+d+e+f+k+q */
    {0x0, 0x6, 0x0, 0x2},  /* "1" */
    {0xB, 0xD, 0x0, 0x0},  /* "2" */
    {0x3, 0xF, 0x0, 0x0},  /* "3" */
    {0x7, 0x6, 0x0, 0x0},  /* "4" */
    {0x7, 0xB, 0x0, 0x0},  /* "5" */
    {0xF, 0xB, 0x0, 0x0},  /* "6" */
    {0x4, 0xE, 0x0, 0x0},  /* "7" */
    {0xF, 0xF, 0x0, 0x0},  /* "8" */
    {0x7, 0xF, 0x0, 0x0}   /* "9" */
};

/* LCD memory map for uppercase letters (Byte Access) */
const char alphabetBig[26][4] =
{
    {0xF, 0xE, 0x0, 0x0},  /* "A" LCD segments a+b+c+e+f+g+m */
    {0x1, 0xF, 0x0, 0x5},  /* "B" */
    {0xC, 0x9, 0x0, 0x0},  /* "C" */
    {0x0, 0xF, 0x0, 0x5},  /* "D" */
    {0xF, 0x9, 0x0, 0x0},  /* "E" */
    {0xF, 0x8, 0x0, 0x0},  /* "F" */
    {0xD, 0xB, 0x0, 0x0},  /* "G" */
    {0xF, 0x6, 0x0, 0x0},  /* "H" */
    {0x0, 0x9, 0x0, 0x5},  /* "I" */
    {0x8, 0x7, 0x0, 0x0},  /* "J" */
    {0xE, 0x0, 0x2, 0x2},  /* "K" */
    {0xC, 0x1, 0x0, 0x0},  /* "L" */
    {0xC, 0x6, 0x0, 0xA},  /* "M" */
    {0xC, 0x6, 0x2, 0x8},  /* "N" */
    {0xC, 0xF, 0x0, 0x0},  /* "O" */
    {0xF, 0xC, 0x0, 0x0},  /* "P" */
    {0xC, 0xF, 0x2, 0x0},  /* "Q" */
    {0xF, 0xC, 0x2, 0x0},  /* "R" */
    {0x7, 0xB, 0x0, 0x0},  /* "S" */
    {0x0, 0x8, 0x0, 0x5},  /* "T" */
    {0xC, 0x7, 0x0, 0x0},  /* "U" */
    {0xC, 0x0, 0x8, 0x2},  /* "V" */
    {0xC, 0x6, 0xA, 0x0},  /* "W" */
    {0x0, 0x0, 0xA, 0xA},  /* "X" */
    {0x0, 0x0, 0x0, 0xB},  /* "Y" */
    {0x0, 0x9, 0x8, 0x2}   /* "Z" */
};
LCD_F_Config lcdConf =
{
    .clockSource = LCD_F_CLOCKSOURCE_ACLK,
    .clockDivider = LCD_F_CLOCKDIVIDER_32,
    .clockPrescaler = LCD_F_CLOCKPRESCALER_1,
    .muxRate = LCD_F_4_MUX,
    .waveforms = LCD_F_STANDARD_WAVEFORMS,
    .segments = LCD_F_SEGMENTS_ENABLED
};


void lcdInit()
{
    /* Initializing all of the function selection bits in the pins */
        P3->SEL1 |= 0xF2;
        P6->SEL1 |= 0x0C;
        P7->SEL1 |= 0xF0;
        P8->SEL1 |= 0xFC;
        P9->SEL1 |= 0xFF;
        P10->SEL1 |= 0x3F;

        /* Setting ACLK to the reference oscillator */
        CS_initClockSignal(CS_ACLK, CS_REFOCLK_SELECT, CS_CLOCK_DIVIDER_1);

        /* Initializing the LCD_F module */
        LCD_F_initModule(&lcdConf);

        /* Clearing out all memory */
        LCD_F_clearAllMemory();

        /* Initializing all of our pins and setting the relevant COM lines */
        LCD_F_setPinsAsLCDFunction(LCD_F_SEGMENT_LINE_0, LCD_F_SEGMENT_LINE_3);
        LCD_F_setPinAsLCDFunction(LCD_F_SEGMENT_LINE_6);
        LCD_F_setPinsAsLCDFunction(LCD_F_SEGMENT_LINE_16, LCD_F_SEGMENT_LINE_19);
        LCD_F_setPinsAsLCDFunction(LCD_F_SEGMENT_LINE_26, LCD_F_SEGMENT_LINE_47);
        LCD_F_setPinAsCOM(LCD_F_SEGMENT_LINE_26, LCD_F_MEMORY_COM0);
        LCD_F_setPinAsCOM(LCD_F_SEGMENT_LINE_27, LCD_F_MEMORY_COM1);
        LCD_F_setPinAsCOM(LCD_F_SEGMENT_LINE_6, LCD_F_MEMORY_COM2);
        LCD_F_setPinAsCOM(LCD_F_SEGMENT_LINE_3, LCD_F_MEMORY_COM3);

        /* Turing the LCD_F module on */
        LCD_F_turnOn();
}


void showChar(char c, int position)
{
    uint8_t ii;
    if (c == ' ')
    {
        for (ii=0; ii<4; ii++)
        {
            LCD_F->M[position+ii] |= 0x00;
        }
    }
    else if (c >= '0' && c <= '9')
    {
        for (ii=0; ii<4; ii++)
        {
            LCD_F->M[position+ii] |= digit[c-48][ii];
        }
    }
    else if (c >= 'A' && c <= 'Z')
    {
        for (ii=0; ii<4; ii++)
        {
            LCD_F->M[position+ii] |= alphabetBig[c-65][ii];
        }
    } else
    {
        LCD_F->M[position] = 0xFF;
    }
}



