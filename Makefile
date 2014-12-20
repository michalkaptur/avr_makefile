#----------------------------------------------------------------------------------------
# Quite universal Makefile for AVR MCUs
# Works under Linux
#
# created by Michal Kaptur (2014)
# @ kaptur.michal at gmail
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
#Project specific settings

TARGET_GCC=atmega32
TARGET_DUDE=m32
FCPU=8000000UL
INCLUDES_DIR=../avr_libs/
LIBS=
#LIBS+=mklib_1wire
#LIBS+=mklib_ds18b20
#LIBS+=mklib_usart

#----------------------------------------------------------------------------------------
#Programmer settings
UPLOADER=avrdude
PORT=avrdoper
PROGRAMMER=stk500v2

#----------------------------------------------------------------------------------------
#Universal settings

CXX=avr-gcc
SHELL=bash
OUTPUT=$(shell basename $(CURDIR))
#define, macros
DFLAGS=-DF_CPU=$(FCPU)
#includes
INCLUDES=-I$(INCLUDES_DIR)

#FIXME:
#INCLUDES+=-I../avr_libs/mklib_usart
#INCLUDES+=-I../avr_libs/mklib_ds18b20
#INCLUDES+=-I../avr_libs/mklib_1wire



CXX_PARAMS=-std=c99

#----------------------------------------------------------------------------------------
#Actual makefile
#----------------------------------------------------------------------------------------


build:
#	#FIXME:
#	#LIBS_SOURCES:=$(addprefix $(INCLUDES_DIR), $(LIBS))
#	#LIBS_SOURCES2:=$(foreach SOURCE, $(LIBS_SOURCES),$(shell find "$(SOURCE)" -name '*.c'))
	@`mkdir -p bin`
	@echo -e "\e[32mCompiling...\e[39m"
	$(CXX) $(LIBS_SOURCES2) ./main.c -O2 -mmcu=$(TARGET_GCC) $(CXX_PARAMS) $(INCLUDES) $(DFLAGS) -o ./bin/$(OUTPUT).elf
	@echo -e "\t\e[32m done.\e[39m"
	@echo -e "\n\e[32m Creating hex file...\e[39m"
	avr-objcopy -j .text -j .data -O ihex ./bin/$(OUTPUT).elf ./bin/$(OUTPUT).hex
	@echo -e "\t\e[32m done.\e[39m"

run: build
	@echo -e "\n\e[0;32m Uploading hex file...\e[39m"
	$(UPLOADER) -P $(PORT) -c $(PROGRAMMER) -p$(TARGET_DUDE) -U flash:w:./bin/$(OUTPUT).hex

clean:
	rm -rf *.o
	rm -rf *.elf
	rm -rf *.hex
	rm -rf .\bin
	@echo -e "\t\n \e[32m cleaned up.\e[39m"

test_connect:
	@$(UPLOADER) -P $(PORT) -c $(PROGRAMMER) -p$(TARGET_DUDE)


print_mcu_names:
	@echo -e "\e[32m Names for TARGET_GCC\e[39m"
	-avr-as -mx
	@echo -e "\n\e[32m Names for TARGET_DUDE\e[39m"
	-$(UPLOADER) -P $(PORT) -c $(PROGRAMMER)
	@echo -e "\n\e[32m Don't care about these 'error' above, it's a simple way to get target names listed.\e[39m"
