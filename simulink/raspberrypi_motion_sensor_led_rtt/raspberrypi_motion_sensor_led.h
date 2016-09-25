/*
 * File: raspberrypi_motion_sensor_led.h
 *
 * Code generated for Simulink model 'raspberrypi_motion_sensor_led'.
 *
 * Model version                  : 1.44
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Sat Apr 19 19:11:08 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_raspberrypi_motion_sensor_led_h_
#define RTW_HEADER_raspberrypi_motion_sensor_led_h_
#ifndef raspberrypi_motion_sensor_led_COMMON_INCLUDES_
# define raspberrypi_motion_sensor_led_COMMON_INCLUDES_
#include <float.h>
#include <string.h>
#include "rtwtypes.h"
#include "multiword_types.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "dt_info.h"
#include "ext_work.h"
#include "MW_gpio_lct.h"
#endif                                 /* raspberrypi_motion_sensor_led_COMMON_INCLUDES_ */

#include "raspberrypi_motion_sensor_led_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

/* Block signals (auto storage) */
typedef struct {
  boolean_T GPIORead;                  /* '<Root>/GPIO Read' */
} BlockIO_raspberrypi_motion_sens;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData;
  } MotionSensorOutput_PWORK;          /* '<Root>/Motion Sensor Output' */
} D_Work_raspberrypi_motion_senso;

/* Parameters (auto storage) */
struct Parameters_raspberrypi_motion_s_ {
  uint32_T GPIOWrite1_p1;              /* Computed Parameter: GPIOWrite1_p1
                                        * Referenced by: '<Root>/GPIO Write1'
                                        */
  uint32_T GPIOWrite1_p2;              /* Computed Parameter: GPIOWrite1_p2
                                        * Referenced by: '<Root>/GPIO Write1'
                                        */
  uint32_T GPIOWrite1_p3;              /* Computed Parameter: GPIOWrite1_p3
                                        * Referenced by: '<Root>/GPIO Write1'
                                        */
  uint8_T GPIOWrite1_p4;               /* Expression: pinName
                                        * Referenced by: '<Root>/GPIO Write1'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_raspberrypi_motion_sens {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (auto storage) */
extern Parameters_raspberrypi_motion_s raspberrypi_motion_sensor_led_P;

/* Block signals (auto storage) */
extern BlockIO_raspberrypi_motion_sens raspberrypi_motion_sensor_led_B;

/* Block states (auto storage) */
extern D_Work_raspberrypi_motion_senso raspberrypi_motion_sensor_DWork;

/* Model entry point functions */
extern void raspberrypi_motion_sensor_led_initialize(void);
extern void raspberrypi_motion_sensor_led_output(void);
extern void raspberrypi_motion_sensor_led_update(void);
extern void raspberrypi_motion_sensor_led_terminate(void);

/* Real-time Model object */
extern RT_MODEL_raspberrypi_motion_sen *const raspberrypi_motion_sensor_le_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'raspberrypi_motion_sensor_led'
 */
#endif                                 /* RTW_HEADER_raspberrypi_motion_sensor_led_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
