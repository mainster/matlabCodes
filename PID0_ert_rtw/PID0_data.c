/*
 * File: PID0_data.c
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

/* Block parameters (auto storage) */
P_PID0_T PID0_P = {
  -0.00826902631159402,                /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain'
                                        */
  1.0E-6,                              /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter'
                                        */
  0.0,                                 /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter'
                                        */
  118738.277278908,                    /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient'
                                        */
  -5096.57986519734,                   /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain'
                                        */
  1.0E-6,                              /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator'
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator'
                                        */
  -14.0184615901254                    /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain'
                                        */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
