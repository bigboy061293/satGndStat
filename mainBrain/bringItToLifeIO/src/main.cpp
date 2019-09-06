#include "includeAllStuff.h"
#include "pinStateConstants.h"
uint8_t MODE = 7; // default mode
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

  Serial.begin(BAUDRATE_SERIAL_1);
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
    //easycommProc();
  if (BUT_1_PUSHED)
  {
    if (MODE > 8) MODE = 0;
    else MODE++;
  }
  led8Byte = MODE;
  delay(100);
  if  (BUT_2_PUSHED) break;
}



switch (MODE)
{

  case MODE_TEST_1: // 0 / xoay E
  {
    motorEl.homingDone = 1;
    motorEl.isControlled = 1;
    motorEl.currentPulse = 0;
    while(1)
    {
    if (tempElDesired > MAX_RANGE_180_8_BIT) tempElDesired = 1; // 255 is full 360 degree -> 120 is around 180 degree
    if (BUT_1_PUSHED)
    {
      tempElDesired++;
      if (tempElDesired > MAX_RANGE_180_8_BIT) tempElDesired = MAX_RANGE_180_8_BIT; // 255 is full 360 degree -> 120 is around 180
    }

    if (BUT_2_PUSHED)
    {
      tempElDesired--;
      if (tempElDesired < 1) tempElDesired = 1;
    }

    led8Byte = tempElDesired;
    motorEl.desiredPulse = tempElDesired * 3125;
    delay(100);
    // Serial.print(motorEl.desiredPulse);
    // Serial.print("    ");
    // Serial.println(motorEl.currentPulse);
    //break;

    }
  }



  case MODE_TEST_2: //1 // Xoay A
  {
    motorAz.homingDone = 1;
    motorAz.isControlled = 1;
    motorAz.currentPulse = 0;
    while(1)
    {
    if (tempAzDesired > MAX_RANGE_180_8_BIT) tempAzDesired = 1; // 255 is full 360 degree -> 120 is around 180
    if (BUT_1_PUSHED)
    {
      tempAzDesired++;
      if (tempAzDesired > MAX_RANGE_180_8_BIT) tempAzDesired = MAX_RANGE_180_8_BIT; // 255 is full 360 degree -> 120 is around 180
    }

    if (BUT_2_PUSHED)
    {
      tempAzDesired--;
      if (tempAzDesired < 1) tempAzDesired = 1;
    }

    led8Byte = tempAzDesired;
    motorAz.desiredPulse = tempAzDesired * 625;
    delay(100);
    // Serial.print(motorAz.desiredPulse);
    // Serial.print("    ");
    // Serial.println(motorAz.currentPulse);
    //break;

    }
  }


  case MODE_HOMING_EL_MANUALLY: // 4
  {
    while(1)
    {
    while (motorEl.homingDone == 0)
    {
      if (motorEl.homingDone == 0) motorEl.setSpeed(1023, CW_E);
      if (EL_END == 0)
        {
          motorEl.homingDone = 1;
          motorEl.stop();
          motorEl.currentPulse = 0;
        }
    }
    }
  }

  case MODE_HOMING_AZ_MANUALLY: // 5
  {
    while(1)
    {
    while (motorAz.homingDone == 0)
    {
      if (motorAz.homingDone == 0) motorAz.setSpeed(1023, CW);
      if (AZ_END == 0)
        {
          motorAz.homingDone = 1;
          motorAz.stop();
          motorAz.currentPulse = 0;
        }
    }
    }
  }


  case MODE_GPREDICT: // 6
  {
    // after homing
    motorAz.homingDone = 1;
    motorEl.homingDone = 1;

    motorAz.currentPulse = 0;
    motorEl.currentPulse = 0;

    motorAz.currentAngle = 0.0;
    motorEl.currentAngle = 0.0;

    motorAz.isControlled = 1;
    motorEl.isControlled = 1;
    while(1)
    {
      // if ((EL_END) || (AZ_END))
      // {
      //   while(1)
      //   {
      //     motorAz.stop();
      //     motorEl.stop();
      //   }
      // }
      easycommProc();
      if (easyCommIIIValid)
      {
        if ((motorAz.homingDone == 1) && (motorEl.homingDone == 1))
        {
          //if (motorEl.desiredAngle > 150.0) motorEl.desiredAngle = 150.0;
          //if (motorAz.desiredAngle > 270.0) motorAz.desiredAngle = 270.0;

          motorEl.desiredPulse = motorEl.desiredAngle * 2222.222222;
          motorAz.desiredPulse = motorAz.desiredAngle * 444.444444;

          motorEl.currentAngle = motorEl.currentPulse / 2222.222222;
          motorAz.currentAngle = motorAz.currentPulse / 444.444444;
        }
      // //
        Serial.println("-------------    Angle    ---------------");
        Serial.print("AZ desiredAngle: ");
        Serial.print( motorAz.desiredAngle);
        Serial.print("  ");
        Serial.print("EL desiredAngle: ");
        Serial.println( motorEl.desiredAngle);

        Serial.print("AZ currentAngle: ");
        Serial.print( motorAz.currentAngle);
        Serial.print("  ");
        Serial.print("EL currentAngle: ");
        Serial.println( motorEl.currentAngle);

        Serial.println("-------------    Pulse    ---------------");
        Serial.print("AZ desiredPulse: ");
        Serial.print( motorAz.desiredPulse);
        Serial.print("  ");
        Serial.print("EL desiredPulse: ");
        Serial.println( motorEl.desiredPulse);

        Serial.print("AZ currentPulse: ");
        Serial.print( motorAz.currentPulse);
        Serial.print("  ");
        Serial.print("EL currentPulse: ");
        Serial.println( motorEl.currentPulse);
        Serial.println("----------------------");
      }
    }
  }

  case MODE_HOMING_EL_MANUALLY_BOTH_AUTO: // 2
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

  case MODE_PC_EL:  //  7  Mode verify angle by Smartphone via serial1 //
  {
    //if (motorEl.homingDone == 1)
    //motorAz.isControlled = 1;
    motorEl.isControlled = 1;
    {
      while(1)
      {
        Serial.setTimeout(300000); // 1000 ms
        //waiting for input
        while (Serial.available() == 0);
        float val = Serial.parseFloat(); //read int or parseFloat for ..float...
        //Serial.println(val);
        motorEl.desiredPulse = val*4444.444;
        while (motorEl.desiredPulse != motorEl.currentPulse)
        {

        Serial.println(motorEl.currentPulse/4444.44);
        delay(10);
        }
      }
    }
    break;
  };

  case MODE_PC_AZ:  //  8  Mode verify angle by Smartphone via serial1 //
  {
    if (motorAz.homingDone == 1)
    {
      while(1)
      {
        Serial.setTimeout(300000); // 1000 ms
        //waiting for input
        while (Serial.available() == 0);
        float val = Serial.parseFloat(); //read int or parseFloat for ..float...
        //Serial.println(val);
        motorAz.desiredPulse = val*888.89;
        Serial.println(motorAz.currentPulse/888.89);
      }
    }
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
