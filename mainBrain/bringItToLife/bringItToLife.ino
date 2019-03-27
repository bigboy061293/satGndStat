#include <Arduino.h>
#include <TimerOne.h>
#include <TimerThree.h>
#include "controllingAxes.h"

stepMotor motorEl(PUL_PIN_EL, DIR_PIN_EL);
stepMotor motorAz(PUL_PIN_AZ, DIR_PIN_AZ);
 void initAxesControling(void){
   motorEl.setDutyCycle(0);
   motorAz.setDutyCycle(0);
}


void setup() {
  
  initRuntime();

  initAxesControling();
  Timer1.initialize(1000000);
  Serial.begin(9600);

}

void loop() {
   put your main code here, to run repeatedly:
 
 

 Timer1.pwm(7, 1023);
 Timer1.pwm(6, 1023);
 
}
