/*
 * File: shiftregisterTut_v2_4_pi_data.c
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

#include "shiftregisterTut_v2_4_pi.h"
#include "shiftregisterTut_v2_4_pi_private.h"

/* Block parameters (auto storage) */
P_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_P = {
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S14>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S5>/sh_ctr'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S5>/Constant1'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S1>/f_sck'
                                        */
  20.0,                                /* Expression: periSam
                                        * Referenced by: '<S1>/f_sck'
                                        */
  10.0,                                /* Expression: periSam/2
                                        * Referenced by: '<S1>/f_sck'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S1>/f_sck'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/stop2'
                                        */
  0.0,                                 /* Expression: const
                                        * Referenced by: '<S7>/Constant'
                                        */
  16.0,                                /* Expression: const
                                        * Referenced by: '<S6>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  3000.0,                              /* Expression: 3000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  1000.0,                              /* Expression: 1000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  10.0,                                /* Expression: 10
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/delay1'
                                        */
  0.5,                                 /* Expression: 0.5
                                        * Referenced by: '<Root>/Switch'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S2>/Unit Delay'
                                        */
  16.0,                                /* Expression: const
                                        * Referenced by: '<S10>/Constant'
                                        */
  6U,                                  /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S5>/Delay1'
                                        */
  8U,                                  /* Computed Parameter: CSn_p1
                                        * Referenced by: '<Root>/CSn'
                                        */
  2U,                                  /* Computed Parameter: CSn_p2
                                        * Referenced by: '<Root>/CSn'
                                        */
  255U,                                /* Computed Parameter: CSn_p3
                                        * Referenced by: '<Root>/CSn'
                                        */
  10U,                                 /* Computed Parameter: MOSI_p1
                                        * Referenced by: '<Root>/MOSI'
                                        */
  2U,                                  /* Computed Parameter: MOSI_p2
                                        * Referenced by: '<Root>/MOSI'
                                        */
  255U,                                /* Computed Parameter: MOSI_p3
                                        * Referenced by: '<Root>/MOSI'
                                        */
  11U,                                 /* Computed Parameter: SCK_p1
                                        * Referenced by: '<Root>/SCK'
                                        */
  2U,                                  /* Computed Parameter: SCK_p2
                                        * Referenced by: '<Root>/SCK'
                                        */
  255U,                                /* Computed Parameter: SCK_p3
                                        * Referenced by: '<Root>/SCK'
                                        */
  1U,                                  /* Computed Parameter: out_Y0
                                        * Referenced by: '<S14>/out'
                                        */
  43605U,                              /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_f
                                        * Referenced by: '<S18>/Constant'
                                        */
  1U,                                  /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S17>/FixPt Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S16>/Output'
                                        */
  16383U,                              /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S18>/FixPt Switch'
                                        */
  0U,                                  /* Computed Parameter: Counter_InitialCount
                                        * Referenced by: '<S1>/Counter'
                                        */
  5U,                                  /* Computed Parameter: Counter_HitValue
                                        * Referenced by: '<S1>/Counter'
                                        */
  0U,                                  /* Expression: pinName
                                        * Referenced by: '<Root>/CSn'
                                        */
  0U,                                  /* Expression: pinName
                                        * Referenced by: '<Root>/MOSI'
                                        */
  0U,                                  /* Expression: pinName
                                        * Referenced by: '<Root>/SCK'
                                        */
  0U,                                  /* Computed Parameter: ManualSwitch_CurrentSetting
                                        * Referenced by: '<Root>/Manual Switch'
                                        */
  0U,                                  /* Computed Parameter: Counter_InitialCount_n
                                        * Referenced by: '<S2>/Counter'
                                        */
  15U,                                 /* Computed Parameter: Counter_HitValue_a
                                        * Referenced by: '<S2>/Counter'
                                        */
  0,                                   /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S9>/Q'
                                        */
  1,                                   /* Computed Parameter: Q_Y0_l
                                        * Referenced by: '<S9>/!Q'
                                        */
  0,                                   /* Computed Parameter: clk_delayed_Y0
                                        * Referenced by: '<S5>/clk_delayed'
                                        */
  1,                                   /* Computed Parameter: cs_Y0
                                        * Referenced by: '<S5>/cs'
                                        */
  1,                                   /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S5>/tx'
                                        */
  1,                                   /* Computed Parameter: Constant2_Value
                                        * Referenced by: '<S5>/Constant2'
                                        */
  0,                                   /* Computed Parameter: Delay1_InitialCondition
                                        * Referenced by: '<S5>/Delay1'
                                        */
  0,                                   /* Computed Parameter: UnitDelay_InitialCondition_o
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  0                                    /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                        * Referenced by: synthesized block
                                        */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
