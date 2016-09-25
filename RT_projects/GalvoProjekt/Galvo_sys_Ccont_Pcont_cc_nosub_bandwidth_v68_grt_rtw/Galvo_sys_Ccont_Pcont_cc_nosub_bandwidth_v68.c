/*
 * Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68.c
 *
 * Code generation for model "Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68".
 *
 * Model version              : 1.412
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Mon Oct 13 07:56:21 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68.h"
#include "Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_private.h"

/* Block signals (auto storage) */
B_Galvo_sys_Ccont_Pcont_cc_no_T Galvo_sys_Ccont_Pcont_cc_nosu_B;

/* Continuous states */
X_Galvo_sys_Ccont_Pcont_cc_no_T Galvo_sys_Ccont_Pcont_cc_nosu_X;

/* Block states (auto storage) */
DW_Galvo_sys_Ccont_Pcont_cc_n_T Galvo_sys_Ccont_Pcont_cc_nos_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_Galvo_sys_Ccont_Pcont_cc_T Galvo_sys_Ccont_Pcont_cc_nosu_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_Galvo_sys_Ccont_Pcont_cc_T Galvo_sys_Ccont_Pcont_cc_nosu_Y;

/* Real-time model */
RT_MODEL_Galvo_sys_Ccont_Pcon_T Galvo_sys_Ccont_Pcont_cc_nos_M_;
RT_MODEL_Galvo_sys_Ccont_Pcon_T *const Galvo_sys_Ccont_Pcont_cc_nos_M =
  &Galvo_sys_Ccont_Pcont_cc_nos_M_;

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 5;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_step();
  Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_step();
  Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_step(void)
{
  /* local block i/o variables */
  real_T rtb_Gain_e;
  real_T rtb_Pos;
  real_T rtb_IntegralGain;
  real_T rtb_DataTypeConv3;
  real_T rtb_DeadZone;
  real_T rtb_Saturation;
  real_T rtb_Ic;
  real_T rtb_SignPreSat;
  boolean_T rtb_Equal1;
  boolean_T rtb_Equal2;
  real_T rtb_IntegralGain_0;
  if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    /* set solver stop time */
    if (!(Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                            ((Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH0
        + 1) * Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                            ((Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick0
        + 1) * Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0 +
        Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH0 *
        Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.t[0] = rtsiGetT
      (&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo);
  }

  /* Saturate: '<Root>/Max Angle' incorporates:
   *  Integrator: '<Root>/int3'
   */
  if (Galvo_sys_Ccont_Pcont_cc_nosu_X.int3_CSTATE >= 0.3490658503988659) {
    rtb_Pos = 0.3490658503988659;
  } else if (Galvo_sys_Ccont_Pcont_cc_nosu_X.int3_CSTATE <= (-0.3490658503988659))
  {
    rtb_Pos = (-0.3490658503988659);
  } else {
    rtb_Pos = Galvo_sys_Ccont_Pcont_cc_nosu_X.int3_CSTATE;
  }

  /* End of Saturate: '<Root>/Max Angle' */

  /* Outport: '<Root>/Pos1' */
  Galvo_sys_Ccont_Pcont_cc_nosu_Y.Pos1 = rtb_Pos;

  /* Outport: '<Root>/phideg' incorporates:
   *  Gain: '<Root>/deg2rad2'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_Y.phideg = 57.295779513082323 * rtb_Pos;

  /* Gain: '<Root>/Rotor inertia' incorporates:
   *  Integrator: '<Root>/Int Inertia'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_B.w = 1.6666666666666668E+7 *
    Galvo_sys_Ccont_Pcont_cc_nosu_X.IntInertia_CSTATE;

  /* Step: '<Root>/Step in deg' */
  if (Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.t[0] < 0.001) {
    rtb_IntegralGain = 0.0;
  } else {
    rtb_IntegralGain = 5.0;
  }

  /* End of Step: '<Root>/Step in deg' */

  /* Sum: '<Root>/Sum2' incorporates:
   *  Gain: '<Root>/PosDemod'
   *  Gain: '<Root>/deg2rad'
   *  Inport: '<Root>/w1'
   *  Sum: '<Root>/Sum4'
   */
  rtb_IntegralGain = ((0.0 + Galvo_sys_Ccont_Pcont_cc_nosu_U.w1) +
                      0.017453292519943295 * rtb_IntegralGain) - 1.0 * rtb_Pos;

  /* Gain: '<S2>/Filter Coefficient' incorporates:
   *  Gain: '<S2>/Derivative Gain'
   *  Integrator: '<S2>/Filter'
   *  Sum: '<S2>/SumD'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_B.FilterCoefficient = (0.0075 * rtb_IntegralGain
    - Galvo_sys_Ccont_Pcont_cc_nosu_X.Filter_CSTATE) * 1600.0;

  /* Sum: '<S2>/Sum' incorporates:
   *  Integrator: '<S2>/Integrator'
   */
  rtb_DataTypeConv3 = (rtb_IntegralGain +
                       Galvo_sys_Ccont_Pcont_cc_nosu_X.Integrator_CSTATE) +
    Galvo_sys_Ccont_Pcont_cc_nosu_B.FilterCoefficient;

  /* Gain: '<S2>/Proportional Gain' */
  rtb_DeadZone = 1.36 * rtb_DataTypeConv3;

  /* Saturate: '<S2>/Saturation' */
  if (rtb_DeadZone >= 30.0) {
    rtb_Saturation = 30.0;
  } else if (rtb_DeadZone <= (-30.0)) {
    rtb_Saturation = (-30.0);
  } else {
    rtb_Saturation = rtb_DeadZone;
  }

  /* End of Saturate: '<S2>/Saturation' */

  /* Gain: '<Root>/Coil Inductance' incorporates:
   *  Integrator: '<Root>/Int Coil'
   */
  rtb_Ic = 6249.9999999999991 * Galvo_sys_Ccont_Pcont_cc_nosu_X.IntCoil_CSTATE;

  /* Signum: '<S6>/SignPreSat' */
  if (rtb_DeadZone < 0.0) {
    rtb_SignPreSat = -1.0;
  } else if (rtb_DeadZone > 0.0) {
    rtb_SignPreSat = 1.0;
  } else if (rtb_DeadZone == 0.0) {
    rtb_SignPreSat = 0.0;
  } else {
    rtb_SignPreSat = rtb_DeadZone;
  }

  /* End of Signum: '<S6>/SignPreSat' */

  /* Gain: '<S2>/Integral Gain' */
  rtb_IntegralGain = 9.11 * rtb_IntegralGain;

  /* Signum: '<S6>/SignPreIntegrator' incorporates:
   *  DataTypeConversion: '<S6>/DataTypeConv2'
   */
  if (rtb_IntegralGain < 0.0) {
    rtb_IntegralGain_0 = -1.0;
  } else if (rtb_IntegralGain > 0.0) {
    rtb_IntegralGain_0 = 1.0;
  } else if (rtb_IntegralGain == 0.0) {
    rtb_IntegralGain_0 = 0.0;
  } else {
    rtb_IntegralGain_0 = rtb_IntegralGain;
  }

  /* RelationalOperator: '<S6>/Equal1' incorporates:
   *  Signum: '<S6>/SignPreIntegrator'
   */
  rtb_Equal1 = (rtb_SignPreSat == rtb_IntegralGain_0);

  /* Signum: '<S6>/SignPreP' */
  if (rtb_DataTypeConv3 < 0.0) {
    rtb_DataTypeConv3 = -1.0;
  } else if (rtb_DataTypeConv3 > 0.0) {
    rtb_DataTypeConv3 = 1.0;
  } else {
    if (rtb_DataTypeConv3 == 0.0) {
      rtb_DataTypeConv3 = 0.0;
    }
  }

  /* RelationalOperator: '<S6>/Equal2' incorporates:
   *  Signum: '<S6>/SignPreP'
   */
  rtb_Equal2 = (rtb_SignPreSat == rtb_DataTypeConv3);

  /* Gain: '<S6>/Gain' */
  rtb_DataTypeConv3 = 0.0 * rtb_DeadZone;

  /* DeadZone: '<S6>/DeadZone' */
  if (rtb_DeadZone > 30.0) {
    rtb_DeadZone -= 30.0;
  } else if (rtb_DeadZone >= (-30.0)) {
    rtb_DeadZone = 0.0;
  } else {
    rtb_DeadZone -= (-30.0);
  }

  /* End of DeadZone: '<S6>/DeadZone' */

  /* Logic: '<S6>/AND3' incorporates:
   *  Logic: '<S6>/AND1'
   *  Logic: '<S6>/AND2'
   *  Logic: '<S6>/NOT1'
   *  Logic: '<S6>/NOT2'
   *  Logic: '<S6>/OR1'
   *  RelationalOperator: '<S6>/NotEqual'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_B.AND3 = ((rtb_DataTypeConv3 != rtb_DeadZone) &&
    ((rtb_Equal1 && rtb_Equal2) || ((!rtb_Equal1) && (!rtb_Equal2))));
  if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    /* Memory: '<S6>/Memory' */
    Galvo_sys_Ccont_Pcont_cc_nosu_B.Memory =
      Galvo_sys_Ccont_Pcont_cc_nos_DW.Memory_PreviousInput;
  }

  /* Switch: '<S2>/Switch' incorporates:
   *  Constant: '<S2>/Constant'
   */
  if (Galvo_sys_Ccont_Pcont_cc_nosu_B.Memory) {
    Galvo_sys_Ccont_Pcont_cc_nosu_B.Switch = 0.0;
  } else {
    Galvo_sys_Ccont_Pcont_cc_nosu_B.Switch = rtb_IntegralGain;
  }

  /* End of Switch: '<S2>/Switch' */

  /* Gain: '<S3>/Gain' */
  rtb_Gain_e = 57.295779513082323 * rtb_Pos;

  /* Gain: '<S1>/Proportional Gain' incorporates:
   *  Gain: '<Root>/Shunt res.1'
   *  Gain: '<Root>/current Mon [gain]=V//V'
   *  Sum: '<Root>/Sum1'
   */
  rtb_IntegralGain = (rtb_Saturation - 1.0 * rtb_Ic * 1.0) * 1.0;

  /* Saturate: '<Root>/Plant SAT1' */
  if (rtb_IntegralGain >= 30.0) {
    rtb_IntegralGain = 30.0;
  } else {
    if (rtb_IntegralGain <= (-30.0)) {
      rtb_IntegralGain = (-30.0);
    }
  }

  /* Sum: '<Root>/Sum3' incorporates:
   *  Gain: '<Root>/Back EMF  voltage const.'
   *  Gain: '<Root>/Coil//Shunt res.'
   *  Saturate: '<Root>/Plant SAT1'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_B.Sum3 = (rtb_IntegralGain - 1.51 * rtb_Ic) -
    0.0097402825172239957 * Galvo_sys_Ccont_Pcont_cc_nosu_B.w;

  /* Sum: '<Root>/Sum7' incorporates:
   *  Gain: '<Root>/Torque constant'
   *  Gain: '<Root>/Torsionbar  const'
   *  Gain: '<Root>/friction torque constant'
   *  Integrator: '<Root>/int3'
   */
  Galvo_sys_Ccont_Pcont_cc_nosu_B.Sum7 = (0.0093 * rtb_Ic - 1.0E-9 *
    Galvo_sys_Ccont_Pcont_cc_nosu_X.int3_CSTATE) - 4.0E-12 *
    Galvo_sys_Ccont_Pcont_cc_nosu_B.w;
  if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo,
                        (Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
      /* Update for Memory: '<S6>/Memory' */
      Galvo_sys_Ccont_Pcont_cc_nos_DW.Memory_PreviousInput =
        Galvo_sys_Ccont_Pcont_cc_nosu_B.AND3;
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(Galvo_sys_Ccont_Pcont_cc_nos_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(Galvo_sys_Ccont_Pcont_cc_nos_M)!=-1) &&
          !((rtmGetTFinal(Galvo_sys_Ccont_Pcont_cc_nos_M)-
             (((Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick1+
                Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH1* 4294967296.0))
              * 1.0E-5)) > (((Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick1+
                              Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH1*
              4294967296.0)) * 1.0E-5) * (DBL_EPSILON))) {
        rtmSetErrorStatus(Galvo_sys_Ccont_Pcont_cc_nos_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick0)) {
      ++Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH0;
    }

    Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.t[0] = rtsiGetSolverStopTime
      (&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo);

    {
      /* Update absolute timer for sample time: [1.0E-5s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 1.0E-5, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick1++;
      if (!Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTick1) {
        Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_derivatives(void)
{
  XDot_Galvo_sys_Ccont_Pcont_cc_T *_rtXdot;
  _rtXdot = ((XDot_Galvo_sys_Ccont_Pcont_cc_T *)
             Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.derivs);

  /* Derivatives for Integrator: '<Root>/int3' */
  _rtXdot->int3_CSTATE = Galvo_sys_Ccont_Pcont_cc_nosu_B.w;

  /* Derivatives for Integrator: '<Root>/Int Inertia' */
  _rtXdot->IntInertia_CSTATE = Galvo_sys_Ccont_Pcont_cc_nosu_B.Sum7;

  /* Derivatives for Integrator: '<S2>/Integrator' */
  _rtXdot->Integrator_CSTATE = Galvo_sys_Ccont_Pcont_cc_nosu_B.Switch;

  /* Derivatives for Integrator: '<S2>/Filter' */
  _rtXdot->Filter_CSTATE = Galvo_sys_Ccont_Pcont_cc_nosu_B.FilterCoefficient;

  /* Derivatives for Integrator: '<Root>/Int Coil' */
  _rtXdot->IntCoil_CSTATE = Galvo_sys_Ccont_Pcont_cc_nosu_B.Sum3;
}

/* Model initialize function */
void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)Galvo_sys_Ccont_Pcont_cc_nos_M, 0,
                sizeof(RT_MODEL_Galvo_sys_Ccont_Pcon_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                          &Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.simTimeStep);
    rtsiSetTPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo, &rtmGetTPtr
                (Galvo_sys_Ccont_Pcont_cc_nos_M));
    rtsiSetStepSizePtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                       &Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0);
    rtsiSetdXPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                 &Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.derivs);
    rtsiSetContStatesPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                         &Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
      &Galvo_sys_Ccont_Pcont_cc_nos_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                          (&rtmGetErrorStatus(Galvo_sys_Ccont_Pcont_cc_nos_M)));
    rtsiSetRTModelPtr(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                      Galvo_sys_Ccont_Pcont_cc_nos_M);
  }

  rtsiSetSimTimeStep(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,
                     MAJOR_TIME_STEP);
  Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.intgData.y =
    Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.odeY;
  Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.intgData.f[0] =
    Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.odeF[0];
  Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.intgData.f[1] =
    Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.odeF[1];
  Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.intgData.f[2] =
    Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.odeF[2];
  Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.contStates = ((real_T *)
    &Galvo_sys_Ccont_Pcont_cc_nosu_X);
  rtsiSetSolverData(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo, (void *)
                    &Galvo_sys_Ccont_Pcont_cc_nos_M->ModelData.intgData);
  rtsiSetSolverName(&Galvo_sys_Ccont_Pcont_cc_nos_M->solverInfo,"ode3");
  rtmSetTPtr(Galvo_sys_Ccont_Pcont_cc_nos_M,
             &Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.tArray[0]);
  rtmSetTFinal(Galvo_sys_Ccont_Pcont_cc_nos_M, 0.008);
  Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0 = 1.0E-5;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, (NULL));
    rtliSetLogT(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "");
    rtliSetLogX(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "");
    rtliSetLogXFinal(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "");
    rtliSetSigLog(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, 0);
    rtliSetLogDecimation(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, 1);
    rtliSetLogY(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &Galvo_sys_Ccont_Pcont_cc_nosu_B), 0,
                sizeof(B_Galvo_sys_Ccont_Pcont_cc_no_T));

  /* states (continuous) */
  {
    (void) memset((void *)&Galvo_sys_Ccont_Pcont_cc_nosu_X, 0,
                  sizeof(X_Galvo_sys_Ccont_Pcont_cc_no_T));
  }

  /* states (dwork) */
  (void) memset((void *)&Galvo_sys_Ccont_Pcont_cc_nos_DW, 0,
                sizeof(DW_Galvo_sys_Ccont_Pcont_cc_n_T));

  /* external inputs */
  Galvo_sys_Ccont_Pcont_cc_nosu_U.w1 = 0.0;

  /* external outputs */
  (void) memset((void *)&Galvo_sys_Ccont_Pcont_cc_nosu_Y, 0,
                sizeof(ExtY_Galvo_sys_Ccont_Pcont_cc_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(Galvo_sys_Ccont_Pcont_cc_nos_M->rtwLogInfo,
    0.0, rtmGetTFinal(Galvo_sys_Ccont_Pcont_cc_nos_M),
    Galvo_sys_Ccont_Pcont_cc_nos_M->Timing.stepSize0, (&rtmGetErrorStatus
    (Galvo_sys_Ccont_Pcont_cc_nos_M)));

  /* InitializeConditions for Integrator: '<Root>/int3' */
  Galvo_sys_Ccont_Pcont_cc_nosu_X.int3_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<Root>/Int Inertia' */
  Galvo_sys_Ccont_Pcont_cc_nosu_X.IntInertia_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<S2>/Integrator' */
  Galvo_sys_Ccont_Pcont_cc_nosu_X.Integrator_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<S2>/Filter' */
  Galvo_sys_Ccont_Pcont_cc_nosu_X.Filter_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<Root>/Int Coil' */
  Galvo_sys_Ccont_Pcont_cc_nosu_X.IntCoil_CSTATE = 0.0;

  /* InitializeConditions for Memory: '<S6>/Memory' */
  Galvo_sys_Ccont_Pcont_cc_nos_DW.Memory_PreviousInput = FALSE;
}

/* Model terminate function */
void Galvo_sys_Ccont_Pcont_cc_nosub_bandwidth_v68_terminate(void)
{
  /* (no terminate code required) */
}
