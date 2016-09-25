/*
 * File: stm32_pid_v1_mod_data.c
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

/* Block parameters (auto storage) */
P_stm32_pid_v1_mod_T stm32_pid_v1_mod_P = {
  /*  Computed Parameter: DiscreteZeroPole_A
   * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: A)
   */
  { 1.9444171392071736, -0.97199065291639564, 0.97199065291639586 },
  1.0,                                 /* Computed Parameter: DiscreteZeroPole_B
                                        * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: B)
                                        */

  /*  Computed Parameter: DiscreteZeroPole_C
   * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: C)
   */
  { 0.00017599600077316692, 0.00017767058600437645 },
  -0.00010397286896558608,             /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain' (Parameter: Gain)
                                        */
  5.0E-5,                              /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter' (Parameter: gainval)
                                        */
  0.0,                                 /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter' (Parameter: InitialCondition)
                                        */
  15401.771637736749,                  /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient' (Parameter: Gain)
                                        */
  348.9417691739514,                   /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain' (Parameter: Gain)
                                        */
  5.0E-5,                              /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator' (Parameter: gainval)
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator' (Parameter: InitialCondition)
                                        */
  1.601366384328283                    /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain' (Parameter: Gain)
                                        */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
