#include "includeAllStuff.h"

 //Timer 1: PWM Pin 11 12 13
 //Timer 3: PWM Pin 2 3 5

 stepMotor motorEl(PUL_PIN_EL, DIR_PIN_EL);
 stepMotor motorAz(PUL_PIN_AZ, DIR_PIN_AZ);
void initAxesControling(void){

  Timer1.initialize(PUL_PERIOD);


  pinMode(DIR_PIN_AZ,OUTPUT);
  pinMode(DIR_PIN_EL,OUTPUT);

  digitalWrite(DIR_PIN_AZ,LOW);
  digitalWrite(DIR_PIN_EL,LOW);
   //
   motorEl.setDutyCycle(0);
   motorAz.setDutyCycle(0);
}

void updatePos(void){ // bang bang controller
  if (motorAz.posControl == 1)
  {
    if (encoderAz.positionInDegrees > (motorAz.posInDregree + AZ_TOLERANCE))
      motorAz.setSpeed(1023,CW);
    else
    if (encoderAz.positionInDegrees < (motorAz.posInDregree - AZ_TOLERANCE))
      motorAz.setSpeed(1023,CCW);
    else
      {
        motorAz.stop();
        motorAz.posControl = 0;
      }
  }
  else
  {
    motorAz.stop();
  }



  if (motorEl.posControl == 1)
  {
    if (encoderEl.positionInDegrees > (motorEl.posInDregree + EL_TOLERANCE))
      motorEl.setSpeed(1023,CW);
    else
    if (encoderEl.positionInDegrees < (motorEl.posInDregree - EL_TOLERANCE))
      motorEl.setSpeed(1023,CCW);
    else
      {
        motorEl.stop();
        motorEl.posControl = 0;
      }
  }
  else
  {
    motorEl.stop();
  }



}
