#ifndef RUNTIME_H
#define RUNTIME_H

#include <Arduino.h>
#include <TimerOne.h>
#include <TimerThree.h>

extern int countForEncoder;

extern void initRuntime();
extern void threadOne();


#endif
