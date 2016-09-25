/*
 * rtwdemo_rtwintro.h
 *
 * Code generation for model "rtwdemo_rtwintro".
 *
 * Model version              : 1.251
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Jul 20 06:04:50 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Generic->32-bit Embedded Processor
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#ifndef RTW_HEADER_rtwdemo_rtwintro_h_
#define RTW_HEADER_rtwdemo_rtwintro_h_
#ifndef rtwdemo_rtwintro_COMMON_INCLUDES_
# define rtwdemo_rtwintro_COMMON_INCLUDES_
#include <float.h>
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#include "rt_nonfinite.h"
#endif                                 /* rtwdemo_rtwintro_COMMON_INCLUDES_ */

#include "rtwdemo_rtwintro_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWLogInfo
# define rtmGetRTWLogInfo(rtm)         ((rtm)->rtwLogInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  uint8_T X;                           /* '<Root>/X' */
} DW_rtwdemo_rtwintro_T;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Amplifier_Trig_ZCE;       /* '<Root>/Amplifier' */
} PrevZCX_rtwdemo_rtwintro_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  int32_T Input;                       /* '<Root>/Input' */
} ExtU_rtwdemo_rtwintro_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  int32_T Output;                      /* '<Root>/Output' */
} ExtY_rtwdemo_rtwintro_T;

/* Real-time Model Data Structure */
struct tag_RTM_rtwdemo_rtwintro_T {
  const char_T *errorStatus;
  RTWLogInfo *rtwLogInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block states (auto storage) */
extern DW_rtwdemo_rtwintro_T rtwdemo_rtwintro_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_rtwdemo_rtwintro_T rtwdemo_rtwintro_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_rtwdemo_rtwintro_T rtwdemo_rtwintro_Y;

/* Model entry point functions */
extern void rtwdemo_rtwintro_initialize(void);
extern void rtwdemo_rtwintro_step(void);
extern void rtwdemo_rtwintro_terminate(void);

/* Real-time Model object */
extern RT_MODEL_rtwdemo_rtwintro_T *const rtwdemo_rtwintro_M;

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
 * '<Root>' : 'rtwdemo_rtwintro'
 * '<S1>'   : 'rtwdemo_rtwintro/Amplifier'
 */
#endif                                 /* RTW_HEADER_rtwdemo_rtwintro_h_ */
