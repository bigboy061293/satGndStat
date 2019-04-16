/*
 * encoderAq.c
 *
 *  Created on: 17 thg 3, 2019
 *      Author: Big Boy
 */

#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <systickDefined.h>
#include "encoderAq.h"


void initEncoder(void)
{
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN0); // A
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P5, GPIO_PIN2); // B
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P3, GPIO_PIN6); // C

    MAP_GPIO_setAsInputPinWithPullDownResistor(GPIO_PORT_P3, GPIO_PIN5); // Y1
    MAP_GPIO_setAsInputPinWithPullDownResistor(GPIO_PORT_P3, GPIO_PIN7); // Y2


    //MAP_Interrupt_enableSleepOnIsrExit();


    // for testing LED


}

