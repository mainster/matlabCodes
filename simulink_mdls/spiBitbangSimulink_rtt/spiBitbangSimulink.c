/*
 * File: spiBitbangSimulink.c
 *
 * Code generated for Simulink model 'spiBitbangSimulink'.
 *
 * Model version                  : 1.15
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Sat Apr 19 21:32:51 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "spiBitbangSimulink.h"
#include "spiBitbangSimulink_private.h"

/* Block signals (auto storage) */
B_spiBitbangSimulink_T spiBitbangSimulink_B;

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
  if ((spiBitbangSimulink_M->Timing.TaskCounters.TID[1]) > 19) {/* Sample time: [2.0000000000000003E-6s, 0.0s] */
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
void spiBitbangSimulink_output1(void)  /* Sample time: [2.0000000000000003E-6s, 0.0s] */
{
  uint8_T rtb_Output;

  /* UnitDelay: '<S2>/Output' */
  rtb_Output = spiBitbangSimulink_DW.Output_DSTATE;

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' incorporates:
   *  Constant: '<S1>/Vector'
   *  MultiPortSwitch: '<S1>/Output'
   *  UnitDelay: '<S2>/Output'
   */
  MW_gpioWrite(spiBitbangSimulink_P.GPIOWrite_p1,
               spiBitbangSimulink_P.Vector_Value[spiBitbangSimulink_DW.Output_DSTATE]);

  /* Sum: '<S3>/FixPt Sum1' incorporates:
   *  Constant: '<S3>/FixPt Constant'
   */
  rtb_Output = (uint8_T)((uint32_T)rtb_Output +
    spiBitbangSimulink_P.FixPtConstant_Value);

  /* Switch: '<S4>/FixPt Switch' incorporates:
   *  Constant: '<S4>/Constant'
   */
  if (rtb_Output > spiBitbangSimulink_P.FixPtSwitch_Threshold) {
    spiBitbangSimulink_B.FixPtSwitch = spiBitbangSimulink_P.Constant_Value;
  } else {
    spiBitbangSimulink_B.FixPtSwitch = rtb_Output;
  }

  /* End of Switch: '<S4>/FixPt Switch' */
}

/* Model update function for TID1 */
void spiBitbangSimulink_update1(void)  /* Sample time: [2.0000000000000003E-6s, 0.0s] */
{
  /* Update for UnitDelay: '<S2>/Output' */
  spiBitbangSimulink_DW.Output_DSTATE = spiBitbangSimulink_B.FixPtSwitch;
}

/* Model initialize function */
void spiBitbangSimulink_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)spiBitbangSimulink_M, 0,
                sizeof(RT_MODEL_spiBitbangSimulink_T));

  /* block I/O */
  (void) memset(((void *) &spiBitbangSimulink_B), 0,
                sizeof(B_spiBitbangSimulink_T));

  /* states (dwork) */
  (void) memset((void *)&spiBitbangSimulink_DW, 0,
                sizeof(DW_spiBitbangSimulink_T));

  {
    uint8_T tmp;

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' */
    tmp = spiBitbangSimulink_P.GPIOWrite_p4;
    MW_gpioInit(spiBitbangSimulink_P.GPIOWrite_p1,
                spiBitbangSimulink_P.GPIOWrite_p2,
                spiBitbangSimulink_P.GPIOWrite_p3, &tmp);
  }

  /* InitializeConditions for UnitDelay: '<S2>/Output' */
  spiBitbangSimulink_DW.Output_DSTATE =
    spiBitbangSimulink_P.Output_InitialCondition;
}

/* Model terminate function */
void spiBitbangSimulink_terminate(void)
{
  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/GPIO Write' */
  MW_gpioTerminate(spiBitbangSimulink_P.GPIOWrite_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
