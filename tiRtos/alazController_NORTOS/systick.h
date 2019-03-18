/*
 * systick.h
 *
 *  Created on: 17 thg 3, 2019
 *      Author: Big Boy
 */

#ifndef SYSTICK_H_
#define SYSTICK_H_


#ifdef __cplusplus
extern "C" {
#endif


#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>

extern void systickInit();
extern void SysTick_Handler();
extern uint8_t encoderValue[8];
#ifdef __cplusplus
}
#endif



#endif /* SYSTICK_H_ */
