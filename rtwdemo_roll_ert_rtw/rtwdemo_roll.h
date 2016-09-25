/*
 * File: rtwdemo_roll.h
 *
 * Code generated for Simulink model 'rtwdemo_roll'.
 *
 * Model version                  : 1.31
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sun Jul 20 05:59:20 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_rtwdemo_roll_h_
#define RTW_HEADER_rtwdemo_roll_h_
#ifndef rtwdemo_roll_COMMON_INCLUDES_
# define rtwdemo_roll_COMMON_INCLUDES_
#include <math.h>
#include "rtwtypes.h"
#endif                                 /* rtwdemo_roll_COMMON_INCLUDES_ */

/* Child system includes */
#include "rtwdemo_heading.h"
#include "rtwdemo_attitude.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetErrorStatusPointer
# define rtmGetErrorStatusPointer(rtm) ((const char_T **)(&((rtm)->errorStatus)))
#endif

/* Forward declaration for rtModel */
typedef struct tag_RTM RT_MODEL;

/* Block signals and states (auto storage) for system '<Root>' */
typedef struct {
  rtwdemo_attitude_rtMdlrefDWork BasicRollMode_DWORK1;/* '<Root>/BasicRollMode' */
  rtwdemo_heading_rtMdlrefDWork HeadingMode_DWORK1;/* '<Root>/HeadingMode' */
  real_T FixPtUnitDelay1_DSTATE;       /* '<S2>/FixPt Unit Delay1' */
} D_Work;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T Phi;                          /* '<Root>/Phi' */
  real_T Psi;                          /* '<Root>/Psi' */
  real_T P;                            /* '<Root>/P' */
  real_T TAS;                          /* '<Root>/TAS' */
  boolean_T AP_Eng;                    /* '<Root>/AP_Eng' */
  boolean_T HDG_Mode;                  /* '<Root>/HDG_Mode' */
  real_T HDG_Ref;                      /* '<Root>/HDG_Ref' */
  real_T Turn_Knob;                    /* '<Root>/Turn_Knob' */
} ExternalInputs;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Ail_Cmd;                      /* '<Root>/Ail_Cmd' */
} ExternalOutputs;

/* Real-time Model Data Structure */
struct tag_RTM {
  const char_T * volatile errorStatus;
};

/* Block signals and states (auto storage) */
extern D_Work rtDWork;

/* External inputs (root inport signals with auto storage) */
extern ExternalInputs rtU;

/* External outputs (root outports fed by signals with auto storage) */
extern ExternalOutputs rtY;

/* Model entry point functions */
extern void rtwdemo_roll_initialize(void);
extern void rtwdemo_roll_step(void);

/* Real-time Model object */
extern RT_MODEL *const rtM;

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
 * '<Root>' : 'rtwdemo_roll'
 * '<S1>'   : 'rtwdemo_roll/RollAngleReference'
 * '<S2>'   : 'rtwdemo_roll/RollAngleReference/LatchPhi'
 */

/*-
 * Requirements for '<Root>': rtwdemo_roll
 */
#endif                                 /* RTW_HEADER_rtwdemo_roll_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
