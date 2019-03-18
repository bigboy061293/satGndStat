#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "pulseGen.h"


  //ACLK = TACLK = 32768Hz, MCLK = SMCLK = DCO = 3MHz

const int periodNum = 800; // Need to make clear about the timer and how this fucking number is made. Using oscilloscope
const int dutyCyble = periodNum/2;
Timer_A_PWMConfig pwmConfigCCR1A =
{
        TIMER_A_CLOCKSOURCE_SMCLK,
        TIMER_A_CLOCKSOURCE_DIVIDER_2,
        periodNum,
        TIMER_A_CAPTURECOMPARE_REGISTER_1,
        TIMER_A_OUTPUTMODE_RESET_SET,
        dutyCyble
};
Timer_A_PWMConfig pwmConfigCCR2A =
{
        TIMER_A_CLOCKSOURCE_SMCLK,
        TIMER_A_CLOCKSOURCE_DIVIDER_2,
        periodNum,
        TIMER_A_CAPTURECOMPARE_REGISTER_2,
        TIMER_A_OUTPUTMODE_RESET_SET,
        dutyCyble
};
Timer_A_PWMConfig pwmConfigCCR3A =
{
        TIMER_A_CLOCKSOURCE_SMCLK,
        TIMER_A_CLOCKSOURCE_DIVIDER_2,
        periodNum,
        TIMER_A_CAPTURECOMPARE_REGISTER_3,
        TIMER_A_OUTPUTMODE_RESET_SET,
        dutyCyble
};

void timerAInit(void)
{
    //![Simple Timer_A Example]
        /* Setting MCLK to REFO at 128Khz for LF mode
         * Setting SMCLK to 64Khz */


        //MAP_CS_setReferenceOscillatorFrequency(CS_REFO_128KHZ);
        //MAP_CS_initClockSignal(CS_MCLK, CS_REFOCLK_SELECT, CS_CLOCK_DIVIDER_1);
        //MAP_CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_24);
        //MAP_CS_initClockSignal(CS_SMCLK, CS_REFOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    //MAP_CS_setReferenceOscillatorFrequency(CS_REFO_128KHZ);
      //  MAP_CS_initClockSignal(CS_SMCLK, CS_REFOCLK_SELECT, CS_CLOCK_DIVIDER_1);
    //MAP_PCM_setPowerState(PCM_AM_LF_VCORE0);

        const uint8_t port_mapping[] = { PMAP_TA0CCR0A, PMAP_TA0CCR1A, PMAP_TA0CCR2A, PMAP_NONE, PMAP_NONE, PMAP_NONE, PMAP_NONE, PMAP_NONE };
       // MAP_PMAP_configurePorts((const uint8_t *) port_mapping, PMAP_P2MAP, 1, PMAP_DISABLE_RECONFIGURATION);


           // MAP_CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_24);
            //MAP_CS_initClockSignal(CS_SMCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_128);

        /* Configuring GPIO2.4 as peripheral output for PWM  and P6.7 for button
         * interrupt */
        MAP_GPIO_setAsPeripheralModuleFunctionOutputPin(GPIO_PORT_P2, GPIO_PIN4 | GPIO_PIN5 ,GPIO_PRIMARY_MODULE_FUNCTION);
        MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);
        MAP_GPIO_clearInterruptFlag(GPIO_PORT_P1, GPIO_PIN1);
        MAP_GPIO_enableInterrupt(GPIO_PORT_P1, GPIO_PIN1);

        /* Configuring Timer_A to have a period of approximately 500ms and
         * an initial duty cycle of 10% of that (3200 ticks)  */
        MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfigCCR1A);
        MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfigCCR2A);
        //MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfigCCR3A);
        //![Simple Timer_A Example]

//
        /* Enabling interrupts and starting the watchdog timer */
        MAP_Interrupt_enableInterrupt(INT_PORT1);
        MAP_Interrupt_enableSleepOnIsrExit();
      //  MAP_Interrupt_enableMaster(); --------------> later on!!!!




}

