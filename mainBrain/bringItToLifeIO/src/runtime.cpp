#include "includeAllStuff.h"

int countForEncoder = 0;

void initRuntime(void){
  Timer3.initialize(WORING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}


//  this shit needs to be adjusted!!!!!!!



void threadOne(void){
  digitalWrite(13,1 - digitalRead(13));
  updateEncoder();
  updatePos();

}
