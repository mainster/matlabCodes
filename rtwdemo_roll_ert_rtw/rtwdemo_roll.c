/*
 * File: rtwdemo_roll.c
 *
 * Code generated for Simulink model 'rtwdemo_roll'.
 *
 * Model version                  : 1.31
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sun Jul 20 05:59:20 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "rtwdemo_roll.h"

/* Block signals and states (auto storage) */
D_Work rtDWork;

/* External inputs (root inport signals with auto storage) */
ExternalInputs rtU;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs rtY;

/* Real-time model */
RT_MODEL rtM_;
RT_MODEL *const rtM = &rtM_;

/* Model step function */
void rtwdemo_roll_step(void)
{
  /* local block i/o variables */
  real_T rtb_HeadingMode;
  real_T rtb_BasicRollMode;
  real_T rtb_EngSwitch;
  real_T rtb_FixPtUnitDelay1;

  /* ModelReference: '<Root>/HeadingMode' */
  rtwdemo_heading(&rtU.HDG_Ref, &rtU.Psi, &rtU.TAS, &rtb_HeadingMode);

  /* UnitDelay: '<S2>/FixPt Unit Delay1' */
  rtb_FixPtUnitDelay1 = rtDWork.FixPtUnitDelay1_DSTATE;

  /* Switch: '<Root>/ModeSwitch' incorporates:
   *  Abs: '<S1>/Abs'
   *  Constant: '<S1>/Three'
   *  Inport: '<Root>/HDG_Mode'
   *  Inport: '<Root>/Turn_Knob'
   *  RelationalOperator: '<S1>/TKThreshold'
   *  Switch: '<S1>/TKSwitch'
   */
  if (rtU.HDG_Mode) {
    rtb_EngSwitch = rtb_HeadingMode;
  } else if (fabs(rtU.Turn_Knob) < 3.0) {
    /* Switch: '<S1>/TKSwitch' incorporates:
     *  UnitDelay: '<S2>/FixPt Unit Delay1'
     */
    rtb_EngSwitch = rtDWork.FixPtUnitDelay1_DSTATE;
  } else {
    rtb_EngSwitch = rtU.Turn_Knob;
  }

  /* End of Switch: '<Root>/ModeSwitch' */

  /* ModelReference: '<Root>/BasicRollMode' */
  rtwdemo_attitude(&rtb_EngSwitch, &rtU.Phi, &rtU.P, &rtU.AP_Eng,
                   &rtb_BasicRollMode, &(rtDWork.BasicRollMode_DWORK1.rtdw));

  /* Switch: '<Root>/EngSwitch' incorporates:
   *  Constant: '<Root>/Zero'
   *  Inport: '<Root>/AP_Eng'
   */
  if (rtU.AP_Eng) {
    rtb_EngSwitch = rtb_BasicRollMode;
  } else {
    rtb_EngSwitch = 0.0;
  }

  /* End of Switch: '<Root>/EngSwitch' */

  /* Outport: '<Root>/Ail_Cmd' */
  rtY.Ail_Cmd = rtb_EngSwitch;

  /* Switch: '<S2>/Enable' incorporates:
   *  Inport: '<Root>/AP_Eng'
   *  Logic: '<S1>/NotEngaged'
   */
  if (!rtU.AP_Eng) {
    /* Switch: '<S1>/RefSwitch' incorporates:
     *  Constant: '<S1>/MinusSix'
     *  Constant: '<S1>/Six'
     *  Inport: '<Root>/Phi'
     *  Logic: '<S1>/Or'
     *  RelationalOperator: '<S1>/RefThreshold1'
     *  RelationalOperator: '<S1>/RefThreshold2'
     */
    if ((rtU.Phi >= 6.0) || (rtU.Phi <= -6.0)) {
      /* Update for UnitDelay: '<S2>/FixPt Unit Delay1' */
      rtDWork.FixPtUnitDelay1_DSTATE = rtU.Phi;
    } else {
      /* Update for UnitDelay: '<S2>/FixPt Unit Delay1' incorporates:
       *  Constant: '<S1>/Zero'
       */
      rtDWork.FixPtUnitDelay1_DSTATE = 0.0;
    }
  } else {
    /* Switch: '<S1>/RefSwitch' incorporates:
     *  Update for UnitDelay: '<S2>/FixPt Unit Delay1'
     */
    rtDWork.FixPtUnitDelay1_DSTATE = rtb_FixPtUnitDelay1;
  }

  /* End of Switch: '<S2>/Enable' */
}

/* Model initialize function */
void rtwdemo_roll_initialize(void)
{
  /* Model Initialize fcn for ModelReference Block: '<Root>/BasicRollMode' */
  rtwdemo_attitude_initialize(rtmGetErrorStatusPointer(rtM),
    &(rtDWork.BasicRollMode_DWORK1.rtm));

  /* Model Initialize fcn for ModelReference Block: '<Root>/HeadingMode' */
  rtwdemo_heading_initialize(rtmGetErrorStatusPointer(rtM),
    &(rtDWork.HeadingMode_DWORK1.rtm));
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
