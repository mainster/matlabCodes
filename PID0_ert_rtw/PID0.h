/*
 * File: PID0.h
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

#ifndef RTW_HEADER_PID0_h_
#define RTW_HEADER_PID0_h_
#ifndef PID0_COMMON_INCLUDES_
# define PID0_COMMON_INCLUDES_
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#endif                                 /* PID0_COMMON_INCLUDES_ */

#include "PID0_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Filter_DSTATE;                /* '<S1>/Filter' */
  real_T Integrator_DSTATE;            /* '<S1>/Integrator' */
} DW_PID0_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T u;                            /* '<Root>/u' */
} ExtU_PID0_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T y;                            /* '<Root>/y' */
} ExtY_PID0_T;

/* Parameters (auto storage) */
struct P_PID0_T_ {
  real_T DerivativeGain_Gain;          /* Expression: D
                                        * Referenced by: '<S1>/Derivative Gain'
                                        */
  real_T Filter_gainval;               /* Computed Parameter: Filter_gainval
                                        * Referenced by: '<S1>/Filter'
                                        */
  real_T Filter_IC;                    /* Expression: InitialConditionForFilter
                                        * Referenced by: '<S1>/Filter'
                                        */
  real_T FilterCoefficient_Gain;       /* Expression: N
                                        * Referenced by: '<S1>/Filter Coefficient'
                                        */
  real_T IntegralGain_Gain;            /* Expression: I
                                        * Referenced by: '<S1>/Integral Gain'
                                        */
  real_T Integrator_gainval;           /* Computed Parameter: Integrator_gainval
                                        * Referenced by: '<S1>/Integrator'
                                        */
  real_T Integrator_IC;                /* Expression: InitialConditionForIntegrator
                                        * Referenced by: '<S1>/Integrator'
                                        */
  real_T ProportionalGain_Gain;        /* Expression: P
                                        * Referenced by: '<S1>/Proportional Gain'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_PID0_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (auto storage) */
extern P_PID0_T PID0_P;

/* Block states (auto storage) */
extern DW_PID0_T PID0_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_PID0_T PID0_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_PID0_T PID0_Y;

/* Model entry point functions */
extern void PID0_initialize(void);
extern void PID0_step(void);
extern void PID0_terminate(void);

/* Real-time Model object */
extern RT_MODEL_PID0_T *const PID0_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Note that this particular code originates from a subsystem build,
 * and has its own system numbers different from the parent model.
 * Refer to the system hierarchy for this subsystem below, and use the
 * MATLAB hilite_system command to trace the generated code back
 * to the parent model.  For example,
 *
 * hilite_system('GalvoModel_v3_PID_tfCC/PID Controller')    - opens subsystem GalvoModel_v3_PID_tfCC/PID Controller
 * hilite_system('GalvoModel_v3_PID_tfCC/PID Controller/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'GalvoModel_v3_PID_tfCC'
 * '<S1>'   : 'GalvoModel_v3_PID_tfCC/PID Controller'
 */
#endif                                 /* RTW_HEADER_PID0_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
