/*
 * PID0.c
 *
 * Code generation for model "PID0".
 *
 * Model version              : 1.491
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Tue Apr 28 20:42:02 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: STMicroelectronics->STM32F4xx 32-bit Cortex-M4
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "PID0.h"
#include "PID0_private.h"

/* Block signals (auto storage) */
B_PID0_T PID0_B;

/* Block states (auto storage) */
DW_PID0_T PID0_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_PID0_T PID0_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_PID0_T PID0_Y;

/* Real-time model */
RT_MODEL_PID0_T PID0_M_;
RT_MODEL_PID0_T *const PID0_M = &PID0_M_;

/* Model step function */
void PID0_step(void)
{
  real_T u;
  real_T u_0;
  real_T u_1;

  /* Gain: '<S1>/Proportional Gain' incorporates:
   *  Inport: '<Root>/u'
   */
  PID0_B.ProportionalGain = 0.00117158349672886 * PID0_U.e;

  /* DiscreteIntegrator: '<S1>/Integrator' */
  PID0_B.Integrator = PID0_DW.Integrator_DSTATE;

  /* Gain: '<S1>/Derivative Gain' incorporates:
   *  Inport: '<Root>/u'
   */
  PID0_B.DerivativeGain = 8.13716191016835E-6 * PID0_U.e;

  /* DiscreteIntegrator: '<S1>/Filter' */
  PID0_B.Filter = PID0_DW.Filter_DSTATE;

  /* Sum: '<S1>/SumD' */
  PID0_B.SumD = PID0_B.DerivativeGain - PID0_B.Filter;

  /* Gain: '<S1>/Filter Coefficient' */
  PID0_B.FilterCoefficient = 7118.60238976778 * PID0_B.SumD;

  /* Sum: '<S1>/Sum' */
  PID0_B.Sum = (PID0_B.ProportionalGain + PID0_B.Integrator) +
    PID0_B.FilterCoefficient;

  /* Saturate: '<S1>/Saturation' */
  u = PID0_B.Sum;
  u_0 = (-2048.0);
  u_1 = 2047.0;
  if (u >= u_1) {
    /* Outport: '<Root>/y' */
    PID0_Y.y = u_1;
  } else if (u <= u_0) {
    /* Outport: '<Root>/y' */
    PID0_Y.y = u_0;
  } else {
    /* Outport: '<Root>/y' */
    PID0_Y.y = u;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* Gain: '<S1>/Integral Gain' incorporates:
   *  Inport: '<Root>/u'
   */
  PID0_B.IntegralGain = 0.0373779437685195 * PID0_U.e;

  /* Gain: '<S2>/Gain' */
  PID0_B.Gain = 0.0 * PID0_B.Sum;

  /* DeadZone: '<S2>/DeadZone' */
  if (PID0_B.Sum > 2047.0) {
    PID0_B.DeadZone = PID0_B.Sum - 2047.0;
  } else if (PID0_B.Sum >= (-2048.0)) {
    PID0_B.DeadZone = 0.0;
  } else {
    PID0_B.DeadZone = PID0_B.Sum - (-2048.0);
  }

  /* End of DeadZone: '<S2>/DeadZone' */

  /* RelationalOperator: '<S2>/NotEqual' */
  PID0_B.NotEqual = (PID0_B.Gain != PID0_B.DeadZone);

  /* Signum: '<S2>/SignPreSat' */
  u = PID0_B.Sum;
  if (u < 0.0) {
    PID0_B.SignPreSat = -1.0;
  } else if (u > 0.0) {
    PID0_B.SignPreSat = 1.0;
  } else if (u == 0.0) {
    PID0_B.SignPreSat = 0.0;
  } else {
    PID0_B.SignPreSat = u;
  }

  /* End of Signum: '<S2>/SignPreSat' */

  /* DataTypeConversion: '<S2>/DataTypeConv2' */
  PID0_B.DataTypeConv2 = PID0_B.IntegralGain;

  /* Signum: '<S2>/SignPreIntegrator' */
  u = PID0_B.DataTypeConv2;
  if (u < 0.0) {
    PID0_B.SignPreIntegrator = -1.0;
  } else if (u > 0.0) {
    PID0_B.SignPreIntegrator = 1.0;
  } else if (u == 0.0) {
    PID0_B.SignPreIntegrator = 0.0;
  } else {
    PID0_B.SignPreIntegrator = u;
  }

  /* End of Signum: '<S2>/SignPreIntegrator' */

  /* RelationalOperator: '<S2>/Equal' */
  PID0_B.Equal = (PID0_B.SignPreSat == PID0_B.SignPreIntegrator);

  /* Logic: '<S2>/AND' */
  PID0_B.AND = (PID0_B.NotEqual && PID0_B.Equal);

  /* Switch: '<S1>/Switch' incorporates:
   *  Constant: '<S1>/Constant'
   */
  if (PID0_B.AND) {
    PID0_B.Switch = 0.0;
  } else {
    PID0_B.Switch = PID0_B.IntegralGain;
  }

  /* End of Switch: '<S1>/Switch' */

  /* Update for DiscreteIntegrator: '<S1>/Integrator' */
  PID0_DW.Integrator_DSTATE = 2.5E-5 * PID0_B.Switch + PID0_DW.Integrator_DSTATE;

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  PID0_DW.Filter_DSTATE = 2.5E-5 * PID0_B.FilterCoefficient +
    PID0_DW.Filter_DSTATE;

  /* Matfile logging */
  rt_UpdateTXYLogVars(PID0_M->rtwLogInfo, (&PID0_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [2.5E-5s, 0.0s] */
    if ((rtmGetTFinal(PID0_M)!=-1) &&
        !((rtmGetTFinal(PID0_M)-PID0_M->Timing.taskTime0) >
          PID0_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(PID0_M, "Simulation finished");
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
  if (!(++PID0_M->Timing.clockTick0)) {
    ++PID0_M->Timing.clockTickH0;
  }

  PID0_M->Timing.taskTime0 = PID0_M->Timing.clockTick0 *
    PID0_M->Timing.stepSize0 + PID0_M->Timing.clockTickH0 *
    PID0_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void PID0_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)PID0_M, 0,
                sizeof(RT_MODEL_PID0_T));
  rtmSetTFinal(PID0_M, 0.025);
  PID0_M->Timing.stepSize0 = 2.5E-5;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    PID0_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(PID0_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(PID0_M->rtwLogInfo, (NULL));
    rtliSetLogT(PID0_M->rtwLogInfo, "");
    rtliSetLogX(PID0_M->rtwLogInfo, "");
    rtliSetLogXFinal(PID0_M->rtwLogInfo, "");
    rtliSetSigLog(PID0_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(PID0_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(PID0_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(PID0_M->rtwLogInfo, 0);
    rtliSetLogDecimation(PID0_M->rtwLogInfo, 1);
    rtliSetLogY(PID0_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(PID0_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(PID0_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &PID0_B), 0,
                sizeof(B_PID0_T));

  /* states (dwork) */
  (void) memset((void *)&PID0_DW, 0,
                sizeof(DW_PID0_T));

  /* external inputs */
  PID0_U.e = 0.0;

  /* external outputs */
  PID0_Y.y = 0.0;

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(PID0_M->rtwLogInfo, 0.0, rtmGetTFinal(PID0_M),
    PID0_M->Timing.stepSize0, (&rtmGetErrorStatus(PID0_M)));

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  PID0_DW.Integrator_DSTATE = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  PID0_DW.Filter_DSTATE = 0.0;
}

/* Model terminate function */
void PID0_terminate(void)
{
  /* (no terminate code required) */
}
