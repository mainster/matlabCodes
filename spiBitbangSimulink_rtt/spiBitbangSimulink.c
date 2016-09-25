/*
 * File: spiBitbangSimulink.c
 *
 * Code generated for Simulink model 'spiBitbangSimulink'.
 *
 * Model version                  : 1.20
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Sun Apr 20 16:45:27 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "spiBitbangSimulink.h"
#include "spiBitbangSimulink_private.h"

/* Block states (auto storage) */
DW_spiBitbangSimulink_T spiBitbangSimulink_DW;

/* Real-time model */
RT_MODEL_spiBitbangSimulink_T spiBitbangSimulink_M_;
RT_MODEL_spiBitbangSimulink_T *const spiBitbangSimulink_M =
  &spiBitbangSimulink_M_;
static void rate_monotonic_scheduler(void);

/*
 *   This function updates active task flag for each subrate
 * and rate transition flags for tasks that exchange data.
 * The function assumes rate-monotonic multitasking scheduler.
 * The function must be called at model base rate so that
 * the generated code self-manages all its subrates and rate
 * transition flags.
 */
static void rate_monotonic_scheduler(void)
{
  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (spiBitbangSimulink_M->Timing.TaskCounters.TID[1])++;
  if ((spiBitbangSimulink_M->Timing.TaskCounters.TID[1]) > 9) {/* Sample time: [1.0E-6s, 0.0s] */
    spiBitbangSimulink_M->Timing.TaskCounters.TID[1] = 0;
  }
}

/* Model output function for TID0 */
void spiBitbangSimulink_output0(void)  /* Sample time: [1.0000000000000001E-7s, 0.0s] */
{
  {                                    /* Sample time: [1.0000000000000001E-7s, 0.0s] */
    rate_monotonic_scheduler();
  }
}

/* Model update function for TID0 */
void spiBitbangSimulink_update0(void)  /* Sample time: [1.0000000000000001E-7s, 0.0s] */
{
  /* (no update code required) */
}

/* Model output function for TID1 */
void spiBitbangSimulink_output1(void)  /* Sample time: [1.0E-6s, 0.0s] */
{
  boolean_T rtb_GPIORead_0;
  real_T rtb_PulseGenerator;

  /* S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  rtb_GPIORead_0 = MW_gpioRead(7U);

  /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
  rtb_PulseGenerator = (spiBitbangSimulink_DW.clockTickCounter <
                        spiBitbangSimulink_P.PulseGenerator_Duty) &&
    (spiBitbangSimulink_DW.clockTickCounter >= 0) ?
    spiBitbangSimulink_P.PulseGenerator_Amp : 0.0;
  if (spiBitbangSimulink_DW.clockTickCounter >=
      spiBitbangSimulink_P.PulseGenerator_Period - 1.0) {
    spiBitbangSimulink_DW.clockTickCounter = 0;
  } else {
    spiBitbangSimulink_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' incorporates:
   *  DataTypeConversion: '<Root>/Data Type Conversion'
   *  Logic: '<Root>/Logical Operator'
   *  S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read'
   */
  MW_gpioWrite(spiBitbangSimulink_P.GPIOWrite_p1, rtb_GPIORead_0 &&
               (rtb_PulseGenerator != 0.0));
}

/* Model update function for TID1 */
void spiBitbangSimulink_update1(void)  /* Sample time: [1.0E-6s, 0.0s] */
{
  /* (no update code required) */
}

/* Model initialize function */
void spiBitbangSimulink_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)spiBitbangSimulink_M, 0,
                sizeof(RT_MODEL_spiBitbangSimulink_T));

  /* states (dwork) */
  (void) memset((void *)&spiBitbangSimulink_DW, 0,
                sizeof(DW_spiBitbangSimulink_T));

  {
    uint8_T tmp;
    uint8_T tmp_0;

    /* Start for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
    tmp_0 = 0U;
    MW_gpioInit(7U, 1U, 1U, &tmp_0);

    /* Start for DiscretePulseGenerator: '<Root>/Pulse Generator' */
    spiBitbangSimulink_DW.clockTickCounter = 0;

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' */
    tmp = spiBitbangSimulink_P.GPIOWrite_p4;
    MW_gpioInit(spiBitbangSimulink_P.GPIOWrite_p1,
                spiBitbangSimulink_P.GPIOWrite_p2,
                spiBitbangSimulink_P.GPIOWrite_p3, &tmp);
  }
}

/* Model terminate function */
void spiBitbangSimulink_terminate(void)
{
  /* Terminate for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  MW_gpioTerminate(7U);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' */
  MW_gpioTerminate(spiBitbangSimulink_P.GPIOWrite_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
