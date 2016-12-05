/*
 * Discrete_data.c
 *
 * Code generation for model "Discrete".
 *
 * Model version              : 1.45
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Wed Aug 13 06:42:29 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "Discrete.h"
#include "Discrete_private.h"

/* Block parameters (auto storage) */
P_Discrete_T Discrete_P = {
  6.53739919651441,                    /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator'
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator'
                                        */
  0.00141165985670672,                 /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain'
                                        */
  5.0E-5,                              /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter'
                                        */
  0.0,                                 /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter'
                                        */
  1984.24278999048,                    /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient'
                                        */
  2.9,                                 /* Expression: UpperSaturationLimit
                                        * Referenced by: '<S1>/Saturation'
                                        */
  0.0,                                 /* Expression: LowerSaturationLimit
                                        * Referenced by: '<S1>/Saturation'
                                        */
  891.211690259468                     /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain'
                                        */
};
