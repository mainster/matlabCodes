/*
 * PID0.h
 *
 * Code generation for model "PID0".
 *
 * Model version              : 1.491
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Tue Apr 28 20:42:02 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: STMicroelectronics->STM32F4xx 32-bit Cortex-M4
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#ifndef RTW_HEADER_PID0_h_
#define RTW_HEADER_PID0_h_
#ifndef PID0_COMMON_INCLUDES_
# define PID0_COMMON_INCLUDES_
#include <float.h>
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#include "rt_nonfinite.h"
#endif                                 /* PID0_COMMON_INCLUDES_ */

#include "PID0_types.h"

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

/* Block signals (auto storage) */
typedef struct {
  real_T ProportionalGain;             /* '<S1>/Proportional Gain' */
  real_T Integrator;                   /* '<S1>/Integrator' */
  real_T DerivativeGain;               /* '<S1>/Derivative Gain' */
  real_T Filter;                       /* '<S1>/Filter' */
  real_T SumD;                         /* '<S1>/SumD' */
  real_T FilterCoefficient;            /* '<S1>/Filter Coefficient' */
  real_T Sum;                          /* '<S1>/Sum' */
  real_T IntegralGain;                 /* '<S1>/Integral Gain' */
  real_T Gain;                         /* '<S2>/Gain' */
  real_T DeadZone;                     /* '<S2>/DeadZone' */
  real_T SignPreSat;                   /* '<S2>/SignPreSat' */
  real_T DataTypeConv2;                /* '<S2>/DataTypeConv2' */
  real_T SignPreIntegrator;            /* '<S2>/SignPreIntegrator' */
  real_T Switch;                       /* '<S1>/Switch' */
  boolean_T NotEqual;                  /* '<S2>/NotEqual' */
  boolean_T Equal;                     /* '<S2>/Equal' */
  boolean_T AND;                       /* '<S2>/AND' */
} B_PID0_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Integrator_DSTATE;            /* '<S1>/Integrator' */
  real_T Filter_DSTATE;                /* '<S1>/Filter' */
} DW_PID0_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T e;                            /* '<Root>/u' */
} ExtU_PID0_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T y;                            /* '<Root>/y' */
} ExtY_PID0_T;

/* Real-time Model Data Structure */
struct tag_RTM_PID0_T {
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

/* Block signals (auto storage) */
extern B_PID0_T PID0_B;

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
 * hilite_system('Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub/PID')    - opens subsystem Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub/PID
 * hilite_system('Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub/PID/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub'
 * '<S1>'   : 'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub/PID'
 * '<S2>'   : 'Galvo_sys_Cdisc_Pcont_cc_v64_proto_v13_nosub/PID/Clamping circuit'
 */
#endif                                 /* RTW_HEADER_PID0_h_ */
