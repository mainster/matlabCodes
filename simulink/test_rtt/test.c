/*
 * File: test.c
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

/* Block signals (auto storage) */
B_test_T test_B;

/* Block states (auto storage) */
DW_test_T test_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_test_T test_PrevZCX;

/* Real-time model */
RT_MODEL_test_T test_M_;
RT_MODEL_test_T *const test_M = &test_M_;

/*
 * Disable for enable_with_trigger system:
 *    '<S10>/D Flip-Flop'
 *    '<S11>/D Flip-Flop'
 *    '<S12>/D Flip-Flop'
 *    '<S13>/D Flip-Flop'
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    ...
 */
void test_DFlipFlop_Disable(B_DFlipFlop_test_T *localB, DW_DFlipFlop_test_T
  *localDW, P_DFlipFlop_test_T *localP)
{
  /* Disable for Outport: '<S27>/Q' */
  localB->D = localP->Q_Y0;
  localDW->DFlipFlop_MODE = FALSE;
}

/*
 * Start for enable_with_trigger system:
 *    '<S10>/D Flip-Flop'
 *    '<S11>/D Flip-Flop'
 *    '<S12>/D Flip-Flop'
 *    '<S13>/D Flip-Flop'
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    ...
 */
void test_DFlipFlop_Start(B_DFlipFlop_test_T *localB, P_DFlipFlop_test_T *localP)
{
  /* VirtualOutportStart for Outport: '<S27>/Q' */
  localB->D = localP->Q_Y0;
}

/*
 * Output and update for enable_with_trigger system:
 *    '<S10>/D Flip-Flop'
 *    '<S11>/D Flip-Flop'
 *    '<S12>/D Flip-Flop'
 *    '<S13>/D Flip-Flop'
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    ...
 */
void test_DFlipFlop(boolean_T rtu_0, real_T rtu_1, boolean_T rtu_2,
                    B_DFlipFlop_test_T *localB, DW_DFlipFlop_test_T *localDW,
                    P_DFlipFlop_test_T *localP, ZCE_DFlipFlop_test_T *localZCE)
{
  ZCEventType zcEvent;

  /* Outputs for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' incorporates:
   *  EnablePort: '<S27>/C'
   *  TriggerPort: '<S27>/Trigger'
   */
  zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,&localZCE->DFlipFlop_Trig_ZCE,
                     (rtu_1));
  if (rtu_0) {
    if (!localDW->DFlipFlop_MODE) {
      localDW->DFlipFlop_MODE = TRUE;
    }

    /* Outputs for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' incorporates:
     *  EnablePort: '<S27>/C'
     *  TriggerPort: '<S27>/Trigger'
     */
    if (zcEvent != NO_ZCEVENT) {
      /* Inport: '<S27>/D' */
      localB->D = rtu_2;
    }
  } else {
    if (localDW->DFlipFlop_MODE) {
      test_DFlipFlop_Disable(localB, localDW, localP);
    }
  }

  /* End of Outputs for SubSystem: '<S10>/D Flip-Flop' */
}

uint32_T MWDSP_EPH_R_D(real_T evt, uint32_T *sta)
{
  uint32_T retVal;
  int32_T curState;
  int32_T newState;
  int32_T newStateR;
  int32_T lastzcevent;
  uint32_T previousState;

  /* S-Function (sdspcount2): '<S1>/Counter' */
  /* Detect rising edge events */
  previousState = *sta;
  retVal = 0U;
  lastzcevent = 0;
  newState = 5;
  newStateR = 5;
  if (evt > 0.0) {
    curState = 2;
  } else if (evt < 0.0) {
    curState = 0;
  } else {
    curState = 1;
  }

  if (previousState == 5U) {
    newStateR = curState;
  } else {
    if ((uint32_T)curState != previousState) {
      if (previousState == 3U) {
        if ((uint32_T)curState == 1U) {
          newStateR = 1;
        } else {
          lastzcevent = 2;
          previousState = 1U;
        }
      }

      if (previousState == 4U) {
        if ((uint32_T)curState == 1U) {
          newStateR = 1;
        } else {
          lastzcevent = 3;
          previousState = 1U;
        }
      }

      if ((previousState == 1U) && ((uint32_T)curState == 2U)) {
        retVal = 2U;
      }

      if (previousState == 0U) {
        retVal = 2U;
      }

      if (retVal == (uint32_T)lastzcevent) {
        retVal = 0U;
      }

      if (((uint32_T)curState == 1U) && (retVal == 2U)) {
        newState = 3;
      } else {
        newState = curState;
      }
    }
  }

  if ((uint32_T)newStateR != 5U) {
    *sta = (uint32_T)newStateR;
    retVal = 0U;
  }

  if ((uint32_T)newState != 5U) {
    *sta = (uint32_T)newState;
  }

  /* End of S-Function (sdspcount2): '<S1>/Counter' */
  return retVal;
}

uint32_T MWDSP_EPH_R_B(boolean_T evt, uint32_T *sta)
{
  uint32_T retVal;
  int32_T curState;
  int32_T newState;
  int32_T newStateR;
  int32_T lastzcevent;
  uint32_T previousState;

  /* S-Function (sdspcount2): '<S1>/Counter' */
  /* Detect rising edge events */
  previousState = *sta;
  retVal = 0U;
  lastzcevent = 0;
  newState = 5;
  newStateR = 5;
  if (evt) {
    curState = 2;
  } else {
    curState = 1;
  }

  if (previousState == 5U) {
    newStateR = curState;
  } else {
    if ((uint32_T)curState != previousState) {
      if (previousState == 3U) {
        if ((uint32_T)curState == 1U) {
          newStateR = 1;
        } else {
          lastzcevent = 2;
          previousState = 1U;
        }
      }

      if (previousState == 4U) {
        if ((uint32_T)curState == 1U) {
          newStateR = 1;
        } else {
          lastzcevent = 3;
          previousState = 1U;
        }
      }

      if ((previousState == 1U) && ((uint32_T)curState == 2U)) {
        retVal = 2U;
      }

      if (previousState == 0U) {
        retVal = 2U;
      }

      if (retVal == (uint32_T)lastzcevent) {
        retVal = 0U;
      }

      if (((uint32_T)curState == 1U) && (retVal == 2U)) {
        newState = 3;
      } else {
        newState = curState;
      }
    }
  }

  if ((uint32_T)newStateR != 5U) {
    *sta = (uint32_T)newStateR;
    retVal = 0U;
  }

  if ((uint32_T)newState != 5U) {
    *sta = (uint32_T)newState;
  }

  /* End of S-Function (sdspcount2): '<S1>/Counter' */
  return retVal;
}

/* Model output function */
void test_output(void)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_txStream;
  boolean_T rtb_Q;
  boolean_T rtb_Q_c;
  boolean_T rtb_Q_i;
  boolean_T rtb_Q_h;
  boolean_T rtb_Q_ic;
  boolean_T rtb_Q_ho;
  boolean_T rtb_Q_j;
  boolean_T rtb_Q_o;
  boolean_T rtb_Q_a;
  boolean_T rtb_Q_k;
  boolean_T rtb_Q_g;
  boolean_T rtb_Q_p;
  boolean_T rtb_Q_p0;
  real_T rtb_Switch;
  boolean_T rtb_f_clk;
  boolean_T rtb_conv7;
  ZCEventType zcEvent;
  uint16_T rtb_FixPtSum1;
  int32_T i;
  real_T tmp;
  real_T tmp_0;

  /* DiscretePulseGenerator: '<S1>/f_sck' */
  rtb_Switch = (test_DW.clockTickCounter < test_P.f_sck_Duty) &&
    (test_DW.clockTickCounter >= 0) ? test_P.f_sck_Amp : 0.0;
  if (test_DW.clockTickCounter >= test_P.f_sck_Period - 1.0) {
    test_DW.clockTickCounter = 0;
  } else {
    test_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<S1>/f_sck' */

  /* DataTypeConversion: '<S1>/cast1 ' */
  rtb_f_clk = (rtb_Switch != 0.0);

  /* Outputs for Enabled and Triggered SubSystem: '<S6>/D Flip-Flop' incorporates:
   *  EnablePort: '<S7>/C'
   *  TriggerPort: '<S7>/Trigger'
   */
  /* Constant: '<Root>/stop2' */
  if (test_P.stop2_Value > 0.0) {
    if (!test_DW.DFlipFlop_MODE) {
      test_DW.DFlipFlop_MODE = TRUE;
    }

    /* Outputs for Enabled and Triggered SubSystem: '<S6>/D Flip-Flop' incorporates:
     *  EnablePort: '<S7>/C'
     *  TriggerPort: '<S7>/Trigger'
     */
    /* DataTypeConversion: '<S1>/cast1 ' incorporates:
     *  Inport: '<S7>/D'
     *  Memory: '<S6>/TmpLatchAtD Flip-FlopInport1'
     */
    if ((rtb_Switch != 0.0) && (test_PrevZCX.DFlipFlop_Trig_ZCE_l != POS_ZCSIG))
    {
      test_B.D = test_DW.TmpLatchAtDFlipFlopInport1_Prev;
    }

    test_PrevZCX.DFlipFlop_Trig_ZCE_l = (uint8_T)(rtb_Switch != 0.0 ? (int32_T)
      POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  } else {
    if (test_DW.DFlipFlop_MODE) {
      /* Disable for Outport: '<S7>/Q' */
      test_B.D = test_P.Q_Y0;
      test_DW.DFlipFlop_MODE = FALSE;
    }

    /* DataTypeConversion: '<S1>/cast1 ' */
    test_PrevZCX.DFlipFlop_Trig_ZCE_l = (uint8_T)(rtb_Switch != 0.0 ? (int32_T)
      POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  }

  /* End of Outputs for SubSystem: '<S6>/D Flip-Flop' */

  /* Logic: '<S1>/and3' incorporates:
   *  DataTypeConversion: '<S1>/cast1 '
   *  Logic: '<S1>/and1'
   *  Logic: '<S1>/and2'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  rtb_conv7 = ((test_DW.UnitDelay_DSTATE && (rtb_Switch != 0.0)) || ((rtb_Switch
    != 0.0) && test_B.D));

  /* S-Function (sdspcount2): '<S1>/Counter' incorporates:
   *  Constant: '<Root>/stop2'
   */
  if (MWDSP_EPH_R_D(test_P.stop2_Value, &test_DW.Counter_RstEphState) != 0U) {
    test_DW.Counter_Count = test_P.Counter_InitialCount;
  }

  if (MWDSP_EPH_R_B(rtb_conv7, &test_DW.Counter_ClkEphState) != 0U) {
    if (test_DW.Counter_Count < 16) {
      test_DW.Counter_Count++;
    } else {
      test_DW.Counter_Count = 0U;
    }
  }

  /* Logic: '<S1>/and5' incorporates:
   *  Constant: '<S4>/Constant'
   *  Constant: '<S5>/Constant'
   *  RelationalOperator: '<S4>/Compare'
   *  RelationalOperator: '<S5>/Compare'
   *  S-Function (sdspcount2): '<S1>/Counter'
   */
  test_B.En16 = ((test_DW.Counter_Count > test_P.Constant_Value_c) &&
                 (test_DW.Counter_Count <= test_P.Constant_Value_l));

  /* DiscretePulseGenerator: '<Root>/Start16BitRead' */
  rtb_Switch = (test_DW.clockTickCounter_f < test_P.Start16BitRead_Duty) &&
    (test_DW.clockTickCounter_f >= 0) ? test_P.Start16BitRead_Amp : 0.0;
  if (test_DW.clockTickCounter_f >= test_P.Start16BitRead_Period - 1.0) {
    test_DW.clockTickCounter_f = 0;
  } else {
    test_DW.clockTickCounter_f++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Start16BitRead' */

  /* Switch: '<Root>/Switch' incorporates:
   *  Constant: '<Root>/delay1'
   *  Constant: '<Root>/stop1'
   */
  if (!(test_P.delay1_Value >= test_P.Switch_Threshold)) {
    rtb_Switch = test_P.stop1_Value;
  }

  /* End of Switch: '<Root>/Switch' */

  /* Outputs for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  EnablePort: '<S3>/Enable'
   */
  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Constant: '<S3>/Constant2'
   */
  if ((rtb_Switch != 0.0) || test_B.En16) {
    if (!test_DW.TxSubsystem_MODE) {
      /* InitializeConditions for Triggered SubSystem: '<S3>/Bitmask' */
      /* InitializeConditions for UnitDelay: '<S44>/Output' */
      test_DW.Output_DSTATE = test_P.Output_InitialCondition;

      /* End of InitializeConditions for SubSystem: '<S3>/Bitmask' */

      /* InitializeConditions for Delay: '<S3>/Delay1' */
      for (i = 0; i < 6; i++) {
        test_DW.Delay1_DSTATE[i] = test_P.Delay1_InitialCondition;
      }

      /* End of InitializeConditions for Delay: '<S3>/Delay1' */
      test_DW.TxSubsystem_MODE = TRUE;
    }

    /* DataTypeConversion: '<S3>/conv1' incorporates:
     *  Logic: '<S1>/and4'
     */
    test_B.clk = (rtb_f_clk && test_B.En16);

    /* Outputs for Triggered SubSystem: '<S3>/Bitmask' incorporates:
     *  TriggerPort: '<S42>/Trigger'
     */
    zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,&test_PrevZCX.Bitmask_Trig_ZCE,
                       (test_B.clk));
    if (zcEvent != NO_ZCEVENT) {
      /* DataTypeConversion: '<S42>/conv2' incorporates:
       *  Constant: '<S3>/Constant1'
       */
      tmp = floor(test_P.Constant1_Value);
      if (rtIsNaN(tmp) || rtIsInf(tmp)) {
        tmp = 0.0;
      } else {
        tmp = fmod(tmp, 65536.0);
      }

      /* DataTypeConversion: '<S42>/conv1' incorporates:
       *  Constant: '<S42>/Constant'
       *  Sum: '<S42>/Sum'
       *  UnitDelay: '<S44>/Output'
       */
      tmp_0 = floor((real_T)test_DW.Output_DSTATE + test_P.Constant_Value);
      if (rtIsNaN(tmp_0) || rtIsInf(tmp_0)) {
        tmp_0 = 0.0;
      } else {
        tmp_0 = fmod(tmp_0, 65536.0);
      }

      /* S-Function (sfix_bitop): '<S42>/Bitwise Operator' incorporates:
       *  ArithShift: '<S42>/Shift Arithmetic'
       *  Constant: '<S43>/Constant'
       *  DataTypeConversion: '<S42>/conv1'
       *  DataTypeConversion: '<S42>/conv2'
       *  DataTypeConversion: '<S42>/conv3'
       *  RelationalOperator: '<S43>/Compare'
       *  UnitDelay: '<S44>/Output'
       */
      test_B.BitwiseOperator = (uint16_T)((uint16_T)((uint16_T)(tmp < 0.0 ?
        (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp : (int32_T)(uint16_T)tmp) <<
        (tmp_0 < 0.0 ? (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp_0 : (int32_T)
         (uint16_T)tmp_0)) | (uint16_T)(test_DW.Output_DSTATE ==
        test_P.Constant_Value_e));

      /* Sum: '<S45>/FixPt Sum1' incorporates:
       *  Constant: '<S45>/FixPt Constant'
       *  UnitDelay: '<S44>/Output'
       */
      rtb_FixPtSum1 = (uint16_T)((uint16_T)((uint32_T)test_DW.Output_DSTATE +
        test_P.FixPtConstant_Value) & 16383);

      /* Switch: '<S46>/FixPt Switch' */
      if (rtb_FixPtSum1 > test_P.FixPtSwitch_Threshold) {
        /* Update for UnitDelay: '<S44>/Output' incorporates:
         *  Constant: '<S46>/Constant'
         */
        test_DW.Output_DSTATE = test_P.Constant_Value_d;
      } else {
        /* Update for UnitDelay: '<S44>/Output' */
        test_DW.Output_DSTATE = rtb_FixPtSum1;
      }

      /* End of Switch: '<S46>/FixPt Switch' */
    }

    /* End of Outputs for SubSystem: '<S3>/Bitmask' */

    /* S-Function (sfix_bitop): '<S3>/Bitwise Operator' incorporates:
     *  Constant: '<Root>/TxData'
     */
    rtb_FixPtSum1 = (uint16_T)(test_P.TxData_Value & test_B.BitwiseOperator);
    test_B.gen_CS = test_P.Constant2_Value;

    /* Delay: '<S3>/Delay1' incorporates:
     *  Constant: '<S3>/Constant2'
     */
    zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,&test_PrevZCX.Delay1_Reset_ZCE,
                       (test_B.gen_CS));
    if (zcEvent != NO_ZCEVENT) {
      for (i = 0; i < 6; i++) {
        test_DW.Delay1_DSTATE[i] = test_P.Delay1_InitialCondition;
      }
    }

    test_B.clk_delayed = test_DW.Delay1_DSTATE[0];

    /* End of Delay: '<S3>/Delay1' */

    /* DataTypeConversion: '<S3>/conv2' */
    test_B.conv2 = (rtb_FixPtSum1 != 0);
  } else {
    if (test_DW.TxSubsystem_MODE) {
      /* Disable for Outport: '<S3>/cs' */
      test_B.gen_CS = test_P.cs_Y0;

      /* Disable for Outport: '<S3>/tx' */
      test_B.conv2 = test_P.tx_Y0;

      /* Disable for Outport: '<S3>/clk_delayed' */
      test_B.clk_delayed = test_P.clk_delayed_Y0;
      test_DW.TxSubsystem_MODE = FALSE;
    }
  }

  /* End of Logic: '<Root>/Logical Operator' */
  /* End of Outputs for SubSystem: '<Root>/TxSubsystem' */

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' incorporates:
   *  DataTypeConversion: '<Root>/conv6'
   */
  MW_gpioWrite(test_P.CSn_p1, test_B.gen_CS != 0.0);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioWrite(test_P.MOSI_p1, test_B.conv2);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' incorporates:
   *  DataTypeConversion: '<Root>/conv7'
   */
  MW_gpioWrite(test_P.SCK_p1, test_B.clk_delayed != 0.0);

  /* DataTypeConversion: '<S1>/cast1 1' */
  test_B.cast11 = (rtb_Switch != 0.0);

  /* DiscretePulseGenerator: '<Root>/ResTimer ' */
  rtb_Switch = (test_DW.clockTickCounter_j < test_P.ResTimer_Duty) &&
    (test_DW.clockTickCounter_j >= 0) ? test_P.ResTimer_Amp : 0.0;
  if (test_DW.clockTickCounter_j >= test_P.ResTimer_Period - 1.0) {
    test_DW.clockTickCounter_j = 0;
  } else {
    test_DW.clockTickCounter_j++;
  }

  /* End of DiscretePulseGenerator: '<Root>/ResTimer ' */

  /* Logic: '<Root>/Logical Operator2' */
  rtb_LogicalOperator2 = !(rtb_Switch != 0.0);

  /* Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  rtb_txStream = test_DW.TmpLatchAtDFlipFlopInport1_Pr_g;

  /* Outputs for Enabled and Triggered SubSystem: '<S21>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_txStream,
                 &test_B.DFlipFlop_a, &test_DW.DFlipFlop_a, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_a, &test_PrevZCX.DFlipFlop_a);

  /* End of Outputs for SubSystem: '<S21>/D Flip-Flop' */

  /* Memory: '<S22>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q = test_DW.TmpLatchAtDFlipFlopInport1_Pr_m;

  /* Outputs for Enabled and Triggered SubSystem: '<S22>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q,
                 &test_B.DFlipFlop_o, &test_DW.DFlipFlop_o, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_o, &test_PrevZCX.DFlipFlop_o);

  /* End of Outputs for SubSystem: '<S22>/D Flip-Flop' */

  /* Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_c = test_DW.TmpLatchAtDFlipFlopInport1_Pr_n;

  /* Outputs for Enabled and Triggered SubSystem: '<S23>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_c,
                 &test_B.DFlipFlop_k, &test_DW.DFlipFlop_k, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_k, &test_PrevZCX.DFlipFlop_k);

  /* End of Outputs for SubSystem: '<S23>/D Flip-Flop' */

  /* Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_i = test_DW.TmpLatchAtDFlipFlopInport1_Pr_e;

  /* Outputs for Enabled and Triggered SubSystem: '<S24>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_i,
                 &test_B.DFlipFlop_i, &test_DW.DFlipFlop_i, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_i, &test_PrevZCX.DFlipFlop_i);

  /* End of Outputs for SubSystem: '<S24>/D Flip-Flop' */

  /* Memory: '<S10>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_h = test_DW.TmpLatchAtDFlipFlopInport1_P_nx;

  /* Outputs for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_h,
                 &test_B.DFlipFlop_ir, &test_DW.DFlipFlop_ir,
                 (P_DFlipFlop_test_T *)&test_P.DFlipFlop_ir,
                 &test_PrevZCX.DFlipFlop_ir);

  /* End of Outputs for SubSystem: '<S10>/D Flip-Flop' */

  /* Memory: '<S11>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_ic = test_DW.TmpLatchAtDFlipFlopInport1_P_mf;

  /* Outputs for Enabled and Triggered SubSystem: '<S11>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_ic,
                 &test_B.DFlipFlop_kr, &test_DW.DFlipFlop_kr,
                 (P_DFlipFlop_test_T *)&test_P.DFlipFlop_kr,
                 &test_PrevZCX.DFlipFlop_kr);

  /* End of Outputs for SubSystem: '<S11>/D Flip-Flop' */

  /* Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_ho = test_DW.TmpLatchAtDFlipFlopInport1_Pr_l;

  /* Outputs for Enabled and Triggered SubSystem: '<S19>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_ho,
                 &test_B.DFlipFlop_j, &test_DW.DFlipFlop_j, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_j, &test_PrevZCX.DFlipFlop_j);

  /* End of Outputs for SubSystem: '<S19>/D Flip-Flop' */

  /* Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_j = test_DW.TmpLatchAtDFlipFlopInport1_Pr_k;

  /* Outputs for Enabled and Triggered SubSystem: '<S20>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_j,
                 &test_B.DFlipFlop_c, &test_DW.DFlipFlop_c, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_c, &test_PrevZCX.DFlipFlop_c);

  /* End of Outputs for SubSystem: '<S20>/D Flip-Flop' */

  /* Memory: '<S12>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_o = test_DW.TmpLatchAtDFlipFlopInport1_P_ln;

  /* Outputs for Enabled and Triggered SubSystem: '<S12>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_o,
                 &test_B.DFlipFlop_k2, &test_DW.DFlipFlop_k2,
                 (P_DFlipFlop_test_T *)&test_P.DFlipFlop_k2,
                 &test_PrevZCX.DFlipFlop_k2);

  /* End of Outputs for SubSystem: '<S12>/D Flip-Flop' */

  /* Memory: '<S13>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_a = test_DW.TmpLatchAtDFlipFlopInport1_P_km;

  /* Outputs for Enabled and Triggered SubSystem: '<S13>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_a,
                 &test_B.DFlipFlop_d, &test_DW.DFlipFlop_d, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_d, &test_PrevZCX.DFlipFlop_d);

  /* End of Outputs for SubSystem: '<S13>/D Flip-Flop' */

  /* Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_k = test_DW.TmpLatchAtDFlipFlopInport1_Pr_j;

  /* Outputs for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_k,
                 &test_B.DFlipFlop_je, &test_DW.DFlipFlop_je,
                 (P_DFlipFlop_test_T *)&test_P.DFlipFlop_je,
                 &test_PrevZCX.DFlipFlop_je);

  /* End of Outputs for SubSystem: '<S14>/D Flip-Flop' */

  /* Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_g = test_DW.TmpLatchAtDFlipFlopInport1_Pr_p;

  /* Outputs for Enabled and Triggered SubSystem: '<S15>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_g,
                 &test_B.DFlipFlop_b, &test_DW.DFlipFlop_b, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_b, &test_PrevZCX.DFlipFlop_b);

  /* End of Outputs for SubSystem: '<S15>/D Flip-Flop' */

  /* Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_p = test_DW.TmpLatchAtDFlipFlopInport1_Pr_i;

  /* Outputs for Enabled and Triggered SubSystem: '<S16>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_p,
                 &test_B.DFlipFlop_n, &test_DW.DFlipFlop_n, (P_DFlipFlop_test_T *)
                 &test_P.DFlipFlop_n, &test_PrevZCX.DFlipFlop_n);

  /* End of Outputs for SubSystem: '<S16>/D Flip-Flop' */

  /* Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_p0 = test_DW.TmpLatchAtDFlipFlopInport1_Pr_o;

  /* Outputs for Enabled and Triggered SubSystem: '<S17>/D Flip-Flop' */
  test_DFlipFlop(rtb_LogicalOperator2, test_B.clk_delayed, rtb_Q_p0,
                 &test_B.DFlipFlop_og, &test_DW.DFlipFlop_og,
                 (P_DFlipFlop_test_T *)&test_P.DFlipFlop_og,
                 &test_PrevZCX.DFlipFlop_og);

  /* End of Outputs for SubSystem: '<S17>/D Flip-Flop' */

  /* Outputs for Enabled and Triggered SubSystem: '<S18>/D Flip-Flop' incorporates:
   *  EnablePort: '<S35>/C'
   *  TriggerPort: '<S35>/Trigger'
   */
  rt_ZCFcn(RISING_ZERO_CROSSING,&test_PrevZCX.DFlipFlop_Trig_ZCE_c,
           (test_B.clk_delayed));
  if (rtb_LogicalOperator2) {
    if (!test_DW.DFlipFlop_MODE_i) {
      test_DW.DFlipFlop_MODE_i = TRUE;
    }
  } else {
    if (test_DW.DFlipFlop_MODE_i) {
      test_DW.DFlipFlop_MODE_i = FALSE;
    }
  }

  /* End of Outputs for SubSystem: '<S18>/D Flip-Flop' */

  /* Logic: '<S2>/Logical Operator1' */
  test_B.LogicalOperator1 = !rtb_LogicalOperator2;

  /* S-Function (sdspcount2): '<S2>/Counter' */
  if (MWDSP_EPH_R_B(test_B.LogicalOperator1, &test_DW.Counter_RstEphState_j) !=
      0U) {
    test_DW.Counter_Count_f = test_P.Counter_InitialCount_p;
  }

  if (MWDSP_EPH_R_D(test_B.clk_delayed, &test_DW.Counter_ClkEphState_l) != 0U) {
    if (test_DW.Counter_Count_f < 255) {
      test_DW.Counter_Count_f++;
    } else {
      test_DW.Counter_Count_f = 0U;
    }
  }

  /* End of S-Function (sdspcount2): '<S2>/Counter' */
}

/* Model update function */
void test_update(void)
{
  int_T idxDelay;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  test_DW.UnitDelay_DSTATE = test_B.En16;

  /* Update for Memory: '<S6>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Prev = test_B.cast11;

  /* Update for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  Update for EnablePort: '<S3>/Enable'
   */
  if (test_DW.TxSubsystem_MODE) {
    /* Update for Delay: '<S3>/Delay1' */
    for (idxDelay = 0; idxDelay < 5; idxDelay++) {
      test_DW.Delay1_DSTATE[idxDelay] = test_DW.Delay1_DSTATE[idxDelay + 1];
    }

    test_DW.Delay1_DSTATE[5] = test_B.clk;

    /* End of Update for Delay: '<S3>/Delay1' */
  }

  /* End of Update for SubSystem: '<Root>/TxSubsystem' */

  /* Update for Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_g = test_B.conv2;

  /* Update for Memory: '<S22>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_m = test_B.DFlipFlop_a.D;

  /* Update for Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_n = test_B.DFlipFlop_o.D;

  /* Update for Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_e = test_B.DFlipFlop_k.D;

  /* Update for Memory: '<S10>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_nx = test_B.DFlipFlop_i.D;

  /* Update for Memory: '<S11>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_mf = test_B.DFlipFlop_ir.D;

  /* Update for Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_l = test_B.DFlipFlop_kr.D;

  /* Update for Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_k = test_B.DFlipFlop_j.D;

  /* Update for Memory: '<S12>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_ln = test_B.DFlipFlop_c.D;

  /* Update for Memory: '<S13>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_km = test_B.DFlipFlop_k2.D;

  /* Update for Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_j = test_B.DFlipFlop_d.D;

  /* Update for Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_p = test_B.DFlipFlop_je.D;

  /* Update for Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_i = test_B.DFlipFlop_b.D;

  /* Update for Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_o = test_B.DFlipFlop_n.D;

  /* Update for Memory: '<S18>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_b = test_B.DFlipFlop_og.D;
}

/* Model initialize function */
void test_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize error status */
  rtmSetErrorStatus(test_M, (NULL));

  /* block I/O */
  (void) memset(((void *) &test_B), 0,
                sizeof(B_test_T));

  /* states (dwork) */
  (void) memset((void *)&test_DW, 0,
                sizeof(DW_test_T));

  {
    int32_T i;
    uint8_T tmp;
    uint8_T tmp_0;
    uint8_T tmp_1;

    /* Start for DiscretePulseGenerator: '<S1>/f_sck' */
    test_DW.clockTickCounter = 0;

    /* Start for Enabled and Triggered SubSystem: '<S6>/D Flip-Flop' */
    /* VirtualOutportStart for Outport: '<S7>/Q' */
    test_B.D = test_P.Q_Y0;

    /* End of Start for SubSystem: '<S6>/D Flip-Flop' */

    /* Start for DiscretePulseGenerator: '<Root>/Start16BitRead' */
    test_DW.clockTickCounter_f = -10;

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* Start for Triggered SubSystem: '<S3>/Bitmask' */
    /* VirtualOutportStart for Outport: '<S42>/out' */
    test_B.BitwiseOperator = test_P.out_Y0;

    /* End of Start for SubSystem: '<S3>/Bitmask' */
    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* InitializeConditions for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* InitializeConditions for Triggered SubSystem: '<S3>/Bitmask' */
    /* InitializeConditions for UnitDelay: '<S44>/Output' */
    test_DW.Output_DSTATE = test_P.Output_InitialCondition;

    /* End of InitializeConditions for SubSystem: '<S3>/Bitmask' */

    /* InitializeConditions for Delay: '<S3>/Delay1' */
    for (i = 0; i < 6; i++) {
      test_DW.Delay1_DSTATE[i] = test_P.Delay1_InitialCondition;
    }

    /* End of InitializeConditions for Delay: '<S3>/Delay1' */
    /* End of InitializeConditions for SubSystem: '<Root>/TxSubsystem' */

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* VirtualOutportStart for Outport: '<S3>/cs' */
    test_B.gen_CS = test_P.cs_Y0;

    /* VirtualOutportStart for Outport: '<S3>/tx' */
    test_B.conv2 = test_P.tx_Y0;

    /* VirtualOutportStart for Outport: '<S3>/clk_delayed' */
    test_B.clk_delayed = test_P.clk_delayed_Y0;

    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
    tmp_1 = test_P.CSn_p4;
    MW_gpioInit(test_P.CSn_p1, test_P.CSn_p2, test_P.CSn_p3, &tmp_1);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
    tmp_0 = test_P.MOSI_p4;
    MW_gpioInit(test_P.MOSI_p1, test_P.MOSI_p2, test_P.MOSI_p3, &tmp_0);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
    tmp = test_P.SCK_p4;
    MW_gpioInit(test_P.SCK_p1, test_P.SCK_p2, test_P.SCK_p3, &tmp);

    /* Start for DiscretePulseGenerator: '<Root>/ResTimer ' */
    test_DW.clockTickCounter_j = -70;

    /* Start for Enabled and Triggered SubSystem: '<S21>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_a, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_a);

    /* End of Start for SubSystem: '<S21>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S22>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_o, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_o);

    /* End of Start for SubSystem: '<S22>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S23>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_k, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_k);

    /* End of Start for SubSystem: '<S23>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S24>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_i, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_i);

    /* End of Start for SubSystem: '<S24>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_ir, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_ir);

    /* End of Start for SubSystem: '<S10>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S11>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_kr, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_kr);

    /* End of Start for SubSystem: '<S11>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S19>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_j, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_j);

    /* End of Start for SubSystem: '<S19>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S20>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_c, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_c);

    /* End of Start for SubSystem: '<S20>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S12>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_k2, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_k2);

    /* End of Start for SubSystem: '<S12>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S13>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_d, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_d);

    /* End of Start for SubSystem: '<S13>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_je, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_je);

    /* End of Start for SubSystem: '<S14>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S15>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_b, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_b);

    /* End of Start for SubSystem: '<S15>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S16>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_n, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_n);

    /* End of Start for SubSystem: '<S16>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S17>/D Flip-Flop' */
    test_DFlipFlop_Start(&test_B.DFlipFlop_og, (P_DFlipFlop_test_T *)
                         &test_P.DFlipFlop_og);

    /* End of Start for SubSystem: '<S17>/D Flip-Flop' */
  }

  test_PrevZCX.Delay1_Reset_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.Bitmask_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.TriggeredToWorkspace_Trig_ZCE = POS_ZCSIG;
  test_PrevZCX.DFlipFlop_i.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_k.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_o.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_a.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_c.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_j.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_Trig_ZCE_c = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_og.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_n.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_b.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_je.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_d.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_k2.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_kr.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_ir.DFlipFlop_Trig_ZCE = UNINITIALIZED_ZCSIG;
  test_PrevZCX.DFlipFlop_Trig_ZCE_l = POS_ZCSIG;

  /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
  test_DW.UnitDelay_DSTATE = test_P.UnitDelay_InitialCondition;

  /* InitializeConditions for Memory: '<S6>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Prev = test_P.TmpLatchAtDFlipFlopInport1_X0;

  /* InitializeConditions for S-Function (sdspcount2): '<S1>/Counter' */
  test_DW.Counter_ClkEphState = 5U;
  test_DW.Counter_RstEphState = 5U;
  test_DW.Counter_Count = test_P.Counter_InitialCount;

  /* InitializeConditions for Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_g =
    test_P.TmpLatchAtDFlipFlopInport1_X0_d;

  /* InitializeConditions for Memory: '<S22>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_m =
    test_P.TmpLatchAtDFlipFlopInport1_X_dc;

  /* InitializeConditions for Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_n =
    test_P.TmpLatchAtDFlipFlopInport1_X0_i;

  /* InitializeConditions for Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_e =
    test_P.TmpLatchAtDFlipFlopInport1_X0_b;

  /* InitializeConditions for Memory: '<S10>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_nx =
    test_P.TmpLatchAtDFlipFlopInport1_X0_k;

  /* InitializeConditions for Memory: '<S11>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_mf =
    test_P.TmpLatchAtDFlipFlopInport1_X0_a;

  /* InitializeConditions for Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_l =
    test_P.TmpLatchAtDFlipFlopInport1_X0_f;

  /* InitializeConditions for Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_k =
    test_P.TmpLatchAtDFlipFlopInport1_X_fu;

  /* InitializeConditions for Memory: '<S12>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_ln =
    test_P.TmpLatchAtDFlipFlopInport1_X0_j;

  /* InitializeConditions for Memory: '<S13>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_P_km =
    test_P.TmpLatchAtDFlipFlopInport1_X0_p;

  /* InitializeConditions for Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_j =
    test_P.TmpLatchAtDFlipFlopInport1_X_kg;

  /* InitializeConditions for Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_p =
    test_P.TmpLatchAtDFlipFlopInport1_X0_l;

  /* InitializeConditions for Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_i =
    test_P.TmpLatchAtDFlipFlopInport1_X_li;

  /* InitializeConditions for Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_o =
    test_P.TmpLatchAtDFlipFlopInport1_X_ia;

  /* InitializeConditions for Memory: '<S18>/TmpLatchAtD Flip-FlopInport1' */
  test_DW.TmpLatchAtDFlipFlopInport1_Pr_b =
    test_P.TmpLatchAtDFlipFlopInport1_X_iz;

  /* InitializeConditions for S-Function (sdspcount2): '<S2>/Counter' */
  test_DW.Counter_ClkEphState_l = 5U;
  test_DW.Counter_RstEphState_j = 5U;
  test_DW.Counter_Count_f = test_P.Counter_InitialCount_p;
}

/* Model terminate function */
void test_terminate(void)
{
  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
  MW_gpioTerminate(test_P.CSn_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioTerminate(test_P.MOSI_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
  MW_gpioTerminate(test_P.SCK_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
