#ifndef PINSTATECONSTANTS_H
#define PINSTATECONSTANTS_H

// For AZ before , half step, 360 degree is 500 pulses (precise)
// For AZ after (x160) , half step, 360 degree is 80 000 pulses (precise)
//(80 000 pulse <=> 360 degree)

// For EL after (x2000), full step, 360 degree is 800 000 pulse => need to recalibrated
//( 800 000 pulse <=> 360 degree)
#define CW 0
#define CCW 1

#define CW_E 1
#define CCW_E 0

#define CLOSED 0
#define OPENED 1

#define PUL_PIN_EL 11
#define DIR_PIN_EL 9
#define PUL_PIN_AZ 12
#define DIR_PIN_AZ 13
#define PUL_PIN_AZ_1 12
#define PUL_PIN_AZ_2 13

#define BUT_1_PIN 28
#define BUT_2_PIN 29

#define LED7_DATA 26
#define LED7_CLOCK 27

#define LED8_DATA 24
#define LED8_CLOCK 25

#define BUT_3_PIN 22
#define BUT_4_PIN 23


#define ENDSTOP_PIN_AZ 30
#define ENDSTOP_PIN_EL 31

#define AZ_END (digitalRead(ENDSTOP_PIN_AZ))
#define EL_END (digitalRead(ENDSTOP_PIN_EL))

#define BUT_1_PUSHED ((digitalRead(BUT_1_PIN)) == 0)
#define BUT_2_PUSHED ((digitalRead(BUT_2_PIN)) == 0)
#define BUT_3_PUSHED ((digitalRead(BUT_3_PIN)) == 0)
#define BUT_4_PUSHED ((digitalRead(BUT_4_PIN)) == 0)

#define PIN_A 2
#define PIN_B 3
#define PIN_C 4
#define PIN_STATE_EL 5
#define PIN_STATE_AZ 6

#define BAUDRATE_SERIAL_1 9600
#define BAUDRATE_SERIAL_2 19200

#define TIME_OUT_EASYCOMM 2000

//#define WORING_PERIOD 150 // 1.5Mhz <-> 1s: 1500000.
#define WORING_PERIOD 1500 // 1.5Mhz <-> 1s: 1500000.
#define WORING_PERIOD_EASYCOMM WORING_PERIOD*10
#define PUL_PERIOD  600
#define PUL_PERIOD_5_PHASE  200
//it was 600
/*
2
3
4
5
6


9
10
11
12

*/
#define EASYCOMMBUFFERSIZE 256

#define AZ_TOLERANCE 1
#define EL_TOLERANCE 1

#define MODE_TEST_1 0
#define MODE_TEST_2 1
#define MODE_HOMING_EL_MANUALLY_BOTH_AUTO 2
#define MODE_PC_EL 7
#define MODE_PC_AZ 8

#define MODE_HOMING_EL_MANUALLY 4
#define MODE_HOMING_AZ_MANUALLY 5

#define MODE_GPREDICT 6

#define MAX_RANGE_360_8_BIT 255
#define MAX_RANGE_180_8_BIT 127

#define MAX_RANGE_AZ 300.0
#define MAX_RANGE_EL 170.0

#define MIN_RANGE_AZ 0.0
#define MIN_RANGE_EL 5.0

#endif
