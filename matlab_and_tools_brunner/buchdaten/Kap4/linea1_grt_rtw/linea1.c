/*
 * linea1.c
 *
 * Code generation for model "linea1".
 *
 * Model version              : 1.4
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Thu Apr 24 21:14:30 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "linea1.h"
#include "linea1_private.h"

/* Block signals (auto storage) */
B_linea1_T linea1_B;

/* Continuous states */
X_linea1_T linea1_X;

/* External inputs (root inport signals with auto storage) */
ExtU_linea1_T linea1_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_linea1_T linea1_Y;

/* Real-time model */
RT_MODEL_linea1_T linea1_M_;
RT_MODEL_linea1_T *const linea1_M = &linea1_M_;

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
  int_T nXc = 3;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  linea1_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  linea1_output();
  linea1_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  linea1_output();
  linea1_derivatives();

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

/* Model output function */
void linea1_output(void)
{
  /* local block i/o variables */
  real_T rtb_TransferFcn;
  real_T rtb_Sum;
  if (rtmIsMajorTimeStep(linea1_M)) {
    /* set solver stop time */
    if (!(linea1_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&linea1_M->solverInfo,
                            ((linea1_M->Timing.clockTickH0 + 1) *
        linea1_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&linea1_M->solverInfo, ((linea1_M->Timing.clockTick0
        + 1) * linea1_M->Timing.stepSize0 + linea1_M->Timing.clockTickH0 *
        linea1_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(linea1_M)) {
    linea1_M->Timing.t[0] = rtsiGetT(&linea1_M->solverInfo);
  }

  /* ZeroPole: '<Root>/Zero-Pole' */
  {
    linea1_B.ZeroPole = linea1_P.ZeroPole_C[0]*linea1_X.ZeroPole_CSTATE[0] +
      linea1_P.ZeroPole_C[1]*linea1_X.ZeroPole_CSTATE[1];
  }

  /* Outport: '<Root>/Out1 y(1)' */
  linea1_Y.Out1y1 = linea1_B.ZeroPole;

  /* Step: '<Root>/Step' */
  if (linea1_M->Timing.t[0] < linea1_P.Step_Time) {
    rtb_TransferFcn = linea1_P.Step_Y0;
  } else {
    rtb_TransferFcn = linea1_P.Step_YFinal;
  }

  /* End of Step: '<Root>/Step' */

  /* Sum: '<Root>/Sum' incorporates:
   *  Inport: '<Root>/In1 u'
   */
  rtb_Sum = linea1_U.In1u + rtb_TransferFcn;

  /* TransferFcn: '<Root>/Transfer Fcn' */
  rtb_TransferFcn = linea1_P.TransferFcn_C*linea1_X.TransferFcn_CSTATE;

  /* Sum: '<Root>/Sum1' */
  linea1_B.Sum1 = rtb_Sum - rtb_TransferFcn;

  /* Outport: '<Root>/Out2 y(2)' */
  linea1_Y.Out2y2 = linea1_B.Sum1;
}

/* Model update function */
void linea1_update(void)
{
  if (rtmIsMajorTimeStep(linea1_M)) {
    rt_ertODEUpdateContinuousStates(&linea1_M->solverInfo);
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
  if (!(++linea1_M->Timing.clockTick0)) {
    ++linea1_M->Timing.clockTickH0;
  }

  linea1_M->Timing.t[0] = rtsiGetSolverStopTime(&linea1_M->solverInfo);
}

/* Derivatives for root system: '<Root>' */
void linea1_derivatives(void)
{
  /* Derivatives for ZeroPole: '<Root>/Zero-Pole' */
  {
    ((XDot_linea1_T *) linea1_M->ModelData.derivs)->ZeroPole_CSTATE[0] =
      linea1_B.Sum1;
    ((XDot_linea1_T *) linea1_M->ModelData.derivs)->ZeroPole_CSTATE[0] +=
      (linea1_P.ZeroPole_A[0])*linea1_X.ZeroPole_CSTATE[0] +
      (linea1_P.ZeroPole_A[1])*linea1_X.ZeroPole_CSTATE[1];
    ((XDot_linea1_T *) linea1_M->ModelData.derivs)->ZeroPole_CSTATE[1]=
      linea1_X.ZeroPole_CSTATE[0];
  }

  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' */
  {
    ((XDot_linea1_T *) linea1_M->ModelData.derivs)->TransferFcn_CSTATE =
      linea1_B.ZeroPole;
    ((XDot_linea1_T *) linea1_M->ModelData.derivs)->TransferFcn_CSTATE +=
      (linea1_P.TransferFcn_A)*linea1_X.TransferFcn_CSTATE;
  }
}

/* Model initialize function */
void linea1_initialize(void)
{
  /* InitializeConditions for ZeroPole: '<Root>/Zero-Pole' */
  linea1_X.ZeroPole_CSTATE[0] = 0.0;
  linea1_X.ZeroPole_CSTATE[1] = 0.0;

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  linea1_X.TransferFcn_CSTATE = 0.0;
}

/* Model terminate function */
void linea1_terminate(void)
{
  /* (no terminate code required) */
}

/*========================================================================*
 * Start of Classic call interface                                        *
 *========================================================================*/

/* Solver interface called by GRT_Main */
#ifndef USE_GENERATED_SOLVER

void rt_ODECreateIntegrationData(RTWSolverInfo *si)
{
  UNUSED_PARAMETER(si);
  return;
}                                      /* do nothing */

void rt_ODEDestroyIntegrationData(RTWSolverInfo *si)
{
  UNUSED_PARAMETER(si);
  return;
}                                      /* do nothing */

void rt_ODEUpdateContinuousStates(RTWSolverInfo *si)
{
  UNUSED_PARAMETER(si);
  return;
}                                      /* do nothing */

#endif

void MdlOutputs(int_T tid)
{
  linea1_output();

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

void MdlUpdate(int_T tid)
{
  linea1_update();

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

void MdlInitializeSizes(void)
{
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  linea1_initialize();
}

void MdlTerminate(void)
{
  linea1_terminate();
}

/* Registration function */
RT_MODEL_linea1_T *linea1(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)linea1_M, 0,
                sizeof(RT_MODEL_linea1_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&linea1_M->solverInfo, &linea1_M->Timing.simTimeStep);
    rtsiSetTPtr(&linea1_M->solverInfo, &rtmGetTPtr(linea1_M));
    rtsiSetStepSizePtr(&linea1_M->solverInfo, &linea1_M->Timing.stepSize0);
    rtsiSetdXPtr(&linea1_M->solverInfo, &linea1_M->ModelData.derivs);
    rtsiSetContStatesPtr(&linea1_M->solverInfo, &linea1_M->ModelData.contStates);
    rtsiSetNumContStatesPtr(&linea1_M->solverInfo,
      &linea1_M->Sizes.numContStates);
    rtsiSetErrorStatusPtr(&linea1_M->solverInfo, (&rtmGetErrorStatus(linea1_M)));
    rtsiSetRTModelPtr(&linea1_M->solverInfo, linea1_M);
  }

  rtsiSetSimTimeStep(&linea1_M->solverInfo, MAJOR_TIME_STEP);
  linea1_M->ModelData.intgData.y = linea1_M->ModelData.odeY;
  linea1_M->ModelData.intgData.f[0] = linea1_M->ModelData.odeF[0];
  linea1_M->ModelData.intgData.f[1] = linea1_M->ModelData.odeF[1];
  linea1_M->ModelData.intgData.f[2] = linea1_M->ModelData.odeF[2];
  linea1_M->ModelData.contStates = ((real_T *) &linea1_X);
  rtsiSetSolverData(&linea1_M->solverInfo, (void *)&linea1_M->ModelData.intgData);
  rtsiSetSolverName(&linea1_M->solverInfo,"ode3");

  /* Initialize timing info */
  {
    int_T *mdlTsMap = linea1_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    linea1_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    linea1_M->Timing.sampleTimes = (&linea1_M->Timing.sampleTimesArray[0]);
    linea1_M->Timing.offsetTimes = (&linea1_M->Timing.offsetTimesArray[0]);

    /* task periods */
    linea1_M->Timing.sampleTimes[0] = (0.0);

    /* task offsets */
    linea1_M->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(linea1_M, &linea1_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = linea1_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    linea1_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(linea1_M, 10.0);
  linea1_M->Timing.stepSize0 = 0.2;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    linea1_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(linea1_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(linea1_M->rtwLogInfo, (NULL));
    rtliSetLogT(linea1_M->rtwLogInfo, "tout");
    rtliSetLogX(linea1_M->rtwLogInfo, "");
    rtliSetLogXFinal(linea1_M->rtwLogInfo, "");
    rtliSetSigLog(linea1_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(linea1_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(linea1_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(linea1_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(linea1_M->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &linea1_Y.Out1y1,
        &linea1_Y.Out2y2
      };

      rtliSetLogYSignalPtrs(linea1_M->rtwLogInfo, ((LogSignalPtrsType)
        rt_LoggedOutputSignalPtrs));
    }

    {
      static int_T rt_LoggedOutputWidths[] = {
        1,
        1
      };

      static int_T rt_LoggedOutputNumDimensions[] = {
        1,
        1
      };

      static int_T rt_LoggedOutputDimensions[] = {
        1,
        1
      };

      static boolean_T rt_LoggedOutputIsVarDims[] = {
        0,
        0
      };

      static void* rt_LoggedCurrentSignalDimensions[] = {
        (NULL),
        (NULL)
      };

      static int_T rt_LoggedCurrentSignalDimensionsSize[] = {
        4,
        4
      };

      static BuiltInDTypeId rt_LoggedOutputDataTypeIds[] = {
        SS_DOUBLE,
        SS_DOUBLE
      };

      static int_T rt_LoggedOutputComplexSignals[] = {
        0,
        0
      };

      static const char_T *rt_LoggedOutputLabels[] = {
        "",
        "" };

      static const char_T *rt_LoggedOutputBlockNames[] = {
        "linea1/Out1\ny(1)",
        "linea1/Out2\ny(2)" };

      static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert[] = {
        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 },

        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 }
      };

      static RTWLogSignalInfo rt_LoggedOutputSignalInfo[] = {
        {
          2,
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

      rtliSetLogYSignalInfo(linea1_M->rtwLogInfo, rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
      rt_LoggedCurrentSignalDimensions[1] = &rt_LoggedOutputWidths[1];
    }

    rtliSetLogY(linea1_M->rtwLogInfo, "yout");
  }

  linea1_M->solverInfoPtr = (&linea1_M->solverInfo);
  linea1_M->Timing.stepSize = (0.2);
  rtsiSetFixedStepSize(&linea1_M->solverInfo, 0.2);
  rtsiSetSolverMode(&linea1_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  linea1_M->ModelData.blockIO = ((void *) &linea1_B);
  (void) memset(((void *) &linea1_B), 0,
                sizeof(B_linea1_T));

  /* parameters */
  linea1_M->ModelData.defaultParam = ((real_T *)&linea1_P);

  /* states (continuous) */
  {
    real_T *x = (real_T *) &linea1_X;
    linea1_M->ModelData.contStates = (x);
    (void) memset((void *)&linea1_X, 0,
                  sizeof(X_linea1_T));
  }

  /* external inputs */
  linea1_M->ModelData.inputs = (((void*)&linea1_U));
  linea1_U.In1u = 0.0;

  /* external outputs */
  linea1_M->ModelData.outputs = (&linea1_Y);
  (void) memset((void *)&linea1_Y, 0,
                sizeof(ExtY_linea1_T));

  /* Initialize Sizes */
  linea1_M->Sizes.numContStates = (3); /* Number of continuous states */
  linea1_M->Sizes.numY = (2);          /* Number of model outputs */
  linea1_M->Sizes.numU = (1);          /* Number of model inputs */
  linea1_M->Sizes.sysDirFeedThru = (1);/* The model is direct feedthrough */
  linea1_M->Sizes.numSampTimes = (1);  /* Number of sample times */
  linea1_M->Sizes.numBlocks = (7);     /* Number of blocks */
  linea1_M->Sizes.numBlockIO = (2);    /* Number of block outputs */
  linea1_M->Sizes.numBlockPrms = (9);  /* Sum of parameter "widths" */
  return linea1_M;
}

/*========================================================================*
 * End of Classic call interface                                          *
 *========================================================================*/
