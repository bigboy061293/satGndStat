#include <ti/devices/msp432p4xx/inc/msp.h>
#include <ti/devices/msp432p4xx/driverlib/driverlib.h>

void SetConfiguation(void);

int main(void)
{
    WDT_A_holdTimer();
    SetConfiguation();
    while(1);
}

void SetConfiguation(void)
{

    Interrupt_disableMaster();

    CS_setDCOCenteredFrequency(CS_DCO_FREQUENCY_24);
    CS_initClockSignal(CS_SMCLK, CS_DCOCLK_SELECT, CS_CLOCK_DIVIDER_128);

    /*
    Timer_A_UpModeConfig upConfig =
    {
            TIMER_A_CLOCKSOURCE_SMCLK,              // SMCLK Clock SOurce
            TIMER_A_CLOCKSOURCE_DIVIDER_64,          // SCLK/64 = 24MHz/128/64 = 2929 Hz
            24,                           // 50000 tick period
            TIMER_A_TAIE_INTERRUPT_ENABLE,         // Enable Timer interrupt
            TIMER_A_CCIE_CCR0_INTERRUPT_ENABLE ,    // Enable CCR0 interrupt
            //TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE,     // Disable CCR0 interrupt
            TIMER_A_DO_CLEAR                      // Clear value
    };
    */
    Timer_A_PWMConfig pwmConf =
    {
        //uint_fast16_t clockSource;
        TIMER_A_CLOCKSOURCE_SMCLK,
        //uint_fast16_t clockSourceDivider;
        TIMER_A_CLOCKSOURCE_DIVIDER_64,
        //uint_fast16_t timerPeriod;
        1600,
        //uint_fast16_t compareRegister;
        TIMER_A_CAPTURECOMPARE_REGISTER_1,
        //uint_fast16_t compareOutputMode;
        TIMER_A_OUTPUTMODE_SET_RESET,
        //uint_fast16_t dutyCycle;
        200
    };

    Timer_A_generatePWM(TIMER_A0_BASE, &pwmConf);

    P1DIR |= BIT0;
    P1OUT &= ~BIT0;

    //Timer_A_configureUpMode(TIMER_A0_MODULE, &upConfig);
    /*
    Timer_A_CompareModeConfig compConfig =
    {
        //uint_fast16_t compareRegister;
        TIMER_A_CAPTURECOMPARE_REGISTER_1,
        //uint_fast16_t compareInterruptEnable;
        TIMER_A_CAPTURECOMPARE_INTERRUPT_ENABLE,
        //uint_fast16_t compareOutputMode;
        TIMER_A_OUTPUTMODE_SET_RESET,
        //TIMER_A_OUTPUTMODE_TOGGLE_RESET,
        //uint_fast16_t compareValue;
        6
    };
    */
    //Timer_A_initCompare(TIMER_A0_MODULE, &compConfig);

    Timer_A_enableCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_0);
    Timer_A_enableCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);

    Interrupt_enableInterrupt(INT_TA0_0);
    Interrupt_enableInterrupt(INT_TA0_N);

    PCM_setCoreVoltageLevel(PCM_VCORE0);
    PCM_setPowerState(PCM_AM_LDO_VCORE0);

    //Timer_A_startCounter(TIMER_A0_MODULE, TIMER_A_UP_MODE);
    Interrupt_enableMaster();
}


void Port1IsrHandler(void)
{

}

void Timer_AIsrHandler(void)
{
    Timer_A_clearCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_0);
    //Timer_A_clearCaptureCompareInterrupt(TIMER_A0_MODULE, TIMER_A_CAPTURECOMPARE_REGISTER_1);
    //Timer_A_clearInterruptFlag(TIMER_A0_MODULE);
    P1OUT ^= 1;

}

void Timer_A_N_IsrHandler(void)
{
    Timer_A_clearCaptureCompareInterrupt(TIMER_A0_BASE, TIMER_A_CAPTURECOMPARE_REGISTER_1);
    P1OUT ^= 1;
}
