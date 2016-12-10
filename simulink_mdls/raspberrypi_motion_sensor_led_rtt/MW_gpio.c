// Copyright 2012 The MathWorks, Inc.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include "MW_gpio.h"

// Local defines
#define SYSFS_GPIO_DIR          "/sys/class/gpio"
#define POLL_TIMEOUT            (-1) // Forever

typedef struct {
    int gpio;                   // Pin number
    int fd;                     // File descriptor for the GPIO pin  
    boolean_T direction;        // Input or output
    int internalResistor;       // Internal resistor setting
    uint8_T pinName[32];        // Pin name from data sheet
} GPIO_info;

int numGpio = 0;                // Number of GPIO modules used
GPIO_info *gpioInfo = NULL;     // Structure array holding GPIO info

extern int32_T setGpioPinMux(const uint8_T *pinName, boolean_T direction, uint32_T internalResistor);

// Export specified GPIO pin
int gpioExport(unsigned int gpio)
{
    int fd, len;
    char buf[GPIO_MAX_BUF];
    ssize_t bytesWritten;
    
    fd = open(SYSFS_GPIO_DIR "/export", O_WRONLY);
    if (fd < 0) {
#ifdef _DEBUG
        perror("gpio/export");
#endif
        return fd;
    }
    len = snprintf(buf, sizeof(buf), "%d", gpio);
    bytesWritten = write(fd, buf, len);
    close(fd);
    
    return 0;
}

// Remove specified GPIO pin from export list
int gpioUnexport(unsigned int gpio)
{
	int fd, len;
	char buf[GPIO_MAX_BUF];
    ssize_t bytesWritten;
 
	fd = open(SYSFS_GPIO_DIR "/unexport", O_WRONLY);
	if (fd < 0) {
#ifdef _DEBUG
		perror("gpio/export");
#endif
		return fd;
	}
	len = snprintf(buf, sizeof(buf), "%d", gpio);
	bytesWritten = write(fd, buf, len);
	close(fd);
    
	return 0;
}

// Set direction of the GPIO pin
int gpioSetDirection(unsigned int gpio, unsigned int direction)
{
	int fd;
	char buf[GPIO_MAX_BUF];
    ssize_t bytesWritten;
 
	snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR  "/gpio%d/direction", gpio);
 
    // Open device file
	fd = open(buf, O_WRONLY);
	if (fd < 0) {
#ifdef _DEBUG
		perror("gpio/direction");
#endif
		return fd;
	}
 
    // Set direction
	if (direction == GPIO_DIRECTION_INPUT) {
		bytesWritten = write(fd, "in", 3);
    }
	else {
        bytesWritten = write(fd, "out", 4);
    }
	close(fd);
    
	return 0;
}

// Set interrupt edge
int gpioSetInterruptEdge(unsigned int gpio, char *edge)
{
	int fd;
	char buf[GPIO_MAX_BUF];
    ssize_t bytesWritten;

	snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/edge", gpio);
 
	fd = open(buf, O_WRONLY);
	if (fd < 0) {
#ifdef _DEBUG
		perror("gpio/set-edge");
#endif
		return fd;
	}
	bytesWritten = write(fd, edge, strlen(edge) + 1); 
	close(fd);
    
	return 0;
}

// Open GPIO device
int gpioOpen(unsigned int gpio, int direction)
{
	int fd;
	char buf[GPIO_MAX_BUF];
    ssize_t bytesWritten;

	snprintf(buf, sizeof(buf), SYSFS_GPIO_DIR "/gpio%d/value", gpio);
    if (direction == GPIO_DIRECTION_INPUT) {
        fd = open(buf, O_RDONLY | O_NONBLOCK);
    }
    else {
        fd = open(buf, O_WRONLY | O_NONBLOCK);
    }
	if (fd < 0) {
#ifdef _DEBUG
		perror("gpio/fd_open");
#endif
	}
	return fd;
}

// Close GPIO device
int gpioClose(int fd)
{
	return close(fd);
}

// Return resources used for GPIO
void MW_gpioExit(void)
{
    if (gpioInfo != NULL) {
        free(gpioInfo);
    }
    exit(EXIT_FAILURE);
}

// Return a pointer to GPIO infor structure for a given GPIO
GPIO_info *MW_getGpioInfo(const int32_T gpio)
{
    int i;
    GPIO_info *ptr = NULL;
    
    for (i = 0; i < numGpio; i++) {
        if (gpioInfo[i].gpio == gpio) {
            ptr = &gpioInfo[i];
            break;
        }
    }
    
    return ptr;
}

// Dump GPIO information to command line
void MW_dumpGpioInfo(const uint8_T *text)
{
    int i;
    
    printf("%s:\n", text);
    if (gpioInfo == NULL) {
        printf("Nothing to dump. gpioInfo == NULL\n");
    }
    for (i = 0; i < numGpio; i++) {
        printf("GPIO = %d, dir = %d, res = %d, fd = %d\n", 
                gpioInfo[i].gpio, gpioInfo[i].direction, 
                gpioInfo[i].internalResistor, gpioInfo[i].fd);
    }
}

// Initialize GPIO module
void MW_gpioInit(int32_T gpio, boolean_T direction, uint32_T internalResistor, const uint8_T *pinName)
{
    GPIO_info *gpioInfoPtr;
    
    gpioInfo = realloc(gpioInfo, (numGpio + 1) * sizeof(GPIO_info));
    if (gpioInfo == NULL) {
        fprintf(stderr, "Error allocating memory for GPIO pin %d.\n", gpio);
        MW_gpioExit();
    }
    gpioInfoPtr = gpioInfo + numGpio;
    
    //Fill in GPIO info structure for the GPIO module
#ifdef _DEBUG
    printf("gpio = %d, direction = %d, internalRes = %d, pinName = %s\n", 
        gpio, direction, internalResistor, pinName);
#endif
    gpioInfoPtr->gpio             = gpio;
    gpioInfoPtr->direction        = direction;
    gpioInfoPtr->internalResistor = internalResistor;
    gpioInfoPtr->fd               = -1;
    strcpy(&(gpioInfoPtr->pinName[0]), pinName); 
    numGpio++;
    
    // Set pin muxing and claim GPIO pin
    if (setGpioPinMux(pinName, direction, internalResistor) < 0) {
        fprintf(stderr, "Error setting PIN MUX.\n");
        MW_gpioExit();
    }
    if (gpioExport(gpio) < 0) {
        fprintf(stderr, "Error exporting GPIO pin.\n");
        MW_gpioExit();
    }
	if (gpioSetDirection(gpio, direction) < 0) { 
        fprintf(stderr, "Error setting GPIO pin direction.\n");
        MW_gpioExit();
    }
	gpioInfoPtr->fd = gpioOpen(gpio, direction);
    if (gpioInfoPtr->fd < 0) {
        fprintf(stderr, "Error opening GPIO.\n");
        MW_gpioExit();
    }
#ifdef _DEBUG
    MW_dumpGpioInfo("INIT");
#endif
}

// Close GPIO module
void MW_gpioTerminate(int32_T gpio)
{
    GPIO_info *gpioInfoPtr = NULL;
    static int32_T numClosedGpio = 0;
    
    // Get GPIO information pointer and close the GPIO file descriptor
    gpioInfoPtr = MW_getGpioInfo(gpio);
    if (gpioInfoPtr == NULL) {
        return;
    }
    if (gpioClose(gpioInfoPtr->fd) < 0) {
        fprintf(stderr, "Error closing GPIO module.\n");
    }
    if (gpioUnexport(gpio) < 0) {
        fprintf(stderr, "Error closing GPIO module.\n");
    }
    numClosedGpio++;
    if ((numClosedGpio == numGpio) && !gpioInfo) {
        free(gpioInfo);
    }
}

// Read value from given GPIO pin
boolean_T MW_gpioRead(int32_T gpio)
{
    GPIO_info *gpioInfoPtr = NULL;
    char value;
    
    // Get GPIO information pointer
    gpioInfoPtr = MW_getGpioInfo(gpio);
    lseek(gpioInfoPtr->fd, 0, SEEK_SET);
    if (read(gpioInfoPtr->fd, &value, 1) < 0) {
        return(0);
    }
    
    // The sysfs returns the value as a char. Convert the value to bool.
    return((boolean_T)(value - '0'));
}

// Write value to given GPIO pin
void MW_gpioWrite(int gpio, boolean_T value)
{
    GPIO_info *gpioInfoPtr = NULL;
    ssize_t bytesWritten;
    
    // Get GPIO information pointer
    gpioInfoPtr = MW_getGpioInfo(gpio);
    lseek(gpioInfoPtr->fd, 0, SEEK_SET);
    if (value) {
        bytesWritten = write(gpioInfoPtr->fd, "1", 2);
    }
    else {
        bytesWritten = write(gpioInfoPtr->fd, "0", 2);
    }
}

#ifdef _MW_GPIO_TEST_
#define NUM_GPIO_OPS    (100000)
// Main function
int main(int argc, char *argv[])
{
	unsigned int gpio = 121; 
    int i;
    
    // Open GPIO device
    printf("Opening GPIO %d for input. Reading for %d times.\n", gpio, NUM_GPIO_OPS);
    MW_gpioInit(gpio, GPIO_DIRECTION_INPUT);
    i = 0;
    while (i < NUM_GPIO_OPS) {
        MW_gpioRead(gpio);
#ifdef _DEBUG
        printf("[%d]. GPIO value = %d\n", i, MW_gpioRead(gpio));
        sleep(1);
#endif
        i++;
    }
    MW_gpioTerminate(gpio);
    
    printf("Opening GPIO %d for output. Writing for %d times.\n", gpio, NUM_GPIO_OPS);
    MW_gpioInit(gpio, GPIO_OUTPUT);
    i = 0;
    while (i < NUM_GPIO_OPS) {
        MW_gpioWrite(gpio, i & 0x1);
#ifdef _DEBUG
        printf("[%d]. GPIO value = %d\n", i, MW_gpioRead(gpio));
        sleep(1);
#endif
        i++;
    }
    MW_gpioTerminate(gpio);
    
    exit(EXIT_SUCCESS);
}
#endif
