#ifndef __LCDDISPLAY_H_
#define __LCDDISPLAY_H_


#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>
#include <ti/devices/msp432p4xx/inc/msp.h>

#define char1 16    // Digit A1 - L16
#define char2 32    // Digit A2 - L32
#define char3 40    // Digit A3 - L40
#define char4 36    // Digit A4 - L36
#define char5 28    // Digit A5 - L28
#define char6 44    // Digit A6 - L44


extern void lcdInit();
extern void showChar(char c, int position);

#ifdef __cplusplus
}
#endif

#endif
