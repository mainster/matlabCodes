/*
 * File: pid2Ccode.h
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

#ifndef RTW_HEADER_pid2Ccode_h_
#define RTW_HEADER_pid2Ccode_h_
#ifndef pid2Ccode_COMMON_INCLUDES_
# define pid2Ccode_COMMON_INCLUDES_
#include <string.h>
#include "rtwtypes.h"
#endif                                 /* pid2Ccode_COMMON_INCLUDES_ */

#include "pid2Ccode_types.h"

/* Macros for accessing real-time model data structure */

/* Block signals (auto storage) */
typedef struct {
  real_T ProportionalGain;             /* '<S1>/Proportional Gain' (Output 1)  */
  real_T Integrator;                   /* '<S1>/Integrator' (Output 1)  */
  real_T DerivativeGain;               /* '<S1>/Derivative Gain' (Output 1)  */
  real_T Filter;                       /* '<S1>/Filter' (Output 1)  */
  real_T SumD;                         /* '<S1>/SumD' (Output 1)  */
  real_T FilterCoefficient;            /* '<S1>/Filter Coefficient' (Output 1)  */
  real_T IntegralGain;                 /* '<S1>/Integral Gain' (Output 1)  */
} B_pid2Ccode_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Integrator_DSTATE;            /* '<S1>/Integrator' (DWork 1)  */
  real_T Filter_DSTATE;                /* '<S1>/Filter' (DWork 1)  */
} DW_pid2Ccode_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T In1;                          /* '<Root>/In1' */
} ExtU_pid2Ccode_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Out1;                         /* '<Root>/Out1' */
} ExtY_pid2Ccode_T;

/* Parameters (auto storage) */
struct P_pid2Ccode_T_ {
  real_T ProportionalGain_Gain;        /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain' (Parameter: Gain)
                                        */
  real_T Integrator_gainval;           /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator' (Parameter: gainval)
                                        */
  real_T Integrator_IC;                /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator' (Parameter: InitialCondition)
                                        */
  real_T DerivativeGain_Gain;          /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain' (Parameter: Gain)
                                        */
  real_T Filter_gainval;               /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter' (Parameter: gainval)
                                        */
  real_T Filter_IC;                    /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter' (Parameter: InitialCondition)
                                        */
  real_T FilterCoefficient_Gain;       /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient' (Parameter: Gain)
                                        */
  real_T IntegralGain_Gain;            /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain' (Parameter: Gain)
                                        */
};

/* Block parameters (auto storage) */
extern P_pid2Ccode_T pid2Ccode_P;

/* Block signals (auto storage) */
extern B_pid2Ccode_T pid2Ccode_B;

/* Block states (auto storage) */
extern DW_pid2Ccode_T pid2Ccode_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_pid2Ccode_T pid2Ccode_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_pid2Ccode_T pid2Ccode_Y;

/* Model entry point functions */
extern void pid2Ccode_initialize(void);
extern void pid2Ccode_step(void);

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'pid2Ccode'
 * '<S1>'   : 'pid2Ccode/Discrete PID Controller'
 */
#endif                                 /* RTW_HEADER_pid2Ccode_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
