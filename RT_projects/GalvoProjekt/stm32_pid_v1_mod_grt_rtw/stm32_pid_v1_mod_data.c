/*
 * stm32_pid_v1_mod_data.c
 *
 * Code generation for model "stm32_pid_v1_mod".
 *
 * Model version              : 1.48
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Wed Aug 13 07:05:03 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Atmel->AVR
 * Code generation objective: Debugging
 * Validation result: Not run
 */
#include "stm32_pid_v1_mod.h"
#include "stm32_pid_v1_mod_private.h"

/* Block parameters (auto storage) */
P_stm32_pid_v1_mod_T stm32_pid_v1_mod_P = {
  /*  Computed Parameter: DiscreteZeroPole_A
   * Referenced by: '<Root>/Discrete Zero-Pole'
   */
  { 1.9444171392071736, -0.97199065291639564, 0.97199065291639586 },
  1.0,                                 /* Computed Parameter: DiscreteZeroPole_B
                                        * Referenced by: '<Root>/Discrete Zero-Pole'
                                        */

  /*  Computed Parameter: DiscreteZeroPole_C
   * Referenced by: '<Root>/Discrete Zero-Pole'
   */
  { 0.00017599600077316692, 0.00017767058600437645 },
  -0.00010397286896558608,             /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter'
                                        */
  0.0,                                 /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter'
                                        */
  15401.771637736749,                  /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient'
                                        */
  348.9417691739514,                   /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator'
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator'
                                        */
  1.601366384328283,                   /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain'
                                        */
  0.5,                                 /* Expression: 0.5
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  1333.0,                              /* Expression: round(1/(15*Ts))
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  667.0,                               /* Expression: round(0.5*1/(15*Ts))
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  667.0,                               /* Expression: round(0.5*1/(15*Ts))
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  1.0,                                 /* Expression: 1.
                                        * Referenced by: '<Root>/Constant'
                                        */

  /*  Computed Parameter: DiscreteZeroPole1_A
   * Referenced by: '<Root>/Discrete Zero-Pole1'
   */
  { 1.9444171392071736, -0.97199065291639564, 0.97199065291639586 },
  1.0,                                 /* Computed Parameter: DiscreteZeroPole1_B
                                        * Referenced by: '<Root>/Discrete Zero-Pole1'
                                        */

  /*  Computed Parameter: DiscreteZeroPole1_C
   * Referenced by: '<Root>/Discrete Zero-Pole1'
   */
  { 0.00017599600077316692, 0.00017767058600437645 },
  6.53739919651441,                    /* Expression: P
                                        * Referenced by: '<S2>/Proportional Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Integrator_gainval_l
                                        * Referenced by: '<S2>/Integrator'
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S2>/Integrator'
                                        */
  0.00141165985670672,                 /* Expression: D
                                        * Referenced by: '<S2>/Derivative Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Filter_gainval_c
                                        * Referenced by: '<S2>/Filter'
                                        */
  0.0,                                 /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S2>/Filter'
                                        */
  1984.24278999048,                    /* Expression: N
                                        * Referenced by: '<S2>/Filter Coefficient'
                                        */
  2.9,                                 /* Expression: UpperSaturationLimit
                                        * Referenced by: '<S2>/Saturation'
                                        */
  0.0,                                 /* Expression: LowerSaturationLimit
                                        * Referenced by: '<S2>/Saturation'
                                        */
  891.211690259468                     /* Expression: I
                                        * Referenced by: '<S2>/Integral Gain'
                                        */
};
