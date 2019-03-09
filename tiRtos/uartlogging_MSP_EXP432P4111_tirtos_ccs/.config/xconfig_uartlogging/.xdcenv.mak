#
_XDCBUILDCOUNT = 
ifneq (,$(findstring path,$(_USEXDCENV_)))
override XDCPATH = C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source;C:/ti/simplelink_msp432p4_sdk_2_40_00_10/kernel/tirtos/packages;D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs/.config
override XDCROOT = C:/ti/xdctools_3_51_01_18_core
override XDCBUILDCFG = ./config.bld
endif
ifneq (,$(findstring args,$(_USEXDCENV_)))
override XDCARGS = 
override XDCTARGETS = 
endif
#
ifeq (0,1)
PKGPATH = C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source;C:/ti/simplelink_msp432p4_sdk_2_40_00_10/kernel/tirtos/packages;D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs/.config;C:/ti/xdctools_3_51_01_18_core/packages;..
HOSTOS = Windows
endif
