################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board.c \
../dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board_sysinit.c 

OBJS += \
./dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board.o \
./dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board_sysinit.o 

C_DEPS += \
./dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board.d \
./dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/board_sysinit.d 


# Each subdirectory must supply rules for building sources it contributes
dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/%.o: ../dmix_lpc_m0/lpc_board_nxp_lpclink2_4370_m0/src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU C Compiler'
	arm-none-eabi-gcc -D__NEWLIB__ -DDEBUG -D__CODE_RED -DCORE_M0 -D__USE_LPCOPEN -DCPP_USE_HEAP -D__LPC43XX__ -D__MULTICORE_M0APP -DCORE_M0APP -I"C:\Users\kouhei\Documents\GitHub\dmix\lpc\dmix_lpc_m0\dmix_lpc_m0\lpc_chip_43xx_m0\inc" -I"C:\Users\kouhei\Documents\GitHub\dmix\lpc\dmix_lpc_m0\dmix_lpc_m0\lpc_board_nxp_lpclink2_4370_m0\inc" -I"C:\Users\kouhei\Documents\GitHub\dmix\lpc\dmix_lpc_m0\dmix_lpc_m0\lpc_chip_43xx_m0\inc\config_m0app" -I"C:\Users\kouhei\Documents\GitHub\dmix\lpc\dmix_lpc_m0\dmix_lpc_m0\lpc_chip_43xx_m0\inc\usbd" -O0 -g3 -Wall -c -fmessage-length=0 -fno-builtin -ffunction-sections -fdata-sections -mcpu=cortex-m0 -mthumb -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


