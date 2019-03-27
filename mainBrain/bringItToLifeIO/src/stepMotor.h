#ifndef STEPMOTOR_H
#define STEPMOTOR_H

#include "includeAllStuff.h"
#include "pinStateConstants.h"

class stepMotor;
class stepMotor{
  private:
    uint8_t pinDir;
    uint8_t pinPul;

  public:

    uint8_t dutyCyle;
    uint8_t currentPos;
    uint8_t currentVec;

    stepMotor(uint8_t pinPul, uint8_t pinDir){
      this->pinDir = pinDir;
      this->pinPul = pinPul;
    }

    void setDutyCycle(int dutyCyle){
      this->dutyCyle = dutyCyle;
      Timer1.pwm(pinPul, (dutyCyle*1023/100));
    }
    void setDutyDir(uint8_t dir){
      if (dir == CW) digitalWrite(this->pinDir, HIGH);
        else digitalWrite(this->pinDir, LOW);
    }
};

#endif
