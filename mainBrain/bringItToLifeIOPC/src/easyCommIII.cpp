#include "easycommIII.h"
#include "includeAllStuff.h"
#include <Wstring.h>
#include "easycommIII.h"
char buffer[EASYCOMMBUFFERSIZE];
uint16_t bufferCnt = 0;
bool easyCommIIIValid = false;
bool isNumber(char *input)
{
  for (uint16_t i = 0; input[i] != '\0'; i++)
    {
        if (isalpha(input[i]))
        return false;
    }
  return true;
}
void easycommInit()
{
  Serial2.begin(BAUDRATE_SERIAL_2);
}

//
// void easycommProcOld()
// {
// char *Data = buffer;
// char incommingByte;
// char *rawData;
// char data[100];
// String str1, str2, str3, str4, str5, str6;
//
//   while (Serial2.available() > 0)
//   {
//     incommingByte = Serial2.read();
//     if  ((incommingByte == '\n') || (incommingByte == '\r'))
//     {
//       buffer[bufferCnt] = 0;
//       if ((buffer[0] == 'A') && (buffer[1] == 'Z'))
//       {
//         if ((buffer[2] == ' ') && (buffer[3] == 'E') && (buffer[4] == 'L'))
//         {
//           // sending current pos to gpredict
//           str1 = String("AZ");
//           str2 = String(encoderAz.positionInDegrees,1);
//           str3 = String(" EL");
//           str4 = String(encoderEl.positionInDegrees,1);
//           //str5 = String("\n");
//           Serial2.println(str1 + str2 + str3 + str4);
//         }
//         else
//         {
//           // get pos from gpredict
//           rawData = strtok_r(Data, " ", &Data);
//           strncpy(data,rawData + 2, 10);
//           if (isNumber(data));  // if yes, set possition data for AZ axis
//           //control_az.setpoint = atof(data);
//           //   motorAz.posControl == 1;
//           //   motorAz.posInDregree = xxx;//
//           // }
//           rawData = strtok_r(Data, " ",&Data);
//           if ((rawData[0] == 'E') && (rawData[1] == 'L'))
//           {
//             strncpy(data, rawData + 2, 10);
//             if (isNumber(data));  // if yes, set position data for EL axis
//             //control_el.setpoint = atof(data);
//             // {
//             //   motorEl.posControl == 1;
//             //   motorEl.posInDregree = xxx;//
//             // }
//           }
//         }
//
//       }
//
//       else if ((buffer[0] == 'E') && (buffer[1] == 'L'))
//       {
//         rawData = strtok_r(Data, " ", &Data);
//         if ((rawData[0] == 'E') && (rawData[1] == 'L'))
//         {
//           strncpy(data, rawData + 2, 10);
//           if (isNumber(data));  //  set control_el.setpoint = atof(data);
//           // {
//           //   motorEl.posControl == 1;
//           //   motorEl.posInDregree = xxx;//
//           // }
//         }
//       }
//       else if ((buffer[0] == 'S') && (buffer[1] == 'A') && (buffer[2] == ' ')
//         && (buffer[3] == 'S') && (buffer[0] == 'E'))
//         {
//           //stop el and az
//           str1 = String("AZ");
//           str2 = String(encoderAz.positionInDegrees,1);
//           str3 = String(" EL");
//           str4 = String(encoderEl.positionInDegrees,1);
//           //str5 = String("\n");
//           Serial2.println(str1 + str2 + str3 + str4);
//
//           motorAz.posControl == 0;
//           motorEl.posControl == 0;
//         }
//
//         bufferCnt = 0;
//
//
//     }
//
//
//     else
//     {
//       buffer[bufferCnt] = incommingByte;
//       bufferCnt++;
//
//       str1 = String("AZ");
//       str2 = String(encoderAz.positionInDegrees,10);
//       str3 = String(" EL");
//       str4 = String(encoderEl.positionInDegrees,10);
//     //  str5 = String("\n");
//       Serial2.println(str1 + str2 + str3 + str4);
//     }
//
//   }
//
// //   str1 = String("AZ");
// //   str2 = String(encoderAz.positionInDegrees,10);
// //   str3 = String(" EL");
// //   str4 = String(encoderEl.positionInDegrees,10);
// // //  str5 = String("\n");
// //   Serial2.println(str1 + str2 + str3 + str4);
// //  Serial2.println(encoderAz.positionInDegrees);
// }


void easycommProc() // remove "er" after testing
{
char *Data = buffer;
char incommingByte;
char *rawData;
char data[100];
String str1, str2, str3, str4, str5, str6;

  while (Serial2.available() > 0)
  {
      easyCommIIIValid = true;
      countForEasyCommValid = 0;
      //easyCommIIIValid = truel
    incommingByte = Serial2.read();
      //Serial.print(incommingByte);
    if  ((incommingByte == '\n') || (incommingByte == '\r'))
    {
      buffer[bufferCnt] = 0;
      if ((buffer[0] == 'A') && (buffer[1] == 'Z'))
      {
        if ((buffer[2] == ' ') && (buffer[3] == 'E') && (buffer[4] == 'L'))
        {
          // sending current pos to gpredict
          str1 = String("AZ");
          str2 = String(motorAz.currentAngle ,1);
          str3 = String(" EL");
          str4 = String(motorEl.currentAngle ,1);
          //str5 = String("\n");
          Serial2.println(str1 + str2 + str3 + str4);
        }
        else
        {
          // get pos from gpredict
          rawData = strtok_r(Data, " ", &Data);
          strncpy(data,rawData + 2, 10);
          if (isNumber(data))
          {
              motorAz.desiredAngle = atof(data);
              //if (motorAz.desiredAngle < 0) motorAz.desiredAngle = 0;

              if (motorAz.desiredAngle > MAX_RANGE_AZ) motorAz.desiredAngle = MAX_RANGE_AZ;
              if (motorAz.desiredAngle < MIN_RANGE_AZ) motorAz.desiredAngle = MIN_RANGE_AZ;
              //Serial.println(motorAz.desiredAngle);
          }
              // if yes, set possition data for AZ axis
          //control_az.setpoint = atof(data);
          //   motorAz.posControl == 1;
          //   motorAz.posInDregree = xxx;//
          // }
          rawData = strtok_r(Data, " ",&Data);
          if ((rawData[0] == 'E') && (rawData[1] == 'L'))
          {
            strncpy(data, rawData + 2, 10);
            if (isNumber(data))
            {
                motorEl.desiredAngle = atof(data);
                //if (motorEl.desiredAngle < 0) motorEl.desiredAngle = 0;

                if (motorEl.desiredAngle > MAX_RANGE_EL) motorEl.desiredAngle = MAX_RANGE_EL;
                if (motorEl.desiredAngle < MIN_RANGE_EL) motorEl.desiredAngle = MIN_RANGE_EL;
                //Serial.println(motorEl.desiredAngle );
            } // if yes, set position data for EL axis
            //control_el.setpoint = atof(data);
            // {
            //   motorEl.posControl == 1;
            //   motorEl.posInDregree = xxx;//
            // }
          }
        }

      }

      else if ((buffer[0] == 'E') && (buffer[1] == 'L'))
      {
        rawData = strtok_r(Data, " ", &Data);
        if ((rawData[0] == 'E') && (rawData[1] == 'L'))
        {
          strncpy(data, rawData + 2, 10);
          if (isNumber(data))
          {
            motorEl.desiredAngle = atof(data);
            //if (motorEl.desiredAngle < 0) motorEl.desiredAngle = 0;
            if (motorEl.desiredAngle > MAX_RANGE_EL) motorEl.desiredAngle = MAX_RANGE_EL;
            if (motorEl.desiredAngle < MIN_RANGE_EL) motorEl.desiredAngle = MIN_RANGE_EL;
          }  //  set control_el.setpoint = atof(data);
          // {
          //   motorEl.posControl == 1;
          //   motorEl.posInDregree = xxx;//
          // }
        }
      }
      else if ((buffer[0] == 'S') && (buffer[1] == 'A') && (buffer[2] == ' ')
        && (buffer[3] == 'S') && (buffer[0] == 'E'))
        {
          //stop el and az
          str1 = String("AZ");
          str2 = String(motorAz.currentAngle ,1);
          str3 = String(" EL");
          str4 = String(motorEl.currentAngle ,1);
          //str5 = String("\n");
          Serial2.println(str1 + str2 + str3 + str4);

          motorAz.stop();
          motorEl.stop();
          motorEl.isControlled = 0;
          motorAz.isControlled = 0;
        }
        bufferCnt = 0;
        //Serial2.flush();

    }


    else
    {
      buffer[bufferCnt] = incommingByte;
      bufferCnt++;
    }
    str1 = String("AZ");
    str2 = String(motorAz.currentAngle ,10);
    str3 = String(" EL");
    str4 = String(motorEl.currentAngle ,10);
    //  str5 = String("\n");
    Serial2.println(str1 + str2 + str3 + str4);
  }

//   str1 = String("AZ");
//   str2 = String(encoderAz.positionInDegrees,10);
//   str3 = String(" EL");
//   str4 = String(encoderEl.positionInDegrees,10);
// //  str5 = String("\n");
//   Serial2.println(str1 + str2 + str3 + str4);
//  Serial2.println(encoderAz.positionInDegrees);
}

// void easycommProc()
// {
//   char *Data = buffer;
//   char incommingByte;
//   char *rawData;
//   char data[100];
//   String str1, str2, str3, str4, str5, str6;
//
//   while (Serial2.available() > 0)
//   {
//
//     incommingByte = Serial2.read();
//       Serial.print(incommingByte);
//   //    Serial2.flush();
//
//   str1 = String("AZ");
//   str2 = String(0 ,1);
//   str3 = String(" EL");
//   str4 = String(0 ,1);
//   //  str5 = String("\n");
//   Serial2.println(str1 + str2 + str3 + str4);
//   }
//

//}
