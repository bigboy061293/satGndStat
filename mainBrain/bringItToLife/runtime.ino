#include "controllingAxes.h"

#define WORKING_PERIOD 150000
void initRuntime(void){
  Timer1.initialize(PUL_PERIOD);
  Timer3.initialize(WORKING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}

void threadOne(void){
  digitalWrite(13,1 - digitalRead(13));
}
