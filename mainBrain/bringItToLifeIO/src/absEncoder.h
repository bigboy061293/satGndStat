#ifndef ABSENCODER_H
#define ABSENCODER_H

#include "pinStateConstants.h"

class absEncoder;

class absEncoder{
  private:

    uint8_t pinA, pinB, pinC, pinState;


  public:

    // uint8_t dutyCyle;
    // uint8_t currentPos;
    // uint8_t currentVec;
    uint32_t positionInDegrees=0;
    uint32_t positionInGray;
    uint8_t currentCode[8];
    uint32_t currentCode8bit = 0;
    uint8_t currentCodeGray = 0;
    uint8_t readyToUse = 0; // flag that ready to use
    absEncoder(uint8_t pinA, uint8_t pinB, uint8_t pinC, uint8_t pinState){
      this->pinA = pinA;
      this->pinB = pinB;
      this->pinC = pinC;
      this->pinState = pinState;

      pinMode(this->pinA, OUTPUT);
      pinMode(this->pinB, OUTPUT);
      pinMode(this->pinC, OUTPUT);

      pinMode(this->pinState, INPUT);
      digitalWrite(this->pinState, HIGH);

    }

    void readCurrentCode(uint8_t currentState){
      digitalWrite(this->pinC, (currentState >> 2) & 0x01);
      digitalWrite(this->pinB, (currentState >> 1) & 0x01);
      digitalWrite(this->pinA, (currentState  & 0x01));

      this->currentCode[currentState] = ~digitalRead(this->pinState);
      this->currentCodeGray = this->currentCodeGray &
        ~(0x01 << currentState);

      this->currentCodeGray = this->currentCodeGray |
        (((uint8_t) ~digitalRead(this->pinState)) << currentState);

      if (currentState == 7) {
        this->readyToUse = 1;
        //this->currentCodeGray = 0;
      }


        else this->readyToUse = 0;
    }

    uint8_t convertFromGray(uint8_t codeInGray ){
      uint8_t temp = codeInGray;
      uint8_t mask = (temp >> 1);
        while (mask != 0){
          temp = temp ^ mask;
          mask = mask >> 1;
        }
    return temp;

    }
};

#endif
