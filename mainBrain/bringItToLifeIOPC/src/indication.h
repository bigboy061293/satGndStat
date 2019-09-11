#ifndef INDICATION_H
#define INDICATION_H
#include "includeAllStuff.h"
extern void initIndication();

extern void updateLed7(uint8_t byteX);
extern void updateLed8(uint8_t byteX);

//uint8_t byteToLED7(unsigned int numIn);
extern uint8_t led8Byte;
extern uint8_t led7Byte;
extern unsigned int led7Num;
extern void extractNumAndUpDateLed7(unsigned int numIn);

#endif
