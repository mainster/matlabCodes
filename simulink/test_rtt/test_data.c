/*
 * File: test_data.c
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

#include "test.h"
#include "test_private.h"

/* Block parameters (auto storage) */
P_test_T test_P = {
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S42>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S3>/cs'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S3>/clk_delayed'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S3>/txSubShifts'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S3>/Constant1'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<S3>/Constant2'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S3>/Delay1'
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
                                        * Referenced by: '<S5>/Constant'
                                        */
  16.0,                                /* Expression: const
                                        * Referenced by: '<S4>/Constant'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  1000.0,                              /* Expression: 1000
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  20.0,                                /* Expression: 20
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  10.0,                                /* Expression: 10
                                        * Referenced by: '<Root>/Start16BitRead'
                                        */
  1.0,                                 /* Expression: 1
                                        * Referenced by: '<Root>/delay1'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<Root>/stop1'
                                        */
  0.5,                                 /* Expression: 0.5
                                        * Referenced by: '<Root>/Switch'
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
  6U,                                  /* Computed Parameter: Delay1_DelayLength
                                        * Referenced by: '<S3>/Delay1'
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
                                        * Referenced by: '<S42>/out'
                                        */
  43605U,                              /* Computed Parameter: TxData_Value
                                        * Referenced by: '<Root>/TxData'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_d
                                        * Referenced by: '<S46>/Constant'
                                        */
  0U,                                  /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S44>/Output'
                                        */
  0U,                                  /* Computed Parameter: Constant_Value_e
                                        * Referenced by: '<S43>/Constant'
                                        */
  1U,                                  /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S45>/FixPt Constant'
                                        */
  16383U,                              /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S46>/FixPt Switch'
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
  0U,                                  /* Computed Parameter: Counter_InitialCount_p
                                        * Referenced by: '<S2>/Counter'
                                        */

  /*  Computed Parameter: Counter_HitValue_n
   * Referenced by: '<S2>/Counter'
   */
  { 15U, 16U, 30U, 31U, 32U },
  0,                                   /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S7>/Q'
                                        */
  1,                                   /* Computed Parameter: Q_Y0_k
                                        * Referenced by: '<S7>/!Q'
                                        */
  0,                                   /* Computed Parameter: Q_Y0_e
                                        * Referenced by: '<S35>/Q'
                                        */
  1,                                   /* Computed Parameter: Q_Y0_f
                                        * Referenced by: '<S35>/!Q'
                                        */
  0,                                   /* Computed Parameter: tx_Y0
                                        * Referenced by: '<S3>/tx'
                                        */
  0,                                   /* Computed Parameter: UnitDelay_InitialCondition
                                        * Referenced by: '<S1>/Unit Delay'
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_d
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_dc
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_i
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_b
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_k
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_a
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_f
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_fu
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_j
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_p
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_kg
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X0_l
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_li
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_ia
                                        * Referenced by: synthesized block
                                        */
  0,                                   /* Computed Parameter: TmpLatchAtDFlipFlopInport1_X_iz
                                        * Referenced by: synthesized block
                                        */

  /* Start of '<S24>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S41>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S41>/!Q'
                                        */
  }
  /* End of '<S24>/D Flip-Flop' */
  ,

  /* Start of '<S23>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S40>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S40>/!Q'
                                        */
  }
  /* End of '<S23>/D Flip-Flop' */
  ,

  /* Start of '<S22>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S39>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S39>/!Q'
                                        */
  }
  /* End of '<S22>/D Flip-Flop' */
  ,

  /* Start of '<S21>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S38>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S38>/!Q'
                                        */
  }
  /* End of '<S21>/D Flip-Flop' */
  ,

  /* Start of '<S20>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S37>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S37>/!Q'
                                        */
  }
  /* End of '<S20>/D Flip-Flop' */
  ,

  /* Start of '<S19>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S36>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S36>/!Q'
                                        */
  }
  /* End of '<S19>/D Flip-Flop' */
  ,

  /* Start of '<S17>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S34>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S34>/!Q'
                                        */
  }
  /* End of '<S17>/D Flip-Flop' */
  ,

  /* Start of '<S16>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S33>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S33>/!Q'
                                        */
  }
  /* End of '<S16>/D Flip-Flop' */
  ,

  /* Start of '<S15>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S32>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S32>/!Q'
                                        */
  }
  /* End of '<S15>/D Flip-Flop' */
  ,

  /* Start of '<S14>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S31>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S31>/!Q'
                                        */
  }
  /* End of '<S14>/D Flip-Flop' */
  ,

  /* Start of '<S13>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S30>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S30>/!Q'
                                        */
  }
  /* End of '<S13>/D Flip-Flop' */
  ,

  /* Start of '<S12>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S29>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S29>/!Q'
                                        */
  }
  /* End of '<S12>/D Flip-Flop' */
  ,

  /* Start of '<S11>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S28>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S28>/!Q'
                                        */
  }
  /* End of '<S11>/D Flip-Flop' */
  ,

  /* Start of '<S10>/D Flip-Flop' */
  {
    0,                                 /* Computed Parameter: Q_Y0
                                        * Referenced by: '<S27>/Q'
                                        */
    1                                  /* Computed Parameter: Q_Y0_n
                                        * Referenced by: '<S27>/!Q'
                                        */
  }
  /* End of '<S10>/D Flip-Flop' */
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
