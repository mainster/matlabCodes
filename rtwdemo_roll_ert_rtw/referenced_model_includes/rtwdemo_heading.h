/*
 * File: rtwdemo_heading.h
 *
 * Code generated for Simulink model 'rtwdemo_heading'.
 *
 * Model version                  : 1.19
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sun Jul 20 05:59:14 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_rtwdemo_heading_h_
#define RTW_HEADER_rtwdemo_heading_h_
#ifndef rtwdemo_heading_COMMON_INCLUDES_
# define rtwdemo_heading_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* rtwdemo_heading_COMMON_INCLUDES_ */

/* Forward declaration for rtModel */
typedef struct rtwdemo_heading_tag_RTM rtwdemo_heading_RT_MODEL;

/* Real-time Model Data Structure */
struct rtwdemo_heading_tag_RTM {
  const char_T **errorStatus;
};

typedef struct {
  rtwdemo_heading_RT_MODEL rtm;
} rtwdemo_heading_rtMdlrefDWork;

/* Model reference registration function */
extern void rtwdemo_heading_initialize(const char_T **rt_errorStatus,
  rtwdemo_heading_RT_MODEL *const rtwdemo_headingrtM);
extern void rtwdemo_heading(const real_T *rtu_Psi_Ref, const real_T *rtu_Psi,
  const real_T *rtu_TAS, real_T *rty_Phi_Cmd);

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
 * '<Root>' : 'rtwdemo_heading'
 */

/*-
 * Requirements for '<Root>': rtwdemo_heading
 */
#endif                                 /* RTW_HEADER_rtwdemo_heading_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
