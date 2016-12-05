/*
 * Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68.h
 *
 * Code generation for model "Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68".
 *
 * Model version              : 1.412
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Mon Oct 13 07:56:21 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#ifndef RTW_HEADER_Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_h_
#define RTW_HEADER_Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_h_
#ifndef Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_COMMON_INCLUDES_
# define Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_COMMON_INCLUDES_
#include <float.h>
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#include "rt_nonfinite.h"
#endif                                 /* Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_COMMON_INCLUDES_ */

#include "Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetBlkStateChangeFlag
# define rtmGetBlkStateChangeFlag(rtm) ((rtm)->ModelData.blkStateChange)
#endif

#ifndef rtmSetBlkStateChangeFlag
# define rtmSetBlkStateChangeFlag(rtm, val) ((rtm)->ModelData.blkStateChange = (val))
#endif

#ifndef rtmGetContStateDisabled
# define rtmGetContStateDisabled(rtm)  ((rtm)->ModelData.contStateDisabled)
#endif

#ifndef rtmSetContStateDisabled
# define rtmSetContStateDisabled(rtm, val) ((rtm)->ModelData.contStateDisabled = (val))
#endif

#ifndef rtmGetContStates
# define rtmGetContStates(rtm)         ((rtm)->ModelData.contStates)
#endif

#ifndef rtmSetContStates
# define rtmSetContStates(rtm, val)    ((rtm)->ModelData.contStates = (val))
#endif

#ifndef rtmGetDerivCacheNeedsReset
# define rtmGetDerivCacheNeedsReset(rtm) ((rtm)->ModelData.derivCacheNeedsReset)
#endif

#ifndef rtmSetDerivCacheNeedsReset
# define rtmSetDerivCacheNeedsReset(rtm, val) ((rtm)->ModelData.derivCacheNeedsReset = (val))
#endif

#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetIntgData
# define rtmGetIntgData(rtm)           ((rtm)->ModelData.intgData)
#endif

#ifndef rtmSetIntgData
# define rtmSetIntgData(rtm, val)      ((rtm)->ModelData.intgData = (val))
#endif

#ifndef rtmGetOdeF
# define rtmGetOdeF(rtm)               ((rtm)->ModelData.odeF)
#endif

#ifndef rtmSetOdeF
# define rtmSetOdeF(rtm, val)          ((rtm)->ModelData.odeF = (val))
#endif

#ifndef rtmGetOdeY
# define rtmGetOdeY(rtm)               ((rtm)->ModelData.odeY)
#endif

#ifndef rtmSetOdeY
# define rtmSetOdeY(rtm, val)          ((rtm)->ModelData.odeY = (val))
#endif

#ifndef rtmGetRTWLogInfo
# define rtmGetRTWLogInfo(rtm)         ((rtm)->rtwLogInfo)
#endif

#ifndef rtmGetZCCacheNeedsReset
# define rtmGetZCCacheNeedsReset(rtm)  ((rtm)->ModelData.zCCacheNeedsReset)
#endif

#ifndef rtmSetZCCacheNeedsReset
# define rtmSetZCCacheNeedsReset(rtm, val) ((rtm)->ModelData.zCCacheNeedsReset = (val))
#endif

#ifndef rtmGetdX
# define rtmGetdX(rtm)                 ((rtm)->ModelData.derivs)
#endif

#ifndef rtmSetdX
# define rtmSetdX(rtm, val)            ((rtm)->ModelData.derivs = (val))
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
# define rtmGetT(rtm)                  (rtmGetTPtr((rtm))[0])
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

#define Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_M (Galvo_sys_Ccont_Pcont_cc_nos_M)

/* Block signals (auto storage) */
typedef struct {
  real_T w;                            /* '<Root>/Rotor inertia' */
  real_T FilterCoefficient;            /* '<S2>/Filter Coefficient' */
  real_T Switch;                       /* '<S2>/Switch' */
  real_T Sum3;                         /* '<Root>/Sum3' */
  real_T Sum7;                         /* '<Root>/Sum7' */
  boolean_T AND3;                      /* '<S6>/AND3' */
  boolean_T Memory;                    /* '<S6>/Memory' */
} B_Galvo_sys_Ccont_Pcont_cc_no_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  boolean_T Memory_PreviousInput;      /* '<S6>/Memory' */
} DW_Galvo_sys_Ccont_Pcont_cc_n_T;

/* Continuous states (auto storage) */
typedef struct {
  real_T int3_CSTATE;                  /* '<Root>/int3' */
  real_T IntInertia_CSTATE;            /* '<Root>/Int Inertia' */
  real_T Integrator_CSTATE;            /* '<S2>/Integrator' */
  real_T Filter_CSTATE;                /* '<S2>/Filter' */
  real_T IntCoil_CSTATE;               /* '<Root>/Int Coil' */
} X_Galvo_sys_Ccont_Pcont_cc_no_T;

/* State derivatives (auto storage) */
typedef struct {
  real_T int3_CSTATE;                  /* '<Root>/int3' */
  real_T IntInertia_CSTATE;            /* '<Root>/Int Inertia' */
  real_T Integrator_CSTATE;            /* '<S2>/Integrator' */
  real_T Filter_CSTATE;                /* '<S2>/Filter' */
  real_T IntCoil_CSTATE;               /* '<Root>/Int Coil' */
} XDot_Galvo_sys_Ccont_Pcont_cc_T;

/* State disabled  */
typedef struct {
  boolean_T int3_CSTATE;               /* '<Root>/int3' */
  boolean_T IntInertia_CSTATE;         /* '<Root>/Int Inertia' */
  boolean_T Integrator_CSTATE;         /* '<S2>/Integrator' */
  boolean_T Filter_CSTATE;             /* '<S2>/Filter' */
  boolean_T IntCoil_CSTATE;            /* '<Root>/Int Coil' */
} XDis_Galvo_sys_Ccont_Pcont_cc_T;

/* Invariant block signals (auto storage) */
typedef struct {
  const real_T deg2rad1;               /* '<S5>/deg2rad1' */
  const real_T deg2rad1_e;             /* '<S4>/deg2rad1' */
} ConstB_Galvo_sys_Ccont_Pcont__T;

#ifndef ODE3_INTG
#define ODE3_INTG

/* ODE3 Integration Data */
typedef struct {
  real_T *y;                           /* output */
  real_T *f[3];                        /* derivatives */
} ODE3_IntgData;

#endif

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T w1;                           /* '<Root>/w1' */
} ExtU_Galvo_sys_Ccont_Pcont_cc_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T Pos1;                         /* '<Root>/Pos1' */
  real_T phideg;                       /* '<Root>/phideg' */
} ExtY_Galvo_sys_Ccont_Pcont_cc_T;

/* Real-time Model Data Structure */
struct tag_RTM_Galvo_sys_Ccont_Pcont_T {
  const char_T *errorStatus;
  RTWLogInfo *rtwLogInfo;
  RTWSolverInfo solverInfo;

  /*
   * ModelData:
   * The following substructure contains information regarding
   * the data used in the model.
   */
  struct {
    real_T *contStates;
    real_T *derivs;
    boolean_T *contStateDisabled;
    boolean_T zCCacheNeedsReset;
    boolean_T derivCacheNeedsReset;
    boolean_T blkStateChange;
    real_T odeY[5];
    real_T odeF[3][5];
    ODE3_IntgData intgData;
  } ModelData;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    int_T numContStates;
    int_T numSampTimes;
  } Sizes;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    uint32_T clockTick1;
    uint32_T clockTickH1;
    time_T tFinal;
    SimTimeStep simTimeStep;
    boolean_T stopRequestedFlag;
    time_T *t;
    time_T tArray[2];
  } Timing;
};

/* Block signals (auto storage) */
extern B_Galvo_sys_Ccont_Pcont_cc_no_T Galvo_sys_Ccont_Pcont_cc_nosu_B;

/* Continuous states (auto storage) */
extern X_Galvo_sys_Ccont_Pcont_cc_no_T Galvo_sys_Ccont_Pcont_cc_nosu_X;

/* Block states (auto storage) */
extern DW_Galvo_sys_Ccont_Pcont_cc_n_T Galvo_sys_Ccont_Pcont_cc_nos_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_Galvo_sys_Ccont_Pcont_cc_T Galvo_sys_Ccont_Pcont_cc_nosu_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_Galvo_sys_Ccont_Pcont_cc_T Galvo_sys_Ccont_Pcont_cc_nosu_Y;
extern const ConstB_Galvo_sys_Ccont_Pcont__T Galvo_sys_Ccont_Pcont_cc_ConstB;/* constant block i/o */

/* Model entry point functions */
extern void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_initialize(void);
extern void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_step(void);
extern void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_terminate(void);

/* Real-time Model object */
extern RT_MODEL_Galvo_sys_Ccont_Pcon_T *const Galvo_sys_Ccont_Pcont_cc_nos_M;

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
 * '<Root>' : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68'
 * '<S1>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/Cc(s)'
 * '<S2>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/PID'
 * '<S3>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/Radians to Degrees'
 * '<S4>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/Subsystem'
 * '<S5>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/convRadDeg'
 * '<S6>'   : 'Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68/PID/Clamping circuit'
 */
#endif                                 /* RTW_HEADER_Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_h_ */
