/*
 * RC_RC.c
 *
 * Code generation for model "RC_RC".
 *
 * Model version              : 1.27
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Fri Sep 19 10:57:13 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "RC_RC.h"
#include "RC_RC_private.h"

/* Block signals (auto storage) */
B_RC_RC_T RC_RC_B;

/* Continuous states */
X_RC_RC_T RC_RC_X;

/* Block states (auto storage) */
DW_RC_RC_T RC_RC_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_RC_RC_T RC_RC_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_RC_RC_T RC_RC_Y;

/* Real-time model */
RT_MODEL_RC_RC_T RC_RC_M_;
RT_MODEL_RC_RC_T *const RC_RC_M = &RC_RC_M_;
static void rate_scheduler(void);

/*
 *   This function updates active task flag for each subrate.
 * The function is called at model base rate, hence the
 * generated code self-manages all its subrates.
 */
static void rate_scheduler(void)
{
  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (RC_RC_M->Timing.TaskCounters.TID[2])++;
  if ((RC_RC_M->Timing.TaskCounters.TID[2]) > 9) {/* Sample time: [0.0001s, 0.0s] */
    RC_RC_M->Timing.TaskCounters.TID[2] = 0;
  }
}

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
  int_T nXc = 1;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  RC_RC_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  RC_RC_step();
  RC_RC_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  RC_RC_step();
  RC_RC_derivatives();

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
void RC_RC_step(void)
{
  /* local block i/o variables */
  real_T rtb_FilterCoefficient;
  real_T rtb_IntegralGain;
  real_T currentTime;
  real_T rtb_e;
  int32_T currentTime_0;
  if (rtmIsMajorTimeStep(RC_RC_M)) {
    /* set solver stop time */
    if (!(RC_RC_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&RC_RC_M->solverInfo, ((RC_RC_M->Timing.clockTickH0
        + 1) * RC_RC_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&RC_RC_M->solverInfo, ((RC_RC_M->Timing.clockTick0 +
        1) * RC_RC_M->Timing.stepSize0 + RC_RC_M->Timing.clockTickH0 *
        RC_RC_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(RC_RC_M)) {
    RC_RC_M->Timing.t[0] = rtsiGetT(&RC_RC_M->solverInfo);
  }

  /* TransferFcn: '<Root>/Transfer Fcn' */
  RC_RC_B.TransferFcn = 1.0*RC_RC_X.TransferFcn_CSTATE;
  if (rtmIsMajorTimeStep(RC_RC_M) &&
      RC_RC_M->Timing.TaskCounters.TID[2] == 0) {
    /* Outport: '<Root>/Ua' */
    RC_RC_Y.Ua = RC_RC_B.TransferFcn;

    /* Step: '<Root>/Step' */
    currentTime = (((RC_RC_M->Timing.clockTick2+RC_RC_M->Timing.clockTickH2*
                     4294967296.0)) * 0.0001);
    if (currentTime < 0.001) {
      currentTime_0 = 0;
    } else {
      currentTime_0 = 1;
    }

    /* End of Step: '<Root>/Step' */

    /* Sum: '<Root>/Sum' incorporates:
     *  Inport: '<Root>/Ue'
     *  Sum: '<Root>/Sum1'
     *  ZeroOrderHold: '<Root>/ADC'
     */
    rtb_e = (RC_RC_U.w + (real_T)currentTime_0) - RC_RC_B.TransferFcn;

    /* Gain: '<S1>/Filter Coefficient' incorporates:
     *  DiscreteIntegrator: '<S1>/Filter'
     *  Gain: '<S1>/Derivative Gain'
     *  Sum: '<S1>/SumD'
     */
    rtb_FilterCoefficient = (9.0248898483108E-5 * rtb_e - RC_RC_DW.Filter_DSTATE)
      * 10930.7783722874;

    /* Gain: '<S1>/Integral Gain' */
    rtb_IntegralGain = 4987.28970965762 * rtb_e;

    /* Sum: '<S1>/Sum' incorporates:
     *  DiscreteIntegrator: '<S1>/Integrator'
     *  Gain: '<S1>/Proportional Gain'
     */
    RC_RC_B.Sum = (1.81294555482371 * rtb_e + RC_RC_DW.Integrator_DSTATE) +
      rtb_FilterCoefficient;
  }

  if (rtmIsMajorTimeStep(RC_RC_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(RC_RC_M->rtwLogInfo, (RC_RC_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(RC_RC_M)) {
    if (rtmIsMajorTimeStep(RC_RC_M) &&
        RC_RC_M->Timing.TaskCounters.TID[2] == 0) {
      /* Update for DiscreteIntegrator: '<S1>/Filter' */
      RC_RC_DW.Filter_DSTATE += 0.0001 * rtb_FilterCoefficient;

      /* Update for DiscreteIntegrator: '<S1>/Integrator' */
      RC_RC_DW.Integrator_DSTATE += 0.0001 * rtb_IntegralGain;
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(RC_RC_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(RC_RC_M)!=-1) &&
          !((rtmGetTFinal(RC_RC_M)-(((RC_RC_M->Timing.clockTick1+
               RC_RC_M->Timing.clockTickH1* 4294967296.0)) * 1.0E-5)) >
            (((RC_RC_M->Timing.clockTick1+RC_RC_M->Timing.clockTickH1*
               4294967296.0)) * 1.0E-5) * (DBL_EPSILON))) {
        rtmSetErrorStatus(RC_RC_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&RC_RC_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++RC_RC_M->Timing.clockTick0)) {
      ++RC_RC_M->Timing.clockTickH0;
    }

    RC_RC_M->Timing.t[0] = rtsiGetSolverStopTime(&RC_RC_M->solverInfo);

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
      RC_RC_M->Timing.clockTick1++;
      if (!RC_RC_M->Timing.clockTick1) {
        RC_RC_M->Timing.clockTickH1++;
      }
    }

    if (rtmIsMajorTimeStep(RC_RC_M) &&
        RC_RC_M->Timing.TaskCounters.TID[2] == 0) {
      /* Update absolute timer for sample time: [0.0001s, 0.0s] */
      /* The "clockTick2" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.0001, which is the step size
       * of the task. Size of "clockTick2" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick2 and the high bits
       * Timing.clockTickH2. When the low bit overflows to 0, the high bits increment.
       */
      RC_RC_M->Timing.clockTick2++;
      if (!RC_RC_M->Timing.clockTick2) {
        RC_RC_M->Timing.clockTickH2++;
      }
    }

    rate_scheduler();
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void RC_RC_derivatives(void)
{
  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' */
  {
    ((XDot_RC_RC_T *) RC_RC_M->ModelData.derivs)->TransferFcn_CSTATE =
      RC_RC_B.Sum;
    ((XDot_RC_RC_T *) RC_RC_M->ModelData.derivs)->TransferFcn_CSTATE += (-1.0)*
      RC_RC_X.TransferFcn_CSTATE;
  }
}

/* Model initialize function */
void RC_RC_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)RC_RC_M, 0,
                sizeof(RT_MODEL_RC_RC_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&RC_RC_M->solverInfo, &RC_RC_M->Timing.simTimeStep);
    rtsiSetTPtr(&RC_RC_M->solverInfo, &rtmGetTPtr(RC_RC_M));
    rtsiSetStepSizePtr(&RC_RC_M->solverInfo, &RC_RC_M->Timing.stepSize0);
    rtsiSetdXPtr(&RC_RC_M->solverInfo, &RC_RC_M->ModelData.derivs);
    rtsiSetContStatesPtr(&RC_RC_M->solverInfo, &RC_RC_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&RC_RC_M->solverInfo, &RC_RC_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&RC_RC_M->solverInfo, (&rtmGetErrorStatus(RC_RC_M)));
    rtsiSetRTModelPtr(&RC_RC_M->solverInfo, RC_RC_M);
  }

  rtsiSetSimTimeStep(&RC_RC_M->solverInfo, MAJOR_TIME_STEP);
  RC_RC_M->ModelData.intgData.y = RC_RC_M->ModelData.odeY;
  RC_RC_M->ModelData.intgData.f[0] = RC_RC_M->ModelData.odeF[0];
  RC_RC_M->ModelData.intgData.f[1] = RC_RC_M->ModelData.odeF[1];
  RC_RC_M->ModelData.intgData.f[2] = RC_RC_M->ModelData.odeF[2];
  RC_RC_M->ModelData.contStates = ((real_T *) &RC_RC_X);
  rtsiSetSolverData(&RC_RC_M->solverInfo, (void *)&RC_RC_M->ModelData.intgData);
  rtsiSetSolverName(&RC_RC_M->solverInfo,"ode3");
  rtmSetTPtr(RC_RC_M, &RC_RC_M->Timing.tArray[0]);
  rtmSetTFinal(RC_RC_M, 0.005);
  RC_RC_M->Timing.stepSize0 = 1.0E-5;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    RC_RC_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(RC_RC_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(RC_RC_M->rtwLogInfo, (NULL));
    rtliSetLogT(RC_RC_M->rtwLogInfo, "tout");
    rtliSetLogX(RC_RC_M->rtwLogInfo, "");
    rtliSetLogXFinal(RC_RC_M->rtwLogInfo, "");
    rtliSetSigLog(RC_RC_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(RC_RC_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(RC_RC_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(RC_RC_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(RC_RC_M->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &RC_RC_Y.Ua
      };

      rtliSetLogYSignalPtrs(RC_RC_M->rtwLogInfo, ((LogSignalPtrsType)
        rt_LoggedOutputSignalPtrs));
    }

    {
      static int_T rt_LoggedOutputWidths[] = {
        1
      };

      static int_T rt_LoggedOutputNumDimensions[] = {
        1
      };

      static int_T rt_LoggedOutputDimensions[] = {
        1
      };

      static boolean_T rt_LoggedOutputIsVarDims[] = {
        0
      };

      static void* rt_LoggedCurrentSignalDimensions[] = {
        (NULL)
      };

      static int_T rt_LoggedCurrentSignalDimensionsSize[] = {
        4
      };

      static BuiltInDTypeId rt_LoggedOutputDataTypeIds[] = {
        SS_DOUBLE
      };

      static int_T rt_LoggedOutputComplexSignals[] = {
        0
      };

      static const char_T *rt_LoggedOutputLabels[] = {
        "" };

      static const char_T *rt_LoggedOutputBlockNames[] = {
        "RC_RC/Ua" };

      static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert[] = {
        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 }
      };

      static RTWLogSignalInfo rt_LoggedOutputSignalInfo[] = {
        {
          1,
          rt_LoggedOutputWidths,
          rt_LoggedOutputNumDimensions,
          rt_LoggedOutputDimensions,
          rt_LoggedOutputIsVarDims,
          rt_LoggedCurrentSignalDimensions,
          rt_LoggedCurrentSignalDimensionsSize,
          rt_LoggedOutputDataTypeIds,
          rt_LoggedOutputComplexSignals,
          (NULL),

          { rt_LoggedOutputLabels },
          (NULL),
          (NULL),
          (NULL),

          { rt_LoggedOutputBlockNames },

          { (NULL) },
          (NULL),
          rt_RTWLogDataTypeConvert
        }
      };

      rtliSetLogYSignalInfo(RC_RC_M->rtwLogInfo, rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
    }

    rtliSetLogY(RC_RC_M->rtwLogInfo, "yout");
  }

  /* block I/O */
  (void) memset(((void *) &RC_RC_B), 0,
                sizeof(B_RC_RC_T));

  /* states (continuous) */
  {
    (void) memset((void *)&RC_RC_X, 0,
                  sizeof(X_RC_RC_T));
  }

  /* states (dwork) */
  (void) memset((void *)&RC_RC_DW, 0,
                sizeof(DW_RC_RC_T));

  /* external inputs */
  RC_RC_U.w = 0.0;

  /* external outputs */
  RC_RC_Y.Ua = 0.0;

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(RC_RC_M->rtwLogInfo, 0.0, rtmGetTFinal
    (RC_RC_M), RC_RC_M->Timing.stepSize0, (&rtmGetErrorStatus(RC_RC_M)));

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  RC_RC_X.TransferFcn_CSTATE = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  RC_RC_DW.Filter_DSTATE = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  RC_RC_DW.Integrator_DSTATE = 0.0;
}

/* Model terminate function */
void RC_RC_terminate(void)
{
  /* (no terminate code required) */
}
