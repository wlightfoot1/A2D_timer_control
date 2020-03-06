################################################################################
# Automatically-generated file. Do not edit!
################################################################################

#Progress monitor hint: 1
first : all
-include ../makefile.init

# This file contains definitions of environment variables used in the makefiles and .args files if exist.
-include makefile.local

RM := "$(GNU_Make_Install_DirEnv)/rm" -f

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include Sources/subdir.mk
-include Project_Settings/Linker_Files/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(ASM_UPPER_DEPS)),)
-include $(ASM_UPPER_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
lab12_A2D_timer_control.abs \

EXECUTABLES_QUOTED += \
"lab12_A2D_timer_control.abs" \

EXECUTABLES_OS_FORMAT += \
lab12_A2D_timer_control.abs \

BURNER_OUTPUT_OUTPUTS += \
lab12_A2D_timer_control.abs.s19 \

BURNER_OUTPUT_OUTPUTS_QUOTED += \
"lab12_A2D_timer_control.abs.s19" \

BURNER_OUTPUT_OUTPUTS_OS_FORMAT += \
lab12_A2D_timer_control.abs.s19 \


# All Target
call-burner := 0
ifneq ($(strip $(EXECUTABLES)),)
ifneq ($(strip $(BBL_SRCS_QUOTED)),)
call-burner := 1
endif
endif
ifeq ($(call-burner),1)
all: lab12_A2D_timer_control.abs lab12_A2D_timer_control.abs.s19
else
all: lab12_A2D_timer_control.abs
endif

# Tool invocations
lab12_A2D_timer_control.abs: $(OBJS) $(USER_OBJS) ../Project_Settings/Linker_Files/Project.prm
	@echo 'Building target: $@'
	@echo 'Executing target #2 $@'
	@echo 'Invoking: S08 Linker'
	"$(HC08ToolsEnv)/linker" -ArgFile"lab12_A2D_timer_control.args" -O"lab12_A2D_timer_control.abs"
	@echo 'Finished building target: $@'
	@echo ' '

lab12_A2D_timer_control.abs.s19: $(BBL_SRCS) $(EXECUTABLES)
	@echo 'Executing target #3 $@'
	@echo 'Invoking: S08 Burner'
	"$(HC08ToolsEnv)/burner" -ArgFile"lab12_A2D_timer_control.abs.args" -f="$<" -env"ABS_FILE=$(strip $(EXECUTABLES_OS_FORMAT))"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(S_DEPS_QUOTED) "./*/*.obj"  $(CPP_DEPS_QUOTED) $(CC_DEPS_QUOTED) $(S_UPPER_DEPS_QUOTED) $(CXX_DEPS_QUOTED) "./*/*.d"  $(BURNER_OUTPUT_OUTPUTS_QUOTED) $(ASM_UPPER_DEPS_QUOTED) $(C_UPPER_DEPS_QUOTED) $(C++_DEPS_QUOTED) $(EXECUTABLES_QUOTED) $(C_DEPS_QUOTED) $(ProjDirPath)/FLASH/lab12_A2D_timer_control.abs $(ProjDirPath)/FLASH/lab12_A2D_timer_control.abs.args $(ProjDirPath)/FLASH/lab12_A2D_timer_control.abs.s19 $(ProjDirPath)/FLASH/lab12_A2D_timer_control.args $(ProjDirPath)/FLASH/lab12_A2D_timer_control.map
	-@echo ' '

.PHONY: all clean dependents explicit-dependencies warning-messages
.SECONDARY:

-include ../makefile.targets

explicit-dependencies: ../Project_Settings/Linker_Files/Project.prm 

warning-messages: 

