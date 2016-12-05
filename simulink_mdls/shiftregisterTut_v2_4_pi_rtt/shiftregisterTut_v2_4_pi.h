/*
 * File: shiftregisterTut_v2_4_pi.h
 *
 * Code generated for Simulink model 'shiftregisterTut_v2_4_pi'.
 *
 * Model version                  : 1.32
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Thu Apr 24 20:03:31 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_shiftregisterTut_v2_4_pi_h_
#define RTW_HEADER_shiftregisterTut_v2_4_pi_h_
#ifndef shiftregisterTut_v2_4_pi_COMMON_INCLUDES_
# define shiftregisterTut_v2_4_pi_COMMON_INCLUDES_
#include <stddef.h>
#include <math.h>
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "MW_gpio_lct.h"
#include "rtGetInf.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#endif                                 /* shiftregisterTut_v2_4_pi_COMMON_INCLUDES_ */

#include "shiftregisterTut_v2_4_pi_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Zero-crossing (trigger) state for system '<Root>/TriggToWb' */
typedef struct {
  ZCSigState TriggToWb_Trig_ZCE;       /* '<Root>/TriggToWb' */
} ZCE_TriggToWb_shiftregisterTu_T;

/* Block signals (auto storage) */
typedef struct {
  real_T cast16;                       /* '<S2>/cast1 6' */
  real_T Counter_o1;                   /* '<S2>/Counter' */
  real_T SFunction[16];                /* '<S12>/S-Function ' */
  uint16_T shiftout;                   /* '<S14>/Shift Arithmetic' */
  boolean_T En16;                      /* '<S1>/and5' */
  boolean_T clk16;                     /* '<S1>/and4' */
  boolean_T Compare;                   /* '<S10>/Compare' */
  boolean_T cast11;                    /* '<S1>/cast1 1' */
  boolean_T gen_CS;                    /* '<S5>/Constant2' */
  boolean_T clk_delayed;               /* '<S5>/Delay1' */
  boolean_T MOSI;                      /* '<S5>/cast1 6' */
  boolean_T D;                         /* '<S9>/D' */
} B_shiftregisterTut_v2_4_pi_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T UnitDelay_DSTATE;             /* '<S2>/Unit Delay' */
  struct {
    void *uBuffers;
  } SFunction_PWORK;                   /* '<S12>/S-Function ' */

  int32_T clockTickCounter;            /* '<S1>/f_sck' */
  int32_T clockTickCounter_i;          /* '<Root>/Start16BitRead' */
  uint32_T Counter_ClkEphState;        /* '<S1>/Counter' */
  uint32_T Counter_RstEphState;        /* '<S1>/Counter' */
  uint32_T Counter_ClkEphState_k;      /* '<S2>/Counter' */
  uint32_T Counter_RstEphState_b;      /* '<S2>/Counter' */
  struct {
    int_T indPs;
    int_T bufSz;
  } SFunction_IWORK;                   /* '<S12>/S-Function ' */

  uint16_T Output_DSTATE;              /* '<S16>/Output' */
  boolean_T UnitDelay_DSTATE_p;        /* '<S1>/Unit Delay' */
  boolean_T Delay1_DSTATE[6];          /* '<S5>/Delay1' */
  uint8_T Counter_Count;               /* '<S1>/Counter' */
  uint8_T Counter_Count_a;             /* '<S2>/Counter' */
  boolean_T TmpLatchAtDFlipFlopInport1_Prev;/* synthesized block */
  boolean_T DFlipFlop_MODE;            /* '<S8>/D Flip-Flop' */
  boolean_T TxSubsystem_MODE;          /* '<Root>/TxSubsystem' */
} DW_shiftregisterTut_v2_4_pi_T;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Delay1_Reset_ZCE;         /* '<S5>/Delay1' */
  ZCSigState Bitmask_Trig_ZCE;         /* '<S5>/Bitmask' */
  ZCE_TriggToWb_shiftregisterTu_T TriggToWb1;/* '<Root>/TriggToWb' */
  ZCE_TriggToWb_shiftregisterTu_T TriggToWb;/* '<Root>/TriggToWb' */
  ZCSigState TriggeredShifter_Trig_ZCE;/* '<S2>/TriggeredShifter' */
  ZCSigState DFlipFlop_Trig_ZCE;       /* '<S8>/D Flip-Flop' */
} PrevZCX_shiftregisterTut_v2_4_T;

/* Parameters (auto storage) */
struct P_shiftregisterTut_v2_4_pi_T_ {
  real_T stop1_Value;                  /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  real_T Constant_Value;               /* Expression: 0
                                        * Referenced by: '<S14>/Constant'
                                        */
  real_T sh_ctr_Y0;                    /* Expression: 1
                                        * Referenced by: '<S5>/sh_ctr'
                                        */
  real_T Constant1_Value;              /* Expression: 1
                                        * Referenced by: '<S5>/Constant1'
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
  real_T stop2_Value;                  /* Expression: 1
                                        * Referenced by: '<Root>/stop2'
                                        */
  real_T Constant_Value_o;             /* Expression: const
                                        * Referenced by: '<S7>/Constant'
                                        */
  real_T Constant_Value_b;             /* Expression: const
                                        * Referenced by: '<S6>/Constant'
                                        */
  real_T Start16BitRead_Amp;           /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Period;        /* Expression: 3000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Duty;          /* Expression: 1000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_PhaseDelay;    /* Expression: 10
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T delay1_Value;                 /* Expression: 1
                                        * Referenced by: '<Root>/delay1'
                                        */
  real_T Switch_Threshold;             /* Expression: 0.5
                                        * Referenced by: '<Root>/Switch'
                                        */
  real_T UnitDelay_InitialCondition;   /* Expression: 0
                                        * Referenced by: '<S2>/Unit Delay'
                                        */
  real_T Constant_Value_a;             /* Expression: const
                                        * Referenced by: '<S10>/Constant'
                                        */
  uint32_T Delay1_DelayLength;         /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S5>/Delay1'
                                        */
  uint32_T CSn_p1;                     /* Computed Parameter: CSn_p1
                                        * Referenced by: '<Root>/CSn'
                                        */
  uint32_T CSn_p2;                     /* Computed Parameter: CSn_p2
                                        * Referenced by: '<Root>/CSn'
                                        */
  uint32_T CSn_p3;                     /* Computed Parameter: CSn_p3
                                        * Referenced by: '<Root>/CSn'
                                        */
  uint32_T MOSI_p1;                    /* Computed Parameter: MOSI_p1
                                        * Referenced by: '<Root>/MOSI'
                                        */
  uint32_T MOSI_p2;                    /* Computed Parameter: MOSI_p2
                                        * Referenced by: '<Root>/MOSI'
                                        */
  uint32_T MOSI_p3;                    /* Computed Parameter: MOSI_p3
                                        * Referenced by: '<Root>/MOSI'
                                        */
  uint32_T SCK_p1;                     /* Computed Parameter: SCK_p1
                                        * Referenced by: '<Root>/SCK'
                                        */
  uint32_T SCK_p2;                     /* Computed Parameter: SCK_p2
                                        * Referenced by: '<Root>/SCK'
                                        */
  uint32_T SCK_p3;                     /* Computed Parameter: SCK_p3
                                        * Referenced by: '<Root>/SCK'
                                        */
  uint16_T out_Y0;                     /* Computed Parameter: out_Y0
                                        * Referenced by: '<S14>/out'
                                        */
  uint16_T TxData_Value;               /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  uint16_T Constant_Value_f;           /* Computed Parameter: Constant_Value_f
                                        * Referenced by: '<S18>/Constant'
                                        */
  uint16_T FixPtConstant_Value;        /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S17>/FixPt Constant'
                                        */
  uint16_T Output_InitialCondition;    /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S16>/Output'
                                        */
  uint16_T FixPtSwitch_Threshold;      /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S18>/FixPt Switch'
                                        */
  uint8_T Counter_InitialCount;        /* Computed Parameter: Counter_InitialCount
                                        * Referenced by: '<S1>/Counter'
                                        */
  uint8_T Counter_HitValue;            /* Computed Parameter: Counter_HitValue
                                        * Referenced by: '<S1>/Counter'
                                        */
  uint8_T CSn_p4;                      /* Expression: pinName
                                        * Referenced by: '<Root>/CSn'
                                        */
  uint8_T MOSI_p4;                     /* Expression: pinName
                                        * Referenced by: '<Root>/MOSI'
                                        */
  uint8_T SCK_p4;                      /* Expression: pinName
                                        * Referenced by: '<Root>/SCK'
                                        */
  uint8_T ManualSwitch_CurrentSetting; /* Computed Parameter: ManualSwitch_CurrentSetting
                                        * Referenced by: '<Root>/Manual Switch'
                                        */
  uint8_T Counter_InitialCount_n;      /* Computed Parameter: Counter_InitialCount_n
                                        * Referenced by: '<S2>/Counter'
                                        */
  uint8_T Counter_HitValue_a;          /* Computed Parameter: Counter_HitValue_a
                                        * Referenced by: '<S2>/Counter'
                                        */
  boolean_T Q_Y0;                      /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S9>/Q'
                                        */
  boolean_T Q_Y0_l;                    /* Computed Parameter: Q_Y0_l
                                        * Referenced by: '<S9>/!Q'
                                        */
  boolean_T clk_delayed_Y0;            /* Computed Parameter: clk_delayed_Y0
                                        * Referenced by: '<S5>/clk_delayed'
                                        */
  boolean_T cs_Y0;                     /* Computed Parameter: cs_Y0
                                        * Referenced by: '<S5>/cs'
                                        */
  boolean_T tx_Y0;                     /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S5>/tx'
                                        */
  boolean_T Constant2_Value;           /* Computed Parameter: Constant2_Value
                                        * Referenced by: '<S5>/Constant2'
                                        */
  boolean_T Delay1_InitialCondition;   /* Computed Parameter: Delay1_InitialCondition
                                        * Referenced by: '<S5>/Delay1'
                                        */
  boolean_T UnitDelay_InitialCondition_o;/* Computed Parameter: UnitDelay_InitialCondition_o
                                          * Referenced by: '<S1>/Unit Delay'
                                          */
  boolean_T TmpLatchAtDFlipFlopInport1_X0;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                           * Referenced by: synthesized block
                                           */
};

/* Real-time Model Data Structure */
struct tag_RTM_shiftregisterTut_v2_4_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (auto storage) */
extern P_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_P;

/* Block signals (auto storage) */
extern B_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_B;

/* Block states (auto storage) */
extern DW_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_DW;

/* Model entry point functions */
extern void shiftregisterTut_v2_4_pi_initialize(void);
extern void shiftregisterTut_v2_4_pi_output(void);
extern void shiftregisterTut_v2_4_pi_update(void);
extern void shiftregisterTut_v2_4_pi_terminate(void);

/* Real-time Model object */
extern RT_MODEL_shiftregisterTut_v2__T *const shiftregisterTut_v2_4_pi_M;

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
 * '<Root>' : 'shiftregisterTut_v2_4_pi'
 * '<S1>'   : 'shiftregisterTut_v2_4_pi/Clock Gen'
 * '<S2>'   : 'shiftregisterTut_v2_4_pi/RxSubsystem'
 * '<S3>'   : 'shiftregisterTut_v2_4_pi/TriggToWb'
 * '<S4>'   : 'shiftregisterTut_v2_4_pi/TriggToWb1'
 * '<S5>'   : 'shiftregisterTut_v2_4_pi/TxSubsystem'
 * '<S6>'   : 'shiftregisterTut_v2_4_pi/Clock Gen/Comp1'
 * '<S7>'   : 'shiftregisterTut_v2_4_pi/Clock Gen/Comp2'
 * '<S8>'   : 'shiftregisterTut_v2_4_pi/Clock Gen/D Flip-Flop1'
 * '<S9>'   : 'shiftregisterTut_v2_4_pi/Clock Gen/D Flip-Flop1/D Flip-Flop'
 * '<S10>'  : 'shiftregisterTut_v2_4_pi/RxSubsystem/Compare To Constant'
 * '<S11>'  : 'shiftregisterTut_v2_4_pi/RxSubsystem/TriggeredShifter'
 * '<S12>'  : 'shiftregisterTut_v2_4_pi/RxSubsystem/TriggeredShifter/Discrete Shift Register3'
 * '<S13>'  : 'shiftregisterTut_v2_4_pi/RxSubsystem/TriggeredShifter/Extract Bits2'
 * '<S14>'  : 'shiftregisterTut_v2_4_pi/TxSubsystem/Bitmask'
 * '<S15>'  : 'shiftregisterTut_v2_4_pi/TxSubsystem/Bitmask/Compare To Constant'
 * '<S16>'  : 'shiftregisterTut_v2_4_pi/TxSubsystem/Bitmask/Counter Free-Running'
 * '<S17>'  : 'shiftregisterTut_v2_4_pi/TxSubsystem/Bitmask/Counter Free-Running/Increment Real World'
 * '<S18>'  : 'shiftregisterTut_v2_4_pi/TxSubsystem/Bitmask/Counter Free-Running/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_shiftregisterTut_v2_4_pi_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
