/*
 * spiBitbang_MainClockDistr_v2.c
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

/* Block signals (auto storage) */
B_spiBitbang_MainClockDistr_v_T spiBitbang_MainClockDistr_v2_B;

/* Block states (auto storage) */
DW_spiBitbang_MainClockDistr__T spiBitbang_MainClockDistr_v2_DW;

/* Previous zero-crossings (trigger) states */
PrevZCX_spiBitbang_MainClockD_T spiBitbang_MainClockDis_PrevZCX;

/* Real-time model */
RT_MODEL_spiBitbang_MainClock_T spiBitbang_MainClockDistr_v2_M_;
RT_MODEL_spiBitbang_MainClock_T *const spiBitbang_MainClockDistr_v2_M =
  &spiBitbang_MainClockDistr_v2_M_;
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

/* Model step function */
void spiBitbang_MainClockDistr_v2_step(void)
{
  /* local block i/o variables */
  real_T rtb_conv1;
  real_T rtb_Sum[4];
  real_T rtb_conv3;
  real_T rtb_Transmit;
  boolean_T rtb_and3;
  ZCEventType zcEvent;
  uint16_T rtb_conv2;
  uint8_T rtb_FixPtSum1;
  int32_T i;
  uint32_T tmp;
  real_T tmp_0;

  /* DiscretePulseGenerator: '<S1>/f_sck' */
  rtb_conv3 = (spiBitbang_MainClockDistr_v2_DW.clockTickCounter <
               spiBitbang_MainClockDistr_v2_P.f_sck_Duty) &&
    (spiBitbang_MainClockDistr_v2_DW.clockTickCounter >= 0) ?
    spiBitbang_MainClockDistr_v2_P.f_sck_Amp : 0.0;
  if (spiBitbang_MainClockDistr_v2_DW.clockTickCounter >=
      spiBitbang_MainClockDistr_v2_P.f_sck_Period - 1.0) {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter = 0;
  } else {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<S1>/f_sck' */

  /* DataTypeConversion: '<S1>/cast1 ' */
  spiBitbang_MainClockDistr_v2_B.f_clk = (rtb_conv3 != 0.0);

  /* DiscretePulseGenerator: '<Root>/Start16BitRead' */
  rtb_conv3 = (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c <
               spiBitbang_MainClockDistr_v2_P.Start16BitRead_Duty) &&
    (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c >= 0) ?
    spiBitbang_MainClockDistr_v2_P.Start16BitRead_Amp : 0.0;
  if (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c >=
      spiBitbang_MainClockDistr_v2_P.Start16BitRead_Period - 1.0) {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c = 0;
  } else {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Start16BitRead' */
  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/N-Sample Enable' */
  {
    {
      if (spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter ==
          spiBitbang_MainClockDistr_v2_P.NSampleEnable_TARGETCNT) {
        spiBitbang_MainClockDistr_v2_B.NSampleEnable = (boolean_T)(2 -
          spiBitbang_MainClockDistr_v2_P.NSampleEnable_ACTLEVEL);
      } else {
        spiBitbang_MainClockDistr_v2_B.NSampleEnable = (boolean_T)
          (spiBitbang_MainClockDistr_v2_P.NSampleEnable_ACTLEVEL - 1);
        (spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter)++;
      }
    }
  }

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<S6>/N-Sample Enable' */
  {
    {
      if (spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter_o ==
          spiBitbang_MainClockDistr_v2_P.NSampleEnable_TARGETCNT_k) {
        spiBitbang_MainClockDistr_v2_B.NSampleEnable_m = (boolean_T)(2 -
          spiBitbang_MainClockDistr_v2_P.NSampleEnable_ACTLEVEL_n);
      } else {
        spiBitbang_MainClockDistr_v2_B.NSampleEnable_m = (boolean_T)
          (spiBitbang_MainClockDistr_v2_P.NSampleEnable_ACTLEVEL_n - 1);
        (spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter_o)++;
      }
    }
  }

  /* ManualSwitch: '<Root>/Transmit Command' incorporates:
   *  Constant: '<Root>/stop'
   *  Switch: '<S6>/Switch'
   */
  if (spiBitbang_MainClockDistr_v2_P.TransmitCommand_CurrentSetting == 1) {
    rtb_Transmit = rtb_conv3;
  } else if (spiBitbang_MainClockDistr_v2_B.NSampleEnable_m) {
    /* Switch: '<S6>/Switch' */
    rtb_Transmit = spiBitbang_MainClockDistr_v2_B.NSampleEnable;
  } else {
    rtb_Transmit = spiBitbang_MainClockDistr_v2_P.stop_Value;
  }

  /* End of ManualSwitch: '<Root>/Transmit Command' */

  /* Logic: '<S1>/and3' incorporates:
   *  Logic: '<S1>/and1'
   *  Logic: '<S1>/and2'
   *  UnitDelay: '<S1>/Unit Delay'
   */
  rtb_and3 = ((spiBitbang_MainClockDistr_v2_DW.UnitDelay_DSTATE &&
               spiBitbang_MainClockDistr_v2_B.f_clk) ||
              (spiBitbang_MainClockDistr_v2_B.f_clk && (rtb_Transmit != 0.0)));

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/f_sck_OnOff' */
  {
    {
      if (spiBitbang_MainClockDistr_v2_DW.f_sck_OnOff_Counter ==
          spiBitbang_MainClockDistr_v2_P.f_sck_OnOff_TARGETCNT) {
        spiBitbang_MainClockDistr_v2_B.interrupt = (boolean_T)(2 -
          spiBitbang_MainClockDistr_v2_P.f_sck_OnOff_ACTLEVEL);
      } else {
        spiBitbang_MainClockDistr_v2_B.interrupt = (boolean_T)
          (spiBitbang_MainClockDistr_v2_P.f_sck_OnOff_ACTLEVEL - 1);
        (spiBitbang_MainClockDistr_v2_DW.f_sck_OnOff_Counter)++;
      }
    }
  }

  /* S-Function (sdspcount2): '<S1>/Counter' */
  if (MWDSP_EPH_R_B(spiBitbang_MainClockDistr_v2_B.interrupt,
                    &spiBitbang_MainClockDistr_v2_DW.Counter_RstEphState) != 0U)
  {
    spiBitbang_MainClockDistr_v2_DW.Counter_Count =
      spiBitbang_MainClockDistr_v2_P.Counter_InitialCount;
  }

  if (MWDSP_EPH_R_B(rtb_and3,
                    &spiBitbang_MainClockDistr_v2_DW.Counter_ClkEphState) != 0U)
  {
    if (spiBitbang_MainClockDistr_v2_DW.Counter_Count < 16) {
      spiBitbang_MainClockDistr_v2_DW.Counter_Count++;
    } else {
      spiBitbang_MainClockDistr_v2_DW.Counter_Count = 0U;
    }
  }

  spiBitbang_MainClockDistr_v2_B.ctrGen =
    spiBitbang_MainClockDistr_v2_DW.Counter_Count;

  /* End of S-Function (sdspcount2): '<S1>/Counter' */

  /* RelationalOperator: '<S8>/Compare' incorporates:
   *  Constant: '<S8>/Constant'
   */
  spiBitbang_MainClockDistr_v2_B.g0 = (spiBitbang_MainClockDistr_v2_B.ctrGen >
    spiBitbang_MainClockDistr_v2_P.Constant_Value_a);

  /* Outputs for Enabled SubSystem: '<Root>/TxSubsystem' incorporates:
   *  EnablePort: '<S7>/Enable'
   */
  if (rtb_Transmit > 0.0) {
    if (!spiBitbang_MainClockDistr_v2_DW.TxSubsystem_MODE) {
      /* InitializeConditions for Delay: '<S7>/Delay1' */
      spiBitbang_MainClockDistr_v2_DW.icLoad = 1U;

      /* InitializeConditions for Triggered SubSystem: '<S7>/Bitmask' */
      /* InitializeConditions for UnitDelay: '<S15>/Output' */
      spiBitbang_MainClockDistr_v2_DW.Output_DSTATE =
        spiBitbang_MainClockDistr_v2_P.Output_InitialCondition;

      /* End of InitializeConditions for SubSystem: '<S7>/Bitmask' */
      spiBitbang_MainClockDistr_v2_DW.TxSubsystem_MODE = TRUE;
    }

    /* Constant: '<S7>/Constant' */
    spiBitbang_MainClockDistr_v2_B.gen_CS =
      spiBitbang_MainClockDistr_v2_P.Constant_Value_g;

    /* DataTypeConversion: '<S7>/conv1' incorporates:
     *  Logic: '<S1>/and4'
     */
    rtb_conv1 = (spiBitbang_MainClockDistr_v2_B.f_clk &&
                 spiBitbang_MainClockDistr_v2_B.g0);

    /* Delay: '<S7>/Delay1' incorporates:
     *  Constant: '<Root>/stop1'
     *  Constant: '<S7>/initial'
     */
    if (spiBitbang_MainClockDistr_v2_DW.icLoad != 0) {
      for (i = 0; i < 100; i++) {
        spiBitbang_MainClockDistr_v2_DW.Delay1_DSTATE[i] =
          spiBitbang_MainClockDistr_v2_P.initial_Value;
      }
    }

    if ((spiBitbang_MainClockDistr_v2_P.stop1_Value < 1.0) || rtIsNaN
        (spiBitbang_MainClockDistr_v2_P.stop1_Value)) {
      spiBitbang_MainClockDistr_v2_B.clk_delayed = rtb_conv1;
    } else {
      if (spiBitbang_MainClockDistr_v2_P.stop1_Value > 100.0) {
        tmp = 100U;
      } else {
        if (spiBitbang_MainClockDistr_v2_P.stop1_Value < 0.0) {
          rtb_Transmit = ceil(spiBitbang_MainClockDistr_v2_P.stop1_Value);
        } else {
          rtb_Transmit = floor(spiBitbang_MainClockDistr_v2_P.stop1_Value);
        }

        if (rtIsNaN(rtb_Transmit) || rtIsInf(rtb_Transmit)) {
          rtb_Transmit = 0.0;
        } else {
          rtb_Transmit = fmod(rtb_Transmit, 4.294967296E+9);
        }

        tmp = rtb_Transmit < 0.0 ? (uint32_T)-(int32_T)(uint32_T)-rtb_Transmit :
          (uint32_T)rtb_Transmit;
      }

      spiBitbang_MainClockDistr_v2_B.clk_delayed =
        spiBitbang_MainClockDistr_v2_DW.Delay1_DSTATE[100U - tmp];
    }

    /* End of Delay: '<S7>/Delay1' */

    /* Outputs for Triggered SubSystem: '<S7>/Bitmask' incorporates:
     *  TriggerPort: '<S12>/Trigger'
     */
    zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,
                       &spiBitbang_MainClockDis_PrevZCX.Bitmask_Trig_ZCE,
                       (spiBitbang_MainClockDistr_v2_B.clk_delayed));
    if (zcEvent != NO_ZCEVENT) {
      /* Sum: '<S16>/FixPt Sum1' incorporates:
       *  Constant: '<S16>/FixPt Constant'
       *  UnitDelay: '<S15>/Output'
       */
      rtb_conv2 = (uint16_T)((uint16_T)((uint32_T)
        spiBitbang_MainClockDistr_v2_DW.Output_DSTATE +
        spiBitbang_MainClockDistr_v2_P.FixPtConstant_Value) & 32767);

      /* DataTypeConversion: '<S12>/conv2' incorporates:
       *  Constant: '<S7>/Constant1'
       */
      rtb_Transmit = floor(spiBitbang_MainClockDistr_v2_P.Constant1_Value);
      if (rtIsNaN(rtb_Transmit) || rtIsInf(rtb_Transmit)) {
        rtb_Transmit = 0.0;
      } else {
        rtb_Transmit = fmod(rtb_Transmit, 65536.0);
      }

      /* DataTypeConversion: '<S12>/conv1' incorporates:
       *  Constant: '<S12>/Constant'
       *  Sum: '<S12>/Sum'
       *  UnitDelay: '<S15>/Output'
       */
      tmp_0 = floor((real_T)spiBitbang_MainClockDistr_v2_DW.Output_DSTATE +
                    spiBitbang_MainClockDistr_v2_P.Constant_Value);
      if (rtIsNaN(tmp_0) || rtIsInf(tmp_0)) {
        tmp_0 = 0.0;
      } else {
        tmp_0 = fmod(tmp_0, 65536.0);
      }

      /* ArithShift: '<S12>/Shift Arithmetic' incorporates:
       *  DataTypeConversion: '<S12>/conv1'
       *  DataTypeConversion: '<S12>/conv2'
       */
      spiBitbang_MainClockDistr_v2_B.ShiftArithmetic_e = (uint16_T)((uint16_T)
        (rtb_Transmit < 0.0 ? (int32_T)(uint16_T)-(int16_T)(uint16_T)
         -rtb_Transmit : (int32_T)(uint16_T)rtb_Transmit) << (tmp_0 < 0.0 ?
        (int32_T)(uint16_T)-(int16_T)(uint16_T)-tmp_0 : (int32_T)(uint16_T)tmp_0));

      /* Switch: '<S17>/FixPt Switch' */
      if (rtb_conv2 > spiBitbang_MainClockDistr_v2_P.FixPtSwitch_Threshold) {
        /* Update for UnitDelay: '<S15>/Output' incorporates:
         *  Constant: '<S17>/Constant'
         */
        spiBitbang_MainClockDistr_v2_DW.Output_DSTATE =
          spiBitbang_MainClockDistr_v2_P.Constant_Value_p;
      } else {
        /* Update for UnitDelay: '<S15>/Output' */
        spiBitbang_MainClockDistr_v2_DW.Output_DSTATE = rtb_conv2;
      }

      /* End of Switch: '<S17>/FixPt Switch' */
    }

    /* End of Outputs for SubSystem: '<S7>/Bitmask' */

    /* S-Function (sfix_bitop): '<S7>/Bitwise Operator' incorporates:
     *  Constant: '<Root>/stop2'
     */
    spiBitbang_MainClockDistr_v2_B.BitwiseOperator = (uint16_T)
      (spiBitbang_MainClockDistr_v2_P.stop2_Value &
       spiBitbang_MainClockDistr_v2_B.ShiftArithmetic_e);

    /* Update for Delay: '<S7>/Delay1' */
    spiBitbang_MainClockDistr_v2_DW.icLoad = 0U;
    for (i = 0; i < 99; i++) {
      spiBitbang_MainClockDistr_v2_DW.Delay1_DSTATE[i] =
        spiBitbang_MainClockDistr_v2_DW.Delay1_DSTATE[i + 1];
    }

    spiBitbang_MainClockDistr_v2_DW.Delay1_DSTATE[99] = rtb_conv1;

    /* End of Update for Delay: '<S7>/Delay1' */
  } else {
    if (spiBitbang_MainClockDistr_v2_DW.TxSubsystem_MODE) {
      spiBitbang_MainClockDistr_v2_DW.TxSubsystem_MODE = FALSE;
    }
  }

  /* End of Outputs for SubSystem: '<Root>/TxSubsystem' */

  /* DataTypeConversion: '<Root>/conv3' */
  rtb_conv3 = spiBitbang_MainClockDistr_v2_B.BitwiseOperator;

  /* Sum: '<Root>/Sum' incorporates:
   *  Constant: '<Root>/stop3'
   */
  rtb_Sum[0] = 0.0 + spiBitbang_MainClockDistr_v2_P.stop3_Value[0];
  rtb_Sum[1] = spiBitbang_MainClockDistr_v2_B.gen_CS +
    spiBitbang_MainClockDistr_v2_P.stop3_Value[1];
  rtb_Sum[2] = rtb_conv3 + spiBitbang_MainClockDistr_v2_P.stop3_Value[2];
  rtb_Sum[3] = spiBitbang_MainClockDistr_v2_B.clk_delayed +
    spiBitbang_MainClockDistr_v2_P.stop3_Value[3];

  /* DiscretePulseGenerator: '<Root>/Start16BitRead1' */
  rtb_Transmit = (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j <
                  spiBitbang_MainClockDistr_v2_P.Start16BitRead1_Duty) &&
    (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j >= 0) ?
    spiBitbang_MainClockDistr_v2_P.Start16BitRead1_Amp : 0.0;
  if (spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j >=
      spiBitbang_MainClockDistr_v2_P.Start16BitRead1_Period - 1.0) {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j = 0;
  } else {
    spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Start16BitRead1' */

  /* Outputs for Triggered SubSystem: '<Root>/Shifter' incorporates:
   *  TriggerPort: '<S4>/Trigger'
   */
  zcEvent = rt_ZCFcn(RISING_ZERO_CROSSING,
                     &spiBitbang_MainClockDis_PrevZCX.Shifter_Trig_ZCE,
                     (rtb_Transmit));
  if (zcEvent != NO_ZCEVENT) {
    /* UnitDelay: '<S9>/Output' */
    spiBitbang_MainClockDistr_v2_B.Output =
      spiBitbang_MainClockDistr_v2_DW.Output_DSTATE_c;

    /* Sum: '<S10>/FixPt Sum1' incorporates:
     *  Constant: '<S10>/FixPt Constant'
     */
    rtb_FixPtSum1 = (uint8_T)((uint8_T)((uint32_T)
      spiBitbang_MainClockDistr_v2_B.Output +
      spiBitbang_MainClockDistr_v2_P.FixPtConstant_Value_d) & 7);

    /* ArithShift: '<S4>/Shift Arithmetic' incorporates:
     *  Constant: '<Root>/Constant'
     */
    spiBitbang_MainClockDistr_v2_B.ShiftArithmetic = ldexp
      (spiBitbang_MainClockDistr_v2_P.Constant_Value_gq,
       spiBitbang_MainClockDistr_v2_B.Output);

    /* Switch: '<S11>/FixPt Switch' */
    if (rtb_FixPtSum1 > spiBitbang_MainClockDistr_v2_P.FixPtSwitch_Threshold_a)
    {
      /* Update for UnitDelay: '<S9>/Output' incorporates:
       *  Constant: '<S11>/Constant'
       */
      spiBitbang_MainClockDistr_v2_DW.Output_DSTATE_c =
        spiBitbang_MainClockDistr_v2_P.Constant_Value_p3;
    } else {
      /* Update for UnitDelay: '<S9>/Output' */
      spiBitbang_MainClockDistr_v2_DW.Output_DSTATE_c = rtb_FixPtSum1;
    }

    /* End of Switch: '<S11>/FixPt Switch' */
  }

  /* End of Outputs for SubSystem: '<Root>/Shifter' */

  /* Update for UnitDelay: '<S1>/Unit Delay' */
  spiBitbang_MainClockDistr_v2_DW.UnitDelay_DSTATE =
    spiBitbang_MainClockDistr_v2_B.g0;

  /* Matfile logging */
  rt_UpdateTXYLogVars(spiBitbang_MainClockDistr_v2_M->rtwLogInfo,
                      (&spiBitbang_MainClockDistr_v2_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [1.0E-6s, 0.0s] */
    if ((rtmGetTFinal(spiBitbang_MainClockDistr_v2_M)!=-1) &&
        !((rtmGetTFinal(spiBitbang_MainClockDistr_v2_M)-
           spiBitbang_MainClockDistr_v2_M->Timing.taskTime0) >
          spiBitbang_MainClockDistr_v2_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(spiBitbang_MainClockDistr_v2_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++spiBitbang_MainClockDistr_v2_M->Timing.clockTick0)) {
    ++spiBitbang_MainClockDistr_v2_M->Timing.clockTickH0;
  }

  spiBitbang_MainClockDistr_v2_M->Timing.taskTime0 =
    spiBitbang_MainClockDistr_v2_M->Timing.clockTick0 *
    spiBitbang_MainClockDistr_v2_M->Timing.stepSize0 +
    spiBitbang_MainClockDistr_v2_M->Timing.clockTickH0 *
    spiBitbang_MainClockDistr_v2_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void spiBitbang_MainClockDistr_v2_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)spiBitbang_MainClockDistr_v2_M, 0,
                sizeof(RT_MODEL_spiBitbang_MainClock_T));
  rtmSetTFinal(spiBitbang_MainClockDistr_v2_M, 0.0015);
  spiBitbang_MainClockDistr_v2_M->Timing.stepSize0 = 1.0E-6;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    spiBitbang_MainClockDistr_v2_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, (NULL));
    rtliSetLogT(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "tout");
    rtliSetLogX(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "");
    rtliSetLogXFinal(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "");
    rtliSetSigLog(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, 1);
    rtliSetLogY(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(spiBitbang_MainClockDistr_v2_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &spiBitbang_MainClockDistr_v2_B), 0,
                sizeof(B_spiBitbang_MainClockDistr_v_T));

  /* states (dwork) */
  (void) memset((void *)&spiBitbang_MainClockDistr_v2_DW, 0,
                sizeof(DW_spiBitbang_MainClockDistr__T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(spiBitbang_MainClockDistr_v2_M->rtwLogInfo,
    0.0, rtmGetTFinal(spiBitbang_MainClockDistr_v2_M),
    spiBitbang_MainClockDistr_v2_M->Timing.stepSize0, (&rtmGetErrorStatus
    (spiBitbang_MainClockDistr_v2_M)));

  /* Start for DiscretePulseGenerator: '<S1>/f_sck' */
  spiBitbang_MainClockDistr_v2_DW.clockTickCounter = 0;

  /* Start for DiscretePulseGenerator: '<Root>/Start16BitRead' */
  spiBitbang_MainClockDistr_v2_DW.clockTickCounter_c = -20;

  /* InitializeConditions for Enabled SubSystem: '<Root>/TxSubsystem' */
  /* InitializeConditions for Delay: '<S7>/Delay1' */
  spiBitbang_MainClockDistr_v2_DW.icLoad = 1U;

  /* InitializeConditions for Triggered SubSystem: '<S7>/Bitmask' */
  /* InitializeConditions for UnitDelay: '<S15>/Output' */
  spiBitbang_MainClockDistr_v2_DW.Output_DSTATE =
    spiBitbang_MainClockDistr_v2_P.Output_InitialCondition;

  /* End of InitializeConditions for SubSystem: '<S7>/Bitmask' */
  /* End of InitializeConditions for SubSystem: '<Root>/TxSubsystem' */

  /* Start for Enabled SubSystem: '<Root>/TxSubsystem' */
  /* VirtualOutportStart for Outport: '<S7>/cs' */
  spiBitbang_MainClockDistr_v2_B.gen_CS = spiBitbang_MainClockDistr_v2_P.cs_Y0;

  /* VirtualOutportStart for Outport: '<S7>/tx' */
  spiBitbang_MainClockDistr_v2_B.BitwiseOperator =
    spiBitbang_MainClockDistr_v2_P.tx_Y0;

  /* VirtualOutportStart for Outport: '<S7>/clk_delayed' */
  spiBitbang_MainClockDistr_v2_B.clk_delayed =
    spiBitbang_MainClockDistr_v2_P.clk_delayed_Y0;

  /* End of Start for SubSystem: '<Root>/TxSubsystem' */
  /* Start for DiscretePulseGenerator: '<Root>/Start16BitRead1' */
  spiBitbang_MainClockDistr_v2_DW.clockTickCounter_j = 0;
  spiBitbang_MainClockDis_PrevZCX.Bitmask_Trig_ZCE = UNINITIALIZED_ZCSIG;
  spiBitbang_MainClockDis_PrevZCX.Shifter_Trig_ZCE = UNINITIALIZED_ZCSIG;

  /* InitializeConditions for UnitDelay: '<S1>/Unit Delay' */
  spiBitbang_MainClockDistr_v2_DW.UnitDelay_DSTATE =
    spiBitbang_MainClockDistr_v2_P.UnitDelay_InitialCondition;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/N-Sample Enable' */
  spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter = (uint32_T) 0;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<S6>/N-Sample Enable' */
  spiBitbang_MainClockDistr_v2_DW.NSampleEnable_Counter_o = (uint32_T) 0;

  /* DSP System Toolbox N-Sample Enable  (sdspnsamp2) - '<Root>/f_sck_OnOff' */
  spiBitbang_MainClockDistr_v2_DW.f_sck_OnOff_Counter = (uint32_T) 0;

  /* InitializeConditions for S-Function (sdspcount2): '<S1>/Counter' */
  spiBitbang_MainClockDistr_v2_DW.Counter_ClkEphState = 5U;
  spiBitbang_MainClockDistr_v2_DW.Counter_RstEphState = 5U;
  spiBitbang_MainClockDistr_v2_DW.Counter_Count =
    spiBitbang_MainClockDistr_v2_P.Counter_InitialCount;

  /* InitializeConditions for Triggered SubSystem: '<Root>/Shifter' */
  /* InitializeConditions for UnitDelay: '<S9>/Output' */
  spiBitbang_MainClockDistr_v2_DW.Output_DSTATE_c =
    spiBitbang_MainClockDistr_v2_P.Output_InitialCondition_h;

  /* End of InitializeConditions for SubSystem: '<Root>/Shifter' */
}

/* Model terminate function */
void spiBitbang_MainClockDistr_v2_terminate(void)
{
  /* (no terminate code required) */
}
