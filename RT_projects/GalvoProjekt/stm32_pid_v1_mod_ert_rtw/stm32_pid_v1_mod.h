/*
 * File: stm32_pid_v1_mod.h
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

#ifndef RTW_HEADER_stm32_pid_v1_mod_h_
#define RTW_HEADER_stm32_pid_v1_mod_h_
#ifndef stm32_pid_v1_mod_COMMON_INCLUDES_
# define stm32_pid_v1_mod_COMMON_INCLUDES_
#include <string.h>
#include "rtwtypes.h"
#endif                                 /* stm32_pid_v1_mod_COMMON_INCLUDES_ */

#include "stm32_pid_v1_mod_types.h"

/* Macros for accessing real-time model data structure */

/* Block signals (auto storage) */
typedef struct {
  real_T DerivativeGain;               /* '<S1>/Derivative Gain' (Output 1)  */
  real_T Filter;                       /* '<S1>/Filter' (Output 1)  */
  real_T SumD;                         /* '<S1>/SumD' (Output 1)  */
  real_T FilterCoefficient;            /* '<S1>/Filter Coefficient' (Output 1)  */
  real_T IntegralGain;                 /* '<S1>/Integral Gain' (Output 1)  */
  real_T Integrator;                   /* '<S1>/Integrator' (Output 1)  */
  real_T ProportionalGain;             /* '<S1>/Proportional Gain' (Output 1)  */
  real_T Sum;                          /* '<S1>/Sum' (Output 1)  */
} B_stm32_pid_v1_mod_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T DiscreteZeroPole_DSTATE[2];   /* '<Root>/Discrete Zero-Pole' (DWork 1)  */
  real_T Filter_DSTATE;                /* '<S1>/Filter' (DWork 1)  */
  real_T Integrator_DSTATE;            /* '<S1>/Integrator' (DWork 1)  */
} DW_stm32_pid_v1_mod_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T In1;                          /* '<Root>/In1' */
} ExtU_stm32_pid_v1_mod_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Out1;                         /* '<Root>/Out1' */
} ExtY_stm32_pid_v1_mod_T;

/* Parameters (auto storage) */
struct P_stm32_pid_v1_mod_T_ {
  real_T DiscreteZeroPole_A[3];        /* Computed Parameter: DiscreteZeroPole_A
                                        * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: A)
                                        */
  real_T DiscreteZeroPole_B;           /* Computed Parameter: DiscreteZeroPole_B
                                        * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: B)
                                        */
  real_T DiscreteZeroPole_C[2];        /* Computed Parameter: DiscreteZeroPole_C
                                        * Referenced by: '<Root>/Discrete Zero-Pole' (Parameter: C)
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
  real_T Integrator_gainval;           /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator' (Parameter: gainval)
                                        */
  real_T Integrator_IC;                /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator' (Parameter: InitialCondition)
                                        */
  real_T ProportionalGain_Gain;        /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain' (Parameter: Gain)
                                        */
};

/* Block parameters (auto storage) */
extern P_stm32_pid_v1_mod_T stm32_pid_v1_mod_P;

/* Block signals (auto storage) */
extern B_stm32_pid_v1_mod_T stm32_pid_v1_mod_B;

/* Block states (auto storage) */
extern DW_stm32_pid_v1_mod_T stm32_pid_v1_mod_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_stm32_pid_v1_mod_T stm32_pid_v1_mod_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_stm32_pid_v1_mod_T stm32_pid_v1_mod_Y;

/* Model entry point functions */
extern void stm32_pid_v1_mod_initialize(void);
extern void stm32_pid_v1_mod_step(void);

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
 * '<Root>' : 'stm32_pid_v1_mod'
 * '<S1>'   : 'stm32_pid_v1_mod/Discrete PID Controller'
 * '<S2>'   : 'stm32_pid_v1_mod/DiscretePIDController1'
 */
#endif                                 /* RTW_HEADER_stm32_pid_v1_mod_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
