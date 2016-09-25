/*
 * spiBitbang_MainClockDistr_v2_data.c
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
#include "spiBitbang_MainClockDistr_v2.h"
#include "spiBitbang_MainClockDistr_v2_private.h"

/* Block parameters (auto storage) */
P_spiBitbang_MainClockDistr_v_T spiBitbang_MainClockDistr_v2_P = {
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S12>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/cs'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/clk_delayed'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/Constant1'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S7>/initial'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
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
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  400.0,                               /* Expression: 400
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  35.0,                                /* Expression: 35
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  20.0,                                /* Expression: 20
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  0.0,                                 /* Expression: const
                                        * Referenced by: '<S8>/Constant'
                                        */

  /*  Expression: [0 1 2 3]*1.1
   * Referenced by: '<Root>/stop3'
   */
  { 0.0, 1.1, 2.2, 3.3000000000000003 },
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  100.0,                               /* Expression: 100
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  50.0,                                /* Expression: 50
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/Start16BitRead1'
                                        */
  20U,                                 /* Computed Parameter: NSampleEnable_TARGETCNT
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  1U,                                  /* Computed Parameter: NSampleEnable_ACTLEVEL
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  900U,                                /* Computed Parameter: NSampleEnable_TARGETCNT_k
                                        * Referenced by: '<S6>/N-Sample Enable'
                                        */
  2U,                                  /* Computed Parameter: NSampleEnable_ACTLEVEL_n
                                        * Referenced by: '<S6>/N-Sample Enable'
                                        */
  1U,                                  /* Computed Parameter: f_sck_OnOff_TARGETCNT
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  1U,                                  /* Computed Parameter: f_sck_OnOff_ACTLEVEL
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  1U,                                  /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S7>/tx'
                                        */
  52995U,                              /* Computed Parameter: stop2_Value
                                        * Referenced by: '<Root>/stop2'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_p
                                        * Referenced by: '<S17>/Constant'
                                        */
  1U,                                  /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S16>/FixPt Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S15>/Output'
                                        */
  32767U,                              /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S17>/FixPt Switch'
                                        */
  0U,                                  /* Computed Parameter: TransmitCommand_CurrentSetting
                                        * Referenced by: '<Root>/Transmit Command'
                                        */
  0U,                                  /* Computed Parameter: Counter_InitialCount
                                        * Referenced by: '<S1>/Counter'
                                        */
  5U,                                  /* Computed Parameter: Counter_HitValue
                                        * Referenced by: '<S1>/Counter'
                                        */
  0,                                   /* Computed Parameter: stop_Value
                                        * Referenced by: '<Root>/stop'
                                        */
  0,                                   /* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_p3
                                        * Referenced by: '<S11>/Constant'
                                        */
  1U,                                  /* Computed Parameter: FixPtConstant_Value_d
                                        * Referenced by: '<S10>/FixPt Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition_h
                                        * Referenced by: '<S9>/Output'
                                        */
  7U                                   /* Computed Parameter: FixPtSwitch_Threshold_a
                                        * Referenced by: '<S11>/FixPt Switch'
                                        */
};
