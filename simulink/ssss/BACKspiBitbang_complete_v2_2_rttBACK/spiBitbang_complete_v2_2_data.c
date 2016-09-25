/*
 * File: spiBitbang_complete_v2_2_data.c
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

#include "spiBitbang_complete_v2_2.h"
#include "spiBitbang_complete_v2_2_private.h"

/* Block parameters (auto storage) */
P_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_P = {
  0.0,                                 /* Expression: ic
                                        * Referenced by: '<S6>/Out'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S47>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/cs'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S7>/clk_delayed'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S7>/txSubShifts'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/Constant1'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S7>/Constant2'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S7>/Delay1'
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
  0.0,                                 /* Expression: const
                                        * Referenced by: '<S9>/Constant'
                                        */
  16.0,                                /* Expression: const
                                        * Referenced by: '<S8>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  50000.0,                             /* Expression: 50000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  20000.0,                             /* Expression: 20000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  100.0,                               /* Expression: 100
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  1200.0,                              /* Expression: 1200
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  50.0,                                /* Expression: 50
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  70.0,                                /* Expression: 70
                                        * Referenced by: '<Root>/ResTimer '
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  100.0,                               /* Expression: 100
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  80.0,                                /* Expression: 80
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/ResTimer 1'
                                        */
  6U,                                  /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S7>/Delay1'
                                        */
  1U,                                  /* Computed Parameter: f_sck_OnOff_TARGETCNT
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  1U,                                  /* Computed Parameter: f_sck_OnOff_ACTLEVEL
                                        * Referenced by: '<Root>/f_sck_OnOff'
                                        */
  70U,                                 /* Computed Parameter: NSampleEnable_TARGETCNT
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  1U,                                  /* Computed Parameter: NSampleEnable_ACTLEVEL
                                        * Referenced by: '<Root>/N-Sample Enable'
                                        */
  300U,                                /* Computed Parameter: NSampleEnable_TARGETCNT_k
                                        * Referenced by: '<S4>/N-Sample Enable'
                                        */
  2U,                                  /* Computed Parameter: NSampleEnable_ACTLEVEL_n
                                        * Referenced by: '<S4>/N-Sample Enable'
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
                                        * Referenced by: '<S47>/out'
                                        */
  4369U,                               /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_p
                                        * Referenced by: '<S51>/Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S49>/Output'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_o
                                        * Referenced by: '<S48>/Constant'
                                        */
  1U,                                  /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S50>/FixPt Constant'
                                        */
  16383U,                              /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S51>/FixPt Switch'
                                        */
  1U,                                  /* Computed Parameter: TransmitCommand_CurrentSetting
                                        * Referenced by: '<Root>/Transmit Command'
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
  0U,                                  /* Computed Parameter: Counter_InitialCount_h
                                        * Referenced by: '<S3>/Counter'
                                        */

  /*  Computed Parameter: Counter_HitValue_n
   * Referenced by: '<S3>/Counter'
   */
  { 15U, 16U, 30U, 31U, 32U },
  0,                                   /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S11>/Q'
                                        */
  1,                                   /* Computed Parameter: Q_Y0_b
                                        * Referenced by: '<S11>/!Q'
                                        */
  0,                                   /* Computed Parameter: Q_Y0_j
                                        * Referenced by: '<S40>/Q'
                                        */
  1,                                   /* Computed Parameter: Q_Y0_i
                                        * Referenced by: '<S40>/!Q'
                                        */
  0,                                   /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S7>/tx'
                                        */
  0,                                   /* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: stop_Value
                                        * Referenced by: '<Root>/stop'
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_l
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_j
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_a
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_h
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_g
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_e
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_n
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_jo
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_gi
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_jw
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_b
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_p
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1__jwm
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_f
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_h4
                                        * Referenced by: synthesized block
                                        */

  /* Start of '<S28>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S46>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S46>/!Q'
                                        */
  }
  /* End of '<S28>/D Flip-Flop' */
  ,

  /* Start of '<S27>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S45>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S45>/!Q'
                                        */
  }
  /* End of '<S27>/D Flip-Flop' */
  ,

  /* Start of '<S26>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S44>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S44>/!Q'
                                        */
  }
  /* End of '<S26>/D Flip-Flop' */
  ,

  /* Start of '<S25>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S43>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S43>/!Q'
                                        */
  }
  /* End of '<S25>/D Flip-Flop' */
  ,

  /* Start of '<S24>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S42>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S42>/!Q'
                                        */
  }
  /* End of '<S24>/D Flip-Flop' */
  ,

  /* Start of '<S23>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S41>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S41>/!Q'
                                        */
  }
  /* End of '<S23>/D Flip-Flop' */
  ,

  /* Start of '<S21>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S39>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S39>/!Q'
                                        */
  }
  /* End of '<S21>/D Flip-Flop' */
  ,

  /* Start of '<S20>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S38>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S38>/!Q'
                                        */
  }
  /* End of '<S20>/D Flip-Flop' */
  ,

  /* Start of '<S19>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S37>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S37>/!Q'
                                        */
  }
  /* End of '<S19>/D Flip-Flop' */
  ,

  /* Start of '<S18>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S36>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S36>/!Q'
                                        */
  }
  /* End of '<S18>/D Flip-Flop' */
  ,

  /* Start of '<S17>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S35>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S35>/!Q'
                                        */
  }
  /* End of '<S17>/D Flip-Flop' */
  ,

  /* Start of '<S16>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S34>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S34>/!Q'
                                        */
  }
  /* End of '<S16>/D Flip-Flop' */
  ,

  /* Start of '<S15>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S33>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S33>/!Q'
                                        */
  }
  /* End of '<S15>/D Flip-Flop' */
  ,

  /* Start of '<S14>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S32>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_a
                                        * Referenced by: '<S32>/!Q'
                                        */
  }
  /* End of '<S14>/D Flip-Flop' */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
