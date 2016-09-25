// Copyright 2012 The MathWorks, Inc.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include "MW_gpio.h"

// Local defines
#define SYSFS_OMAP_MUX_DIR      "/sys/kernel/debug/omap_mux/"

// Define pin mux settings for each chip family
#if defined(_OMAP3_GPIO_MUX_)
 #define GPIO_PIN_INPUT_OFF       ("0x104")
 #define GPIO_PIN_INPUT_PULLUP    ("0x11c")
 #define GPIO_PIN_INPUT_PULLDOWN  ("0x10c")
 #define GPIO_PIN_OUTPUT          ("0x4")
#elif defined(_OMAP4_GPIO_MUX_)
 #define GPIO_PIN_INPUT_OFF       ("0x103")
 #define GPIO_PIN_INPUT_PULLUP    ("0x11b")
 #define GPIO_PIN_INPUT_PULLDOWN  ("0x10b")
 #define GPIO_PIN_OUTPUT          ("0x3")
#endif
         

// Set PIN MUXING for GPIO pin if necessary
// The input parameters pinName and mode must be null terminated strings
#if defined(_OMAP3_GPIO_MUX_) || defined(_OMAP4_GPIO_MUX_)
int32_T setGpioPinMux(const uint8_T *pinName, boolean_T direction, uint32_T internalResistor)
{
    int fd;
    char buf[GPIO_MAX_BUF] = SYSFS_OMAP_MUX_DIR;
    char padConf[8];
    ssize_t bytesWritten;
    
    // Early return in case mux configuration is not needed
    if ((pinName == NULL) || (pinName[0] == '\0')) {
#ifdef _DEBUG
        fprintf(stdout, "setGpioPinMux: Null pin name.\n");
#endif
        return 0;
    }
    
    // Fill in padConf value, "0x011b" for example, to set the pin mux mode
    if (direction == GPIO_DIRECTION_INPUT) {
        switch (internalResistor) {
            case INTERNAL_RESISTOR_OFF:
                strcpy(&padConf[0], GPIO_PIN_INPUT_OFF);
                break;
            case INTERNAL_RESISTOR_PULLUP:
                strcpy(&padConf[0], GPIO_PIN_INPUT_PULLUP);
                break;
            case INTERNAL_RESISTOR_PULLDOWN:
                strcpy(&padConf[0], GPIO_PIN_INPUT_PULLDOWN);
                break;
            case INTERNAL_RESISTOR_NA:
                return 0; 
                break;
            default:
#ifdef _DEBUG
                fprintf(stderr, "Unknown internal resistor configuration %d.\n", internalResistor);
#endif
                return -1;
        }
    }
    else { //direction == GPIO_DIRECTION_OUTPUT
        strcpy(&padConf[0], GPIO_PIN_OUTPUT);
    }
    
    // Configure pin mux settings
    strcat(buf, pinName);
    fd = open(buf, O_WRONLY);
    if (fd < 0) {
#ifdef _DEBUG
        fprintf(stderr, "file = '%s', pin name = '%s'\n", buf, pinName);
        perror("Open pinmux file:");
#endif
        return -1;
    }
    bytesWritten = write(fd, padConf, strlen(padConf) + 1);
    close(fd);
    
    return 0;
}
#else
// If we are not on OMAP3 / OMAP4 platform substitute a macro that does nothing
int32_T setGpioPinMux(const uint8_T *pinName, boolean_T direction, uint32_T internalResistor)
{
    return 0;
}
#endif

#ifdef _MW_GPIO_PINMUX_TEST_
// Main function for testing
int main(int argc, char *argv[])
{
    char pf[GPIO_MAX_BUF]   = "/mcspi1_cs3"; 
    
    // set pin to INPUT, Pull-up
    if (setGpioPinMux(pf, GPIO_DIRECTION_INPUT, INTERNAL_RESISTO_PULLUP) < 0) {
        fprintf(stderr, "Error setting pin muxing mode for %s\n", pf);
    }
    
    exit(EXIT_SUCCESS);
}
#endif //_GPIO_PINMUX_MAIN_

