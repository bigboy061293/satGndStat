/*
 * encoderAq.h
 *
 *  Created on: 17 thg 3, 2019
 *      Author: Big Boy
 */

#ifndef ENCODERAQ_H_
#define ENCODERAQ_H_

#ifdef __cplusplus
extern "C" {
#endif


#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>

extern void initInteruptInput();
extern void PORT3_IRQHandler();

#ifdef __cplusplus
}
#endif





#endif /* ENCODERAQ_H_ */
