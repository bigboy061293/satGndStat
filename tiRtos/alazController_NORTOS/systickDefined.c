#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <systickDefined.h>
#include "uartComm.h"
uint8_t countingToEight = 0;
uint8_t countingToInhibit = 0;
uint8_t encoderAqState = 0;
uint8_t encoderAqReadDone = 0;
uint8_t encoderValueTemp[2][8];

uint8_t encoderValue[2][8];
uint8_t i = 0;
void systickInit(void)
{
    //MCLK is 1.5Mhz
   // MAP_SysTick_disableInterrupt();
    MAP_SysTick_enableModule();
    MAP_SysTick_setPeriod(1500000);
    MAP_Interrupt_enableSleepOnIsrExit();
    MAP_SysTick_enableInterrupt();

    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);

//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN0); // clock
//
//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN2); // latch
//   MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5,GPIO_PIN2);
//
//    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P3, GPIO_PIN6); //data in

}


void SysTick_Handler(void)
{
    MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1,GPIO_PIN0,
//                            ~MAP_GPIO_getInputPinValue(GPIO_PORT_P1,GPIO_PIN0));
//
//    if (encoderValue[7] == 0)
//        MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P1,GPIO_PIN0);
//    else
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P1,GPIO_PIN0);
//
//  sendClockTo166();

    MAP_UART_transmitData(EUSCI_A0_BASE,
            ROM_GPIO_getInputPinValue(GPIO_PORT_P3, GPIO_PIN7) + 48);

    MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5, GPIO_PIN0);
                   MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5, GPIO_PIN2);
                   MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN6);




    for (i = 0; i < 8; i ++)
              {
                  //showChar(encoderValue[0][i]);
                 // MAP_UART_transmitData(EUSCI_A0_BASE, encoderValue[0][i] + 48);
            //putChar(encoderValue[0][i]+ 48);
            //putChar(' ');

                  //MAP_UART_transmitData(EUSCI_A0_BASE, ' ');
              }

              //MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
//              for (i = 0; i < 8; i ++)
//              {
//                             //showChar(encoderValue[0][i]);
//                  MAP_UART_transmitData(EUSCI_A0_BASE, encoderValue[1][i]);
//                  MAP_UART_transmitData(EUSCI_A0_BASE, ' ');
//              }
              MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
              MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
              MAP_UART_transmitData(EUSCI_A0_BASE, '\n');
// ------------------------------- LUT -----------------------------
           if (encoderAqState < 8)
           {

//               if (((encoderAqState >> 2) & 0x01) == 0x01)
//                   MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5, GPIO_PIN0);
//                   else
//                   MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5, GPIO_PIN0);
//
//               if (((encoderAqState >> 1) & 0x01) == 0x01)
//                   MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5, GPIO_PIN2);
//                  else
//                  MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5, GPIO_PIN2);
//
//               if (((encoderAqState) & 0x01) == 0x01)
//                   MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P3, GPIO_PIN6);
//                   else
//                   MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P3, GPIO_PIN6);



               encoderValueTemp[0][encoderAqState] =
                       ROM_GPIO_getInputPinValue(GPIO_PORT_P3, GPIO_PIN7);
               encoderValueTemp[1][encoderAqState] =
                       ROM_GPIO_getInputPinValue(GPIO_PORT_P3, GPIO_PIN5);

               encoderAqState++;

           }
           else
           {
               encoderAqState = 0;
               for (i=0; i< 8; i++)
                       {
                           encoderValue[0][i] = encoderValueTemp[0][i];
                           encoderValue[1][i] = encoderValueTemp[1][i];
                       }
           }
// ------------------------------- LUT -----------------------------

//       if (encoderAqState < 8)
//       {
//           if (encoderAqState == 0)
//           {
//               MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P5,GPIO_PIN2); //latch = 0;
//               encoderAqState = 1;
//           }
//           else
//           if (encoderAqState == 1)
//           {
//               MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P5,GPIO_PIN2); //latch = 1;
//               encoderAqState = 2;
//               countingToEight = 0;
//           }
//           else
//           {
//               if (ROM_GPIO_getInputPinValue(GPIO_PORT_P5,GPIO_PIN0) == 1)  //check lock HIGH
//               {
//                   encoderAqState++;
//                   encoderValueTemp[countingToEight] = ROM_GPIO_getInputPinValue(GPIO_PORT_P3, GPIO_PIN6); // save temp
//                   countingToEight++;
//               }
//           }
//       }
//       else
//       {
//           encoderAqState = 0;
//           for (i=0; i< 8; i++) encoderValue[i] = encoderValueTemp[i];
//       }
}
