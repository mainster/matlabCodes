/*
 * File: pid2Ccode_data.c
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

/* Block parameters (auto storage) */
P_pid2Ccode_T pid2Ccode_P = {
  1.601366384328283,                   /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain' (Parameter: Gain)
                                        */
  5.0E-5,                              /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator' (Parameter: gainval)
                                        */
  0.0,                                 /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator' (Parameter: InitialCondition)
                                        */
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
  348.9417691739514                    /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain' (Parameter: Gain)
                                        */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
