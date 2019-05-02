#include "includeAllStuff.h"

int countForEncoder = 0;
uint32_t countForEasyComm = 0;

void initRuntime(void){
  Timer3.initialize(WORING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}


//  this shit needs to be adjusted!!!!!!!



void threadOne(void){
  digitalWrite(13,1 - digitalRead(13)); //-> blink to see op
  updateEncoder();
  updatePos();
  if (countForEasyComm >= (10 ))
  {
      easycommProc();
      countForEasyComm = 0;
  }
  else countForEasyComm++;

}
