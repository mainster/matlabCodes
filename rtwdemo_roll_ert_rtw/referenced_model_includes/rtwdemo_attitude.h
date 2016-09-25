/*
 * File: rtwdemo_attitude.h
 *
 * Code generated for Simulink model 'rtwdemo_attitude'.
 *
 * Model version                  : 1.29
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sun Jul 20 05:59:06 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_rtwdemo_attitude_h_
#define RTW_HEADER_rtwdemo_attitude_h_
#ifndef rtwdemo_attitude_COMMON_INCLUDES_
# define rtwdemo_attitude_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* rtwdemo_attitude_COMMON_INCLUDES_ */

/* Forward declaration for rtModel */
typedef struct rtwdemo_attitude_tag_RTM rtwdemo_attitude_RT_MODEL;

/* Block signals and states (auto storage) for model 'rtwdemo_attitude' */
typedef struct {
  real_T Integrator;                   /* '<Root>/Integrator' */
  real_T Integrator_DSTATE;            /* '<Root>/Integrator' */
  int8_T Integrator_PrevResetState;    /* '<Root>/Integrator' */
} rtwdemo_attitude_rtDW;

/* Real-time Model Data Structure */
struct rtwdemo_attitude_tag_RTM {
  const char_T **errorStatus;
};

typedef struct {
  rtwdemo_attitude_rtDW rtdw;
  rtwdemo_attitude_RT_MODEL rtm;
} rtwdemo_attitude_rtMdlrefDWork;

/* Model reference registration function */
extern void rtwdemo_attitude_initialize(const char_T **rt_errorStatus,
  rtwdemo_attitude_RT_MODEL *const rtwdemo_attitudertM);
extern void rtwdemo_attitude_Disable(rtwdemo_attitude_rtDW *localDW);
extern void rtwdemo_attitude(const real_T *u_Disp_Cmd, const real_T *u_Disp_FB,
  const real_T *u_Rate_FB, const boolean_T *u_Engaged, real_T *y_Surf_Cmd,
  rtwdemo_attitude_rtDW *localDW);

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
 * '<Root>' : 'rtwdemo_attitude'
 */

/*-
 * Requirements for '<Root>': rtwdemo_attitude
 */
#endif                                 /* RTW_HEADER_rtwdemo_attitude_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
