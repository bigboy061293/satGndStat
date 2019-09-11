#include "includeAllStuff.h"

int countForEncoder = 0;
uint32_t countForEasyComm = 0;
unsigned int countForLed7 = 0;
uint8_t countForLed8 = 0;
unsigned long countForEasyCommValid = 0;

char inputString[50] = "";
uint8_t numInputString = 0;
boolean stringComplete = false;
boolean letsRead = false;

//uint8_t HOMING_DONE = 0;
void initRuntime(void){
  Timer3.initialize(WORING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  Timer1.attachInterrupt(interruptTimerOne);
  //pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}


//  this shit needs to be adjusted!!!!!!!


void serialEvent(){
  char inChar;

  while(Serial.available() > 0)
  {

   inChar  = Serial.read();
   // numInputString+=1;
   // inputString[numInputString] = inChar;
   //
   // if (inChar == '#')
   // {
   //   stringComplete = true;
   //   numInputString = 0;
   // }
   if ((inChar == '*') && (letsRead == false))
   {
     letsRead = true;
     stringComplete = false;

     inputString[numInputString] = inChar;
     numInputString = 1;
   }
   else
   if ((inChar == '#') && (letsRead == true))
    {

      inputString[numInputString] = inChar;


      stringComplete = true;
      letsRead = false;

    }
    else
    if (letsRead == true)
    {
      inputString[numInputString] = inChar;
      numInputString += 1;
    }

  }



}

void interruptTimerOne(void)
{
//  serialEvent();
  // motorAz.currentPulse++;
  // motorEl.currentPulse++;

  if (motorEl.isControlled)
  {
    if ((motorEl.desiredPulse > motorEl.currentPulse) && (motorEl.desiredPulse >= 0) && (motorEl.currentPulse >= 0)) motorEl.currentPulse++;
    if ((motorEl.desiredPulse < motorEl.currentPulse) && (motorEl.desiredPulse >= 0) && (motorEl.currentPulse >= 0)) motorEl.currentPulse--;
  }

  if (motorAz.isControlled)
  {
    if ((motorAz.desiredPulse > motorAz.currentPulse) && (motorAz.desiredPulse >= 0) && (motorAz.currentPulse >= 0)) motorAz.currentPulse++;
    if ((motorAz.desiredPulse < motorAz.currentPulse) && (motorAz.desiredPulse >= 0) && (motorAz.currentPulse >= 0)) motorAz.currentPulse--;
  }



}

void threadOne(void){
  //digitalWrite(13,1 - digitalRead(13)); //-> blink to see op

  updateEncoder();
  banbangController();
  //updatePos(); -> uncommented af ter attaching the encoder
  // if (Serial2.available())
  // {
  //
  //     //countForEasyComm = 0;
  // }
  //
  // if (countForEasyComm >= TIME_OUT_EASYCOMM )
  // {
  //     //easycommProc();// -> uncommented af after testing the motor
  //      countForEasyComm = 0;
  //
  //
  //
  // }
  //   else countForEasyComm++;

  if (countForEasyCommValid > 10000)
  {
    easyCommIIIValid = false;
    countForEasyCommValid = 10000;
  }
  else countForEasyCommValid++;


  if (countForLed8 >= 100)
  {
    countForLed8 = 0;
    updateLed8(led8Byte);
//    extractNumAndUpDateLed7(led7Byte);
  }
  else countForLed8++;
  //
  // if (countForLed7 >= 10)
  // {
  //   countForLed7 = 0;
  //   //updateLed8(led8Byte);
  //   extractNumAndUpDateLed7(led7Num);
  // }
  // else countForLed7++;

}
