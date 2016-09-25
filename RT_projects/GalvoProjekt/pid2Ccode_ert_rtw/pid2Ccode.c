/*
 * File: pid2Ccode.c
 *
 * Code generated for Simulink model 'pid2Ccode'.
 *
 * Model version                  : 1.6
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Wed Aug 13 07:34:59 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "pid2Ccode.h"
#include "pid2Ccode_private.h"

/* Block signals (auto storage) */
B_pid2Ccode_T pid2Ccode_B;

/* Block states (auto storage) */
DW_pid2Ccode_T pid2Ccode_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_pid2Ccode_T pid2Ccode_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_pid2Ccode_T pid2Ccode_Y;

/* Model step function */
void pid2Ccode_step(void)
{
  /* Gain: '<S1>/Proportional Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  pid2Ccode_B.ProportionalGain = pid2Ccode_P.ProportionalGain_Gain *
    pid2Ccode_U.In1;

  /* DiscreteIntegrator: '<S1>/Integrator' */
  pid2Ccode_B.Integrator = pid2Ccode_DW.Integrator_DSTATE;

  /* Gain: '<S1>/Derivative Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  pid2Ccode_B.DerivativeGain = pid2Ccode_P.DerivativeGain_Gain * pid2Ccode_U.In1;

  /* DiscreteIntegrator: '<S1>/Filter' */
  pid2Ccode_B.Filter = pid2Ccode_DW.Filter_DSTATE;

  /* Sum: '<S1>/SumD' */
  pid2Ccode_B.SumD = pid2Ccode_B.DerivativeGain - pid2Ccode_B.Filter;

  /* Gain: '<S1>/Filter Coefficient' */
  pid2Ccode_B.FilterCoefficient = pid2Ccode_P.FilterCoefficient_Gain *
    pid2Ccode_B.SumD;

  /* Outport: '<Root>/Out1' incorporates:
   *  Sum: '<S1>/Sum'
   */
  pid2Ccode_Y.Out1 = (pid2Ccode_B.ProportionalGain + pid2Ccode_B.Integrator) +
    pid2Ccode_B.FilterCoefficient;

  /* Gain: '<S1>/Integral Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  pid2Ccode_B.IntegralGain = pid2Ccode_P.IntegralGain_Gain * pid2Ccode_U.In1;

  /* Update for DiscreteIntegrator: '<S1>/Integrator' */
  pid2Ccode_DW.Integrator_DSTATE = pid2Ccode_DW.Integrator_DSTATE +
    pid2Ccode_P.Integrator_gainval * pid2Ccode_B.IntegralGain;

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  pid2Ccode_DW.Filter_DSTATE = pid2Ccode_DW.Filter_DSTATE +
    pid2Ccode_P.Filter_gainval * pid2Ccode_B.FilterCoefficient;
}

/* Model initialize function */
void pid2Ccode_initialize(void)
{
  /* Registration code */

  /* block I/O */
  (void) memset(((void *) &pid2Ccode_B), 0,
                sizeof(B_pid2Ccode_T));

  /* states (dwork) */
  (void) memset((void *)&pid2Ccode_DW, 0,
                sizeof(DW_pid2Ccode_T));

  /* external inputs */
  pid2Ccode_U.In1 = 0.0;

  /* external outputs */
  pid2Ccode_Y.Out1 = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  pid2Ccode_DW.Integrator_DSTATE = pid2Ccode_P.Integrator_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  pid2Ccode_DW.Filter_DSTATE = pid2Ccode_P.Filter_IC;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
