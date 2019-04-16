#include <ti/devices/msp432p4xx/driverlib/driverlib.h>
#include <stdint.h>
#include <stdbool.h>
#include "uartComm.h"



const eUSCI_UART_Config uartConfig =
{
        EUSCI_A_UART_CLOCKSOURCE_SMCLK,          // SMCLK Clock Source
        78,                                     // BRDIV = 78
        2,                                       // UCxBRF = 2
        0,                                       // UCxBRS = 0
        EUSCI_A_UART_NO_PARITY,                  // No Parity
        EUSCI_A_UART_LSB_FIRST,                  // LSB First
        EUSCI_A_UART_ONE_STOP_BIT,               // One stop bit
        EUSCI_A_UART_MODE,                       // UART mode
        EUSCI_A_UART_OVERSAMPLING_BAUDRATE_GENERATION  // Oversampling
};

void uartInit(void)
{
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1,
                GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);

        /* Setting DCO to 12MHz */
        CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_12);

        //![Simple UART Example]
        /* Configuring UART Module */
        MAP_UART_initModule(EUSCI_A0_BASE, &uartConfig);

        /* Enable UART module */
        MAP_UART_enableModule(EUSCI_A0_BASE);

        /* Enabling interrupts */
        MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
        MAP_Interrupt_enableInterrupt(INT_EUSCIA0);
        MAP_Interrupt_enableSleepOnIsrExit();
        MAP_Interrupt_enableMaster();
}
void EUSCIA0_IRQHandler(void)
{
    uint32_t status = MAP_UART_getEnabledInterruptStatus(EUSCI_A0_BASE);

    MAP_UART_clearInterruptFlag(EUSCI_A0_BASE, status);

    if(status & EUSCI_A_UART_RECEIVE_INTERRUPT_FLAG)
    {
       // MAP_UART_transmitData(EUSCI_A0_BASE, MAP_UART_receiveData(EUSCI_A0_BASE));
    }

}


void putChar(uint_fast8_t data)
{
    MAP_UART_transmitData(EUSCI_A0_BASE,data);
    return;
}

uint8_t getChar(void)
{
    return MAP_UART_receiveData(EUSCI_A0_BASE);
}

void myPrintf(uint8_t* data)
{
    while(*data!='\0')
    {
        putchar(*data);
        data++;
    }
    return;
}

void printNumber(int32_t number)
{
    uint8_t temp_ascii_store[10];
    int8_t counter=0;
    if(number<0)
    {
        putchar('-');
        number*=-1;
    }
    do
    {
       temp_ascii_store[counter]='0'+number%10;
       number/=10;
       counter++;
    }while(number>0);
    for(counter-=1;counter>=0;counter--)
    {
       putchar(temp_ascii_store[counter]);
    }
    return;
}

