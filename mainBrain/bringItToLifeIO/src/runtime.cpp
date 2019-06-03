#include "includeAllStuff.h"

int countForEncoder = 0;
uint32_t countForEasyComm = 0;
unsigned int countForLed7 = 0;
uint8_t countForLed8 = 0;
//uint8_t HOMING_DONE = 0;
void initRuntime(void){
  Timer3.initialize(WORING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  Timer1.attachInterrupt(interruptTimerOne);
  //pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}


//  this shit needs to be adjusted!!!!!!!


void interruptTimerOne(void)
{

  // motorAz.currentPulse++;
  // motorEl.currentPulse++;
  if (motorEl.isControlled)
  {
    if (motorEl.desiredPulse > motorEl.currentPulse) motorEl.currentPulse++;
    if (motorEl.desiredPulse < (motorEl.currentPulse)) motorEl.currentPulse--;
  }

  if (motorAz.isControlled)
  {
    if (motorAz.desiredPulse > motorAz.currentPulse) motorAz.currentPulse++;
    if (motorAz.desiredPulse < (motorAz.currentPulse)) motorAz.currentPulse--;
  }
}

void threadOne(void){
  //digitalWrite(13,1 - digitalRead(13)); //-> blink to see op

  updateEncoder();
  banbangController();
  //updatePos(); -> uncommented af ter attaching the encoder
  if (countForEasyComm >= (10 ))
  {
      //easycommProc(); -> uncommented af after testing the motor
      countForEasyComm = 0;

  }
    else countForEasyComm++;


  if (countForLed8 >= 100)
  {
    countForLed8 = 0;
    updateLed8(led8Byte);
//    extractNumAndUpDateLed7(led7Byte);
  }
  else countForLed8++;

  if (countForLed7 >= 10)
  {
    countForLed7 = 0;
    //updateLed8(led8Byte);
    extractNumAndUpDateLed7(led7Num);
  }
  else countForLed7++;

}
