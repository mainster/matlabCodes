/*
 * File: spiBitbang_complete_v2_2.h
 *
 * Code generated for Simulink model 'spiBitbang_complete_v2_2'.
 *
 * Model version                  : 1.88
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Thu Apr 24 09:51:55 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_spiBitbang_complete_v2_2_h_
#define RTW_HEADER_spiBitbang_complete_v2_2_h_
#ifndef spiBitbang_complete_v2_2_COMMON_INCLUDES_
# define spiBitbang_complete_v2_2_COMMON_INCLUDES_
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
#include "rt_zcfcn.h"
#endif                                 /* spiBitbang_complete_v2_2_COMMON_INCLUDES_ */

#include "spiBitbang_complete_v2_2_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block signals for system '<S14>/D Flip-Flop' */
typedef struct {
  boolean_T D;                         /* '<S32>/D' */
} B_DFlipFlop_spiBitbang_comple_T;

/* Block states (auto storage) for system '<S14>/D Flip-Flop' */
typedef struct {
  boolean_T DFlipFlop_MODE;            /* '<S14>/D Flip-Flop' */
} DW_DFlipFlop_spiBitbang_compl_T;

/* Zero-crossing (trigger) state for system '<S14>/D Flip-Flop' */
typedef struct {
  ZCSigState DFlipFlop_Trig_ZCE;       /* '<S14>/D Flip-Flop' */
} ZCE_DFlipFlop_spiBitbang_comp_T;

/* Block signals (auto storage) */
typedef struct {
  real_T clk;                          /* '<S7>/conv1' */
  real_T gen_CS;                       /* '<S7>/Constant2' */
  real_T clk_delayed;                  /* '<S7>/Delay1' */
  uint16_T BitwiseOperator;            /* '<S47>/Bitwise Operator' */
  boolean_T interrupt;                 /* '<Root>/f_sck_OnOff' */
  boolean_T En16;                      /* '<S1>/and5' */
  boolean_T cast11;                    /* '<S1>/cast1 1' */
  boolean_T LogicalOperator;           /* '<S3>/Logical Operator' */
  boolean_T conv2;                     /* '<S7>/conv2' */
  boolean_T D;                         /* '<S11>/D' */
  boolean_T NSampleEnable;             /* '<Root>/N-Sample Enable' */
  boolean_T NSampleEnable_m;           /* '<S4>/N-Sample Enable' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_m;/* '<S28>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_h;/* '<S27>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_a;/* '<S26>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_g;/* '<S25>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_j;/* '<S24>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_l;/* '<S23>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_hh;/* '<S21>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_ht;/* '<S20>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_p;/* '<S19>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_gy;/* '<S18>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_as;/* '<S17>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_e;/* '<S16>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_o;/* '<S15>/D Flip-Flop' */
  B_DFlipFlop_spiBitbang_comple_T DFlipFlop_b;/* '<S14>/D Flip-Flop' */
} B_spiBitbang_complete_v2_2_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Delay1_DSTATE[6];             /* '<S7>/Delay1' */
  int32_T clockTickCounter;            /* '<S1>/f_sck' */
  int32_T clockTickCounter_c;          /* '<Root>/Start16BitRead' */
  int32_T clockTickCounter_n;          /* '<Root>/ResTimer ' */
  int32_T clockTickCounter_l;          /* '<Root>/ResTimer 1' */
  uint32_T f_sck_OnOff_Counter;        /* '<Root>/f_sck_OnOff' */
  uint32_T Counter_ClkEphState;        /* '<S1>/Counter' */
  uint32_T Counter_RstEphState;        /* '<S1>/Counter' */
  uint32_T NSampleEnable_Counter;      /* '<Root>/N-Sample Enable' */
  uint32_T NSampleEnable_Counter_o;    /* '<S4>/N-Sample Enable' */
  uint32_T Counter_ClkEphState_g;      /* '<S3>/Counter' */
  uint32_T Counter_RstEphState_m;      /* '<S3>/Counter' */
  uint16_T Output_DSTATE;              /* '<S49>/Output' */
  boolean_T UnitDelay_DSTATE;          /* '<S1>/Unit Delay' */
  uint8_T Counter_Count;               /* '<S1>/Counter' */
  uint8_T Counter_Count_o;             /* '<S3>/Counter' */
  boolean_T TmpLatchAtDFlipFlopInport1_Prev;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_g;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_m;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_o;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_n;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_k;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_gk;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_j;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_d;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_np;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_n0;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_ja;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_nq;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_h;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_oj;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_p;/* synthesized block */
  boolean_T DFlipFlop_MODE;            /* '<S10>/D Flip-Flop' */
  boolean_T TxSubsystem_MODE;          /* '<Root>/TxSubsystem' */
  boolean_T DFlipFlop_MODE_k;          /* '<S22>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_m;/* '<S28>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_h;/* '<S27>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_a;/* '<S26>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_g;/* '<S25>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_j;/* '<S24>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_l;/* '<S23>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_hh;/* '<S21>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_ht;/* '<S20>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_p;/* '<S19>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_gy;/* '<S18>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_as;/* '<S17>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_e;/* '<S16>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_o;/* '<S15>/D Flip-Flop' */
  DW_DFlipFlop_spiBitbang_compl_T DFlipFlop_b;/* '<S14>/D Flip-Flop' */
} DW_spiBitbang_complete_v2_2_T;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Delay1_Reset_ZCE;         /* '<S7>/Delay1' */
  ZCSigState Bitmask_Trig_ZCE;         /* '<S7>/Bitmask' */
  ZCSigState TriggeredSignalFromWorkspace_Tr;/* '<Root>/Triggered Signal From Workspace' */
  ZCSigState TriggeredToWorkspace_Trig_ZCE;/* '<S3>/Triggered To Workspace' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_m;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_h;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_a;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_g;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_j;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_l;/* '<S14>/D Flip-Flop' */
  ZCSigState DFlipFlop_Trig_ZCE_p;     /* '<S22>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_hh;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_ht;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_p;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_gy;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_as;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_e;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_o;/* '<S14>/D Flip-Flop' */
  ZCE_DFlipFlop_spiBitbang_comp_T DFlipFlop_b;/* '<S14>/D Flip-Flop' */
  ZCSigState DFlipFlop_Trig_ZCE_e;     /* '<S10>/D Flip-Flop' */
} PrevZCX_spiBitbang_complete_v_T;

/* Parameters for system: '<S14>/D Flip-Flop' */
struct P_DFlipFlop_spiBitbang_comple_T_ {
  boolean_T Q_Y0;                      /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S32>/Q'
                                        */
  boolean_T Q_Y0_a;                    /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S32>/!Q'
                                        */
};

/* Parameters (auto storage) */
struct P_spiBitbang_complete_v2_2_T_ {
  real_T Out_Y0;                       /* Expression: ic
                                        * Referenced by: '<S6>/Out'
                                        */
  real_T Constant_Value;               /* Expression: 0
                                        * Referenced by: '<S47>/Constant'
                                        */
  real_T cs_Y0;                        /* Expression: 1
                                        * Referenced by: '<S7>/cs'
                                        */
  real_T clk_delayed_Y0;               /* Expression: 0
                                        * Referenced by: '<S7>/clk_delayed'
                                        */
  real_T txSubShifts_Y0;               /* Expression: 0
                                        * Referenced by: '<S7>/txSubShifts'
                                        */
  real_T Constant1_Value;              /* Expression: 1
                                        * Referenced by: '<S7>/Constant1'
                                        */
  real_T Constant2_Value;              /* Expression: 1
                                        * Referenced by: '<S7>/Constant2'
                                        */
  real_T Delay1_InitialCondition;      /* Expression: 0
                                        * Referenced by: '<S7>/Delay1'
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
  real_T Constant_Value_a;             /* Expression: const
                                        * Referenced by: '<S9>/Constant'
                                        */
  real_T Constant_Value_j;             /* Expression: const
                                        * Referenced by: '<S8>/Constant'
                                        */
  real_T Start16BitRead_Amp;           /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Period;        /* Expression: 50000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Duty;          /* Expression: 20000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_PhaseDelay;    /* Expression: 100
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T stop1_Value;                  /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  real_T ResTimer_Amp;                 /* Expression: 1
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  real_T ResTimer_Period;              /* Expression: 1200
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  real_T ResTimer_Duty;                /* Expression: 50
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  real_T ResTimer_PhaseDelay;          /* Expression: 70
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  real_T ResTimer1_Amp;                /* Expression: 1
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  real_T ResTimer1_Period;             /* Expression: 100
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  real_T ResTimer1_Duty;               /* Expression: 80
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  real_T ResTimer1_PhaseDelay;         /* Expression: 0
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  uint32_T Delay1_DelayLength;         /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S7>/Delay1'
                                        */
  uint32_T f_sck_OnOff_TARGETCNT;      /* Computed Parameter: f_sck_OnOff_TARGETCNT
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  uint32_T f_sck_OnOff_ACTLEVEL;       /* Computed Parameter: f_sck_OnOff_ACTLEVEL
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  uint32_T NSampleEnable_TARGETCNT;    /* Computed Parameter: NSampleEnable_TARGETCNT
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_ACTLEVEL;     /* Computed Parameter: NSampleEnable_ACTLEVEL
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_TARGETCNT_k;  /* Computed Parameter: NSampleEnable_TARGETCNT_k
                                        * Referenced by: '<S4>/N-Sample Enable'
                                        */
  uint32_T NSampleEnable_ACTLEVEL_n;   /* Computed Parameter: NSampleEnable_ACTLEVEL_n
                                        * Referenced by: '<S4>/N-Sample Enable'
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
                                        * Referenced by: '<S47>/out'
                                        */
  uint16_T TxData_Value;               /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  uint16_T Constant_Value_p;           /* Computed Parameter: Constant_Value_p
                                        * Referenced by: '<S51>/Constant'
                                        */
  uint16_T Output_InitialCondition;    /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S49>/Output'
                                        */
  uint16_T Constant_Value_o;           /* Computed Parameter: Constant_Value_o
                                        * Referenced by: '<S48>/Constant'
                                        */
  uint16_T FixPtConstant_Value;        /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S50>/FixPt Constant'
                                        */
  uint16_T FixPtSwitch_Threshold;      /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S51>/FixPt Switch'
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
  uint8_T CSn_p4;                      /* Expression: pinName
                                        * Referenced by: '<Root>/CSn'
                                        */
  uint8_T MOSI_p4;                     /* Expression: pinName
                                        * Referenced by: '<Root>/MOSI'
                                        */
  uint8_T SCK_p4;                      /* Expression: pinName
                                        * Referenced by: '<Root>/SCK'
                                        */
  uint8_T Counter_InitialCount_h;      /* Computed Parameter: Counter_InitialCount_h
                                        * Referenced by: '<S3>/Counter'
                                        */
  uint8_T Counter_HitValue_n[5];       /* Computed Parameter: Counter_HitValue_n
                                        * Referenced by: '<S3>/Counter'
                                        */
  boolean_T Q_Y0;                      /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S11>/Q'
                                        */
  boolean_T Q_Y0_b;                    /* Computed Parameter: Q_Y0_b
                                        * Referenced by: '<S11>/!Q'
                                        */
  boolean_T Q_Y0_j;                    /* Computed Parameter: Q_Y0_j
                                        * Referenced by: '<S40>/Q'
                                        */
  boolean_T Q_Y0_i;                    /* Computed Parameter: Q_Y0_i
                                        * Referenced by: '<S40>/!Q'
                                        */
  boolean_T tx_Y0;                     /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S7>/tx'
                                        */
  boolean_T UnitDelay_InitialCondition;/* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  boolean_T TmpLatchAtDFlipFlopInport1_X0;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                           * Referenced by: synthesized block
                                           */
  boolean_T stop_Value;                /* Computed Parameter: stop_Value
                                        * Referenced by: '<Root>/stop'
                                        */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_l;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_l
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_j;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_j
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_a;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_a
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_h;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_h
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_g;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_g
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_e;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_e
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_n;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_n
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_jo;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_jo
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_gi;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_gi
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_jw;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_jw
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_b;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_b
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_p;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_p
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1__jwm;/* Computed Parameter: TmpLatchAtDFlipFlopInport1__jwm
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_f;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_f
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_h4;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_h4
                                             * Referenced by: synthesized block
                                             */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_m;/* '<S28>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_h;/* '<S27>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_a;/* '<S26>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_g;/* '<S25>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_j;/* '<S24>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_l;/* '<S23>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_hh;/* '<S21>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_ht;/* '<S20>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_p;/* '<S19>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_gy;/* '<S18>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_as;/* '<S17>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_e;/* '<S16>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_o;/* '<S15>/D Flip-Flop' */
  P_DFlipFlop_spiBitbang_comple_T DFlipFlop_b;/* '<S14>/D Flip-Flop' */
};

/* Real-time Model Data Structure */
struct tag_RTM_spiBitbang_complete_v_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (auto storage) */
extern P_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_P;

/* Block signals (auto storage) */
extern B_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_B;

/* Block states (auto storage) */
extern DW_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_DW;

/* Model entry point functions */
extern void spiBitbang_complete_v2_2_initialize(void);
extern void spiBitbang_complete_v2_2_output(void);
extern void spiBitbang_complete_v2_2_update(void);
extern void spiBitbang_complete_v2_2_terminate(void);

/* Real-time Model object */
extern RT_MODEL_spiBitbang_complete__T *const spiBitbang_complete_v2_2_M;

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
 * '<Root>' : 'spiBitbang_complete_v2_2'
 * '<S1>'   : 'spiBitbang_complete_v2_2/Clock Gen'
 * '<S2>'   : 'spiBitbang_complete_v2_2/Compare To Constant'
 * '<S3>'   : 'spiBitbang_complete_v2_2/RxSubsystem'
 * '<S4>'   : 'spiBitbang_complete_v2_2/Transmiss Toggle'
 * '<S5>'   : 'spiBitbang_complete_v2_2/Triggered To Workspace2'
 * '<S6>'   : 'spiBitbang_complete_v2_2/Triggered Signal From Workspace'
 * '<S7>'   : 'spiBitbang_complete_v2_2/TxSubsystem'
 * '<S8>'   : 'spiBitbang_complete_v2_2/Clock Gen/Comp1'
 * '<S9>'   : 'spiBitbang_complete_v2_2/Clock Gen/Comp2'
 * '<S10>'  : 'spiBitbang_complete_v2_2/Clock Gen/D Flip-Flop1'
 * '<S11>'  : 'spiBitbang_complete_v2_2/Clock Gen/D Flip-Flop1/D Flip-Flop'
 * '<S12>'  : 'spiBitbang_complete_v2_2/RxSubsystem/!RES'
 * '<S13>'  : 'spiBitbang_complete_v2_2/RxSubsystem/Clk'
 * '<S14>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop10'
 * '<S15>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop11'
 * '<S16>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop12'
 * '<S17>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop13'
 * '<S18>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop14'
 * '<S19>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop15'
 * '<S20>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop16'
 * '<S21>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop17'
 * '<S22>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop18'
 * '<S23>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop19'
 * '<S24>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop20'
 * '<S25>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop6'
 * '<S26>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop7'
 * '<S27>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop8'
 * '<S28>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop9'
 * '<S29>'  : 'spiBitbang_complete_v2_2/RxSubsystem/DataIn'
 * '<S30>'  : 'spiBitbang_complete_v2_2/RxSubsystem/Triggered To Workspace'
 * '<S31>'  : 'spiBitbang_complete_v2_2/RxSubsystem/Triggered To Workspace1'
 * '<S32>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop10/D Flip-Flop'
 * '<S33>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop11/D Flip-Flop'
 * '<S34>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop12/D Flip-Flop'
 * '<S35>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop13/D Flip-Flop'
 * '<S36>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop14/D Flip-Flop'
 * '<S37>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop15/D Flip-Flop'
 * '<S38>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop16/D Flip-Flop'
 * '<S39>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop17/D Flip-Flop'
 * '<S40>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop18/D Flip-Flop'
 * '<S41>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop19/D Flip-Flop'
 * '<S42>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop20/D Flip-Flop'
 * '<S43>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop6/D Flip-Flop'
 * '<S44>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop7/D Flip-Flop'
 * '<S45>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop8/D Flip-Flop'
 * '<S46>'  : 'spiBitbang_complete_v2_2/RxSubsystem/D Flip-Flop9/D Flip-Flop'
 * '<S47>'  : 'spiBitbang_complete_v2_2/TxSubsystem/Bitmask'
 * '<S48>'  : 'spiBitbang_complete_v2_2/TxSubsystem/Bitmask/Compare To Constant'
 * '<S49>'  : 'spiBitbang_complete_v2_2/TxSubsystem/Bitmask/Counter Free-Running'
 * '<S50>'  : 'spiBitbang_complete_v2_2/TxSubsystem/Bitmask/Counter Free-Running/Increment Real World'
 * '<S51>'  : 'spiBitbang_complete_v2_2/TxSubsystem/Bitmask/Counter Free-Running/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_spiBitbang_complete_v2_2_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
