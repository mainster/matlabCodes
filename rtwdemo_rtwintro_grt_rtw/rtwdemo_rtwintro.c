/*
 * rtwdemo_rtwintro.c
 *
 * Code generation for model "rtwdemo_rtwintro".
 *
 * Model version              : 1.251
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Jul 20 06:04:50 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Generic->32-bit Embedded Processor
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "rtwdemo_rtwintro.h"
#include "rtwdemo_rtwintro_private.h"

/* Block states (auto storage) */
DW_rtwdemo_rtwintro_T rtwdemo_rtwintro_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_rtwdemo_rtwintro_T rtwdemo_rtwintro_PrevZCX;

/* External inputs (root inport signals with auto storage) */
ExtU_rtwdemo_rtwintro_T rtwdemo_rtwintro_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_rtwdemo_rtwintro_T rtwdemo_rtwintro_Y;

/* Real-time model */
RT_MODEL_rtwdemo_rtwintro_T rtwdemo_rtwintro_M_;
RT_MODEL_rtwdemo_rtwintro_T *const rtwdemo_rtwintro_M = &rtwdemo_rtwintro_M_;

/* Model step function */
void rtwdemo_rtwintro_step(void)
{
  uint8_T rtb_sum_out;
  boolean_T rtb_equal_to_count;

  /* Sum: '<Root>/Sum' incorporates:
   *  Constant: '<Root>/INC'
   *  UnitDelay: '<Root>/X'
   */
  rtb_sum_out = (uint8_T)(1U + rtwdemo_rtwintro_DW.X);

  /* RelationalOperator: '<Root>/RelOpt' incorporates:
   *  Constant: '<Root>/LIMIT'
   */
  rtb_equal_to_count = (rtb_sum_out != 16);

  /* Outputs for Triggered SubSystem: '<Root>/Amplifier' incorporates:
   *  TriggerPort: '<S1>/Trigger'
   */
  if (rtb_equal_to_count && (rtwdemo_rtwintro_PrevZCX.Amplifier_Trig_ZCE !=
       POS_ZCSIG)) {
    /* Outport: '<Root>/Output' incorporates:
     *  Gain: '<S1>/Gain'
     *  Inport: '<Root>/Input'
     */
    rtwdemo_rtwintro_Y.Output = rtwdemo_rtwintro_U.Input << 1;
  }

  rtwdemo_rtwintro_PrevZCX.Amplifier_Trig_ZCE = (uint8_T)(rtb_equal_to_count ?
    (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);

  /* End of Outputs for SubSystem: '<Root>/Amplifier' */

  /* Switch: '<Root>/Switch' */
  if (rtb_equal_to_count) {
    /* Update for UnitDelay: '<Root>/X' */
    rtwdemo_rtwintro_DW.X = rtb_sum_out;
  } else {
    /* Update for UnitDelay: '<Root>/X' incorporates:
     *  Constant: '<Root>/RESET'
     */
    rtwdemo_rtwintro_DW.X = 0U;
  }

  /* End of Switch: '<Root>/Switch' */

  /* Matfile logging */
  rt_UpdateTXYLogVars(rtwdemo_rtwintro_M->rtwLogInfo,
                      (&rtwdemo_rtwintro_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.96s, 0.0s] */
    if ((rtmGetTFinal(rtwdemo_rtwintro_M)!=-1) &&
        !((rtmGetTFinal(rtwdemo_rtwintro_M)-rtwdemo_rtwintro_M->Timing.taskTime0)
          > rtwdemo_rtwintro_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(rtwdemo_rtwintro_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++rtwdemo_rtwintro_M->Timing.clockTick0)) {
    ++rtwdemo_rtwintro_M->Timing.clockTickH0;
  }

  rtwdemo_rtwintro_M->Timing.taskTime0 = rtwdemo_rtwintro_M->Timing.clockTick0 *
    rtwdemo_rtwintro_M->Timing.stepSize0 +
    rtwdemo_rtwintro_M->Timing.clockTickH0 *
    rtwdemo_rtwintro_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void rtwdemo_rtwintro_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)rtwdemo_rtwintro_M, 0,
                sizeof(RT_MODEL_rtwdemo_rtwintro_T));
  rtmSetTFinal(rtwdemo_rtwintro_M, 48.0);
  rtwdemo_rtwintro_M->Timing.stepSize0 = 0.96;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rtwdemo_rtwintro_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(rtwdemo_rtwintro_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(rtwdemo_rtwintro_M->rtwLogInfo, (NULL));
    rtliSetLogT(rtwdemo_rtwintro_M->rtwLogInfo, "");
    rtliSetLogX(rtwdemo_rtwintro_M->rtwLogInfo, "");
    rtliSetLogXFinal(rtwdemo_rtwintro_M->rtwLogInfo, "");
    rtliSetSigLog(rtwdemo_rtwintro_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(rtwdemo_rtwintro_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(rtwdemo_rtwintro_M->rtwLogInfo, 2);
    rtliSetLogMaxRows(rtwdemo_rtwintro_M->rtwLogInfo, 0);
    rtliSetLogDecimation(rtwdemo_rtwintro_M->rtwLogInfo, 1);
    rtliSetLogY(rtwdemo_rtwintro_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(rtwdemo_rtwintro_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(rtwdemo_rtwintro_M->rtwLogInfo, (NULL));
  }

  /* states (dwork) */
  (void) memset((void *)&rtwdemo_rtwintro_DW, 0,
                sizeof(DW_rtwdemo_rtwintro_T));

  /* external inputs */
  rtwdemo_rtwintro_U.Input = 0;

  /* external outputs */
  rtwdemo_rtwintro_Y.Output = 0;

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(rtwdemo_rtwintro_M->rtwLogInfo, 0.0,
    rtmGetTFinal(rtwdemo_rtwintro_M), rtwdemo_rtwintro_M->Timing.stepSize0,
    (&rtmGetErrorStatus(rtwdemo_rtwintro_M)));

  /* Start for Triggered SubSystem: '<Root>/Amplifier' */
  /* VirtualOutportStart for Outport: '<Root>/Output' incorporates:
   *  VirtualOutportStart for Outport: '<S1>/Out'
   */
  rtwdemo_rtwintro_Y.Output = 0;

  /* End of Start for SubSystem: '<Root>/Amplifier' */
  rtwdemo_rtwintro_PrevZCX.Amplifier_Trig_ZCE = POS_ZCSIG;

  /* InitializeConditions for UnitDelay: '<Root>/X' */
  rtwdemo_rtwintro_DW.X = 0U;
}

/* Model terminate function */
void rtwdemo_rtwintro_terminate(void)
{
  /* (no terminate code required) */
}
