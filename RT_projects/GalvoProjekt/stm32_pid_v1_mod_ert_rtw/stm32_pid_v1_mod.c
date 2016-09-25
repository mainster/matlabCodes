/*
 * File: stm32_pid_v1_mod.c
 *
 * Code generated for Simulink model 'stm32_pid_v1_mod'.
 *
 * Model version                  : 1.53
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Wed Aug 13 07:11:23 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "stm32_pid_v1_mod.h"
#include "stm32_pid_v1_mod_private.h"

/* Block signals (auto storage) */
B_stm32_pid_v1_mod_T stm32_pid_v1_mod_B;

/* Block states (auto storage) */
DW_stm32_pid_v1_mod_T stm32_pid_v1_mod_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_stm32_pid_v1_mod_T stm32_pid_v1_mod_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_stm32_pid_v1_mod_T stm32_pid_v1_mod_Y;

/* Model step function */
void stm32_pid_v1_mod_step(void)
{
  /* DiscreteZeroPole: '<Root>/Discrete Zero-Pole' */
  {
    stm32_pid_v1_mod_Y.Out1 = (stm32_pid_v1_mod_P.DiscreteZeroPole_C[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole_C[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[1];
  }

  /* Gain: '<S1>/Derivative Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.DerivativeGain = stm32_pid_v1_mod_P.DerivativeGain_Gain *
    stm32_pid_v1_mod_U.In1;

  /* DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_B.Filter = stm32_pid_v1_mod_DW.Filter_DSTATE;

  /* Sum: '<S1>/SumD' */
  stm32_pid_v1_mod_B.SumD = stm32_pid_v1_mod_B.DerivativeGain -
    stm32_pid_v1_mod_B.Filter;

  /* Gain: '<S1>/Filter Coefficient' */
  stm32_pid_v1_mod_B.FilterCoefficient =
    stm32_pid_v1_mod_P.FilterCoefficient_Gain * stm32_pid_v1_mod_B.SumD;

  /* Gain: '<S1>/Integral Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.IntegralGain = stm32_pid_v1_mod_P.IntegralGain_Gain *
    stm32_pid_v1_mod_U.In1;

  /* DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_B.Integrator = stm32_pid_v1_mod_DW.Integrator_DSTATE;

  /* Gain: '<S1>/Proportional Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.ProportionalGain = stm32_pid_v1_mod_P.ProportionalGain_Gain
    * stm32_pid_v1_mod_U.In1;

  /* Sum: '<S1>/Sum' */
  stm32_pid_v1_mod_B.Sum = (stm32_pid_v1_mod_B.ProportionalGain +
    stm32_pid_v1_mod_B.Integrator) + stm32_pid_v1_mod_B.FilterCoefficient;

  /* Update for DiscreteZeroPole: '<Root>/Discrete Zero-Pole' */
  {
    real_T xnew[2];
    xnew[0] = (stm32_pid_v1_mod_P.DiscreteZeroPole_A[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole_A[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[1];
    xnew[0] += stm32_pid_v1_mod_P.DiscreteZeroPole_B*stm32_pid_v1_mod_B.Sum;
    xnew[1] = (stm32_pid_v1_mod_P.DiscreteZeroPole_A[2])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0];
    (void) memcpy(&stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0], xnew,
                  sizeof(real_T)*2);
  }

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE = stm32_pid_v1_mod_DW.Filter_DSTATE +
    stm32_pid_v1_mod_P.Filter_gainval * stm32_pid_v1_mod_B.FilterCoefficient;

  /* Update for DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE = stm32_pid_v1_mod_DW.Integrator_DSTATE
    + stm32_pid_v1_mod_P.Integrator_gainval * stm32_pid_v1_mod_B.IntegralGain;
}

/* Model initialize function */
void stm32_pid_v1_mod_initialize(void)
{
  /* Registration code */

  /* block I/O */
  (void) memset(((void *) &stm32_pid_v1_mod_B), 0,
                sizeof(B_stm32_pid_v1_mod_T));

  /* states (dwork) */
  (void) memset((void *)&stm32_pid_v1_mod_DW, 0,
                sizeof(DW_stm32_pid_v1_mod_T));

  /* external inputs */
  stm32_pid_v1_mod_U.In1 = 0.0;

  /* external outputs */
  stm32_pid_v1_mod_Y.Out1 = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE = stm32_pid_v1_mod_P.Filter_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE = stm32_pid_v1_mod_P.Integrator_IC;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
