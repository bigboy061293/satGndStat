/*
 * uartComm.h
 *
 *  Created on: 16 thg 3, 2019
 *      Author: Big Boy
 */

#ifndef UARTCOMM_H_
#define UARTCOMM_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>

extern void uartInit();
extern void EUSCIA0_IRQHandler();


#ifdef __cplusplus
}
#endif

#endif /* UARTCOMM_H_ */
