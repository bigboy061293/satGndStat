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
    uint16_t posInDregree;
    uint8_t posControl;
    unsigned long currentPulse;
    unsigned long desiredPulse;
    unsigned long differentialPulse;
    uint8_t isControlled = 0;
    uint8_t homingDone = 0;
    stepMotor(uint8_t pinPul, uint8_t pinDir){
      this->pinDir = pinDir;
      this->pinPul = pinPul;
      posInDregree = 90;
      posControl = 0;

      currentPulse = 0;
      desiredPulse = 0;
      differentialPulse = 0;
    }
    void setDutyCycle(int dutyCyle){
      this->dutyCyle = dutyCyle;
      Timer1.pwm(pinPul, (dutyCyle*1023/100));
    }
    void setDir(uint8_t dir){
      if (dir == CW) digitalWrite(this->pinDir, LOW);
        else digitalWrite(this->pinDir, HIGH);
    }

    void setSpeed(int speed, int dir){
        this->setDir(dir);
        Timer1.pwm(pinPul, speed);
      }

    void stop(){
        //this->setDir(dir);
        Timer1.pwm(pinPul, 0);
    }
    // void setPos(uint16_t posInDregree){
    //
    // }


};

#endif
