#include "includeAllStuff.h"

int countForEncoder = 0;



void initRuntime(void){


  Timer3.initialize(WORING_PERIOD);
  Timer3.attachInterrupt(threadOne);

  pinMode(13, OUTPUT);
  //digitalWrite(13,1 - digitalRead(13);
}

void threadOne(void){

  digitalWrite(13,1 - digitalRead(13));

  if (countForEncoder < 8)
    {
      encoderEl.readCurrentCode(countForEncoder);
      encoderAz.readCurrentCode(countForEncoder);
      countForEncoder++;
    }
    else
    {
      countForEncoder = 0;

      if (encoderEl.readyToUse == 1){
        //for (int i = 0; i < 8; i++) Serial.print(encoderEl.currentCode[i]);
        Serial.print(encoderEl.currentCodeGray,BIN);
        Serial.print("  |  ");
        Serial.print(encoderEl.convertFromGray(encoderEl.currentCodeGray),BIN);
        Serial.print("  |||  ");
        Serial.print(encoderAz.currentCodeGray,BIN);
        Serial.print("  |  ");
        Serial.println(encoderAz.convertFromGray(encoderAz.currentCodeGray),BIN);

      }
    }
}
