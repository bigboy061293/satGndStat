#
#  Do not edit this file.  This file is generated from 
#  package.bld.  Any modifications to this file will be 
#  overwritten whenever makefiles are re-generated.
#
#  target compatibility key = ti.targets.arm.elf.M4F{1,0,18.1,4
#
ifeq (,$(MK_NOGENDEPS))
-include package/cfg/uartlogging_pem4f.oem4f.dep
package/cfg/uartlogging_pem4f.oem4f.dep: ;
endif

package/cfg/uartlogging_pem4f.oem4f: | .interfaces
package/cfg/uartlogging_pem4f.oem4f: package/cfg/uartlogging_pem4f.c package/cfg/uartlogging_pem4f.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4f $< ...
	$(ti.targets.arm.elf.M4F.rootDir)/bin/armcl -c  -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/ti/posix/ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.4.LTS/include" --advice:power=none -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on   -qq -pdsw225 -ms --fp_mode=strict --endian=little -mv7M4 --abi=eabi --float_support=fpv4spd16 -eo.oem4f -ea.sem4f   -Dxdc_cfg__xheader__='"xconfig_uartlogging/package/cfg/uartlogging_pem4f.h"'  -Dxdc_target_name__=M4F -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_18_1_4 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4F.rootDir)/include  -fs=./package/cfg -fr=./package/cfg -fc $<
	$(MKDEP) -a $@.dep -p package/cfg -s oem4f $< -C   -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/ti/posix/ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.4.LTS/include" --advice:power=none -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on   -qq -pdsw225 -ms --fp_mode=strict --endian=little -mv7M4 --abi=eabi --float_support=fpv4spd16 -eo.oem4f -ea.sem4f   -Dxdc_cfg__xheader__='"xconfig_uartlogging/package/cfg/uartlogging_pem4f.h"'  -Dxdc_target_name__=M4F -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_18_1_4 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4F.rootDir)/include  -fs=./package/cfg -fr=./package/cfg
	-@$(FIXDEP) $@.dep $@.dep
	
package/cfg/uartlogging_pem4f.oem4f: export C_DIR=
package/cfg/uartlogging_pem4f.oem4f: PATH:=$(ti.targets.arm.elf.M4F.rootDir)/bin/;$(PATH)
package/cfg/uartlogging_pem4f.oem4f: Path:=$(ti.targets.arm.elf.M4F.rootDir)/bin/;$(PATH)

package/cfg/uartlogging_pem4f.sem4f: | .interfaces
package/cfg/uartlogging_pem4f.sem4f: package/cfg/uartlogging_pem4f.c package/cfg/uartlogging_pem4f.mak
	@$(RM) $@.dep
	$(RM) $@
	@$(MSG) clem4f -n $< ...
	$(ti.targets.arm.elf.M4F.rootDir)/bin/armcl -c -n -s --symdebug:none -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/ti/posix/ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.4.LTS/include" --advice:power=none -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on   -qq -pdsw225 --endian=little -mv7M4 --abi=eabi --float_support=fpv4spd16 -eo.oem4f -ea.sem4f   -Dxdc_cfg__xheader__='"xconfig_uartlogging/package/cfg/uartlogging_pem4f.h"'  -Dxdc_target_name__=M4F -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_18_1_4 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4F.rootDir)/include  -fs=./package/cfg -fr=./package/cfg -fc $<
	$(MKDEP) -a $@.dep -p package/cfg -s oem4f $< -C  -n -s --symdebug:none -mv7M4 --code_state=16 --float_support=FPv4SPD16 -me --include_path="D:/vgu/satGndStat/tiRtos/uartlogging_MSP_EXP432P4111_tirtos_ccs" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/third_party/CMSIS/Include" --include_path="C:/ti/simplelink_msp432p4_sdk_2_40_00_10/source/ti/posix/ccs" --include_path="C:/ti/ccsv8/tools/compiler/ti-cgt-arm_18.1.4.LTS/include" --advice:power=none -g --diag_warning=225 --diag_warning=255 --diag_wrap=off --display_error_number --gen_func_subsections=on   -qq -pdsw225 --endian=little -mv7M4 --abi=eabi --float_support=fpv4spd16 -eo.oem4f -ea.sem4f   -Dxdc_cfg__xheader__='"xconfig_uartlogging/package/cfg/uartlogging_pem4f.h"'  -Dxdc_target_name__=M4F -Dxdc_target_types__=ti/targets/arm/elf/std.h -Dxdc_bld__profile_release -Dxdc_bld__vers_1_0_18_1_4 -O2  $(XDCINCS) -I$(ti.targets.arm.elf.M4F.rootDir)/include  -fs=./package/cfg -fr=./package/cfg
	-@$(FIXDEP) $@.dep $@.dep
	
package/cfg/uartlogging_pem4f.sem4f: export C_DIR=
package/cfg/uartlogging_pem4f.sem4f: PATH:=$(ti.targets.arm.elf.M4F.rootDir)/bin/;$(PATH)
package/cfg/uartlogging_pem4f.sem4f: Path:=$(ti.targets.arm.elf.M4F.rootDir)/bin/;$(PATH)

clean,em4f ::
	-$(RM) package/cfg/uartlogging_pem4f.oem4f
	-$(RM) package/cfg/uartlogging_pem4f.sem4f

uartlogging.pem4f: package/cfg/uartlogging_pem4f.oem4f package/cfg/uartlogging_pem4f.mak

clean::
	-$(RM) package/cfg/uartlogging_pem4f.mak
