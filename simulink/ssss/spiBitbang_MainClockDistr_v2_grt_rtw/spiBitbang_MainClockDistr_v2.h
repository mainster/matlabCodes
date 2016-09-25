/*
 * spiBitbang_MainClockDistr_v2.h
 *
 * Code generation for model "spiBitbang_MainClockDistr_v2".
 *
 * Model version              : 1.44
 * Simulink Coder version : 8.5 (R2013b) 08-Aug-2013
 * C source code generated on : Wed Apr 23 02:22:31 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#ifndef RTW_HEADER_spiBitbang_MainClockDistr_v2_h_
#define RTW_HEADER_spiBitbang_MainClockDistr_v2_h_
#ifndef spiBitbang_MainClockDistr_v2_COMMON_INCLUDES_
# define spiBitbang_MainClockDistr_v2_COMMON_INCLUDES_
#include <float.h>
#include <stddef.h>
#include <math.h>
#include <string.h>
#include "rtwtypes.h"
#include "builtin_typeid_types.h"
#include "multiword_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#include "rtGetInf.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include "rt_zcfcn.h"
#endif                                 /* spiBitbang_MainClockDistr_v2_COMMON_INCLUDES_ */

#include "spiBitbang_MainClockDistr_v2_types.h"

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
  real_T ctrGen;                       /* '<S1>/Counter' */
  real_T gen_CS;                       /* '<S7>/Constant' */
  real_T clk_delayed;                  /* '<S7>/Delay1' */
  real_T ShiftArithmetic;              /* '<S4>/Shift Arithmetic' */
  uint16_T BitwiseOperator;            /* '<S7>/Bitwise Operator' */
  uint16_T ShiftArithmetic_e;          /* '<S12>/Shift Arithmetic' */
  boolean_T f_clk;                     /* '<S1>/cast1 ' */
  boolean_T interrupt;                 /* '<Root>/f_sck_OnOff' */
  boolean_T g0;                        /* '<S8>/Compare' */
  boolean_T NSampleEnable;             /* '<Root>/N-Sample Enable' */
  boolean_T NSampleEnable_m;           /* '<S6>/N-Sample Enable' */
  uint8_T Output;                      /* '<S9>/Output' */
} B_spiBitbang_MainClockDistr_v_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Delay1_DSTATE[100];           /* '<S7>/Delay1' */
  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  struct {
    void *LoggedData;
  } Scope3_PWORK;                      /* '<Root>/Scope3' */

  struct {
    void *LoggedData;
  } Scope2_PWORK;                      /* '<Root>/Scope2' */

  struct {
    void *LoggedData;
  } FloatingScope_PWORK;               /* synthesized block */

  struct {
    void *LoggedData;
  } FloatingScope1_PWORK;              /* synthesized block */

  int32_T clockTickCounter;            /* '<S1>/f_sck' */
  int32_T clockTickCounter_c;          /* '<Root>/Start16BitRead' */
  int32_T clockTickCounter_j;          /* '<Root>/Start16BitRead1' */
  uint32_T NSampleEnable_Counter;      /* '<Root>/N-Sample Enable' */
  uint32_T NSampleEnable_Counter_o;    /* '<S6>/N-Sample Enable' */
  uint32_T f_sck_OnOff_Counter;        /* '<Root>/f_sck_OnOff' */
  uint32_T Counter_ClkEphState;        /* '<S1>/Counter' */
  uint32_T Counter_RstEphState;        /* '<S1>/Counter' */
  uint16_T Output_DSTATE;              /* '<S15>/Output' */
  boolean_T UnitDelay_DSTATE;          /* '<S1>/Unit Delay' */
  uint8_T Output_DSTATE_c;             /* '<S9>/Output' */
  uint8_T Counter_Count;               /* '<S1>/Counter' */
  uint8_T icLoad;                      /* '<S7>/Delay1' */
  boolean_T TxSubsystem_MODE;          /* '<Root>/TxSubsystem' */
} DW_spiBitbang_MainClockDistr__T;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Bitmask_Trig_ZCE;         /* '<S7>/Bitmask' */
  ZCSigState Shifter_Trig_ZCE;         /* '<Root>/Shifter' */
} PrevZCX_spiBitbang_MainClockD_T;

/* Parameters (auto storage) */
struct P_spiBitbang_MainClockDistr_v_T_ {
  real_T Constant_Value;               /* Expression: 1
                                        * Referenced by: '<S12>/Constant'
                                        */
  real_T cs_Y0;                        /* Expression: 1
                                        * Referenced by: '<S7>/cs'
                                        */
  real_T clk_delayed_Y0;               /* Expression: 1
                                        * Referenced by: '<S7>/clk_delayed'
                                        */
  real_T Constant_Value_g;             /* Expression: 1
                                        * Referenced by: '<S7>/Constant'
                                        */
  real_T Constant1_Value;              /* Expression: 1
                                        * Referenced by: '<S7>/Constant1'
                                        */
  real_T initial_Value;                /* Expression: 0
                                        * Referenced by: '<S7>/initial'
                                        */
  real_T stop1_Value;                  /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  real_T f_sck_Amp;                    /* Expression: 1
                                        * Referenced by: '<S1>/f_sck'
                                        */
  real_T f_sck_Period;                 /* Expression: periSam
                                        * Referenced by: '<S1>/f_sck'
                                        */
  real_T f_sck_Duty;                   /* Expression: periSam/2
                                        * Referenced by: '<S1>/f_sck'
                                        */
  real_T f_sck_PhaseDelay;             /* Expression: 0
                                        * Referenced by: '<S1>/f_sck'
                                        */
  real_T Start16BitRead_Amp;           /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Period;        /* Expression: 400
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Duty;          /* Expression: 35
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_PhaseDelay;    /* Expression: 20
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Constant_Value_a;             /* Expression: const
                                        * Referenced by: '<S8>/Constant'
                                        */
  real_T stop3_Value[4];               /* Expression: [0 1 2 3]*1.1
                                        * Referenced by: '<Root>/stop3'
                                        */
  real_T Constant_Value_gq;            /* Expression: 1
                                        * Referenced by: '<Root>/Constant'
                                        */
  real_T Start16BitRead1_Amp;          /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  real_T Start16BitRead1_Period;       /* Expression: 100
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  real_T Start16BitRead1_Duty;         /* Expression: 50
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  real_T Start16BitRead1_PhaseDelay;   /* Expression: 0
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  uint32_T NSampleEnable_TARGETCNT;    /* Computed Parameter: NSampleEnable_TARGETCNT
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_ACTLEVEL;     /* Computed Parameter: NSampleEnable_ACTLEVEL
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_TARGETCNT_k;  /* Computed Parameter: NSampleEnable_TARGETCNT_k
                                        * Referenced by: '<S6>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_ACTLEVEL_n;   /* Computed Parameter: NSampleEnable_ACTLEVEL_n
                                        * Referenced by: '<S6>/N-Sample Enable'
                                        */
  uint32_T f_sck_OnOff_TARGETCNT;      /* Computed Parameter: f_sck_OnOff_TARGETCNT
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  uint32_T f_sck_OnOff_ACTLEVEL;       /* Computed Parameter: f_sck_OnOff_ACTLEVEL
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  uint16_T tx_Y0;                      /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S7>/tx'
                                        */
  uint16_T stop2_Value;                /* Computed Parameter: stop2_Value
                                        * Referenced by: '<Root>/stop2'
                                        */
  uint16_T Constant_Value_p;           /* Computed Parameter: Constant_Value_p
                                        * Referenced by: '<S17>/Constant'
                                        */
  uint16_T FixPtConstant_Value;        /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S16>/FixPt Constant'
                                        */
  uint16_T Output_InitialCondition;    /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S15>/Output'
                                        */
  uint16_T FixPtSwitch_Threshold;      /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S17>/FixPt Switch'
                                        */
  uint8_T TransmitCommand_CurrentSetting;/* Computed Parameter: TransmitCommand_CurrentSetting
                                          * Referenced by: '<Root>/Transmit Command'
                                          */
  uint8_T Counter_InitialCount;        /* Computed Parameter: Counter_InitialCount
                                        * Referenced by: '<S1>/Counter'
                                        */
  uint8_T Counter_HitValue;            /* Computed Parameter: Counter_HitValue
                                        * Referenced by: '<S1>/Counter'
                                        */
  boolean_T stop_Value;                /* Computed Parameter: stop_Value
                                        * Referenced by: '<Root>/stop'
                                        */
  boolean_T UnitDelay_InitialCondition;/* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  uint8_T Constant_Value_p3;           /* Computed Parameter: Constant_Value_p3
                                        * Referenced by: '<S11>/Constant'
                                        */
  uint8_T FixPtConstant_Value_d;       /* Computed Parameter: FixPtConstant_Value_d
                                        * Referenced by: '<S10>/FixPt Constant'
                                        */
  uint8_T Output_InitialCondition_h;   /* Computed Parameter: Output_InitialCondition_h
                                        * Referenced by: '<S9>/Output'
                                        */
  uint8_T FixPtSwitch_Threshold_a;     /* Computed Parameter: FixPtSwitch_Threshold_a
                                        * Referenced by: '<S11>/FixPt Switch'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_spiBitbang_MainClockD_T {
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

/* Block parameters (auto storage) */
extern P_spiBitbang_MainClockDistr_v_T spiBitbang_MainClockDistr_v2_P;

/* Block signals (auto storage) */
extern B_spiBitbang_MainClockDistr_v_T spiBitbang_MainClockDistr_v2_B;

/* Block states (auto storage) */
extern DW_spiBitbang_MainClockDistr__T spiBitbang_MainClockDistr_v2_DW;

/* Model entry point functions */
extern void spiBitbang_MainClockDistr_v2_initialize(void);
extern void spiBitbang_MainClockDistr_v2_step(void);
extern void spiBitbang_MainClockDistr_v2_terminate(void);

/* Real-time Model object */
extern RT_MODEL_spiBitbang_MainClock_T *const spiBitbang_MainClockDistr_v2_M;

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
 * '<Root>' : 'spiBitbang_MainClockDistr_v2'
 * '<S1>'   : 'spiBitbang_MainClockDistr_v2/Clock Gen'
 * '<S2>'   : 'spiBitbang_MainClockDistr_v2/Compare To Constant'
 * '<S3>'   : 'spiBitbang_MainClockDistr_v2/Compare To Constant1'
 * '<S4>'   : 'spiBitbang_MainClockDistr_v2/Shifter'
 * '<S5>'   : 'spiBitbang_MainClockDistr_v2/Signal Builder4'
 * '<S6>'   : 'spiBitbang_MainClockDistr_v2/Transmiss Toggle'
 * '<S7>'   : 'spiBitbang_MainClockDistr_v2/TxSubsystem'
 * '<S8>'   : 'spiBitbang_MainClockDistr_v2/Clock Gen/Comp2'
 * '<S9>'   : 'spiBitbang_MainClockDistr_v2/Shifter/Counter Free-Running'
 * '<S10>'  : 'spiBitbang_MainClockDistr_v2/Shifter/Counter Free-Running/Increment Real World'
 * '<S11>'  : 'spiBitbang_MainClockDistr_v2/Shifter/Counter Free-Running/Wrap To Zero'
 * '<S12>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Bitmask'
 * '<S13>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Dff'
 * '<S14>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Extract Bits'
 * '<S15>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Bitmask/Counter Free-Running'
 * '<S16>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Bitmask/Counter Free-Running/Increment Real World'
 * '<S17>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Bitmask/Counter Free-Running/Wrap To Zero'
 * '<S18>'  : 'spiBitbang_MainClockDistr_v2/TxSubsystem/Dff/D Flip-Flop'
 */
#endif                                 /* RTW_HEADER_spiBitbang_MainClockDistr_v2_h_ */
