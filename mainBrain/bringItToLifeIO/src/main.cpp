#include "includeAllStuff.h"
#include "pinStateConstants.h"
uint8_t MODE = MODE_RUN_1;
unsigned long tempElDesired = 0;
unsigned long tempAzDesired = 0;

void testing1()
{
  Serial.print("Encoder Elevation:  ");
  Serial.println(encoderEl.positionInDegrees);
  Serial.print("Encoder Azimuth:  ");
  Serial.println(encoderAz.positionInDegrees);
  Serial.print("Endstop Elevation:  ");
  Serial.println(EL_END);
  Serial.print("Endstop Azimuth:  ");
  Serial.println(AZ_END);
}
void setup() {
  // put your setup code here, to run once:
  pinMode(ENDSTOP_PIN_AZ,INPUT);
  pinMode(ENDSTOP_PIN_EL,INPUT);
  //digitalWrite(ENDSTOP_PIN_AZ,HIGH);
  //digitalWrite(ENDSTOP_PIN_EL,HIGH);

  initRuntime();
  initIndication();
  initAxesControling();
  easycommInit();

  Serial.begin(9600);
  delay(1000);

  //HOMING_DONE = 0;
    //motorEl.setSpeed(1023,CCW);

}

void loop() {

  //led7Num = 9999;
//Serial.println(encoderEl.positionInDegrees);
// while(1)
// {
//   motorEl.setSpeed(1023, CCW);
// }
while(1)
{
  if (BUT_1_PUSHED)
  {
    if (MODE > 4) MODE = 0;
    else MODE++;
  }
  led8Byte = MODE;
  delay(200);
  if  (BUT_2_PUSHED) break;
}



switch (MODE)
{

  case MODE_TEST_1:
  {
    motorEl.homingDone = 1;
    motorEl.isControlled = 1;
    motorEl.currentPulse = 0;
    while(1)
    {
    if (tempElDesired > 255) tempElDesired = 1;
    if (BUT_1_PUSHED)
    {
      tempElDesired++;
      if (tempElDesired > 255) tempElDesired = 255;
    }

    if (BUT_2_PUSHED)
    {
      tempElDesired--;
      if (tempElDesired < 1) tempElDesired = 1;
    }

    led8Byte = tempElDesired;
    motorEl.desiredPulse = tempElDesired * 3125;
    delay(100);
    Serial.print(motorEl.desiredPulse);
    Serial.print("    ");
    Serial.println(motorEl.currentPulse);
    //break;

    }
  }



  case MODE_TEST_2:
  {
    motorAz.homingDone = 1;
    motorAz.isControlled = 1;
    motorAz.currentPulse = 0;
    while(1)
    {
    if (tempAzDesired > 255) tempAzDesired = 1;
    if (BUT_1_PUSHED)
    {
      tempAzDesired++;
      if (tempAzDesired > 255) tempAzDesired = 255;
    }

    if (BUT_2_PUSHED)
    {
      tempAzDesired--;
      if (tempAzDesired < 1) tempAzDesired = 1;
    }

    led8Byte = tempAzDesired;
    motorAz.desiredPulse = tempAzDesired * 625;
    delay(100);
    Serial.print(motorAz.desiredPulse);
    Serial.print("    ");
    Serial.println(motorAz.currentPulse);
    //break;

    }
  }







  case 100: // used to be MODE_RUN_1
  {
    // if (motorEl.currentPulse < 100000) motorEl.setSpeed(1023, CW_E);
    // else motorEl.stop();
    // //else  motorAz.setSpeed(1023, CCW);
    // while(1)
    // {
    //   motorEl.setSpeed(1023, CW);
    // }
    //testing1();

    while ((motorEl.homingDone == 0) || (motorAz.homingDone == 0))
    {
      if (motorEl.homingDone == 0) motorEl.setSpeed(1023, CW_E);
      if (EL_END == 0)
        {
          motorEl.homingDone = 1;
          motorEl.stop();
          motorEl.currentPulse = 0;
        }

        //motorAz.homingDone = 1;
        if (motorAz.homingDone == 0) motorAz.setSpeed(1023, CW);
        if (AZ_END == 0)
          {
            motorAz.homingDone = 1;
            motorAz.stop();
            motorAz.currentPulse = 0;
          }
    }

    motorEl.isControlled = 1;
    motorAz.isControlled = 1;
    //motorEl.desiredPulse = 10000;
    //delay(20000);
    // motorEl.desiredPulse = 200000;
    // delay(900000);


    break;
  };
  default:
  {

  };
}

  //motorAzz.setDir(CW);
  //motorAz.setSpeed(1023,CW);
  //delay(5000);
  //motorAz.setSpeed(1023,CCW);
  //delay(5000);
  // motorAz.setSpeedCW(1023);
  // delay (4000);
  // motorAz.stop();
  // delay (4000);
  //  motorAz.setSpeedCCW(1023);
  //  delay (4000);
  //  motorAz.stop();
  //  delay (4000);
  // Timer1.pwm(motorAz.pinPul_2, 512);
  // digitalWrite(motorAz.pinPul_1,HIGH);
  // delay(3000);
  // Timer1.pwm(motorAz.pinPul_2, 512);
  // digitalWrite(motorAz.pinPul_1,HIGH);
  // delay(3000);
  // Timer1.pwm(motorAz.pinPul_2, 1023);
  // digitalWrite(motorAz.pinPul_1,HIGH);
  // delay(3000);

// motorEl.setSpeed(1023,CW);
// delay(10000);
// motorEl.setSpeed(1023,CCW);
// delay(10000);
// motorAz.setSpeed(1023,CW);
// delay(1000);
// motorAz.setSpeed(1023,CCW);
// delay(1000);

  // String str1, str2, str3, str4, str5, str6;
  // str1 = String("AZ");
  // str2 = String(encoderAz.positionInDegrees,10);
  // str3 = String(" EL");
  // str4 = String(encoderEl.positionInDegrees,10);
  // str5 = String("\n");
  // Serial2.print(str1 + str2 + str3 + str4 + str5);
  // delay(10);
//  while(1)
//  {
// Serial.print(encoderEl.currentCode8bit);
// Serial.print("  |  ");
// Serial.println(encoderEl.positionInDegrees);
// delay(100);
 //  temp = encoderEl.convertFromGray(encoderEl.currentCodeGray) * 360;
 //  if (encoderEl.readyToUse == 1)
 //  {
 //    Serial.print(  temp   );
 //  Serial.print("  |  ");
 //  Serial.println(encoderEl.convertFromGray(encoderEl.currentCodeGray));
 // }
 //   delay(300);
//motorEl.setSpeed(0,CW);

    //delay(4100);

//motorEl.setSpeed(1023,CW);
  //  delay(4100);

//}
  // if (encoderEl.positionInDegrees < 170)
  // {
  //   motorEl.setSpeed(1023,CW);
  //   motorAz.setSpeed(1023,CCW);
  // }
  // else
  //
  // if (encoderEl.positionInDegrees > 190)
  // {
  //   motorEl.setSpeed(1023,CCW);
  //   motorAz.setSpeed(1023,CW);
  // }
  // else
  // {
  //   motorEl.setSpeed(0,CW);
  //   motorAz.setSpeed(0,CCW);
  // }
}
