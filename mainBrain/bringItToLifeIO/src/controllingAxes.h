#ifndef CONTROLLINGAXES_H
#define CONTROLLINGAXES_H

#include "includeAllStuff.h"

#include "stepMotor.h"

//
extern stepMotor motorEl;
extern stepMotor motorAz;


extern void initAxesControling();



const uint8_t PUL_PERIOD = 540; //540 us
#endif
