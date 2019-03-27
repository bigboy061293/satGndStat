#include "includeAllStuff.h"

 //Timer 1: PWM Pin 11 12 13
 //Timer 3: PWM Pin 2 3 5



stepMotor motorEl(PUL_PIN_EL, DIR_PIN_EL);
stepMotor motorAz(PUL_PIN_AZ, DIR_PIN_AZ);

void initAxesControling(void){

  Timer1.initialize(PUL_PERIOD);

  pinMode(DIR_PIN_AZ,OUTPUT);
  pinMode(DIR_PIN_EL,OUTPUT);
   //
   motorEl.setDutyCycle(0);
   motorAz.setDutyCycle(0);
}
