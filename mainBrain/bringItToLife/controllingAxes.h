#ifndef controllingAxes_h
#define controllingAxes_h

#include <TimerOne.h>
#include <Arduino.h>

#define PUL_PIN_EL 2
#define PUL_PIN_AZ 4
#define DIR_PIN_EL 3
#define DIR_PIN_AZ 5
#define CW 1
#define CCW 0


//Timer 1: PWM Pin 11 12 13
//Timer 3: PWM Pin 2 3 5

const uint8_t PUL_PERIOD = 1000000; //540 us

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

    void stepMotor::setDutyCycle(int dutyCyle){
      this->dutyCyle = dutyCyle;
      Timer1.pwm(pinPul, (dutyCyle*1023/100));
    }
    void stepMotor::setDutyDir(uint8_t dir){
      if (dir == CW) digitalWrite(this->pinDir, HIGH);
        else digitalWrite(this->pinDir, LOW);
    }
};

#endif
