#include "includeAllStuff.h"
#include "pinStateConstants.h"

uint16_t temp = 0;
absEncoder encoderEl(PIN_A, PIN_B, PIN_C, PIN_STATE_EL);
absEncoder encoderAz(PIN_A, PIN_B, PIN_C, PIN_STATE_AZ);

void encoderInit(void){
  //digitalWrite(13,1 - digitalRead(13);
}

void updateEncoder(){
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
        // encoderEl.positionInDegrees =
        //   ((uint16_t)encoderEl.convertFromGray((uint16_t)encoderEl.currentCodeGray)) * 360 / 255;
        // encoderAz.positionInDegrees =
        //   ((uint16_t)encoderAz.convertFromGray((uint16_t)encoderAz.currentCodeGray)) * 360 / 255;

        encoderEl.currentCode8bit = (uint32_t)encoderEl.convertFromGray(encoderEl.currentCodeGray);
        encoderAz.currentCode8bit = (uint32_t)encoderAz.convertFromGray(encoderAz.currentCodeGray);

        encoderEl.positionInDegrees = (uint32_t)encoderEl.currentCode8bit * 360 / 255;
        encoderAz.positionInDegrees = (uint32_t)encoderAz.currentCode8bit * 360 / 255;
        //positionInDegrees

        // Serial.print(encoderEl.currentCodeGray,BIN);
        // Serial.print("  |  ");
        // Serial.print(encoderEl.convertFromGray(encoderEl.currentCodeGray),BIN);
        // Serial.print("  |||  ");
        // Serial.print(encoderAz.currentCodeGray);
        // Serial.print("  |  ");
        // Serial.println(encoderAz.convertFromGray(encoderAz.currentCodeGray));

      }
    }
}
