#include "indication.h"
#include "includeAllStuff.h"

uint8_t led8Byte = 0;
uint8_t led7Byte = 0;
static uint8_t ngan = 0;
static uint8_t chuc = 0;
static uint8_t tram = 0;
static uint8_t donvi = 0;
static uint8_t numI[4];
unsigned int led7Num = 0;
void initIndication(void)
{
  pinMode(BUT_1_PIN, INPUT);
  pinMode(BUT_2_PIN, INPUT);

  pinMode(LED7_DATA, OUTPUT);
  pinMode(LED7_CLOCK, OUTPUT);

  pinMode(LED8_DATA, OUTPUT);
  pinMode(LED8_CLOCK, OUTPUT);

  // digitalWrite(LED7_DATA, HIGH);
  // digitalWrite(LED7_CLOCK, HIGH);
  // digitalWrite(LED8_DATA, HIGH);
  // digitalWrite(LED8_CLOCK, HIGH);
}


void updateLed8(uint8_t byteX)
{
  for (int i = 0; i < 8; i ++)
  {
  digitalWrite(LED8_DATA, (((~byteX) >> i) & 0x01) );
  digitalWrite(LED8_CLOCK, LOW);
  digitalWrite(LED8_CLOCK, HIGH);
}
}

void extractNumAndUpDateLed7(unsigned int numIn)
{
  unsigned int temp;
  uint8_t tempte = 0;
  temp = numIn;
  ngan = temp/1000;
  temp = temp %1000;
  tram = temp/100;
  temp = temp%100;
  chuc = temp/10;
  donvi = temp%10;

  numI[3] = ngan;
  numI[2] = tram;
  numI[1] = chuc;
  numI[0] = donvi;

  uint8_t byte1 = 0x01;
  uint8_t byte2 = 0x00;
  for (int i = 0; i <4; i++)
  {
    byte1 = byte1 << (i + 3);
    for (int j = 0; j < 4; j++)
    {
      byte2 = byte2 | ((numI[0] & 0x01) >> j);
      byte2 = byte2 << 1;
    }
    //byte2 = (~byte2) & 0x0f;
    byte2 = 0x07;
    //Serial.println(byte1);
    updateLed7(uint8_t(byte1 | byte2));
  }

}


void updateLed7(uint8_t byteX)
{
  for (int i = 0; i < 8; i ++)
  {
  digitalWrite(LED7_DATA, (((~byteX) >> i) & 0x01) );
  digitalWrite(LED7_CLOCK, LOW);
  digitalWrite(LED7_CLOCK, HIGH);
}


}
