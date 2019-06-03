#include "includeAllStuff.h"

 //Timer 1: PWM Pin 11 12 13
 //Timer 3: PWM Pin 2 3 5

 stepMotor motorEl(PUL_PIN_EL, DIR_PIN_EL);
 //stepMotor motorAzz(12, 13);
 //stepMotor5Phase motorAz(PUL_PIN_AZ_1, PUL_PIN_AZ_2);
stepMotor motorAz(PUL_PIN_AZ, DIR_PIN_AZ);
void initAxesControling(void){

  Timer1.initialize(PUL_PERIOD);


  //pinMode(DIR_PIN_AZ,OUTPUT);
  pinMode(DIR_PIN_EL,OUTPUT);
  //pinMode(PUL_PIN_AZ_1,OUTPUT);
  pinMode(DIR_PIN_AZ,OUTPUT);
  //pinMode(PUL_PIN_AZ_1,OUTPUT);
  //pinMode(PUL_PIN_AZ_2,OUTPUT);

  //digitalWrite(DIR_PIN_AZ,LOW);
  //digitalWrite(PUL_PIN_AZ_1,LOW);
  //digitalWrite(PUL_PIN_AZ_2,LOW);
  digitalWrite(DIR_PIN_EL,LOW);
  digitalWrite(DIR_PIN_AZ,LOW);
   //
   motorEl.setDutyCycle(0);
   //motorAz.setDutyCycle(0);
   //motorAz.setSpeedCW(0);
}
void banbangController(void)
{
  if (motorEl.homingDone)
  {
  if (motorEl.desiredPulse > (motorEl.currentPulse))
  {
      //motorEl.differentialPulse = (motorEl.desiredPulse - motorEl.currentPulse);
      //if (motorEl.differentialPulse)

      motorEl.setSpeed(1023,CCW_E);
  }
  else
  if (motorEl.desiredPulse < (motorEl.currentPulse))
  {
    motorEl.setSpeed(1023,CW_E);
  }
  else
  motorEl.stop();
  }


  if (motorAz.homingDone)
  {
  if (motorAz.desiredPulse > (motorAz.currentPulse))
  {
      //motorEl.differentialPulse = (motorEl.desiredPulse - motorEl.currentPulse);
      //if (motorEl.differentialPulse)

      motorAz.setSpeed(1023,CCW);
  }
  else
  if (motorAz.desiredPulse < (motorAz.currentPulse))
  {
    motorAz.setSpeed(1023,CW);
  }
  else
  motorAz.stop();
  }
}

void updatePos(void){ // bang bang controller
  // if (motorAz.posControl == 1)
  // {
  //   if (encoderAz.positionInDegrees > (motorAz.posInDregree + AZ_TOLERANCE))
  //     motorAz.setSpeed(1023,CW);
  //   else
  //   if (encoderAz.positionInDegrees < (motorAz.posInDregree - AZ_TOLERANCE))
  //     motorAz.setSpeed(1023,CCW);
  //   else
  //     {
  //       motorAz.stop();
  //       motorAz.posControl = 0;
  //     }
  // }
  // else
  // {
  //   motorAz.stop();
  // }
  //
  //
  //
  // if (motorEl.posControl == 1)
  // {
  //   if (encoderEl.positionInDegrees > (motorEl.posInDregree + EL_TOLERANCE))
  //     motorEl.setSpeed(1023,CW);
  //   else
  //   if (encoderEl.positionInDegrees < (motorEl.posInDregree - EL_TOLERANCE))
  //     motorEl.setSpeed(1023,CCW);
  //   else
  //     {
  //       motorEl.stop();
  //       motorEl.posControl = 0;
  //     }
  // }
  // else
  // {
  //   motorEl.stop();
  // }



}
