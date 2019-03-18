#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "systick.h"

uint8_t countingToEight = 0;
uint8_t countingToInhibit = 0;
uint8_t encoderAqState = 0;
uint8_t encoderAqReadDone = 0;
uint8_t encoderValueTemp[8];
uint8_t encoderValue[8];
uint8_t i = 0;
void systickInit(void)
{
    //MCLK is 1.5Mhz
    MAP_SysTick_enableModule();
    MAP_SysTick_setPeriod(150000);
    MAP_Interrupt_enableSleepOnIsrExit();
    MAP_SysTick_enableInterrupt();

    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);

    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN0); // clock
//
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN2); // latch
    MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5,GPIO_PIN2);
//
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P3, GPIO_PIN6); //data in

}
void sendClockTo166()
{
    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P5, GPIO_PIN0);
}

void SysTick_Handler(void)
{
//    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1,GPIO_PIN0,
//                            ~MAP_GPIO_getInputPinValue(GPIO_PORT_P1,GPIO_PIN0));
//
//    if (encoderValue[7] == 0)
//        MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P1,GPIO_PIN0);
//    else
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1,GPIO_PIN0);
//
    sendClockTo166();



       if (encoderAqState < 8)
       {
           if (encoderAqState == 0)
           {
               MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5,GPIO_PIN2); //latch = 0;
               encoderAqState = 1;
           }
           else
           if (encoderAqState == 1)
           {
               MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5,GPIO_PIN2); //latch = 1;
               encoderAqState = 2;
               countingToEight = 0;
           }
           else
           {
               if (ROM_GPIO_getInputPinValue(GPIO_PORT_P5,GPIO_PIN0) == 1)  //check lock HIGH
               {
                   encoderAqState++;
                   encoderValueTemp[countingToEight] = ROM_GPIO_getInputPinValue(GPIO_PORT_P3, GPIO_PIN6); // save temp
                   countingToEight++;
               }
           }
       }
       else
       {
           encoderAqState = 0;
           for (i=0; i< 8; i++) encoderValue[i] = encoderValueTemp[i];
       }
}
