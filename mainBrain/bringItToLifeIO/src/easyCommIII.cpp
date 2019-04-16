#include "easycommIII.h"
#include "includeAllStuff.h"
#include <Wstring.h>
char buffer[EASYCOMMBUFFERSIZE];
uint16_t bufferCnt = 0;



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
  Serial1.begin(115200);

}

void easycommProc()
{
char *Data = buffer;
char incommingByte;
char *rawData;
char data[100];
String str1, str2, str3, str4, str5, str6;

  while (Serial1.available() > 0)
  {
    incommingByte = Serial1.read();
    if  ((incommingByte == '\n') || (incommingByte == '\r'))
    {
      buffer[bufferCnt] = 0;
      if ((buffer[0] == 'A') && (buffer[1] == 'Z'))
      {
        if ((buffer[2] == ' ') && (buffer[3] == 'E') && (buffer[4] == 'L'))
        {
          // sending current pos to gpredict
          str1 = String("AZ");
          str2 = String(encoderAz.positionInDegrees,1);
          str3 = String(" EL");
          str4 = String(encoderEl.positionInDegrees,1);
          str5 = String("\n");
          Serial1.print(str1 + str2 + str3 + str4 + str5);
        }
        else
        {
          // get pos from gpredict
          rawData = strtok_r(Data, " ", &Data);
          strncpy(data,rawData + 2, 10);
          if (isNumber(data));  // if yes, set possition data for AZ axis
          //control_az.setpoint = atof(data);
          //   motorAz.posControl == 1;
          //   motorAz.posInDregree = xxx;//
          // }
          rawData = strtok_r(Data, " ",&Data);
          if ((rawData[0] == 'E') && (rawData[1] == 'L'))
          {
            strncpy(data, rawData + 2, 10);
            if (isNumber(data));  // if yes, set position data for EL axis
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
          if (isNumber(data));  //  set control_el.setpoint = atof(data);
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
          str2 = String(encoderAz.positionInDegrees,1);
          str3 = String(" EL");
          str4 = String(encoderEl.positionInDegrees,1);
          str5 = String("\n");
          Serial1.print(str1 + str2 + str3 + str4 + str5);

          motorAz.posControl == 0;
          motorEl.posControl == 0;
        }

        bufferCnt = 0;
    }


    else
    {
      buffer[bufferCnt] = incommingByte;
      bufferCnt++;
    }
  }
}
