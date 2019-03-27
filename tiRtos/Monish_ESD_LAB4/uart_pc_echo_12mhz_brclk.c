/*
 * -------------------------------------------
 *    MSP432 DriverLib - v3_21_00_05 
 * -------------------------------------------
 *
 * --COPYRIGHT--,BSD,BSD
 * Copyright (c) 2016, Texas Instruments Incorporated
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
/******************************************************************************
 * MSP432 Empty Project
 *
 * Description: An empty project that uses DriverLib
 *
 *                MSP432P401
 *             ------------------
 *         /|\|                  |
 *          | |                  |
 *          --|RST               |
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 *            |                  |
 * Author:
*******************************************************************************/
/* DriverLib Includes */

//#include "adc14.h"
//#include <msp.h>
/* Standard Includes */
#include "driverlib.h"
#include <stdint.h>
#include <stdbool.h>
#define DUTYCYCLE (70)
#define param1   (100)
#define param2    (5)
#define param3   (3)
#define CRC32_POLY              0xEDB88320
#define CRC32_INIT              0xFFFFFFFF
#define DEVICE_ID (16)
static const uint8_t myData[9] = { 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9 };
static uint32_t calculateCRC32(uint8_t* data, uint32_t length);

volatile float tempC, tempF;
extern int32_t  operation(int32_t a,int32_t b,int32_t c);
/* Statics */
static uint8_t Data[16] =
{ 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc,
        0xdd, 0xee, 0xff };
static uint8_t CipherKey[32] =
{ 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c,
        0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
        0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f };
static uint8_t DataAESencrypted[16];       // Encrypted data
static uint8_t DataAESdecrypted[16];       // Decrypted data



void LED_toggle(void)
{
    static uint8_t counter=0;
    if(counter&0x02)
    {
        MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN0);//Red
    }
    if(counter&0x04)
    {
        MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN1);//Green
    }
    if(counter&0x08)
    {
        MAP_GPIO_toggleOutputOnPin(GPIO_PORT_P2, GPIO_PIN2);//Blue
    }
    counter++;
}

void putchar(uint_fast8_t data)
{
    MAP_UART_transmitData(EUSCI_A0_BASE,data);
    return;
}

uint8_t getchar(void)
{
    return MAP_UART_receiveData(EUSCI_A0_BASE);
}

void my_printf(uint8_t* data)
{
    while(*data!='\0')
    {
        putchar(*data);
        data++;
    }
    return;
}

void print_number(int32_t number)
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
/* UART Configuration Parameter. These are the configuration parameters to
 * make the eUSCI A UART module to operate with a 9600 baud rate. These
 * values were calculated using the online calculator that TI provides
 * at:
 *http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSP430BaudRateConverter/index.html
 */
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

/* Timer_A PWM Configuration Parameter */
Timer_A_PWMConfig pwmConfig =
{
        TIMER_A_CLOCKSOURCE_SMCLK,
        TIMER_A_CLOCKSOURCE_DIVIDER_1,
        32000,
        TIMER_A_CAPTURECOMPARE_REGISTER_1,
        TIMER_A_OUTPUTMODE_RESET_SET,
        320*DUTYCYCLE
};

void Display_Dutycycle(void)
{
    uint8_t duty_txt[] = "\n\rDutycycle -> ";
    uint8_t next_line[] = "\n\r";
    my_printf(duty_txt);
    print_number(DUTYCYCLE);
    my_printf(next_line);
    return;
}

void Display_Temperature(void)
{
    uint8_t temperature_txt[] = "\n\rTemperature -> ";
    uint8_t C_of_txt[] = "C or ";
    uint8_t F_txt[] = "F\n\r";
    my_printf(temperature_txt);
    print_number((uint32_t)tempC);
    my_printf(C_of_txt);
    print_number((uint32_t)tempF);
    my_printf(F_txt);
}


void encypt_decrypt(void)
{
    uint8_t i=0;
    uint8_t data_txt[]="\n\rData to be encrypted->\n\r";
    uint8_t encrypt_txt[]="\n\rEncrypted data->\n\r";
    uint8_t decrypt_txt[]="\n\rDecrypted data->\n\r";
    MAP_AES256_setCipherKey(AES256_BASE, CipherKey, AES256_KEYLENGTH_256BIT);

    /* Encrypt data with preloaded cipher key */
    MAP_AES256_encryptData(AES256_BASE, Data, DataAESencrypted);

    /* Load a decipher key to module */
    MAP_AES256_setDecipherKey(AES256_BASE, CipherKey,AES256_KEYLENGTH_256BIT);

    /* Decrypt data with keys that were generated during encryption - takes
     214 MCLK cyles. This function will generate all round keys needed for
     decryption first and then the encryption process starts */
    MAP_AES256_decryptData(AES256_BASE, DataAESencrypted, DataAESdecrypted);

    /* Array DataAESdecrypted should now contain the same data as array Data */
    my_printf(data_txt);
    for(i=0;i<16;i++)
    {
        print_number(Data[i]);
        putchar(' ');
    }
    my_printf(encrypt_txt);
    for(i=0;i<16;i++)
    {
        print_number( DataAESencrypted[i]);
        putchar(' ');
    }
    my_printf(decrypt_txt);
    for(i=0;i<16;i++)
    {
        print_number(DataAESdecrypted[i]);
        putchar(' ');
    }
    for(i=0;i<32;i++)
    {
        CipherKey[i]+=DEVICE_ID;
    }
}

/* Standard software calculation of CRC32 */
static uint32_t calculateCRC32(uint8_t* data, uint32_t length)
{
    uint32_t ii, jj, byte, crc, mask;

    crc = CRC32_INIT;

    for(ii=0;ii<length;ii++)
    {
        byte = data[ii];
        crc = crc ^ byte;

        for (jj = 0; jj < 8; jj++)
        {
            mask = -(crc & 1);
            crc = (crc >> 1) ^ (CRC32_POLY & mask);
        }

    }
    return ~crc;
}

int main(void)
{

    uint8_t ii=0,Welcome_txt[] = "\n\rMonish Nene ESD Spring 2018 Lab 3\n\rPress 'T' for Temperature, 'C' for CRC test  , 'P' for Dutycycle, 'X' for challenge operation, 'E' for Encryption and Decryption  \n\rAll other characters will be echoed. \n\r";
    /* Halting WDT  */
    WDT_A_holdTimer();

    MAP_CRC32_setSeed(CRC32_INIT, CRC32_MODE);

    for (ii = 0; ii < 9; ii++)
    MAP_CRC32_set8BitData(myData[ii], CRC32_MODE);

    /* Configuring LED pins as output and P1.4 (switch) as input */
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN0);// RED
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN1);// GREEN
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P2, GPIO_PIN2);// BLUE
    MAP_GPIO_setAsOutputPin(GPIO_PORT_P1, GPIO_PIN0);// REDsingle

    /* Selecting P1.2 and P1.3 in UART mode */
    MAP_GPIO_setAsPeripheralModuleFunctionInputPin(GPIO_PORT_P1,
            GPIO_PIN1 | GPIO_PIN2 | GPIO_PIN3, GPIO_PRIMARY_MODULE_FUNCTION);

    /* Setting DCO to 12MHz */
    CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_12);

    /* Configuring UART Module */
    MAP_UART_initModule(EUSCI_A0_BASE, &uartConfig);

    /* Enable UART module */
    MAP_UART_enableModule(EUSCI_A0_BASE);

    /* Configuring GPIO2.4 as peripheral output for PWM  and P6.7 for button
     * interrupt */
    MAP_GPIO_setAsPeripheralModuleFunctionOutputPin(GPIO_PORT_P2, GPIO_PIN4, GPIO_PRIMARY_MODULE_FUNCTION);
    MAP_GPIO_setAsInputPinWithPullUpResistor(GPIO_PORT_P1, GPIO_PIN1);

    /* Configuring Timer_A to have a period of approximately 500ms and
     * an initial duty cycle of 70% of that (22400 ticks)  */
    MAP_Timer_A_generatePWM(TIMER_A0_BASE, &pwmConfig);

    my_printf(Welcome_txt);

     /*Initializing ADC (MCLK/1/1) with temperature sensor routed */
    ADC14_enableModule();
    ADC14_initModule(ADC_CLOCKSOURCE_MCLK, ADC_PREDIVIDER_1, ADC_DIVIDER_1,
    ADC_TEMPSENSEMAP);

    /* Configuring ADC Memory (ADC_MEM0 A22 (Temperature Sensor) in repeat
    * mode).
    */
    ADC14_configureSingleSampleMode(ADC_MEM0, true);
    ADC14_configureConversionMemory(ADC_MEM0, ADC_VREFPOS_INTBUF_VREFNEG_VSS,
    ADC_INPUT_A22, false);

    /* Configuring the sample/hold time for TBD */
    ADC14_setSampleHoldTime(ADC_PULSE_WIDTH_192,ADC_PULSE_WIDTH_192);

    /* Enabling sample timer in auto iteration mode and interrupts*/
    ADC14_enableSampleTimer(ADC_AUTOMATIC_ITERATION);
    ADC14_enableInterrupt(ADC_INT0);

    /* Setting reference voltage to 2.5 and enabling temperature sensor */
    REF_A_setReferenceVoltage(REF_A_VREF2_5V);
    REF_A_enableReferenceVoltage();
    REF_A_enableTempSensor();

    /* Enabling Interrupts */
    Interrupt_enableInterrupt(INT_ADC14);
    Interrupt_enableMaster();

    /* Triggering the start of the sample */
    ADC14_enableConversion();
    ADC14_toggleConversionTrigger();

    /* Configuring SysTick to trigger at 1500000 (MCLK is 3MHz so this will make
     * it toggle every 0.5s) */
    MAP_SysTick_enableModule();
    MAP_SysTick_setPeriod(1500000);
    MAP_Interrupt_enableSleepOnIsrExit();
    MAP_SysTick_enableInterrupt();

    /* Enabling interrupts */
    MAP_UART_enableInterrupt(EUSCI_A0_BASE, EUSCI_A_UART_RECEIVE_INTERRUPT);
    MAP_Interrupt_enableInterrupt(INT_EUSCIA0);
    MAP_Interrupt_enableSleepOnIsrExit();
    MAP_Interrupt_enableMaster();


    /* Stop Watchdog  */
    MAP_WDT_A_holdTimer();

    while(1)
    {
        PCM_gotoLPM0();
    }
}

/* EUSCI A0 UART ISR - Echoes data back to PC host */
void EUSCIA0_IRQHandler(void)
{
    uint8_t a_txt[] = "\n\rparam1=";
    uint8_t b_txt[] = "\n\rparam2=";
    uint8_t c_txt[] = "\n\rparam3=";
    uint8_t operation_txt[] = "\n\rThe operation performed is Result = param1*(param2%param3) ";
    uint8_t result_txt[] = "\n\rResult = ";
    uint8_t temp_data = 0;
    int32_t result=0;
    uint32_t status = MAP_UART_getEnabledInterruptStatus(EUSCI_A0_BASE);
    volatile uint32_t hwCalculatedCRC, swCalculatedCRC;
    uint8_t hw_crc_txt[]="\n\rCRC calculated by hardware = ";
    uint8_t sw_crc_txt[]="\n\rCRC calculated by software = ";
    uint8_t crc_passed_txt[]="\n\rCRC passed";
    uint8_t crc_failed_txt[]="\n\rCRC failed";
    /* Getting the result from the hardware module */
    MAP_UART_clearInterruptFlag(EUSCI_A0_BASE, status);
    if(status & EUSCI_A_UART_RECEIVE_INTERRUPT_FLAG)
    {
        temp_data = getchar();
        switch(temp_data)
        {
            case 'T':
            {
                Display_Temperature();
                break;
            }

            case 'P':
            {
                Display_Dutycycle();
                break;
            }

            case 'X':
            {
                my_printf(a_txt);
                print_number(param1);
                my_printf(b_txt);
                print_number(param2);
                my_printf(c_txt);
                print_number(param3);
                result=operation(param1,param2,param3);
                my_printf(operation_txt);
                my_printf(result_txt);
                print_number(result);
                break;
            }

            case 'E':
            {
                encypt_decrypt();
                break;
            }

            case 'C':
            {
                hwCalculatedCRC = MAP_CRC32_getResultReversed(CRC32_MODE) ^ CRC32_INIT;
                /* Calculating the CRC32 checksum through software */
                swCalculatedCRC = calculateCRC32((uint8_t*) myData, 9);
                my_printf(hw_crc_txt);
                print_number(hwCalculatedCRC);
                my_printf(sw_crc_txt);
                print_number(swCalculatedCRC);
                if(hwCalculatedCRC == swCalculatedCRC)
                {
                    my_printf(crc_passed_txt);
                }
                else
                {
                    my_printf(crc_failed_txt);
                }
                break;
            }

            default :
            {
                putchar(temp_data);
                break;
            }
        }
    }
}

/* This interrupt happens every time a conversion has completed. Since the FPU
 * is enabled in stacking mode, we are able to use the FPU safely to perform
 * efficient floating point arithmetic.*/
void ADC14_IRQHandler(void)
{
    uint64_t status;
    int32_t cal30, cal85;

    status = ADC14_getEnabledInterruptStatus();
    ADC14_clearInterruptFlag(status);

    if(status & ADC_INT0)
    {
        cal30 = SysCtl_getTempCalibrationConstant(SYSCTL_2_5V_REF,
                SYSCTL_30_DEGREES_C);
        cal85 = SysCtl_getTempCalibrationConstant(SYSCTL_2_5V_REF,
                SYSCTL_85_DEGREES_C);

        tempC = (float) (((int32_t)ADC14_getResult(ADC_MEM0) - cal30) * (85 - 30)) / (cal85 - cal30) + 30.0;
        tempF = tempC * 9.0f / 5.0f + 32.0f;
    }
}

void SysTick_Handler(void)
{
    LED_toggle();
}
