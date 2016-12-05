/*
 * File: test.h
 *
 * Code generated for Simulink model 'test'.
 *
 * Model version                  : 1.2
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Thu Apr 24 11:32:24 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_test_h_
#define RTW_HEADER_test_h_
#ifndef test_COMMON_INCLUDES_
# define test_COMMON_INCLUDES_
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
#endif                                 /* test_COMMON_INCLUDES_ */

#include "test_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block signals for system '<S10>/D Flip-Flop' */
typedef struct {
  boolean_T D;                         /* '<S27>/D' */
} B_DFlipFlop_test_T;

/* Block states (auto storage) for system '<S10>/D Flip-Flop' */
typedef struct {
  boolean_T DFlipFlop_MODE;            /* '<S10>/D Flip-Flop' */
} DW_DFlipFlop_test_T;

/* Zero-crossing (trigger) state for system '<S10>/D Flip-Flop' */
typedef struct {
  ZCSigState DFlipFlop_Trig_ZCE;       /* '<S10>/D Flip-Flop' */
} ZCE_DFlipFlop_test_T;

/* Block signals (auto storage) */
typedef struct {
  real_T clk;                          /* '<S3>/conv1' */
  real_T gen_CS;                       /* '<S3>/Constant2' */
  real_T clk_delayed;                  /* '<S3>/Delay1' */
  uint16_T BitwiseOperator;            /* '<S42>/Bitwise Operator' */
  boolean_T En16;                      /* '<S1>/and5' */
  boolean_T cast11;                    /* '<S1>/cast1 1' */
  boolean_T LogicalOperator1;          /* '<S2>/Logical Operator1' */
  boolean_T conv2;                     /* '<S3>/conv2' */
  boolean_T D;                         /* '<S7>/D' */
  B_DFlipFlop_test_T DFlipFlop_i;      /* '<S24>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_k;      /* '<S23>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_o;      /* '<S22>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_a;      /* '<S21>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_c;      /* '<S20>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_j;      /* '<S19>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_og;     /* '<S17>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_n;      /* '<S16>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_b;      /* '<S15>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_je;     /* '<S14>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_d;      /* '<S13>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_k2;     /* '<S12>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_kr;     /* '<S11>/D Flip-Flop' */
  B_DFlipFlop_test_T DFlipFlop_ir;     /* '<S10>/D Flip-Flop' */
} B_test_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T Delay1_DSTATE[6];             /* '<S3>/Delay1' */
  int32_T clockTickCounter;            /* '<S1>/f_sck' */
  int32_T clockTickCounter_f;          /* '<Root>/Start16BitRead' */
  int32_T clockTickCounter_j;          /* '<Root>/ResTimer ' */
  uint32_T Counter_ClkEphState;        /* '<S1>/Counter' */
  uint32_T Counter_RstEphState;        /* '<S1>/Counter' */
  uint32_T Counter_ClkEphState_l;      /* '<S2>/Counter' */
  uint32_T Counter_RstEphState_j;      /* '<S2>/Counter' */
  uint16_T Output_DSTATE;              /* '<S44>/Output' */
  boolean_T UnitDelay_DSTATE;          /* '<S1>/Unit Delay' */
  uint8_T Counter_Count;               /* '<S1>/Counter' */
  uint8_T Counter_Count_f;             /* '<S2>/Counter' */
  boolean_T TmpLatchAtDFlipFlopInport1_Prev;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_g;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_m;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_n;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_e;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_nx;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_mf;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_l;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_k;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_ln;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_P_km;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_j;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_p;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_i;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_o;/* synthesized block */
  boolean_T TmpLatchAtDFlipFlopInport1_Pr_b;/* synthesized block */
  boolean_T DFlipFlop_MODE;            /* '<S6>/D Flip-Flop' */
  boolean_T TxSubsystem_MODE;          /* '<Root>/TxSubsystem' */
  boolean_T DFlipFlop_MODE_i;          /* '<S18>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_i;     /* '<S24>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_k;     /* '<S23>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_o;     /* '<S22>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_a;     /* '<S21>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_c;     /* '<S20>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_j;     /* '<S19>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_og;    /* '<S17>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_n;     /* '<S16>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_b;     /* '<S15>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_je;    /* '<S14>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_d;     /* '<S13>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_k2;    /* '<S12>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_kr;    /* '<S11>/D Flip-Flop' */
  DW_DFlipFlop_test_T DFlipFlop_ir;    /* '<S10>/D Flip-Flop' */
} DW_test_T;

/* Zero-crossing (trigger) state */
typedef struct {
  ZCSigState Delay1_Reset_ZCE;         /* '<S3>/Delay1' */
  ZCSigState Bitmask_Trig_ZCE;         /* '<S3>/Bitmask' */
  ZCSigState TriggeredToWorkspace_Trig_ZCE;/* '<S2>/Triggered To Workspace' */
  ZCE_DFlipFlop_test_T DFlipFlop_i;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_k;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_o;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_a;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_c;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_j;    /* '<S10>/D Flip-Flop' */
  ZCSigState DFlipFlop_Trig_ZCE_c;     /* '<S18>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_og;   /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_n;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_b;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_je;   /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_d;    /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_k2;   /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_kr;   /* '<S10>/D Flip-Flop' */
  ZCE_DFlipFlop_test_T DFlipFlop_ir;   /* '<S10>/D Flip-Flop' */
  ZCSigState DFlipFlop_Trig_ZCE_l;     /* '<S6>/D Flip-Flop' */
} PrevZCX_test_T;

/* Parameters for system: '<S10>/D Flip-Flop' */
struct P_DFlipFlop_test_T_ {
  boolean_T Q_Y0;                      /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S27>/Q'
                                        */
  boolean_T Q_Y0_n;                    /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S27>/!Q'
                                        */
};

/* Parameters (auto storage) */
struct P_test_T_ {
  real_T Constant_Value;               /* Expression: 0
                                        * Referenced by: '<S42>/Constant'
                                        */
  real_T cs_Y0;                        /* Expression: 1
                                        * Referenced by: '<S3>/cs'
                                        */
  real_T clk_delayed_Y0;               /* Expression: 0
                                        * Referenced by: '<S3>/clk_delayed'
                                        */
  real_T txSubShifts_Y0;               /* Expression: 0
                                        * Referenced by: '<S3>/txSubShifts'
                                        */
  real_T Constant1_Value;              /* Expression: 1
                                        * Referenced by: '<S3>/Constant1'
                                        */
  real_T Constant2_Value;              /* Expression: 1
                                        * Referenced by: '<S3>/Constant2'
                                        */
  real_T Delay1_InitialCondition;      /* Expression: 0
                                        * Referenced by: '<S3>/Delay1'
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
  real_T Constant_Value_c;             /* Expression: const
                                        * Referenced by: '<S5>/Constant'
                                        */
  real_T Constant_Value_l;             /* Expression: const
                                        * Referenced by: '<S4>/Constant'
                                        */
  real_T Start16BitRead_Amp;           /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Period;        /* Expression: 1000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_Duty;          /* Expression: 20
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T Start16BitRead_PhaseDelay;    /* Expression: 10
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  real_T delay1_Value;                 /* Expression: 1
                                        * Referenced by: '<Root>/delay1'
                                        */
  real_T stop1_Value;                  /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  real_T Switch_Threshold;             /* Expression: 0.5
                                        * Referenced by: '<Root>/Switch'
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
  uint32_T Delay1_DelayLength;         /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S3>/Delay1'
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
                                        * Referenced by: '<S42>/out'
                                        */
  uint16_T TxData_Value;               /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  uint16_T Constant_Value_d;           /* Computed Parameter: Constant_Value_d
                                        * Referenced by: '<S46>/Constant'
                                        */
  uint16_T Output_InitialCondition;    /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S44>/Output'
                                        */
  uint16_T Constant_Value_e;           /* Computed Parameter: Constant_Value_e
                                        * Referenced by: '<S43>/Constant'
                                        */
  uint16_T FixPtConstant_Value;        /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S45>/FixPt Constant'
                                        */
  uint16_T FixPtSwitch_Threshold;      /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S46>/FixPt Switch'
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
  uint8_T Counter_InitialCount_p;      /* Computed Parameter: Counter_InitialCount_p
                                        * Referenced by: '<S2>/Counter'
                                        */
  uint8_T Counter_HitValue_n[5];       /* Computed Parameter: Counter_HitValue_n
                                        * Referenced by: '<S2>/Counter'
                                        */
  boolean_T Q_Y0;                      /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S7>/Q'
                                        */
  boolean_T Q_Y0_k;                    /* Computed Parameter: Q_Y0_k
                                        * Referenced by: '<S7>/!Q'
                                        */
  boolean_T Q_Y0_e;                    /* Computed Parameter: Q_Y0_e
                                        * Referenced by: '<S35>/Q'
                                        */
  boolean_T Q_Y0_f;                    /* Computed Parameter: Q_Y0_f
                                        * Referenced by: '<S35>/!Q'
                                        */
  boolean_T tx_Y0;                     /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S3>/tx'
                                        */
  boolean_T UnitDelay_InitialCondition;/* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  boolean_T TmpLatchAtDFlipFlopInport1_X0;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                           * Referenced by: synthesized block
                                           */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_d;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_d
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_dc;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_dc
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_i;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_i
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_b;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_b
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_k;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_k
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_a;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_a
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_f;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_f
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_fu;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_fu
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_j;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_j
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_p;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_p
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_kg;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_kg
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X0_l;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_l
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_li;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_li
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_ia;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_ia
                                             * Referenced by: synthesized block
                                             */
  boolean_T TmpLatchAtDFlipFlopInport1_X_iz;/* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_iz
                                             * Referenced by: synthesized block
                                             */
  P_DFlipFlop_test_T DFlipFlop_i;      /* '<S24>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_k;      /* '<S23>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_o;      /* '<S22>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_a;      /* '<S21>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_c;      /* '<S20>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_j;      /* '<S19>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_og;     /* '<S17>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_n;      /* '<S16>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_b;      /* '<S15>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_je;     /* '<S14>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_d;      /* '<S13>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_k2;     /* '<S12>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_kr;     /* '<S11>/D Flip-Flop' */
  P_DFlipFlop_test_T DFlipFlop_ir;     /* '<S10>/D Flip-Flop' */
};

/* Real-time Model Data Structure */
struct tag_RTM_test_T {
  const char_T * volatile errorStatus;
};

/* Block parameters (auto storage) */
extern P_test_T test_P;

/* Block signals (auto storage) */
extern B_test_T test_B;

/* Block states (auto storage) */
extern DW_test_T test_DW;

/* Model entry point functions */
extern void test_initialize(void);
extern void test_output(void);
extern void test_update(void);
extern void test_terminate(void);

/* Real-time Model object */
extern RT_MODEL_test_T *const test_M;

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
 * '<Root>' : 'test'
 * '<S1>'   : 'test/Clock Gen'
 * '<S2>'   : 'test/Subsystem'
 * '<S3>'   : 'test/TxSubsystem'
 * '<S4>'   : 'test/Clock Gen/Comp1'
 * '<S5>'   : 'test/Clock Gen/Comp2'
 * '<S6>'   : 'test/Clock Gen/D Flip-Flop1'
 * '<S7>'   : 'test/Clock Gen/D Flip-Flop1/D Flip-Flop'
 * '<S8>'   : 'test/Subsystem/!RES'
 * '<S9>'   : 'test/Subsystem/Clk'
 * '<S10>'  : 'test/Subsystem/D Flip-Flop10'
 * '<S11>'  : 'test/Subsystem/D Flip-Flop11'
 * '<S12>'  : 'test/Subsystem/D Flip-Flop12'
 * '<S13>'  : 'test/Subsystem/D Flip-Flop13'
 * '<S14>'  : 'test/Subsystem/D Flip-Flop14'
 * '<S15>'  : 'test/Subsystem/D Flip-Flop15'
 * '<S16>'  : 'test/Subsystem/D Flip-Flop16'
 * '<S17>'  : 'test/Subsystem/D Flip-Flop17'
 * '<S18>'  : 'test/Subsystem/D Flip-Flop18'
 * '<S19>'  : 'test/Subsystem/D Flip-Flop19'
 * '<S20>'  : 'test/Subsystem/D Flip-Flop20'
 * '<S21>'  : 'test/Subsystem/D Flip-Flop6'
 * '<S22>'  : 'test/Subsystem/D Flip-Flop7'
 * '<S23>'  : 'test/Subsystem/D Flip-Flop8'
 * '<S24>'  : 'test/Subsystem/D Flip-Flop9'
 * '<S25>'  : 'test/Subsystem/DataIn'
 * '<S26>'  : 'test/Subsystem/Triggered To Workspace'
 * '<S27>'  : 'test/Subsystem/D Flip-Flop10/D Flip-Flop'
 * '<S28>'  : 'test/Subsystem/D Flip-Flop11/D Flip-Flop'
 * '<S29>'  : 'test/Subsystem/D Flip-Flop12/D Flip-Flop'
 * '<S30>'  : 'test/Subsystem/D Flip-Flop13/D Flip-Flop'
 * '<S31>'  : 'test/Subsystem/D Flip-Flop14/D Flip-Flop'
 * '<S32>'  : 'test/Subsystem/D Flip-Flop15/D Flip-Flop'
 * '<S33>'  : 'test/Subsystem/D Flip-Flop16/D Flip-Flop'
 * '<S34>'  : 'test/Subsystem/D Flip-Flop17/D Flip-Flop'
 * '<S35>'  : 'test/Subsystem/D Flip-Flop18/D Flip-Flop'
 * '<S36>'  : 'test/Subsystem/D Flip-Flop19/D Flip-Flop'
 * '<S37>'  : 'test/Subsystem/D Flip-Flop20/D Flip-Flop'
 * '<S38>'  : 'test/Subsystem/D Flip-Flop6/D Flip-Flop'
 * '<S39>'  : 'test/Subsystem/D Flip-Flop7/D Flip-Flop'
 * '<S40>'  : 'test/Subsystem/D Flip-Flop8/D Flip-Flop'
 * '<S41>'  : 'test/Subsystem/D Flip-Flop9/D Flip-Flop'
 * '<S42>'  : 'test/TxSubsystem/Bitmask'
 * '<S43>'  : 'test/TxSubsystem/Bitmask/Compare To Constant'
 * '<S44>'  : 'test/TxSubsystem/Bitmask/Counter Free-Running'
 * '<S45>'  : 'test/TxSubsystem/Bitmask/Counter Free-Running/Increment Real World'
 * '<S46>'  : 'test/TxSubsystem/Bitmask/Counter Free-Running/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_test_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
