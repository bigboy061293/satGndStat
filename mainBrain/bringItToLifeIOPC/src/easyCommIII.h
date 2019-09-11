#ifndef EASYCOMMIII_H
#define EASYCOMMIII_H
#include  <Arduino.h>
// #define EASY_COMM

extern void easycommInit();
//extern void easycommProcOlder();
//extern void easycommProcOld();
extern void easycommProc();
bool isNumber(char *input);
extern bool easyCommIIIValid;


#endif
