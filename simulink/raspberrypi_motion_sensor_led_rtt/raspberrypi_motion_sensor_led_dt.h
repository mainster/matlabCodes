/*
 * raspberrypi_motion_sensor_led_dt.h
 *
 * Code generation for model "raspberrypi_motion_sensor_led".
 *
 * Model version              : 1.44
 * Simulink Coder version : 8.5 (R2013b) 08-Aug-2013
 * C source code generated on : Sat Apr 19 19:11:08 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "ext_types.h"

/* data type size table */
static uint_T rtDataTypeSizes[] = {
  sizeof(real_T),
  sizeof(real32_T),
  sizeof(int8_T),
  sizeof(uint8_T),
  sizeof(int16_T),
  sizeof(uint16_T),
  sizeof(int32_T),
  sizeof(uint32_T),
  sizeof(boolean_T),
  sizeof(fcn_call_T),
  sizeof(int_T),
  sizeof(pointer_T),
  sizeof(action_T),
  2*sizeof(uint32_T)
};

/* data type name table */
static const char_T * rtDataTypeNames[] = {
  "real_T",
  "real32_T",
  "int8_T",
  "uint8_T",
  "int16_T",
  "uint16_T",
  "int32_T",
  "uint32_T",
  "boolean_T",
  "fcn_call_T",
  "int_T",
  "pointer_T",
  "action_T",
  "timer_uint32_pair_T"
};

/* data type transitions for block I/O structure */
static DataTypeTransition rtBTransitions[] = {
  { (char_T *)(&raspberrypi_motion_sensor_led_B.GPIORead), 8, 0, 1 }
  ,

  { (char_T *)
    (&raspberrypi_motion_sensor_DWork.MotionSensorOutput_PWORK.LoggedData), 11,
    0, 1 }
};

/* data type transition table for block I/O structure */
static DataTypeTransitionTable rtBTransTable = {
  2U,
  rtBTransitions
};

/* data type transitions for Parameters structure */
static DataTypeTransition rtPTransitions[] = {
  { (char_T *)(&raspberrypi_motion_sensor_led_P.GPIOWrite1_p1), 7, 0, 3 },

  { (char_T *)(&raspberrypi_motion_sensor_led_P.GPIOWrite1_p4), 3, 0, 1 }
};

/* data type transition table for Parameters structure */
static DataTypeTransitionTable rtPTransTable = {
  2U,
  rtPTransitions
};

/* [EOF] raspberrypi_motion_sensor_led_dt.h */
