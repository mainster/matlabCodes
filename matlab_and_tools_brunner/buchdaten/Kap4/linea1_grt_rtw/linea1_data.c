/*
 * linea1_data.c
 *
 * Code generation for model "linea1".
 *
 * Model version              : 1.4
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Thu Apr 24 21:14:30 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "linea1.h"
#include "linea1_private.h"

/* Block parameters (auto storage) */
P_linea1_T linea1_P = {
  /*  Computed Parameter: ZeroPole_A
   * Referenced by: '<Root>/Zero-Pole'
   */
  { -0.5, 0.0 },

  /*  Computed Parameter: ZeroPole_C
   * Referenced by: '<Root>/Zero-Pole'
   */
  { 0.1, 0.06 },
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Step'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Step'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Step'
                                        */
  -1.0,                                /* Computed Parameter: TransferFcn_A
                                        * Referenced by: '<Root>/Transfer Fcn'
                                        */
  1.0                                  /* Computed Parameter: TransferFcn_C
                                        * Referenced by: '<Root>/Transfer Fcn'
                                        */
};
