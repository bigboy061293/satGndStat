#ifndef RUNTIME_H
#define RUNTIME_H

#include <Arduino.h>
#include <TimerOne.h>
#include <TimerThree.h>

extern int countForEncoder;
extern uint32_t countForEasyComm;
extern unsigned int countForLed7;
extern uint8_t countForLed8;
//extern uint8_t HOMING_DONE;


extern void initRuntime();
extern void threadOne();
extern void interruptTimerOne();

#endif