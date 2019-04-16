/*
 * Copyright (c) 2015-2018, Texas Instruments Incorporated
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
 */

/*
 *  ======== hello.c ========
 */

/* XDC Module Headers */
#include <xdc/std.h>
#include <xdc/runtime/System.h>
#include <xdc/runtime/Error.h>

/* BIOS Module Headers */
#include <ti/sysbios/BIOS.h>
#include <ti/sysbios/knl/Task.h>
#include <ti/sysbios/knl/Semaphore.h>

/* Example/Board Header files */
#include "Board.h"

/* TI-RTOS Header files */
//C:\ti\tirtos_simplelink_2_13_01_09\packages\ti\drivers
#include <ti/drivers/GPIO.h>
#include <ti/drivers/ADC.h>
#include <ti/drivers/PWM.h>
// #include <ti/drivers/I2C.h>
// #include <ti/drivers/SDSPI.h>
// #include <ti/drivers/SPI.h>
 #include <ti/drivers/UART.h>
 #include <ti/drivers/gpio/GPIOMSP432.h>
// #include <ti/drivers/Watchdog.h>
// #include <ti/drivers/WiFi.h>

/*
 *  ======== heartBeatFxn ========
 *  Toggle the Board_LED0. The Task_sleep is determined by arg0 which
 *  is configured for the heartBeat Task instance.
 */



UART_Handle uart;
UART_Handle gpredictUart;

Semaphore_Handle SEM_uart_rx; // this binary semaphore handles uart receiving interrupts
Semaphore_Handle SEM_gpredict_uart_rx;

void UART00_IRQHandler(UART_Handle handle, void *buffer, size_t num);
void UART01_IRQHandler(UART_Handle handle, void *buffer, size_t num);


Void steperDriver(UArg arg0, UArg arg1)
{
    /* Period and duty in microseconds */
    uint16_t   pwmPeriod = 540;
    uint16_t   duty = pwmPeriod/2;


    /* Sleep time in microseconds */

    PWM_Handle pwm1 = NULL;
    PWM_Handle pwm2 = NULL;
    PWM_Params params;

    /* Call driver init functions. */

    //GPIO_init();
//   GPIO_setConfig(Board_DIR1 , GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
//   GPIO_setConfig(Board_DIR2 , GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
//   GPIO_write(Board_DIR1,  0);
//              GPIO_write(Board_DIR2,  0);


    //MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);
    //MAP_GPIO_setOutputLOnPin(GPIO_PORT_P1, GPIO_PIN0)

    PWM_Params_init(&params);

    params.dutyUnits = PWM_DUTY_US;
        params.dutyValue = duty;
        params.periodUnits = PWM_PERIOD_US;
        params.periodValue = pwmPeriod;
        pwm1 = PWM_open(Board_PWM0, &params);
        if (pwm1 == NULL) {
            /* Board_PWM0 did not open */
            while (1);
        }

        PWM_start(pwm1);

        pwm2 = PWM_open(Board_PWM1, &params);
        if (pwm2 == NULL) {
            /* Board_PWM0 did not open */
            while (1);
        }

        PWM_start(pwm2);

    while(1)
    {
        GPIO_write(Board_GPIO_LED0,  1);
        GPIO_write(Board_DIR2,  1);
       //    GPIO_write(Board_DIR2,  0);
        //GPIO_write(Board_GPIO_LED0,  1);
//        PWM_setDuty(pwm1, duty);
//
//                PWM_setDuty(pwm2, duty);
//
//                duty = (duty + dutyInc);
//
//                if (duty == pwmPeriod || (!duty)) {
//                    dutyInc = - dutyInc;
//    }
    }
}


Void gpredictComm(UArg arg0, UArg arg1)
{
    char gpredictInput;
    UART_Params gpredictUartParams;
    Error_Block  gpredictEb;
    Semaphore_Params  gpredictSemParams;

    /* Create a UART with data processing off. */
    UART_Params_init(&gpredictUartParams);
    gpredictUartParams.writeDataMode = UART_DATA_BINARY;
    gpredictUartParams.readDataMode = UART_DATA_BINARY;
    gpredictUartParams.readReturnMode = UART_RETURN_FULL;
    gpredictUartParams.readEcho = UART_ECHO_OFF;
    gpredictUartParams.baudRate = 9600;
    gpredictUartParams.readMode = UART_MODE_CALLBACK; // the uart uses a read interrupt
    gpredictUartParams.readCallback = &UART01_IRQHandler; // function called when the uart interrupt fires

    gpredictUart = UART_open(Board_UART1, &gpredictUartParams);


//    if (uart == NULL) {
//        System_abort("Error opening the UART for Gpredict");
//    }

//    Semaphore_Params_init(&gpredictSemParams);
//    gpredictSemParams.mode = Semaphore_Mode_BINARY;
//
//    SEM_gpredict_uart_rx = Semaphore_create(0, &gpredictSemParams, &gpredictEb);
//    while (1) {
//       // UART_read(gpredictUart, &gpredictInput, 1); // prime the uart bus to read the first character, non blocking
//      //  Semaphore_pend(SEM_gpredict_uart_rx, BIOS_WAIT_FOREVER); // when a character is received via UART, the interrupt handler will release the binary semaphore
//        // in my case: I get an interrupt for a single character, no need to loop.
//        //GPIO_toggle(Board_GPIO_LED1); // LED B - visual clue that we've received a request over USB
//      //  UART_write(uart, &gpredictInput, 1);  // as a test, let's just echo the char
//        //GPIO_toggle(Board_GPIO_LED1); // LED B - visual clue off
//    }


}
void UART01_IRQHandler(UART_Handle handle, void *buffer, size_t num)
{
    Semaphore_post(SEM_gpredict_uart_rx);
}
/*
 *  ======== fnTaskUART ========
 *  Task for this function is created statically. See the project's .cfg file.
 */
Void fnTaskUART(UArg arg0, UArg arg1)
{
    char input;
    UART_Params uartParams;
    Error_Block eb;
    Semaphore_Params sem_params;


    /* Create a UART with data processing off. */
    UART_Params_init(&uartParams);
    uartParams.writeDataMode = UART_DATA_BINARY;
    uartParams.readDataMode = UART_DATA_BINARY;
    uartParams.readReturnMode = UART_RETURN_FULL;
    uartParams.readEcho = UART_ECHO_OFF;
    uartParams.baudRate = 9600;
    uartParams.readMode = UART_MODE_CALLBACK; // the uart uses a read interrupt
    uartParams.readCallback = &UART00_IRQHandler; // function called when the uart interrupt fires
    uart = UART_open(Board_UART0, &uartParams);


    if (uart == NULL) {
        System_abort("Error opening the UART");
    }

    Semaphore_Params_init(&sem_params);
    sem_params.mode = Semaphore_Mode_BINARY;

    SEM_uart_rx = Semaphore_create(0, &sem_params, &eb);
    while (1) {
        UART_read(uart, &input, 1); // prime the uart bus to read the first character, non blocking
        Semaphore_pend(SEM_uart_rx, BIOS_WAIT_FOREVER); // when a character is received via UART, the interrupt handler will release the binary semaphore
        // in my case: I get an interrupt for a single character, no need to loop.
        GPIO_toggle(Board_GPIO_LED1); // LED B - visual clue that we've received a request over USB
        UART_write(gpredictUart, &input, 1);  // as a test, let's just echo the char
        GPIO_toggle(Board_GPIO_LED1); // LED B - visual clue off

    }
}

/* EUSCI A0 UART ISR - The interrupt handler fr UART0 (USB)
 * this method releases the TI-RTOS binary semaphore SEM_uart_rx
 * and uartFxn() will process the received c
 */

void UART00_IRQHandler(UART_Handle handle, void *buffer, size_t num)
{
    Semaphore_post(SEM_uart_rx);
}


Void heartBeatFxn(UArg arg0, UArg arg1)
{

    //GPIO_setConfig(Board_GPIO_LED0 , GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
    //   GPIO_setConfig(Board_DIR2 , GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);


                  //GPIO_write(Board_GPIO_LED0, Board_GPIO_LED_ON);
    while (1) {
//        Task_sleep((UInt)arg0);
//        GPIO_toggle(Board_GPIO_LED0);
//        //System_printf("LED here!!!");
  //      GPIO_write(Board_GPIO_LED0,  0);
        //                  GPIO_write(Board_DIR2,  1);
    }
}

Board_initGPIO()
{
    GPIO_init();
    GPIO_setConfig(Board_GPIO_LED0, GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
    GPIO_setConfig(Board_GPIO_LED1, GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
    GPIO_setConfig(Board_DIR1, GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);
    GPIO_setConfig(Board_DIR2, GPIO_CFG_OUT_STD | GPIO_CFG_OUT_LOW);


}
Board_initADC()
{
    ADC_init();
}
Board_initUART()
{
    UART_init();
}
Board_initPWM()
{
    PWM_init();
}
/*
 *  ======== main ========
 */
int main()
{
    /* Call driver init functions */
    Board_init();
    Board_initGeneral();
    Board_initGPIO();
    Board_initADC();
    Board_initUART();
    Board_initPWM();


    //

//    System_printf("Starting the example\nSystem provider is set to SysMin. "
//                      "Halt the target to view any SysMin contents in ROV.\n");
     /* SysMin will only print to the console when you call flush or exit */

  //   System_flush();

     /* Start BIOS */
    BIOS_start();

        return (0);

    /*
     *  normal BIOS programs, would call BIOS_start() to enable interrupts
     *  and start the scheduler and kick BIOS into gear.  But, this program
     *  is a simple sanity test and calls BIOS_exit() instead.
     */
    //BIOS_exit(0);  /* terminates program and dumps SysMin output */
    //return(0);
}
