#ifndef CONTROLLINGAXES_H
#define CONTROLLINGAXES_H

#define PULSE_MODE 1

#include "includeAllStuff.h"
#include "stepMotor.h"


//
extern stepMotor motorEl;
extern stepMotor motorAz;
//extern stepMotor5Phase motorAz;



extern void initAxesControling();
extern void updatePos();
extern void banbangController();

 //540 us
#endif
