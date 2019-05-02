#include "includeAllStuff.h"


void setup() {
  // put your setup code here, to run once:
  initRuntime();
  initAxesControling();
  easycommInit();
  Serial.begin(9600);

}

void loop() {
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
