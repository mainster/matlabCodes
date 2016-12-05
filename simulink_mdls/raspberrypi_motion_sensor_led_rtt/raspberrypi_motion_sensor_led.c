/*
 * File: raspberrypi_motion_sensor_led.c
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

#include "raspberrypi_motion_sensor_led.h"
#include "raspberrypi_motion_sensor_led_private.h"
#include "raspberrypi_motion_sensor_led_dt.h"

/* Block signals (auto storage) */
BlockIO_raspberrypi_motion_sens raspberrypi_motion_sensor_led_B;

/* Block states (auto storage) */
D_Work_raspberrypi_motion_senso raspberrypi_motion_sensor_DWork;

/* Real-time model */
RT_MODEL_raspberrypi_motion_sen raspberrypi_motion_sensor_le_M_;
RT_MODEL_raspberrypi_motion_sen *const raspberrypi_motion_sensor_le_M =
  &raspberrypi_motion_sensor_le_M_;

/* Model output function */
void raspberrypi_motion_sensor_led_output(void)
{
  /* S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  raspberrypi_motion_sensor_led_B.GPIORead = MW_gpioRead(23U);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write1' */
  MW_gpioWrite(raspberrypi_motion_sensor_led_P.GPIOWrite1_p1,
               raspberrypi_motion_sensor_led_B.GPIORead);
}

/* Model update function */
void raspberrypi_motion_sensor_led_update(void)
{
  /* signal main to stop simulation */
  {                                    /* Sample time: [0.1s, 0.0s] */
    if ((rtmGetTFinal(raspberrypi_motion_sensor_le_M)!=-1) &&
        !((rtmGetTFinal(raspberrypi_motion_sensor_le_M)-
           raspberrypi_motion_sensor_le_M->Timing.taskTime0) >
          raspberrypi_motion_sensor_le_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(raspberrypi_motion_sensor_le_M, "Simulation finished");
    }

    if (rtmGetStopRequested(raspberrypi_motion_sensor_le_M)) {
      rtmSetErrorStatus(raspberrypi_motion_sensor_le_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  raspberrypi_motion_sensor_le_M->Timing.taskTime0 =
    (++raspberrypi_motion_sensor_le_M->Timing.clockTick0) *
    raspberrypi_motion_sensor_le_M->Timing.stepSize0;
}

/* Model initialize function */
void raspberrypi_motion_sensor_led_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)raspberrypi_motion_sensor_le_M, 0,
                sizeof(RT_MODEL_raspberrypi_motion_sen));
  rtmSetTFinal(raspberrypi_motion_sensor_le_M, -1);
  raspberrypi_motion_sensor_le_M->Timing.stepSize0 = 0.1;

  /* External mode info */
  raspberrypi_motion_sensor_le_M->Sizes.checksums[0] = (1193787651U);
  raspberrypi_motion_sensor_le_M->Sizes.checksums[1] = (3422281863U);
  raspberrypi_motion_sensor_le_M->Sizes.checksums[2] = (2306152471U);
  raspberrypi_motion_sensor_le_M->Sizes.checksums[3] = (2709343853U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    raspberrypi_motion_sensor_le_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(raspberrypi_motion_sensor_le_M->extModeInfo,
      &raspberrypi_motion_sensor_le_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(raspberrypi_motion_sensor_le_M->extModeInfo,
                        raspberrypi_motion_sensor_le_M->Sizes.checksums);
    rteiSetTPtr(raspberrypi_motion_sensor_le_M->extModeInfo, rtmGetTPtr
                (raspberrypi_motion_sensor_le_M));
  }

  /* block I/O */
  (void) memset(((void *) &raspberrypi_motion_sensor_led_B), 0,
                sizeof(BlockIO_raspberrypi_motion_sens));

  /* states (dwork) */
  (void) memset((void *)&raspberrypi_motion_sensor_DWork, 0,
                sizeof(D_Work_raspberrypi_motion_senso));

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    raspberrypi_motion_sensor_le_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  {
    uint8_T tmp;
    uint8_T tmp_0;

    /* Start for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
    tmp_0 = 0U;
    MW_gpioInit(23U, 1U, 1U, &tmp_0);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write1' */
    tmp = raspberrypi_motion_sensor_led_P.GPIOWrite1_p4;
    MW_gpioInit(raspberrypi_motion_sensor_led_P.GPIOWrite1_p1,
                raspberrypi_motion_sensor_led_P.GPIOWrite1_p2,
                raspberrypi_motion_sensor_led_P.GPIOWrite1_p3, &tmp);
  }
}

/* Model terminate function */
void raspberrypi_motion_sensor_led_terminate(void)
{
  /* Terminate for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  MW_gpioTerminate(23U);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write1' */
  MW_gpioTerminate(raspberrypi_motion_sensor_led_P.GPIOWrite1_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
