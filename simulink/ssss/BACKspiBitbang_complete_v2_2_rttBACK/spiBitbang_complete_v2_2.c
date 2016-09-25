/*
 * File: spiBitbang_complete_v2_2.c
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

/* Block signals (auto storage) */
B_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_B;

/* Block states (auto storage) */
DW_spiBitbang_complete_v2_2_T spiBitbang_complete_v2_2_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_spiBitbang_complete_v_T spiBitbang_complete_v2__PrevZCX;

/* Real-time model */
RT_MODEL_spiBitbang_complete__T spiBitbang_complete_v2_2_M_;
RT_MODEL_spiBitbang_complete__T *const spiBitbang_complete_v2_2_M =
  &spiBitbang_complete_v2_2_M_;

/*
 * Disable for enable_with_trigger system:
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S18>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    '<S21>/D Flip-Flop'
 *    '<S23>/D Flip-Flop'
 *    '<S24>/D Flip-Flop'
 *    ...
 */
void spiBitbang_co_DFlipFlop_Disable(B_DFlipFlop_spiBitbang_comple_T *localB,
  DW_DFlipFlop_spiBitbang_compl_T *localDW, P_DFlipFlop_spiBitbang_comple_T
  *localP)
{
  /* Disable for Outport: '<S32>/Q' */
  localB->D = localP->Q_Y0;
  localDW->DFlipFlop_MODE = FALSE;
}

/*
 * Start for enable_with_trigger system:
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S18>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    '<S21>/D Flip-Flop'
 *    '<S23>/D Flip-Flop'
 *    '<S24>/D Flip-Flop'
 *    ...
 */
void spiBitbang_comp_DFlipFlop_Start(B_DFlipFlop_spiBitbang_comple_T *localB,
  P_DFlipFlop_spiBitbang_comple_T *localP)
{
  /* VirtualOutportStart for Outport: '<S32>/Q' */
  localB->D = localP->Q_Y0;
}

/*
 * Output and update for enable_with_trigger system:
 *    '<S14>/D Flip-Flop'
 *    '<S15>/D Flip-Flop'
 *    '<S16>/D Flip-Flop'
 *    '<S17>/D Flip-Flop'
 *    '<S18>/D Flip-Flop'
 *    '<S19>/D Flip-Flop'
 *    '<S20>/D Flip-Flop'
 *    '<S21>/D Flip-Flop'
 *    '<S23>/D Flip-Flop'
 *    '<S24>/D Flip-Flop'
 *    ...
 */
void spiBitbang_complete_v_DFlipFlop(boolean_T rtu_0, real_T rtu_1, boolean_T
  rtu_2, B_DFlipFlop_spiBitbang_comple_T *localB,
  DW_DFlipFlop_spiBitbang_compl_T *localDW, P_DFlipFlop_spiBitbang_comple_T
  *localP, ZCE_DFlipFlop_spiBitbang_comp_T *localZCE)
{
  ZCEventType zcEvent;

  /* Outputs for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' incorporates:
   *  EnablePort: '<S32>/C'
   *  TriggerPort: '<S32>/Trigger'
   */
  zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,&localZCE->DFlipFlop_Trig_ZCE,
                     (rtu_1));
  if (rtu_0) {
    if (!localDW->DFlipFlop_MODE) {
      localDW->DFlipFlop_MODE = TRUE;
    }

    /* Outputs for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' incorporates:
     *  EnablePort: '<S32>/C'
     *  TriggerPort: '<S32>/Trigger'
     */
    if (zcEvent != NO_ZCEVENT) {
      /* Inport: '<S32>/D' */
      localB->D = rtu_2;
    }
  } else {
    if (localDW->DFlipFlop_MODE) {
      spiBitbang_co_DFlipFlop_Disable(localB, localDW, localP);
    }
  }

  /* End of Outputs for SubSystem: '<S14>/D Flip-Flop' */
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

uint32_T MWDSP_EPH_R_D(real_T evt, uint32_T *sta)
{
  uint32_T retVal;
  int32_T curState;
  int32_T newState;
  int32_T newStateR;
  int32_T lastzcevent;
  uint32_T previousState;

  /* S-Function (sdspcount2): '<S3>/Counter' */
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

  /* End of S-Function (sdspcount2): '<S3>/Counter' */
  return retVal;
}

/* Model output function */
void spiBitbang_complete_v2_2_output(void)
{
  /* local block i/o variables */
  boolean_T rtb_LogicalOperator2;
  boolean_T rtb_txStream;
  boolean_T rtb_Q;
  boolean_T rtb_Q_g;
  boolean_T rtb_Q_m;
  boolean_T rtb_Q_o;
  boolean_T rtb_Q_n;
  boolean_T rtb_Q_f;
  boolean_T rtb_Q_n2;
  boolean_T rtb_Q_mq;
  boolean_T rtb_Q_a;
  boolean_T rtb_Q_of;
  boolean_T rtb_Q_m5;
  boolean_T rtb_Q_nw;
  boolean_T rtb_Q_od;
  boolean_T rtb_GPIORead_0;
  real_T rtb_ResTimer1;
  boolean_T rtb_f_clk;
  boolean_T rtb_conv7;
  ZCEventType zcEvent;
  uint16_T rtb_FixPtSum1;
  int32_T i;
  real_T tmp;
  real_T tmp_0;

  /* DiscretePulseGenerator: '<S1>/f_sck' */
  rtb_ResTimer1 = (spiBitbang_complete_v2_2_DW.clockTickCounter <
                   spiBitbang_complete_v2_2_P.f_sck_Duty) &&
    (spiBitbang_complete_v2_2_DW.clockTickCounter >= 0) ?
    spiBitbang_complete_v2_2_P.f_sck_Amp : 0.0;
  if (spiBitbang_complete_v2_2_DW.clockTickCounter >=
      spiBitbang_complete_v2_2_P.f_sck_Period - 1.0) {
    spiBitbang_complete_v2_2_DW.clockTickCounter = 0;
  } else {
    spiBitbang_complete_v2_2_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<S1>/f_sck' */

  /* DataTypeConversion: '<S1>/cast1 ' */
  rtb_f_clk = (rtb_ResTimer1 != 0.0);

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/f_sck_OnOff' */
  {
    {
      if (spiBitbang_complete_v2_2_DW.f_sck_OnOff_Counter ==
          spiBitbang_complete_v2_2_P.f_sck_OnOff_TARGETCNT) {
        spiBitbang_complete_v2_2_B.interrupt = (boolean_T)(2 -
          spiBitbang_complete_v2_2_P.f_sck_OnOff_ACTLEVEL);
      } else {
        spiBitbang_complete_v2_2_B.interrupt = (boolean_T)
          (spiBitbang_complete_v2_2_P.f_sck_OnOff_ACTLEVEL - 1);
        (spiBitbang_complete_v2_2_DW.f_sck_OnOff_Counter)++;
      }
    }
  }

  /* Outputs for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' incorporates:
   *  EnablePort: '<S11>/C'
   *  TriggerPort: '<S11>/Trigger'
   */
  if (spiBitbang_complete_v2_2_B.interrupt) {
    if (!spiBitbang_complete_v2_2_DW.DFlipFlop_MODE) {
      spiBitbang_complete_v2_2_DW.DFlipFlop_MODE = TRUE;
    }

    /* Outputs for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' incorporates:
     *  EnablePort: '<S11>/C'
     *  TriggerPort: '<S11>/Trigger'
     */
    /* DataTypeConversion: '<S1>/cast1 ' incorporates:
     *  Inport: '<S11>/D'
     *  Memory: '<S10>/TmpLatchAtD Flip-FlopInport1'
     */
    if ((rtb_ResTimer1 != 0.0) &&
        (spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_e != POS_ZCSIG)) {
      spiBitbang_complete_v2_2_B.D =
        spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Prev;
    }

    spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_e = (uint8_T)
      (rtb_ResTimer1 != 0.0 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  } else {
    if (spiBitbang_complete_v2_2_DW.DFlipFlop_MODE) {
      /* Disable for Outport: '<S11>/Q' */
      spiBitbang_complete_v2_2_B.D = spiBitbang_complete_v2_2_P.Q_Y0;
      spiBitbang_complete_v2_2_DW.DFlipFlop_MODE = FALSE;
    }

    /* DataTypeConversion: '<S1>/cast1 ' */
    spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_e = (uint8_T)
      (rtb_ResTimer1 != 0.0 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  }

  /* End of Outputs for SubSystem: '<S10>/D Flip-Flop' */

  /* Logic: '<S1>/and3' incorporates:
   *  DataTypeConversion: '<S1>/cast1 '
   *  Logic: '<S1>/and1'
   *  Logic: '<S1>/and2'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  rtb_conv7 = ((spiBitbang_complete_v2_2_DW.UnitDelay_DSTATE && (rtb_ResTimer1
    != 0.0)) || ((rtb_ResTimer1 != 0.0) && spiBitbang_complete_v2_2_B.D));

  /* S-Function (sdspcount2): '<S1>/Counter' */
  if (MWDSP_EPH_R_B(spiBitbang_complete_v2_2_B.interrupt,
                    &spiBitbang_complete_v2_2_DW.Counter_RstEphState) != 0U) {
    spiBitbang_complete_v2_2_DW.Counter_Count =
      spiBitbang_complete_v2_2_P.Counter_InitialCount;
  }

  if (MWDSP_EPH_R_B(rtb_conv7, &spiBitbang_complete_v2_2_DW.Counter_ClkEphState)
      != 0U) {
    if (spiBitbang_complete_v2_2_DW.Counter_Count < 16) {
      spiBitbang_complete_v2_2_DW.Counter_Count++;
    } else {
      spiBitbang_complete_v2_2_DW.Counter_Count = 0U;
    }
  }

  /* Logic: '<S1>/and5' incorporates:
   *  Constant: '<S8>/Constant'
   *  Constant: '<S9>/Constant'
   *  RelationalOperator: '<S8>/Compare'
   *  RelationalOperator: '<S9>/Compare'
   *  S-Function (sdspcount2): '<S1>/Counter'
   */
  spiBitbang_complete_v2_2_B.En16 = ((spiBitbang_complete_v2_2_DW.Counter_Count >
    spiBitbang_complete_v2_2_P.Constant_Value_a) &&
    (spiBitbang_complete_v2_2_DW.Counter_Count <=
     spiBitbang_complete_v2_2_P.Constant_Value_j));

  /* DiscretePulseGenerator: '<Root>/Start16BitRead' */
  rtb_ResTimer1 = (spiBitbang_complete_v2_2_DW.clockTickCounter_c <
                   spiBitbang_complete_v2_2_P.Start16BitRead_Duty) &&
    (spiBitbang_complete_v2_2_DW.clockTickCounter_c >= 0) ?
    spiBitbang_complete_v2_2_P.Start16BitRead_Amp : 0.0;
  if (spiBitbang_complete_v2_2_DW.clockTickCounter_c >=
      spiBitbang_complete_v2_2_P.Start16BitRead_Period - 1.0) {
    spiBitbang_complete_v2_2_DW.clockTickCounter_c = 0;
  } else {
    spiBitbang_complete_v2_2_DW.clockTickCounter_c++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Start16BitRead' */
  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/N-Sample Enable' */
  {
    {
      if (spiBitbang_complete_v2_2_DW.NSampleEnable_Counter ==
          spiBitbang_complete_v2_2_P.NSampleEnable_TARGETCNT) {
        spiBitbang_complete_v2_2_B.NSampleEnable = (boolean_T)(2 -
          spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL);
      } else {
        spiBitbang_complete_v2_2_B.NSampleEnable = (boolean_T)
          (spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL - 1);
        (spiBitbang_complete_v2_2_DW.NSampleEnable_Counter)++;
      }
    }
  }

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<S4>/N-Sample Enable' */
  {
    {
      if (spiBitbang_complete_v2_2_DW.NSampleEnable_Counter_o ==
          spiBitbang_complete_v2_2_P.NSampleEnable_TARGETCNT_k) {
        spiBitbang_complete_v2_2_B.NSampleEnable_m = (boolean_T)(2 -
          spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL_n);
      } else {
        spiBitbang_complete_v2_2_B.NSampleEnable_m = (boolean_T)
          (spiBitbang_complete_v2_2_P.NSampleEnable_ACTLEVEL_n - 1);
        (spiBitbang_complete_v2_2_DW.NSampleEnable_Counter_o)++;
      }
    }
  }

  /* Switch: '<S4>/Switch' incorporates:
   *  Constant: '<Root>/stop'
   */
  if (spiBitbang_complete_v2_2_B.NSampleEnable_m) {
    rtb_conv7 = spiBitbang_complete_v2_2_B.NSampleEnable;
  } else {
    rtb_conv7 = spiBitbang_complete_v2_2_P.stop_Value;
  }

  /* End of Switch: '<S4>/Switch' */

  /* S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  rtb_GPIORead_0 = MW_gpioRead(9U);

  /* Switch: '<Root>/Switch' incorporates:
   *  Constant: '<Root>/stop1'
   *  S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read'
   */
  if (rtb_GPIORead_0) {
    /* ManualSwitch: '<Root>/Transmit Command' */
    if (spiBitbang_complete_v2_2_P.TransmitCommand_CurrentSetting != 1) {
      rtb_ResTimer1 = rtb_conv7;
    }

    /* End of ManualSwitch: '<Root>/Transmit Command' */
  } else {
    rtb_ResTimer1 = spiBitbang_complete_v2_2_P.stop1_Value;
  }

  /* End of Switch: '<Root>/Switch' */

  /* Outputs for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  EnablePort: '<S7>/Enable'
   */
  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Constant: '<S7>/Constant2'
   */
  if ((rtb_ResTimer1 != 0.0) || spiBitbang_complete_v2_2_B.En16) {
    if (!spiBitbang_complete_v2_2_DW.TxSubsystem_MODE) {
      /* InitializeConditions for Triggered SubSystem: '<S7>/Bitmask' */
      /* InitializeConditions for UnitDelay: '<S49>/Output' */
      spiBitbang_complete_v2_2_DW.Output_DSTATE =
        spiBitbang_complete_v2_2_P.Output_InitialCondition;

      /* End of InitializeConditions for SubSystem: '<S7>/Bitmask' */

      /* InitializeConditions for Delay: '<S7>/Delay1' */
      for (i = 0; i < 6; i++) {
        spiBitbang_complete_v2_2_DW.Delay1_DSTATE[i] =
          spiBitbang_complete_v2_2_P.Delay1_InitialCondition;
      }

      /* End of InitializeConditions for Delay: '<S7>/Delay1' */
      spiBitbang_complete_v2_2_DW.TxSubsystem_MODE = TRUE;
    }

    /* DataTypeConversion: '<S7>/conv1' incorporates:
     *  Logic: '<S1>/and4'
     */
    spiBitbang_complete_v2_2_B.clk = (rtb_f_clk &&
      spiBitbang_complete_v2_2_B.En16);

    /* Outputs for Triggered SubSystem: '<S7>/Bitmask' incorporates:
     *  TriggerPort: '<S47>/Trigger'
     */
    zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,
                       &spiBitbang_complete_v2__PrevZCX.Bitmask_Trig_ZCE,
                       (spiBitbang_complete_v2_2_B.clk));
    if (zcEvent != NO_ZCEVENT) {
      /* DataTypeConversion: '<S47>/conv2' incorporates:
       *  Constant: '<S7>/Constant1'
       */
      tmp = floor(spiBitbang_complete_v2_2_P.Constant1_Value);
      if (rtIsNaN(tmp) || rtIsInf(tmp)) {
        tmp = 0.0;
      } else {
        tmp = fmod(tmp, 65536.0);
      }

      /* DataTypeConversion: '<S47>/conv1' incorporates:
       *  Constant: '<S47>/Constant'
       *  Sum: '<S47>/Sum'
       *  UnitDelay: '<S49>/Output'
       */
      tmp_0 = floor((real_T)spiBitbang_complete_v2_2_DW.Output_DSTATE +
                    spiBitbang_complete_v2_2_P.Constant_Value);
      if (rtIsNaN(tmp_0) || rtIsInf(tmp_0)) {
        tmp_0 = 0.0;
      } else {
        tmp_0 = fmod(tmp_0, 65536.0);
      }

      /* S-Function (sfix_bitop): '<S47>/Bitwise Operator' incorporates:
       *  ArithShift: '<S47>/Shift Arithmetic'
       *  Constant: '<S48>/Constant'
       *  DataTypeConversion: '<S47>/conv1'
       *  DataTypeConversion: '<S47>/conv2'
       *  DataTypeConversion: '<S47>/conv3'
       *  RelationalOperator: '<S48>/Compare'
       *  UnitDelay: '<S49>/Output'
       */
      spiBitbang_complete_v2_2_B.BitwiseOperator = (uint16_T)((uint16_T)
        ((uint16_T)(tmp < 0.0 ? (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp :
                    (int32_T)(uint16_T)tmp) << (tmp_0 < 0.0 ? (int32_T)(uint16_T)
        -(int16_T)(uint16_T)-tmp_0 : (int32_T)(uint16_T)tmp_0)) | (uint16_T)
        (spiBitbang_complete_v2_2_DW.Output_DSTATE ==
         spiBitbang_complete_v2_2_P.Constant_Value_o));

      /* Sum: '<S50>/FixPt Sum1' incorporates:
       *  Constant: '<S50>/FixPt Constant'
       *  UnitDelay: '<S49>/Output'
       */
      rtb_FixPtSum1 = (uint16_T)((uint16_T)((uint32_T)
        spiBitbang_complete_v2_2_DW.Output_DSTATE +
        spiBitbang_complete_v2_2_P.FixPtConstant_Value) & 16383);

      /* Switch: '<S51>/FixPt Switch' */
      if (rtb_FixPtSum1 > spiBitbang_complete_v2_2_P.FixPtSwitch_Threshold) {
        /* Update for UnitDelay: '<S49>/Output' incorporates:
         *  Constant: '<S51>/Constant'
         */
        spiBitbang_complete_v2_2_DW.Output_DSTATE =
          spiBitbang_complete_v2_2_P.Constant_Value_p;
      } else {
        /* Update for UnitDelay: '<S49>/Output' */
        spiBitbang_complete_v2_2_DW.Output_DSTATE = rtb_FixPtSum1;
      }

      /* End of Switch: '<S51>/FixPt Switch' */
    }

    /* End of Outputs for SubSystem: '<S7>/Bitmask' */

    /* S-Function (sfix_bitop): '<S7>/Bitwise Operator' incorporates:
     *  Constant: '<Root>/TxData'
     */
    rtb_FixPtSum1 = (uint16_T)(spiBitbang_complete_v2_2_P.TxData_Value &
      spiBitbang_complete_v2_2_B.BitwiseOperator);
    spiBitbang_complete_v2_2_B.gen_CS =
      spiBitbang_complete_v2_2_P.Constant2_Value;

    /* Delay: '<S7>/Delay1' incorporates:
     *  Constant: '<S7>/Constant2'
     */
    zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,
                       &spiBitbang_complete_v2__PrevZCX.Delay1_Reset_ZCE,
                       (spiBitbang_complete_v2_2_B.gen_CS));
    if (zcEvent != NO_ZCEVENT) {
      for (i = 0; i < 6; i++) {
        spiBitbang_complete_v2_2_DW.Delay1_DSTATE[i] =
          spiBitbang_complete_v2_2_P.Delay1_InitialCondition;
      }
    }

    spiBitbang_complete_v2_2_B.clk_delayed =
      spiBitbang_complete_v2_2_DW.Delay1_DSTATE[0];

    /* End of Delay: '<S7>/Delay1' */

    /* DataTypeConversion: '<S7>/conv2' */
    spiBitbang_complete_v2_2_B.conv2 = (rtb_FixPtSum1 != 0);
  } else {
    if (spiBitbang_complete_v2_2_DW.TxSubsystem_MODE) {
      /* Disable for Outport: '<S7>/cs' */
      spiBitbang_complete_v2_2_B.gen_CS = spiBitbang_complete_v2_2_P.cs_Y0;

      /* Disable for Outport: '<S7>/tx' */
      spiBitbang_complete_v2_2_B.conv2 = spiBitbang_complete_v2_2_P.tx_Y0;

      /* Disable for Outport: '<S7>/clk_delayed' */
      spiBitbang_complete_v2_2_B.clk_delayed =
        spiBitbang_complete_v2_2_P.clk_delayed_Y0;
      spiBitbang_complete_v2_2_DW.TxSubsystem_MODE = FALSE;
    }
  }

  /* End of Logic: '<Root>/Logical Operator' */
  /* End of Outputs for SubSystem: '<Root>/TxSubsystem' */

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' incorporates:
   *  DataTypeConversion: '<Root>/conv6'
   */
  MW_gpioWrite(spiBitbang_complete_v2_2_P.CSn_p1,
               spiBitbang_complete_v2_2_B.gen_CS != 0.0);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioWrite(spiBitbang_complete_v2_2_P.MOSI_p1,
               spiBitbang_complete_v2_2_B.conv2);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' incorporates:
   *  DataTypeConversion: '<Root>/conv7'
   */
  MW_gpioWrite(spiBitbang_complete_v2_2_P.SCK_p1,
               spiBitbang_complete_v2_2_B.clk_delayed != 0.0);

  /* DataTypeConversion: '<S1>/cast1 1' */
  spiBitbang_complete_v2_2_B.cast11 = (rtb_ResTimer1 != 0.0);

  /* DiscretePulseGenerator: '<Root>/ResTimer ' */
  rtb_ResTimer1 = (spiBitbang_complete_v2_2_DW.clockTickCounter_n <
                   spiBitbang_complete_v2_2_P.ResTimer_Duty) &&
    (spiBitbang_complete_v2_2_DW.clockTickCounter_n >= 0) ?
    spiBitbang_complete_v2_2_P.ResTimer_Amp : 0.0;
  if (spiBitbang_complete_v2_2_DW.clockTickCounter_n >=
      spiBitbang_complete_v2_2_P.ResTimer_Period - 1.0) {
    spiBitbang_complete_v2_2_DW.clockTickCounter_n = 0;
  } else {
    spiBitbang_complete_v2_2_DW.clockTickCounter_n++;
  }

  /* End of DiscretePulseGenerator: '<Root>/ResTimer ' */

  /* Logic: '<Root>/Logical Operator2' */
  rtb_LogicalOperator2 = !(rtb_ResTimer1 != 0.0);

  /* Memory: '<S25>/TmpLatchAtD Flip-FlopInport1' */
  rtb_txStream = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_g;

  /* Outputs for Enabled and Triggered SubSystem: '<S25>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_txStream,
    &spiBitbang_complete_v2_2_B.DFlipFlop_g,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_g, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_g,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_g);

  /* End of Outputs for SubSystem: '<S25>/D Flip-Flop' */

  /* Memory: '<S26>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_m;

  /* Outputs for Enabled and Triggered SubSystem: '<S26>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q,
    &spiBitbang_complete_v2_2_B.DFlipFlop_a,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_a, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_a,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_a);

  /* End of Outputs for SubSystem: '<S26>/D Flip-Flop' */

  /* Memory: '<S27>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_g = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_o;

  /* Outputs for Enabled and Triggered SubSystem: '<S27>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_g,
    &spiBitbang_complete_v2_2_B.DFlipFlop_h,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_h, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_h,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_h);

  /* End of Outputs for SubSystem: '<S27>/D Flip-Flop' */

  /* Memory: '<S28>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_m = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_n;

  /* Outputs for Enabled and Triggered SubSystem: '<S28>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_m,
    &spiBitbang_complete_v2_2_B.DFlipFlop_m,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_m, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_m,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_m);

  /* End of Outputs for SubSystem: '<S28>/D Flip-Flop' */

  /* Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_o = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_k;

  /* Outputs for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_o,
    &spiBitbang_complete_v2_2_B.DFlipFlop_b,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_b, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_b,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_b);

  /* End of Outputs for SubSystem: '<S14>/D Flip-Flop' */

  /* Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_n = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_gk;

  /* Outputs for Enabled and Triggered SubSystem: '<S15>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_n,
    &spiBitbang_complete_v2_2_B.DFlipFlop_o,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_o, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_o,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_o);

  /* End of Outputs for SubSystem: '<S15>/D Flip-Flop' */

  /* Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_f = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_j;

  /* Outputs for Enabled and Triggered SubSystem: '<S23>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_f,
    &spiBitbang_complete_v2_2_B.DFlipFlop_l,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_l, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_l,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_l);

  /* End of Outputs for SubSystem: '<S23>/D Flip-Flop' */

  /* Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_n2 = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_d;

  /* Outputs for Enabled and Triggered SubSystem: '<S24>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_n2,
    &spiBitbang_complete_v2_2_B.DFlipFlop_j,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_j, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_j,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_j);

  /* End of Outputs for SubSystem: '<S24>/D Flip-Flop' */

  /* Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_mq = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_np;

  /* Outputs for Enabled and Triggered SubSystem: '<S16>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_mq,
    &spiBitbang_complete_v2_2_B.DFlipFlop_e,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_e, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_e,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_e);

  /* End of Outputs for SubSystem: '<S16>/D Flip-Flop' */

  /* Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_a = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_n0;

  /* Outputs for Enabled and Triggered SubSystem: '<S17>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_a,
    &spiBitbang_complete_v2_2_B.DFlipFlop_as,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_as, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_as,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_as);

  /* End of Outputs for SubSystem: '<S17>/D Flip-Flop' */

  /* Memory: '<S18>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_of = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_ja;

  /* Outputs for Enabled and Triggered SubSystem: '<S18>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_of,
    &spiBitbang_complete_v2_2_B.DFlipFlop_gy,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_gy, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_gy,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_gy);

  /* End of Outputs for SubSystem: '<S18>/D Flip-Flop' */

  /* Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_m5 = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_nq;

  /* Outputs for Enabled and Triggered SubSystem: '<S19>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_m5,
    &spiBitbang_complete_v2_2_B.DFlipFlop_p,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_p, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_p,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_p);

  /* End of Outputs for SubSystem: '<S19>/D Flip-Flop' */

  /* Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_nw = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_h;

  /* Outputs for Enabled and Triggered SubSystem: '<S20>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_nw,
    &spiBitbang_complete_v2_2_B.DFlipFlop_ht,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_ht, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_ht,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_ht);

  /* End of Outputs for SubSystem: '<S20>/D Flip-Flop' */

  /* Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  rtb_Q_od = spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_oj;

  /* Outputs for Enabled and Triggered SubSystem: '<S21>/D Flip-Flop' */
  spiBitbang_complete_v_DFlipFlop(rtb_LogicalOperator2,
    spiBitbang_complete_v2_2_B.clk_delayed, rtb_Q_od,
    &spiBitbang_complete_v2_2_B.DFlipFlop_hh,
    &spiBitbang_complete_v2_2_DW.DFlipFlop_hh, (P_DFlipFlop_spiBitbang_comple_T *)
    &spiBitbang_complete_v2_2_P.DFlipFlop_hh,
    &spiBitbang_complete_v2__PrevZCX.DFlipFlop_hh);

  /* End of Outputs for SubSystem: '<S21>/D Flip-Flop' */

  /* Outputs for Enabled and Triggered SubSystem: '<S22>/D Flip-Flop' incorporates:
   *  EnablePort: '<S40>/C'
   *  TriggerPort: '<S40>/Trigger'
   */
  rt_ZCFcn(RISING_ZERO_CROSSING,
           &spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_p,
           (spiBitbang_complete_v2_2_B.clk_delayed));
  if (rtb_LogicalOperator2) {
    if (!spiBitbang_complete_v2_2_DW.DFlipFlop_MODE_k) {
      spiBitbang_complete_v2_2_DW.DFlipFlop_MODE_k = TRUE;
    }
  } else {
    if (spiBitbang_complete_v2_2_DW.DFlipFlop_MODE_k) {
      spiBitbang_complete_v2_2_DW.DFlipFlop_MODE_k = FALSE;
    }
  }

  /* End of Outputs for SubSystem: '<S22>/D Flip-Flop' */

  /* Logic: '<S3>/Logical Operator' */
  spiBitbang_complete_v2_2_B.LogicalOperator = !rtb_LogicalOperator2;

  /* S-Function (sdspcount2): '<S3>/Counter' */
  if (MWDSP_EPH_R_B(spiBitbang_complete_v2_2_B.LogicalOperator,
                    &spiBitbang_complete_v2_2_DW.Counter_RstEphState_m) != 0U) {
    spiBitbang_complete_v2_2_DW.Counter_Count_o =
      spiBitbang_complete_v2_2_P.Counter_InitialCount_h;
  }

  if (MWDSP_EPH_R_D(spiBitbang_complete_v2_2_B.clk_delayed,
                    &spiBitbang_complete_v2_2_DW.Counter_ClkEphState_g) != 0U) {
    if (spiBitbang_complete_v2_2_DW.Counter_Count_o < 255) {
      spiBitbang_complete_v2_2_DW.Counter_Count_o++;
    } else {
      spiBitbang_complete_v2_2_DW.Counter_Count_o = 0U;
    }
  }

  /* End of S-Function (sdspcount2): '<S3>/Counter' */

  /* DiscretePulseGenerator: '<Root>/ResTimer 1' */
  if (spiBitbang_complete_v2_2_DW.clockTickCounter_l >=
      spiBitbang_complete_v2_2_P.ResTimer1_Period - 1.0) {
    spiBitbang_complete_v2_2_DW.clockTickCounter_l = 0;
  } else {
    spiBitbang_complete_v2_2_DW.clockTickCounter_l++;
  }

  /* End of DiscretePulseGenerator: '<Root>/ResTimer 1' */
}

/* Model update function */
void spiBitbang_complete_v2_2_update(void)
{
  int_T idxDelay;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  spiBitbang_complete_v2_2_DW.UnitDelay_DSTATE = spiBitbang_complete_v2_2_B.En16;

  /* Update for Memory: '<S10>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Prev =
    spiBitbang_complete_v2_2_B.cast11;

  /* Update for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  Update for EnablePort: '<S7>/Enable'
   */
  if (spiBitbang_complete_v2_2_DW.TxSubsystem_MODE) {
    /* Update for Delay: '<S7>/Delay1' */
    for (idxDelay = 0; idxDelay < 5; idxDelay++) {
      spiBitbang_complete_v2_2_DW.Delay1_DSTATE[idxDelay] =
        spiBitbang_complete_v2_2_DW.Delay1_DSTATE[idxDelay + 1];
    }

    spiBitbang_complete_v2_2_DW.Delay1_DSTATE[5] =
      spiBitbang_complete_v2_2_B.clk;

    /* End of Update for Delay: '<S7>/Delay1' */
  }

  /* End of Update for SubSystem: '<Root>/TxSubsystem' */

  /* Update for Memory: '<S25>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_g =
    spiBitbang_complete_v2_2_B.conv2;

  /* Update for Memory: '<S26>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_m =
    spiBitbang_complete_v2_2_B.DFlipFlop_g.D;

  /* Update for Memory: '<S27>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_o =
    spiBitbang_complete_v2_2_B.DFlipFlop_a.D;

  /* Update for Memory: '<S28>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_n =
    spiBitbang_complete_v2_2_B.DFlipFlop_h.D;

  /* Update for Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_k =
    spiBitbang_complete_v2_2_B.DFlipFlop_m.D;

  /* Update for Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_gk =
    spiBitbang_complete_v2_2_B.DFlipFlop_b.D;

  /* Update for Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_j =
    spiBitbang_complete_v2_2_B.DFlipFlop_o.D;

  /* Update for Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_d =
    spiBitbang_complete_v2_2_B.DFlipFlop_l.D;

  /* Update for Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_np =
    spiBitbang_complete_v2_2_B.DFlipFlop_j.D;

  /* Update for Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_n0 =
    spiBitbang_complete_v2_2_B.DFlipFlop_e.D;

  /* Update for Memory: '<S18>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_ja =
    spiBitbang_complete_v2_2_B.DFlipFlop_as.D;

  /* Update for Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_nq =
    spiBitbang_complete_v2_2_B.DFlipFlop_gy.D;

  /* Update for Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_h =
    spiBitbang_complete_v2_2_B.DFlipFlop_p.D;

  /* Update for Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_oj =
    spiBitbang_complete_v2_2_B.DFlipFlop_ht.D;

  /* Update for Memory: '<S22>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_p =
    spiBitbang_complete_v2_2_B.DFlipFlop_hh.D;
}

/* Model initialize function */
void spiBitbang_complete_v2_2_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize error status */
  rtmSetErrorStatus(spiBitbang_complete_v2_2_M, (NULL));

  /* block I/O */
  (void) memset(((void *) &spiBitbang_complete_v2_2_B), 0,
                sizeof(B_spiBitbang_complete_v2_2_T));

  /* states (dwork) */
  (void) memset((void *)&spiBitbang_complete_v2_2_DW, 0,
                sizeof(DW_spiBitbang_complete_v2_2_T));

  {
    int32_T i;
    uint8_T tmp;
    uint8_T tmp_0;
    uint8_T tmp_1;
    uint8_T tmp_2;

    /* Start for DiscretePulseGenerator: '<S1>/f_sck' */
    spiBitbang_complete_v2_2_DW.clockTickCounter = 0;

    /* Start for Enabled and Triggered SubSystem: '<S10>/D Flip-Flop' */
    /* VirtualOutportStart for Outport: '<S11>/Q' */
    spiBitbang_complete_v2_2_B.D = spiBitbang_complete_v2_2_P.Q_Y0;

    /* End of Start for SubSystem: '<S10>/D Flip-Flop' */

    /* Start for DiscretePulseGenerator: '<Root>/Start16BitRead' */
    spiBitbang_complete_v2_2_DW.clockTickCounter_c = -100;

    /* Start for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
    tmp_2 = 0U;
    MW_gpioInit(9U, 1U, 1U, &tmp_2);

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* Start for Triggered SubSystem: '<S7>/Bitmask' */
    /* VirtualOutportStart for Outport: '<S47>/out' */
    spiBitbang_complete_v2_2_B.BitwiseOperator =
      spiBitbang_complete_v2_2_P.out_Y0;

    /* End of Start for SubSystem: '<S7>/Bitmask' */
    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* InitializeConditions for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* InitializeConditions for Triggered SubSystem: '<S7>/Bitmask' */
    /* InitializeConditions for UnitDelay: '<S49>/Output' */
    spiBitbang_complete_v2_2_DW.Output_DSTATE =
      spiBitbang_complete_v2_2_P.Output_InitialCondition;

    /* End of InitializeConditions for SubSystem: '<S7>/Bitmask' */

    /* InitializeConditions for Delay: '<S7>/Delay1' */
    for (i = 0; i < 6; i++) {
      spiBitbang_complete_v2_2_DW.Delay1_DSTATE[i] =
        spiBitbang_complete_v2_2_P.Delay1_InitialCondition;
    }

    /* End of InitializeConditions for Delay: '<S7>/Delay1' */
    /* End of InitializeConditions for SubSystem: '<Root>/TxSubsystem' */

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* VirtualOutportStart for Outport: '<S7>/cs' */
    spiBitbang_complete_v2_2_B.gen_CS = spiBitbang_complete_v2_2_P.cs_Y0;

    /* VirtualOutportStart for Outport: '<S7>/tx' */
    spiBitbang_complete_v2_2_B.conv2 = spiBitbang_complete_v2_2_P.tx_Y0;

    /* VirtualOutportStart for Outport: '<S7>/clk_delayed' */
    spiBitbang_complete_v2_2_B.clk_delayed =
      spiBitbang_complete_v2_2_P.clk_delayed_Y0;

    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
    tmp_1 = spiBitbang_complete_v2_2_P.CSn_p4;
    MW_gpioInit(spiBitbang_complete_v2_2_P.CSn_p1,
                spiBitbang_complete_v2_2_P.CSn_p2,
                spiBitbang_complete_v2_2_P.CSn_p3, &tmp_1);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
    tmp_0 = spiBitbang_complete_v2_2_P.MOSI_p4;
    MW_gpioInit(spiBitbang_complete_v2_2_P.MOSI_p1,
                spiBitbang_complete_v2_2_P.MOSI_p2,
                spiBitbang_complete_v2_2_P.MOSI_p3, &tmp_0);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
    tmp = spiBitbang_complete_v2_2_P.SCK_p4;
    MW_gpioInit(spiBitbang_complete_v2_2_P.SCK_p1,
                spiBitbang_complete_v2_2_P.SCK_p2,
                spiBitbang_complete_v2_2_P.SCK_p3, &tmp);

    /* Start for DiscretePulseGenerator: '<Root>/ResTimer ' */
    spiBitbang_complete_v2_2_DW.clockTickCounter_n = -70;

    /* Start for Enabled and Triggered SubSystem: '<S25>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_g,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_g);

    /* End of Start for SubSystem: '<S25>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S26>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_a,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_a);

    /* End of Start for SubSystem: '<S26>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S27>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_h,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_h);

    /* End of Start for SubSystem: '<S27>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S28>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_m,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_m);

    /* End of Start for SubSystem: '<S28>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S14>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_b,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_b);

    /* End of Start for SubSystem: '<S14>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S15>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_o,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_o);

    /* End of Start for SubSystem: '<S15>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S23>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_l,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_l);

    /* End of Start for SubSystem: '<S23>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S24>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_j,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_j);

    /* End of Start for SubSystem: '<S24>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S16>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_e,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_e);

    /* End of Start for SubSystem: '<S16>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S17>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_as,
      (P_DFlipFlop_spiBitbang_comple_T *)
      &spiBitbang_complete_v2_2_P.DFlipFlop_as);

    /* End of Start for SubSystem: '<S17>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S18>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_gy,
      (P_DFlipFlop_spiBitbang_comple_T *)
      &spiBitbang_complete_v2_2_P.DFlipFlop_gy);

    /* End of Start for SubSystem: '<S18>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S19>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_p,
      (P_DFlipFlop_spiBitbang_comple_T *)&spiBitbang_complete_v2_2_P.DFlipFlop_p);

    /* End of Start for SubSystem: '<S19>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S20>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_ht,
      (P_DFlipFlop_spiBitbang_comple_T *)
      &spiBitbang_complete_v2_2_P.DFlipFlop_ht);

    /* End of Start for SubSystem: '<S20>/D Flip-Flop' */

    /* Start for Enabled and Triggered SubSystem: '<S21>/D Flip-Flop' */
    spiBitbang_comp_DFlipFlop_Start(&spiBitbang_complete_v2_2_B.DFlipFlop_hh,
      (P_DFlipFlop_spiBitbang_comple_T *)
      &spiBitbang_complete_v2_2_P.DFlipFlop_hh);

    /* End of Start for SubSystem: '<S21>/D Flip-Flop' */

    /* Start for DiscretePulseGenerator: '<Root>/ResTimer 1' */
    spiBitbang_complete_v2_2_DW.clockTickCounter_l = 0;
  }

  spiBitbang_complete_v2__PrevZCX.Delay1_Reset_ZCE = UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.Bitmask_Trig_ZCE = UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.TriggeredSignalFromWorkspace_Tr = ZERO_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.TriggeredToWorkspace_Trig_ZCE = POS_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_m.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_h.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_a.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_g.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_j.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_l.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_p = UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_hh.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_ht.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_p.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_gy.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_as.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_e.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_o.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_b.DFlipFlop_Trig_ZCE =
    UNINITIALIZED_ZCSIG;
  spiBitbang_complete_v2__PrevZCX.DFlipFlop_Trig_ZCE_e = POS_ZCSIG;

  /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
  spiBitbang_complete_v2_2_DW.UnitDelay_DSTATE =
    spiBitbang_complete_v2_2_P.UnitDelay_InitialCondition;

  /* InitializeConditions for Memory: '<S10>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Prev =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/f_sck_OnOff' */
  spiBitbang_complete_v2_2_DW.f_sck_OnOff_Counter = (uint32_T) 0;

  /* InitializeConditions for S-Function (sdspcount2): '<S1>/Counter' */
  spiBitbang_complete_v2_2_DW.Counter_ClkEphState = 5U;
  spiBitbang_complete_v2_2_DW.Counter_RstEphState = 5U;
  spiBitbang_complete_v2_2_DW.Counter_Count =
    spiBitbang_complete_v2_2_P.Counter_InitialCount;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/N-Sample Enable' */
  spiBitbang_complete_v2_2_DW.NSampleEnable_Counter = (uint32_T) 0;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<S4>/N-Sample Enable' */
  spiBitbang_complete_v2_2_DW.NSampleEnable_Counter_o = (uint32_T) 0;

  /* InitializeConditions for Memory: '<S25>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_g =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_l;

  /* InitializeConditions for Memory: '<S26>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_m =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_j;

  /* InitializeConditions for Memory: '<S27>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_o =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_a;

  /* InitializeConditions for Memory: '<S28>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_n =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_h;

  /* InitializeConditions for Memory: '<S14>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_k =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_g;

  /* InitializeConditions for Memory: '<S15>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_gk =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_e;

  /* InitializeConditions for Memory: '<S23>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_j =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_n;

  /* InitializeConditions for Memory: '<S24>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_d =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_jo;

  /* InitializeConditions for Memory: '<S16>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_np =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_gi;

  /* InitializeConditions for Memory: '<S17>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_n0 =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_jw;

  /* InitializeConditions for Memory: '<S18>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_ja =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_b;

  /* InitializeConditions for Memory: '<S19>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_nq =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_p;

  /* InitializeConditions for Memory: '<S20>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_h =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1__jwm;

  /* InitializeConditions for Memory: '<S21>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_P_oj =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X0_f;

  /* InitializeConditions for Memory: '<S22>/TmpLatchAtD Flip-FlopInport1' */
  spiBitbang_complete_v2_2_DW.TmpLatchAtDFlipFlopInport1_Pr_p =
    spiBitbang_complete_v2_2_P.TmpLatchAtDFlipFlopInport1_X_h4;

  /* InitializeConditions for S-Function (sdspcount2): '<S3>/Counter' */
  spiBitbang_complete_v2_2_DW.Counter_ClkEphState_g = 5U;
  spiBitbang_complete_v2_2_DW.Counter_RstEphState_m = 5U;
  spiBitbang_complete_v2_2_DW.Counter_Count_o =
    spiBitbang_complete_v2_2_P.Counter_InitialCount_h;
}

/* Model terminate function */
void spiBitbang_complete_v2_2_terminate(void)
{
  /* Terminate for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  MW_gpioTerminate(9U);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
  MW_gpioTerminate(spiBitbang_complete_v2_2_P.CSn_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioTerminate(spiBitbang_complete_v2_2_P.MOSI_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
  MW_gpioTerminate(spiBitbang_complete_v2_2_P.SCK_p1);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
