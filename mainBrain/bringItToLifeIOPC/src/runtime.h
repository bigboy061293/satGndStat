#ifndef RUNTIME_H
#define RUNTIME_H

#include <Arduino.h>
#include <TimerOne.h>
#include <TimerThree.h>

extern int countForEncoder;
extern uint32_t countForEasyComm;
extern unsigned int countForLed7;
extern uint8_t countForLed8;
extern unsigned long countForEasyCommValid;
extern char inputString[];
extern uint8_t numInputString;
extern boolean stringComplete;
extern boolean letsRead;
//extern uint8_t HOMING_DONE;

extern void initRuntime();
extern void threadOne();
extern void interruptTimerOne();
extern void serialEvent();

#endif
