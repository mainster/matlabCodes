/*
 * Discrete.c
 *
 * Code generation for model "Discrete".
 *
 * Model version              : 1.45
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Wed Aug 13 06:42:29 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "Discrete.h"
#include "Discrete_private.h"

/* Block states (auto storage) */
DW_Discrete_T Discrete_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_Discrete_T Discrete_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_Discrete_T Discrete_Y;

/* Real-time model */
RT_MODEL_Discrete_T Discrete_M_;
RT_MODEL_Discrete_T *const Discrete_M = &Discrete_M_;

/* Model step function */
void Discrete_step(void)
{
  real_T rtb_FilterCoefficient;
  real_T u;

  /* Gain: '<S1>/Filter Coefficient' incorporates:
   *  DiscreteIntegrator: '<S1>/Filter'
   *  Gain: '<S1>/Derivative Gain'
   *  Inport: '<Root>/u'
   *  Sum: '<S1>/SumD'
   */
  rtb_FilterCoefficient = (Discrete_P.DerivativeGain_Gain * Discrete_U.u -
    Discrete_DW.Filter_DSTATE) * Discrete_P.FilterCoefficient_Gain;

  /* Sum: '<S1>/Sum' incorporates:
   *  DiscreteIntegrator: '<S1>/Integrator'
   *  Gain: '<S1>/Proportional Gain'
   *  Inport: '<Root>/u'
   */
  u = (Discrete_P.ProportionalGain_Gain * Discrete_U.u +
       Discrete_DW.Integrator_DSTATE) + rtb_FilterCoefficient;

  /* Saturate: '<S1>/Saturation' */
  if (u >= Discrete_P.Saturation_UpperSat) {
    /* Outport: '<Root>/y' */
    Discrete_Y.y = Discrete_P.Saturation_UpperSat;
  } else if (u <= Discrete_P.Saturation_LowerSat) {
    /* Outport: '<Root>/y' */
    Discrete_Y.y = Discrete_P.Saturation_LowerSat;
  } else {
    /* Outport: '<Root>/y' */
    Discrete_Y.y = u;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* Update for DiscreteIntegrator: '<S1>/Integrator' incorporates:
   *  Gain: '<S1>/Integral Gain'
   *  Inport: '<Root>/u'
   */
  Discrete_DW.Integrator_DSTATE += Discrete_P.IntegralGain_Gain * Discrete_U.u *
    Discrete_P.Integrator_gainval;

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  Discrete_DW.Filter_DSTATE += Discrete_P.Filter_gainval * rtb_FilterCoefficient;

  /* Matfile logging */
  rt_UpdateTXYLogVars(Discrete_M->rtwLogInfo, (&Discrete_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [5.0E-5s, 0.0s] */
    if ((rtmGetTFinal(Discrete_M)!=-1) &&
        !((rtmGetTFinal(Discrete_M)-Discrete_M->Timing.taskTime0) >
          Discrete_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(Discrete_M, "Simulation finished");
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
  if (!(++Discrete_M->Timing.clockTick0)) {
    ++Discrete_M->Timing.clockTickH0;
  }

  Discrete_M->Timing.taskTime0 = Discrete_M->Timing.clockTick0 *
    Discrete_M->Timing.stepSize0 + Discrete_M->Timing.clockTickH0 *
    Discrete_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void Discrete_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)Discrete_M, 0,
                sizeof(RT_MODEL_Discrete_T));
  rtmSetTFinal(Discrete_M, 0.25);
  Discrete_M->Timing.stepSize0 = 5.0E-5;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    Discrete_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(Discrete_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(Discrete_M->rtwLogInfo, (NULL));
    rtliSetLogT(Discrete_M->rtwLogInfo, "tout");
    rtliSetLogX(Discrete_M->rtwLogInfo, "");
    rtliSetLogXFinal(Discrete_M->rtwLogInfo, "");
    rtliSetSigLog(Discrete_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(Discrete_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(Discrete_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(Discrete_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(Discrete_M->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &Discrete_Y.y
      };

      rtliSetLogYSignalPtrs(Discrete_M->rtwLogInfo, ((LogSignalPtrsType)
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
        "Discrete/y" };

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

      rtliSetLogYSignalInfo(Discrete_M->rtwLogInfo, rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
    }

    rtliSetLogY(Discrete_M->rtwLogInfo, "yout");
  }

  /* states (dwork) */
  (void) memset((void *)&Discrete_DW, 0,
                sizeof(DW_Discrete_T));

  /* external inputs */
  Discrete_U.u = 0.0;

  /* external outputs */
  Discrete_Y.y = 0.0;

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(Discrete_M->rtwLogInfo, 0.0, rtmGetTFinal
    (Discrete_M), Discrete_M->Timing.stepSize0, (&rtmGetErrorStatus(Discrete_M)));

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  Discrete_DW.Integrator_DSTATE = Discrete_P.Integrator_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  Discrete_DW.Filter_DSTATE = Discrete_P.Filter_IC;
}

/* Model terminate function */
void Discrete_terminate(void)
{
  /* (no terminate code required) */
}
