/*
 * encoderAq.c
 *
 *  Created on: 17 thg 3, 2019
 *      Author: Big Boy
 */

#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "encoderAq.h"
#include "systick.h"


void initInteruptInput(void)
{
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P3, GPIO_PIN6);
    MAP_GPIO_clearInterruptFlag(GPIO_PORT_P3, GPIO_PIN6);
    MAP_GPIO_enableInterrupt(GPIO_PORT_P3, GPIO_PIN6);
    MAP_Interrupt_enableInterrupt(INT_PORT3);
    //MAP_Interrupt_enableSleepOnIsrExit();


    // for testing LED


}

void PORT3_IRQHandler(void)
{
    uint32_t status = MAP_GPIO_getEnabledInterruptStatus(GPIO_PORT_P3);
    MAP_GPIO_clearInterruptFlag(GPIO_PORT_P3, status);

    //MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);


  //  if (status & GPIO_PIN6)  MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P1, GPIO_PIN0);
//    {
//        if(pwmConfig.dutyCycle == 28800)
//            pwmConfig.dutyCycle = 3200;
//        else
//            pwmConfig.dutyCycle += 3200;
//
//        MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfig);
//    }
}
