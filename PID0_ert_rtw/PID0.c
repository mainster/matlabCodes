/*
 * File: PID0.c
 *
 * Code generated for Simulink model 'PID0'.
 *
 * Model version                  : 1.31
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sun Jul 20 07:26:55 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "PID0.h"
#include "PID0_private.h"

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
  real_T rtb_FilterCoefficient;

  /* Gain: '<S1>/Filter Coefficient' incorporates:
   *  DiscreteIntegrator: '<S1>/Filter'
   *  Gain: '<S1>/Derivative Gain'
   *  Inport: '<Root>/u'
   *  Sum: '<S1>/SumD'
   */
  rtb_FilterCoefficient = (PID0_P.DerivativeGain_Gain * PID0_U.u -
    PID0_DW.Filter_DSTATE) * PID0_P.FilterCoefficient_Gain;

  /* Outport: '<Root>/y' incorporates:
   *  DiscreteIntegrator: '<S1>/Integrator'
   *  Gain: '<S1>/Proportional Gain'
   *  Inport: '<Root>/u'
   *  Sum: '<S1>/Sum'
   */
  PID0_Y.y = (PID0_P.ProportionalGain_Gain * PID0_U.u +
              PID0_DW.Integrator_DSTATE) + rtb_FilterCoefficient;

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  PID0_DW.Filter_DSTATE += PID0_P.Filter_gainval * rtb_FilterCoefficient;

  /* Update for DiscreteIntegrator: '<S1>/Integrator' incorporates:
   *  Gain: '<S1>/Integral Gain'
   *  Inport: '<Root>/u'
   */
  PID0_DW.Integrator_DSTATE += PID0_P.IntegralGain_Gain * PID0_U.u *
    PID0_P.Integrator_gainval;
}

/* Model initialize function */
void PID0_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(PID0_M, (NULL));

  /* states (dwork) */
  (void) memset((void *)&PID0_DW, 0,
                sizeof(DW_PID0_T));

  /* external inputs */
  PID0_U.u = 0.0;

  /* external outputs */
  PID0_Y.y = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  PID0_DW.Filter_DSTATE = PID0_P.Filter_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  PID0_DW.Integrator_DSTATE = PID0_P.Integrator_IC;
}

/* Model terminate function */
void PID0_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
