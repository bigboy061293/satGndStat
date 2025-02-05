/* --COPYRIGHT--,BSD
 * Copyright (c) 2017, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * --/COPYRIGHT--*/
/*******************************************************************************
 * MSP432 GPIO - Toggle Output High/Low
 *
 * Description: In this very simple example, the LED on P1.0 is configured as
 * an output using DriverLib's GPIO APIs. An infinite loop is then started
 * which will continuously toggle the GPIO and effectively blink the LED.
 *
 *                MSP432P4111
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST         P1.0  |---> P1.0 LED
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *
 ******************************************************************************/
/* DriverLib Includes */
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

/* Standard Includes */
#include <stdint.h>
#include <stdbool.h>
#include <systickDefined.h>

#include "lcdDisplay.h"
#include "uartComm.h"
#include "pulseGen.h"
#include "encoderAq.h"

int main(void)
{
    volatile uint32_t ii;
    volatile uint32_t i;
    /* Halting the Watchdog *///
    MAP_WDT_A_holdTimer();

    /* Configuring P1.0 as output */
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN0);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN1);
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);

    MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN0);
        MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN1);
        MAP_GPIO_setOutputHighOnPin(GPIO_PORT_P2, GPIO_PIN2);


//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN5);
//    MAP_GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN0);

   // lcdInit();


    systickInit();
    timerAInit();
    initEncoder();
    uartInit();
//
//    /* 123ABC */
//    showChar('T', char1);
//    showChar('R', char2);
//    showChar('A', char3);
//    showChar('N', char4);
//    showChar('G', char5);
//    showChar(' ', char6);



    MAP_Interrupt_enableMaster();
    while(1)
    {
        //MAP_PCM_gotoLPM0();
        // encoderValue[7];
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN0);
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN1);
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2, GPIO_PIN2);


    }


//    while (1)
//    {
//
//        //MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P2,GPIO_PIN5);
//        MAP_GPIO_setOutputLowOnPin(GPIO_PORT_P3,GPIO_PIN0);
//    }
}


