/*
 * File: shiftregisterTut_v2_4_pi.c
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
#define shiftregisterTut_v2_4_POS_ZCSIG ((uint8_T)1U)

/* Block signals (auto storage) */
B_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_B;

/* Block states (auto storage) */
DW_shiftregisterTut_v2_4_pi_T shiftregisterTut_v2_4_pi_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_shiftregisterTut_v2_4_T shiftregisterTut_v2_4_p_PrevZCX;

/* Real-time model */
RT_MODEL_shiftregisterTut_v2__T shiftregisterTut_v2_4_pi_M_;
RT_MODEL_shiftregisterTut_v2__T *const shiftregisterTut_v2_4_pi_M =
  &shiftregisterTut_v2_4_pi_M_;
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
void shiftregisterTut_v2_4_pi_output(void)
{
  /* local block i/o variables */
  boolean_T rtb_Counter_o2;
  real_T rtb_Switch;
  boolean_T rtb_ManualSwitch;
  uint16_T rtb_u;
  int32_T i;
  real_T tmp;
  real_T tmp_0;

  /* DiscretePulseGenerator: '<S1>/f_sck' */
  rtb_Switch = (shiftregisterTut_v2_4_pi_DW.clockTickCounter <
                shiftregisterTut_v2_4_pi_P.f_sck_Duty) &&
    (shiftregisterTut_v2_4_pi_DW.clockTickCounter >= 0) ?
    shiftregisterTut_v2_4_pi_P.f_sck_Amp : 0.0;
  if (shiftregisterTut_v2_4_pi_DW.clockTickCounter >=
      shiftregisterTut_v2_4_pi_P.f_sck_Period - 1.0) {
    shiftregisterTut_v2_4_pi_DW.clockTickCounter = 0;
  } else {
    shiftregisterTut_v2_4_pi_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<S1>/f_sck' */

  /* Outputs for Enabled and Triggered SubSystem: '<S8>/D Flip-Flop' incorporates:
   *  EnablePort: '<S9>/C'
   *  TriggerPort: '<S9>/Trigger'
   */
  /* Constant: '<Root>/stop2' */
  if (shiftregisterTut_v2_4_pi_P.stop2_Value > 0.0) {
    if (!shiftregisterTut_v2_4_pi_DW.DFlipFlop_MODE) {
      shiftregisterTut_v2_4_pi_DW.DFlipFlop_MODE = TRUE;
    }

    /* Outputs for Enabled and Triggered SubSystem: '<S8>/D Flip-Flop' incorporates:
     *  EnablePort: '<S9>/C'
     *  TriggerPort: '<S9>/Trigger'
     */
    /* DataTypeConversion: '<S1>/cast1 ' incorporates:
     *  Inport: '<S9>/D'
     *  Memory: '<S8>/TmpLatchAtD Flip-FlopInport1'
     */
    if ((rtb_Switch != 0.0) &&
        (shiftregisterTut_v2_4_p_PrevZCX.DFlipFlop_Trig_ZCE != POS_ZCSIG)) {
      shiftregisterTut_v2_4_pi_B.D =
        shiftregisterTut_v2_4_pi_DW.TmpLatchAtDFlipFlopInport1_Prev;
    }

    shiftregisterTut_v2_4_p_PrevZCX.DFlipFlop_Trig_ZCE = (uint8_T)(rtb_Switch !=
      0.0 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  } else {
    if (shiftregisterTut_v2_4_pi_DW.DFlipFlop_MODE) {
      /* Disable for Outport: '<S9>/Q' */
      shiftregisterTut_v2_4_pi_B.D = shiftregisterTut_v2_4_pi_P.Q_Y0;
      shiftregisterTut_v2_4_pi_DW.DFlipFlop_MODE = FALSE;
    }

    /* DataTypeConversion: '<S1>/cast1 ' */
    shiftregisterTut_v2_4_p_PrevZCX.DFlipFlop_Trig_ZCE = (uint8_T)(rtb_Switch !=
      0.0 ? (int32_T)POS_ZCSIG : (int32_T)ZERO_ZCSIG);
  }

  /* End of Outputs for SubSystem: '<S8>/D Flip-Flop' */

  /* Logic: '<S1>/and3' incorporates:
   *  DataTypeConversion: '<S1>/cast1 '
   *  Logic: '<S1>/and1'
   *  Logic: '<S1>/and2'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  rtb_ManualSwitch = ((shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE_p &&
                       (rtb_Switch != 0.0)) || ((rtb_Switch != 0.0) &&
    shiftregisterTut_v2_4_pi_B.D));

  /* S-Function (sdspcount2): '<S1>/Counter' incorporates:
   *  Constant: '<Root>/stop2'
   */
  if (MWDSP_EPH_R_D(shiftregisterTut_v2_4_pi_P.stop2_Value,
                    &shiftregisterTut_v2_4_pi_DW.Counter_RstEphState) != 0U) {
    shiftregisterTut_v2_4_pi_DW.Counter_Count =
      shiftregisterTut_v2_4_pi_P.Counter_InitialCount;
  }

  if (MWDSP_EPH_R_B(rtb_ManualSwitch,
                    &shiftregisterTut_v2_4_pi_DW.Counter_ClkEphState) != 0U) {
    if (shiftregisterTut_v2_4_pi_DW.Counter_Count < 16) {
      shiftregisterTut_v2_4_pi_DW.Counter_Count++;
    } else {
      shiftregisterTut_v2_4_pi_DW.Counter_Count = 0U;
    }
  }

  /* Logic: '<S1>/and5' incorporates:
   *  Constant: '<S6>/Constant'
   *  Constant: '<S7>/Constant'
   *  RelationalOperator: '<S6>/Compare'
   *  RelationalOperator: '<S7>/Compare'
   *  S-Function (sdspcount2): '<S1>/Counter'
   */
  shiftregisterTut_v2_4_pi_B.En16 = ((shiftregisterTut_v2_4_pi_DW.Counter_Count >
    shiftregisterTut_v2_4_pi_P.Constant_Value_o) &&
    (shiftregisterTut_v2_4_pi_DW.Counter_Count <=
     shiftregisterTut_v2_4_pi_P.Constant_Value_b));

  /* Logic: '<S1>/and4' incorporates:
   *  DataTypeConversion: '<S1>/cast1 '
   */
  shiftregisterTut_v2_4_pi_B.clk16 = ((rtb_Switch != 0.0) &&
    shiftregisterTut_v2_4_pi_B.En16);

  /* DiscretePulseGenerator: '<Root>/Start16BitRead' */
  rtb_Switch = (shiftregisterTut_v2_4_pi_DW.clockTickCounter_i <
                shiftregisterTut_v2_4_pi_P.Start16BitRead_Duty) &&
    (shiftregisterTut_v2_4_pi_DW.clockTickCounter_i >= 0) ?
    shiftregisterTut_v2_4_pi_P.Start16BitRead_Amp : 0.0;
  if (shiftregisterTut_v2_4_pi_DW.clockTickCounter_i >=
      shiftregisterTut_v2_4_pi_P.Start16BitRead_Period - 1.0) {
    shiftregisterTut_v2_4_pi_DW.clockTickCounter_i = 0;
  } else {
    shiftregisterTut_v2_4_pi_DW.clockTickCounter_i++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Start16BitRead' */

  /* Switch: '<Root>/Switch' incorporates:
   *  Constant: '<Root>/delay1'
   *  Constant: '<Root>/stop1'
   */
  if (!(shiftregisterTut_v2_4_pi_P.delay1_Value >=
        shiftregisterTut_v2_4_pi_P.Switch_Threshold)) {
    rtb_Switch = shiftregisterTut_v2_4_pi_P.stop1_Value;
  }

  /* End of Switch: '<Root>/Switch' */

  /* Outputs for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  EnablePort: '<S5>/Enable'
   */
  /* Logic: '<Root>/Logical Operator' incorporates:
   *  Constant: '<S5>/Constant2'
   */
  if ((rtb_Switch != 0.0) || shiftregisterTut_v2_4_pi_B.En16) {
    if (!shiftregisterTut_v2_4_pi_DW.TxSubsystem_MODE) {
      /* InitializeConditions for Triggered SubSystem: '<S5>/Bitmask' */
      /* InitializeConditions for UnitDelay: '<S16>/Output' */
      shiftregisterTut_v2_4_pi_DW.Output_DSTATE =
        shiftregisterTut_v2_4_pi_P.Output_InitialCondition;

      /* End of InitializeConditions for SubSystem: '<S5>/Bitmask' */

      /* InitializeConditions for Delay: '<S5>/Delay1' */
      for (i = 0; i < 6; i++) {
        shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[i] =
          shiftregisterTut_v2_4_pi_P.Delay1_InitialCondition;
      }

      /* End of InitializeConditions for Delay: '<S5>/Delay1' */
      shiftregisterTut_v2_4_pi_DW.TxSubsystem_MODE = TRUE;
    }

    /* Outputs for Triggered SubSystem: '<S5>/Bitmask' incorporates:
     *  TriggerPort: '<S14>/Trigger'
     */
    if (shiftregisterTut_v2_4_pi_B.clk16 &&
        (shiftregisterTut_v2_4_p_PrevZCX.Bitmask_Trig_ZCE != POS_ZCSIG)) {
      /* Sum: '<S17>/FixPt Sum1' incorporates:
       *  Constant: '<S17>/FixPt Constant'
       *  UnitDelay: '<S16>/Output'
       */
      rtb_u = (uint16_T)((uint16_T)((uint32_T)
        shiftregisterTut_v2_4_pi_DW.Output_DSTATE +
        shiftregisterTut_v2_4_pi_P.FixPtConstant_Value) & 16383);

      /* DataTypeConversion: '<S14>/conv2' incorporates:
       *  Constant: '<S5>/Constant1'
       */
      tmp = floor(shiftregisterTut_v2_4_pi_P.Constant1_Value);
      if (rtIsNaN(tmp) || rtIsInf(tmp)) {
        tmp = 0.0;
      } else {
        tmp = fmod(tmp, 65536.0);
      }

      /* DataTypeConversion: '<S14>/conv1' incorporates:
       *  Constant: '<S14>/Constant'
       *  Sum: '<S14>/Sum'
       *  UnitDelay: '<S16>/Output'
       */
      tmp_0 = floor((real_T)shiftregisterTut_v2_4_pi_DW.Output_DSTATE +
                    shiftregisterTut_v2_4_pi_P.Constant_Value);
      if (rtIsNaN(tmp_0) || rtIsInf(tmp_0)) {
        tmp_0 = 0.0;
      } else {
        tmp_0 = fmod(tmp_0, 65536.0);
      }

      /* ArithShift: '<S14>/Shift Arithmetic' incorporates:
       *  DataTypeConversion: '<S14>/conv1'
       *  DataTypeConversion: '<S14>/conv2'
       */
      shiftregisterTut_v2_4_pi_B.shiftout = (uint16_T)((uint16_T)(tmp < 0.0 ?
        (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp : (int32_T)(uint16_T)tmp) <<
        (tmp_0 < 0.0 ? (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp_0 : (int32_T)
         (uint16_T)tmp_0));

      /* Switch: '<S18>/FixPt Switch' */
      if (rtb_u > shiftregisterTut_v2_4_pi_P.FixPtSwitch_Threshold) {
        /* Update for UnitDelay: '<S16>/Output' incorporates:
         *  Constant: '<S18>/Constant'
         */
        shiftregisterTut_v2_4_pi_DW.Output_DSTATE =
          shiftregisterTut_v2_4_pi_P.Constant_Value_f;
      } else {
        /* Update for UnitDelay: '<S16>/Output' */
        shiftregisterTut_v2_4_pi_DW.Output_DSTATE = rtb_u;
      }

      /* End of Switch: '<S18>/FixPt Switch' */
    }

    shiftregisterTut_v2_4_p_PrevZCX.Bitmask_Trig_ZCE = (uint8_T)
      (shiftregisterTut_v2_4_pi_B.clk16 ? (int32_T)POS_ZCSIG : (int32_T)
       ZERO_ZCSIG);

    /* End of Outputs for SubSystem: '<S5>/Bitmask' */
    shiftregisterTut_v2_4_pi_B.gen_CS =
      shiftregisterTut_v2_4_pi_P.Constant2_Value;

    /* Delay: '<S5>/Delay1' incorporates:
     *  Constant: '<S5>/Constant2'
     */
    rtb_ManualSwitch = (shiftregisterTut_v2_4_pi_B.gen_CS &&
                        (shiftregisterTut_v2_4_p_PrevZCX.Delay1_Reset_ZCE !=
                         shiftregisterTut_v2_4_POS_ZCSIG));
    shiftregisterTut_v2_4_p_PrevZCX.Delay1_Reset_ZCE =
      shiftregisterTut_v2_4_pi_B.gen_CS;
    if (rtb_ManualSwitch) {
      for (i = 0; i < 6; i++) {
        shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[i] =
          shiftregisterTut_v2_4_pi_P.Delay1_InitialCondition;
      }
    }

    shiftregisterTut_v2_4_pi_B.clk_delayed =
      shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[0];

    /* End of Delay: '<S5>/Delay1' */

    /* DataTypeConversion: '<S5>/cast1 6' incorporates:
     *  Constant: '<Root>/TxData'
     *  S-Function (sfix_bitop): '<S5>/Bitwise Operator'
     */
    shiftregisterTut_v2_4_pi_B.MOSI = ((shiftregisterTut_v2_4_pi_P.TxData_Value
      & shiftregisterTut_v2_4_pi_B.shiftout) != 0);
  } else {
    if (shiftregisterTut_v2_4_pi_DW.TxSubsystem_MODE) {
      /* Disable for Outport: '<S5>/clk_delayed' */
      shiftregisterTut_v2_4_pi_B.clk_delayed =
        shiftregisterTut_v2_4_pi_P.clk_delayed_Y0;

      /* Disable for Outport: '<S5>/cs' */
      shiftregisterTut_v2_4_pi_B.gen_CS = shiftregisterTut_v2_4_pi_P.cs_Y0;

      /* Disable for Outport: '<S5>/tx' */
      shiftregisterTut_v2_4_pi_B.MOSI = shiftregisterTut_v2_4_pi_P.tx_Y0;
      shiftregisterTut_v2_4_pi_DW.TxSubsystem_MODE = FALSE;
    }
  }

  /* End of Logic: '<Root>/Logical Operator' */
  /* End of Outputs for SubSystem: '<Root>/TxSubsystem' */

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
  MW_gpioWrite(shiftregisterTut_v2_4_pi_P.CSn_p1,
               shiftregisterTut_v2_4_pi_B.gen_CS);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioWrite(shiftregisterTut_v2_4_pi_P.MOSI_p1,
               shiftregisterTut_v2_4_pi_B.MOSI);

  /* S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
  MW_gpioWrite(shiftregisterTut_v2_4_pi_P.SCK_p1,
               shiftregisterTut_v2_4_pi_B.clk_delayed);

  /* S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  rtb_ManualSwitch = MW_gpioRead(9U);

  /* ManualSwitch: '<Root>/Manual Switch' */
  if (shiftregisterTut_v2_4_pi_P.ManualSwitch_CurrentSetting == 1) {
    /* DataTypeConversion: '<S2>/cast1 6' incorporates:
     *  S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read'
     */
    shiftregisterTut_v2_4_pi_B.cast16 = rtb_ManualSwitch;
  } else {
    /* DataTypeConversion: '<S2>/cast1 6' */
    shiftregisterTut_v2_4_pi_B.cast16 = shiftregisterTut_v2_4_pi_B.MOSI;
  }

  /* End of ManualSwitch: '<Root>/Manual Switch' */

  /* Outputs for Triggered SubSystem: '<S2>/TriggeredShifter' incorporates:
   *  TriggerPort: '<S11>/Trigger'
   */
  if (shiftregisterTut_v2_4_pi_B.clk_delayed &&
      (shiftregisterTut_v2_4_p_PrevZCX.TriggeredShifter_Trig_ZCE != POS_ZCSIG))
  {
    /* S-Function block: <S12>/S-Function  */
    {
      int nSamples = 16 ;
      int io = 0;
      int iv;
      int ind_Ps = shiftregisterTut_v2_4_pi_DW.SFunction_IWORK.indPs;

      /* Input present value(s) */
      ((real_T *)shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers)[ind_Ps] =
        shiftregisterTut_v2_4_pi_B.cast16;

      /* Output past value(s) */
      /* Output from present sample index to 0 */
      for (iv = ind_Ps; iv >= 0; --iv)
        (&shiftregisterTut_v2_4_pi_B.SFunction[0])[io++] = ((real_T *)
          shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers)[iv];

      /* Output from end of buffer to present sample index excl. */
      for (iv = nSamples-1; iv > ind_Ps; --iv)
        (&shiftregisterTut_v2_4_pi_B.SFunction[0])[io++] = ((real_T *)
          shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers)[iv];

      /* Update ring buffer index */
      if (++(shiftregisterTut_v2_4_pi_DW.SFunction_IWORK.indPs) == nSamples)
        shiftregisterTut_v2_4_pi_DW.SFunction_IWORK.indPs = 0;
    }
  }

  shiftregisterTut_v2_4_p_PrevZCX.TriggeredShifter_Trig_ZCE = (uint8_T)
    (shiftregisterTut_v2_4_pi_B.clk_delayed ? (int32_T)POS_ZCSIG : (int32_T)
     ZERO_ZCSIG);

  /* End of Outputs for SubSystem: '<S2>/TriggeredShifter' */

  /* RelationalOperator: '<S10>/Compare' incorporates:
   *  Constant: '<S10>/Constant'
   *  UnitDelay: '<S2>/Unit Delay'
   */
  shiftregisterTut_v2_4_pi_B.Compare =
    (shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE >=
     shiftregisterTut_v2_4_pi_P.Constant_Value_a);

  /* S-Function (sdspcount2): '<S2>/Counter' */
  rtb_Counter_o2 = FALSE;
  if (MWDSP_EPH_R_B(shiftregisterTut_v2_4_pi_B.Compare,
                    &shiftregisterTut_v2_4_pi_DW.Counter_RstEphState_b) != 0U) {
    shiftregisterTut_v2_4_pi_DW.Counter_Count_a =
      shiftregisterTut_v2_4_pi_P.Counter_InitialCount_n;
  }

  if (MWDSP_EPH_R_B(shiftregisterTut_v2_4_pi_B.clk_delayed,
                    &shiftregisterTut_v2_4_pi_DW.Counter_ClkEphState_k) != 0U) {
    if (shiftregisterTut_v2_4_pi_DW.Counter_Count_a < 17) {
      shiftregisterTut_v2_4_pi_DW.Counter_Count_a++;
    } else {
      shiftregisterTut_v2_4_pi_DW.Counter_Count_a = 0U;
    }
  }

  shiftregisterTut_v2_4_pi_B.Counter_o1 =
    shiftregisterTut_v2_4_pi_DW.Counter_Count_a;
  if (shiftregisterTut_v2_4_pi_DW.Counter_Count_a ==
      shiftregisterTut_v2_4_pi_P.Counter_HitValue_a) {
    rtb_Counter_o2 = TRUE;
  }

  /* End of S-Function (sdspcount2): '<S2>/Counter' */

  /* DataTypeConversion: '<S1>/cast1 1' */
  shiftregisterTut_v2_4_pi_B.cast11 = (rtb_Switch != 0.0);
}

/* Model update function */
void shiftregisterTut_v2_4_pi_update(void)
{
  int_T idxDelay;

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE_p =
    shiftregisterTut_v2_4_pi_B.En16;

  /* Update for Memory: '<S8>/TmpLatchAtD Flip-FlopInport1' */
  shiftregisterTut_v2_4_pi_DW.TmpLatchAtDFlipFlopInport1_Prev =
    shiftregisterTut_v2_4_pi_B.cast11;

  /* Update for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  Update for EnablePort: '<S5>/Enable'
   */
  if (shiftregisterTut_v2_4_pi_DW.TxSubsystem_MODE) {
    /* Update for Delay: '<S5>/Delay1' */
    for (idxDelay = 0; idxDelay < 5; idxDelay++) {
      shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[idxDelay] =
        shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[idxDelay + 1];
    }

    shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[5] =
      shiftregisterTut_v2_4_pi_B.clk16;

    /* End of Update for Delay: '<S5>/Delay1' */
  }

  /* End of Update for SubSystem: '<Root>/TxSubsystem' */

  /* Update for UnitDelay: '<S2>/Unit Delay' */
  shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE =
    shiftregisterTut_v2_4_pi_B.Counter_o1;
}

/* Model initialize function */
void shiftregisterTut_v2_4_pi_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize error status */
  rtmSetErrorStatus(shiftregisterTut_v2_4_pi_M, (NULL));

  /* block I/O */
  (void) memset(((void *) &shiftregisterTut_v2_4_pi_B), 0,
                sizeof(B_shiftregisterTut_v2_4_pi_T));

  /* states (dwork) */
  (void) memset((void *)&shiftregisterTut_v2_4_pi_DW, 0,
                sizeof(DW_shiftregisterTut_v2_4_pi_T));

  {
    int32_T i;
    uint8_T tmp;
    uint8_T tmp_0;
    uint8_T tmp_1;
    uint8_T tmp_2;

    /* Start for DiscretePulseGenerator: '<S1>/f_sck' */
    shiftregisterTut_v2_4_pi_DW.clockTickCounter = 0;

    /* Start for Enabled and Triggered SubSystem: '<S8>/D Flip-Flop' */
    /* VirtualOutportStart for Outport: '<S9>/Q' */
    shiftregisterTut_v2_4_pi_B.D = shiftregisterTut_v2_4_pi_P.Q_Y0;

    /* End of Start for SubSystem: '<S8>/D Flip-Flop' */

    /* Start for DiscretePulseGenerator: '<Root>/Start16BitRead' */
    shiftregisterTut_v2_4_pi_DW.clockTickCounter_i = -10;

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* Start for Triggered SubSystem: '<S5>/Bitmask' */
    /* VirtualOutportStart for Outport: '<S14>/out' */
    shiftregisterTut_v2_4_pi_B.shiftout = shiftregisterTut_v2_4_pi_P.out_Y0;

    /* End of Start for SubSystem: '<S5>/Bitmask' */

    /* Start for Constant: '<S5>/Constant2' */
    shiftregisterTut_v2_4_pi_B.gen_CS =
      shiftregisterTut_v2_4_pi_P.Constant2_Value;

    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* InitializeConditions for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* InitializeConditions for Triggered SubSystem: '<S5>/Bitmask' */
    /* InitializeConditions for UnitDelay: '<S16>/Output' */
    shiftregisterTut_v2_4_pi_DW.Output_DSTATE =
      shiftregisterTut_v2_4_pi_P.Output_InitialCondition;

    /* End of InitializeConditions for SubSystem: '<S5>/Bitmask' */

    /* InitializeConditions for Delay: '<S5>/Delay1' */
    for (i = 0; i < 6; i++) {
      shiftregisterTut_v2_4_pi_DW.Delay1_DSTATE[i] =
        shiftregisterTut_v2_4_pi_P.Delay1_InitialCondition;
    }

    /* End of InitializeConditions for Delay: '<S5>/Delay1' */
    /* End of InitializeConditions for SubSystem: '<Root>/TxSubsystem' */

    /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
    /* VirtualOutportStart for Outport: '<S5>/clk_delayed' */
    shiftregisterTut_v2_4_pi_B.clk_delayed =
      shiftregisterTut_v2_4_pi_P.clk_delayed_Y0;

    /* VirtualOutportStart for Outport: '<S5>/cs' */
    shiftregisterTut_v2_4_pi_B.gen_CS = shiftregisterTut_v2_4_pi_P.cs_Y0;

    /* VirtualOutportStart for Outport: '<S5>/tx' */
    shiftregisterTut_v2_4_pi_B.MOSI = shiftregisterTut_v2_4_pi_P.tx_Y0;

    /* End of Start for SubSystem: '<Root>/TxSubsystem' */

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
    tmp_2 = shiftregisterTut_v2_4_pi_P.CSn_p4;
    MW_gpioInit(shiftregisterTut_v2_4_pi_P.CSn_p1,
                shiftregisterTut_v2_4_pi_P.CSn_p2,
                shiftregisterTut_v2_4_pi_P.CSn_p3, &tmp_2);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
    tmp_1 = shiftregisterTut_v2_4_pi_P.MOSI_p4;
    MW_gpioInit(shiftregisterTut_v2_4_pi_P.MOSI_p1,
                shiftregisterTut_v2_4_pi_P.MOSI_p2,
                shiftregisterTut_v2_4_pi_P.MOSI_p3, &tmp_1);

    /* Start for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
    tmp_0 = shiftregisterTut_v2_4_pi_P.SCK_p4;
    MW_gpioInit(shiftregisterTut_v2_4_pi_P.SCK_p1,
                shiftregisterTut_v2_4_pi_P.SCK_p2,
                shiftregisterTut_v2_4_pi_P.SCK_p3, &tmp_0);

    /* Start for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
    tmp = 0U;
    MW_gpioInit(9U, 1U, 1U, &tmp);

    /* Start for Triggered SubSystem: '<S2>/TriggeredShifter' */

    /* S-Function Block: <S12>/S-Function  */
    {
      static real_T dnls_buffer[1 * 16];
      shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers = (void *)
        &dnls_buffer[0];
    }

    {
      int ids;

      /* Assign default sample(s) */
      if (shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers != NULL) {
        for (ids = 0; ids < 16; ++ids)
          ((real_T *)shiftregisterTut_v2_4_pi_DW.SFunction_PWORK.uBuffers)[ids] =
            (real_T)0.0;
      }

      /* Set work values */
      shiftregisterTut_v2_4_pi_DW.SFunction_IWORK.indPs = 0;
    }

    /* End of Start for SubSystem: '<S2>/TriggeredShifter' */
  }

  shiftregisterTut_v2_4_p_PrevZCX.Delay1_Reset_ZCE = POS_ZCSIG;
  shiftregisterTut_v2_4_p_PrevZCX.Bitmask_Trig_ZCE = POS_ZCSIG;
  shiftregisterTut_v2_4_p_PrevZCX.TriggToWb1.TriggToWb_Trig_ZCE = POS_ZCSIG;
  shiftregisterTut_v2_4_p_PrevZCX.TriggToWb.TriggToWb_Trig_ZCE = POS_ZCSIG;
  shiftregisterTut_v2_4_p_PrevZCX.TriggeredShifter_Trig_ZCE = POS_ZCSIG;
  shiftregisterTut_v2_4_p_PrevZCX.DFlipFlop_Trig_ZCE = POS_ZCSIG;

  /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
  shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE_p =
    shiftregisterTut_v2_4_pi_P.UnitDelay_InitialCondition_o;

  /* InitializeConditions for Memory: '<S8>/TmpLatchAtD Flip-FlopInport1' */
  shiftregisterTut_v2_4_pi_DW.TmpLatchAtDFlipFlopInport1_Prev =
    shiftregisterTut_v2_4_pi_P.TmpLatchAtDFlipFlopInport1_X0;

  /* InitializeConditions for S-Function (sdspcount2): '<S1>/Counter' */
  shiftregisterTut_v2_4_pi_DW.Counter_ClkEphState = 5U;
  shiftregisterTut_v2_4_pi_DW.Counter_RstEphState = 5U;
  shiftregisterTut_v2_4_pi_DW.Counter_Count =
    shiftregisterTut_v2_4_pi_P.Counter_InitialCount;

  /* InitializeConditions for UnitDelay: '<S2>/Unit Delay' */
  shiftregisterTut_v2_4_pi_DW.UnitDelay_DSTATE =
    shiftregisterTut_v2_4_pi_P.UnitDelay_InitialCondition;

  /* InitializeConditions for S-Function (sdspcount2): '<S2>/Counter' */
  shiftregisterTut_v2_4_pi_DW.Counter_ClkEphState_k = 5U;
  shiftregisterTut_v2_4_pi_DW.Counter_RstEphState_b = 5U;
  shiftregisterTut_v2_4_pi_DW.Counter_Count_a =
    shiftregisterTut_v2_4_pi_P.Counter_InitialCount_n;
}

/* Model terminate function */
void shiftregisterTut_v2_4_pi_terminate(void)
{
  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/CSn' */
  MW_gpioTerminate(shiftregisterTut_v2_4_pi_P.CSn_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/MOSI' */
  MW_gpioTerminate(shiftregisterTut_v2_4_pi_P.MOSI_p1);

  /* Terminate for S-Function (linuxGpioWrite_sfcn): '<Root>/SCK' */
  MW_gpioTerminate(shiftregisterTut_v2_4_pi_P.SCK_p1);

  /* Terminate for S-Function (linuxGpioRead_sfcn): '<Root>/GPIO Read' */
  MW_gpioTerminate(9U);

  /* Terminate for Triggered SubSystem: '<S2>/TriggeredShifter' */

  /* S-Function block: <S12>/S-Function  */
  {
    /* Nothing to do! */
  }

  /* End of Terminate for SubSystem: '<S2>/TriggeredShifter' */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
