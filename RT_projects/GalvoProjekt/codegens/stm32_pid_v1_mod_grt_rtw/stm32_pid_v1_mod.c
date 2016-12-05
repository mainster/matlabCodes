/*
 * stm32_pid_v1_mod.c
 *
 * Code generation for model "stm32_pid_v1_mod".
 *
 * Model version              : 1.48
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Wed Aug 13 07:05:03 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Atmel->AVR
 * Code generation objective: Debugging
 * Validation result: Not run
 */
#include "rt_logging_mmi.h"
#include "stm32_pid_v1_mod_capi.h"
#include "stm32_pid_v1_mod.h"
#include "stm32_pid_v1_mod_private.h"

/* Block signals (auto storage) */
B_stm32_pid_v1_mod_T stm32_pid_v1_mod_B;

/* Block states (auto storage) */
DW_stm32_pid_v1_mod_T stm32_pid_v1_mod_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_stm32_pid_v1_mod_T stm32_pid_v1_mod_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_stm32_pid_v1_mod_T stm32_pid_v1_mod_Y;

/* Real-time model */
RT_MODEL_stm32_pid_v1_mod_T stm32_pid_v1_mod_M_;
RT_MODEL_stm32_pid_v1_mod_T *const stm32_pid_v1_mod_M = &stm32_pid_v1_mod_M_;

/* Model output function */
static void stm32_pid_v1_mod_output(void)
{
  real_T u;
  real_T u_0;
  real_T u_1;

  /* DiscreteZeroPole: '<Root>/Discrete Zero-Pole' */
  {
    stm32_pid_v1_mod_Y.Out1 = (stm32_pid_v1_mod_P.DiscreteZeroPole_C[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole_C[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[1];
  }

  /* Gain: '<S1>/Derivative Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.DerivativeGain = stm32_pid_v1_mod_P.DerivativeGain_Gain *
    stm32_pid_v1_mod_U.In1;

  /* DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_B.Filter = stm32_pid_v1_mod_DW.Filter_DSTATE;

  /* Sum: '<S1>/SumD' */
  stm32_pid_v1_mod_B.SumD = stm32_pid_v1_mod_B.DerivativeGain -
    stm32_pid_v1_mod_B.Filter;

  /* Gain: '<S1>/Filter Coefficient' */
  stm32_pid_v1_mod_B.FilterCoefficient =
    stm32_pid_v1_mod_P.FilterCoefficient_Gain * stm32_pid_v1_mod_B.SumD;

  /* Gain: '<S1>/Integral Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.IntegralGain = stm32_pid_v1_mod_P.IntegralGain_Gain *
    stm32_pid_v1_mod_U.In1;

  /* DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_B.Integrator = stm32_pid_v1_mod_DW.Integrator_DSTATE;

  /* Gain: '<S1>/Proportional Gain' incorporates:
   *  Inport: '<Root>/In1'
   */
  stm32_pid_v1_mod_B.ProportionalGain = stm32_pid_v1_mod_P.ProportionalGain_Gain
    * stm32_pid_v1_mod_U.In1;

  /* Sum: '<S1>/Sum' */
  stm32_pid_v1_mod_B.Sum = (stm32_pid_v1_mod_B.ProportionalGain +
    stm32_pid_v1_mod_B.Integrator) + stm32_pid_v1_mod_B.FilterCoefficient;

  /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
  stm32_pid_v1_mod_B.PulseGenerator = (stm32_pid_v1_mod_DW.clockTickCounter <
    stm32_pid_v1_mod_P.PulseGenerator_Duty) &&
    (stm32_pid_v1_mod_DW.clockTickCounter >= 0L) ?
    stm32_pid_v1_mod_P.PulseGenerator_Amp : 0.0;
  if (stm32_pid_v1_mod_DW.clockTickCounter >=
      stm32_pid_v1_mod_P.PulseGenerator_Period - 1.0) {
    stm32_pid_v1_mod_DW.clockTickCounter = 0L;
  } else {
    stm32_pid_v1_mod_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */

  /* Sum: '<Root>/Sum1' incorporates:
   *  Constant: '<Root>/Constant'
   */
  stm32_pid_v1_mod_B.Sum1 = stm32_pid_v1_mod_B.PulseGenerator +
    stm32_pid_v1_mod_P.Constant_Value;

  /* DiscreteZeroPole: '<Root>/Discrete Zero-Pole1' */
  {
    stm32_pid_v1_mod_B.DiscreteZeroPole1 =
      (stm32_pid_v1_mod_P.DiscreteZeroPole1_C[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole1_C[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[1];
  }

  /* Sum: '<Root>/Sum' */
  stm32_pid_v1_mod_B.Sum_o = stm32_pid_v1_mod_B.Sum1 -
    stm32_pid_v1_mod_B.DiscreteZeroPole1;

  /* Gain: '<S2>/Proportional Gain' */
  stm32_pid_v1_mod_B.ProportionalGain_a =
    stm32_pid_v1_mod_P.ProportionalGain_Gain_o * stm32_pid_v1_mod_B.Sum_o;

  /* DiscreteIntegrator: '<S2>/Integrator' */
  stm32_pid_v1_mod_B.Integrator_o = stm32_pid_v1_mod_DW.Integrator_DSTATE_c;

  /* Gain: '<S2>/Derivative Gain' */
  stm32_pid_v1_mod_B.DerivativeGain_o = stm32_pid_v1_mod_P.DerivativeGain_Gain_e
    * stm32_pid_v1_mod_B.Sum_o;

  /* DiscreteIntegrator: '<S2>/Filter' */
  stm32_pid_v1_mod_B.Filter_c = stm32_pid_v1_mod_DW.Filter_DSTATE_e;

  /* Sum: '<S2>/SumD' */
  stm32_pid_v1_mod_B.SumD_e = stm32_pid_v1_mod_B.DerivativeGain_o -
    stm32_pid_v1_mod_B.Filter_c;

  /* Gain: '<S2>/Filter Coefficient' */
  stm32_pid_v1_mod_B.FilterCoefficient_m =
    stm32_pid_v1_mod_P.FilterCoefficient_Gain_a * stm32_pid_v1_mod_B.SumD_e;

  /* Sum: '<S2>/Sum' */
  stm32_pid_v1_mod_B.Sum_ot = (stm32_pid_v1_mod_B.ProportionalGain_a +
    stm32_pid_v1_mod_B.Integrator_o) + stm32_pid_v1_mod_B.FilterCoefficient_m;

  /* Saturate: '<S2>/Saturation' */
  u = stm32_pid_v1_mod_B.Sum_ot;
  u_0 = stm32_pid_v1_mod_P.Saturation_LowerSat;
  u_1 = stm32_pid_v1_mod_P.Saturation_UpperSat;
  if (u >= u_1) {
    stm32_pid_v1_mod_B.Saturation = u_1;
  } else if (u <= u_0) {
    stm32_pid_v1_mod_B.Saturation = u_0;
  } else {
    stm32_pid_v1_mod_B.Saturation = u;
  }

  /* End of Saturate: '<S2>/Saturation' */

  /* Gain: '<S2>/Integral Gain' */
  stm32_pid_v1_mod_B.IntegralGain_m = stm32_pid_v1_mod_P.IntegralGain_Gain_n *
    stm32_pid_v1_mod_B.Sum_o;
}

/* Model update function */
static void stm32_pid_v1_mod_update(void)
{
  /* Update for DiscreteZeroPole: '<Root>/Discrete Zero-Pole' */
  {
    real_T xnew[2];
    xnew[0] = (stm32_pid_v1_mod_P.DiscreteZeroPole_A[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole_A[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[1];
    xnew[0] += stm32_pid_v1_mod_P.DiscreteZeroPole_B*stm32_pid_v1_mod_B.Sum;
    xnew[1] = (stm32_pid_v1_mod_P.DiscreteZeroPole_A[2])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0];
    (void) memcpy(&stm32_pid_v1_mod_DW.DiscreteZeroPole_DSTATE[0], xnew,
                  sizeof(real_T)*2);
  }

  /* Update for DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE += stm32_pid_v1_mod_P.Filter_gainval *
    stm32_pid_v1_mod_B.FilterCoefficient;

  /* Update for DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE += stm32_pid_v1_mod_P.Integrator_gainval
    * stm32_pid_v1_mod_B.IntegralGain;

  /* Update for DiscreteZeroPole: '<Root>/Discrete Zero-Pole1' */
  {
    real_T xnew[2];
    xnew[0] = (stm32_pid_v1_mod_P.DiscreteZeroPole1_A[0])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[0]
      + (stm32_pid_v1_mod_P.DiscreteZeroPole1_A[1])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[1];
    xnew[0] += stm32_pid_v1_mod_P.DiscreteZeroPole1_B*
      stm32_pid_v1_mod_B.Saturation;
    xnew[1] = (stm32_pid_v1_mod_P.DiscreteZeroPole1_A[2])*
      stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[0];
    (void) memcpy(&stm32_pid_v1_mod_DW.DiscreteZeroPole1_DSTATE[0], xnew,
                  sizeof(real_T)*2);
  }

  /* Update for DiscreteIntegrator: '<S2>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE_c +=
    stm32_pid_v1_mod_P.Integrator_gainval_l * stm32_pid_v1_mod_B.IntegralGain_m;

  /* Update for DiscreteIntegrator: '<S2>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE_e += stm32_pid_v1_mod_P.Filter_gainval_c *
    stm32_pid_v1_mod_B.FilterCoefficient_m;

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++stm32_pid_v1_mod_M->Timing.clockTick0)) {
    ++stm32_pid_v1_mod_M->Timing.clockTickH0;
  }

  stm32_pid_v1_mod_M->Timing.t[0] = stm32_pid_v1_mod_M->Timing.clockTick0 *
    stm32_pid_v1_mod_M->Timing.stepSize0 +
    stm32_pid_v1_mod_M->Timing.clockTickH0 *
    stm32_pid_v1_mod_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void stm32_pid_v1_mod_initialize(void)
{
  /* Start for DiscretePulseGenerator: '<Root>/Pulse Generator' */
  stm32_pid_v1_mod_DW.clockTickCounter = -667L;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE = stm32_pid_v1_mod_P.Filter_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE = stm32_pid_v1_mod_P.Integrator_IC;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Integrator' */
  stm32_pid_v1_mod_DW.Integrator_DSTATE_c = stm32_pid_v1_mod_P.Integrator_IC_o;

  /* InitializeConditions for DiscreteIntegrator: '<S2>/Filter' */
  stm32_pid_v1_mod_DW.Filter_DSTATE_e = stm32_pid_v1_mod_P.Filter_IC_h;
}

/* Model terminate function */
void stm32_pid_v1_mod_terminate(void)
{
  /* (no terminate code required) */
}

/*========================================================================*
 * Start of Classic call interface                                        *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  stm32_pid_v1_mod_output();

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

void MdlUpdate(int_T tid)
{
  stm32_pid_v1_mod_update();

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
  stm32_pid_v1_mod_initialize();
}

void MdlTerminate(void)
{
  stm32_pid_v1_mod_terminate();
}

/* Registration function */
RT_MODEL_stm32_pid_v1_mod_T *stm32_pid_v1_mod(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)stm32_pid_v1_mod_M, 0,
                sizeof(RT_MODEL_stm32_pid_v1_mod_T));

  /* Initialize timing info */
  {
    int_T *mdlTsMap = stm32_pid_v1_mod_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    stm32_pid_v1_mod_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    stm32_pid_v1_mod_M->Timing.sampleTimes =
      (&stm32_pid_v1_mod_M->Timing.sampleTimesArray[0]);
    stm32_pid_v1_mod_M->Timing.offsetTimes =
      (&stm32_pid_v1_mod_M->Timing.offsetTimesArray[0]);

    /* task periods */
    stm32_pid_v1_mod_M->Timing.sampleTimes[0] = (5.0E-5);

    /* task offsets */
    stm32_pid_v1_mod_M->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(stm32_pid_v1_mod_M, &stm32_pid_v1_mod_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = stm32_pid_v1_mod_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    stm32_pid_v1_mod_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(stm32_pid_v1_mod_M, 0.25);
  stm32_pid_v1_mod_M->Timing.stepSize0 = 5.0E-5;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    stm32_pid_v1_mod_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(stm32_pid_v1_mod_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(stm32_pid_v1_mod_M->rtwLogInfo, (NULL));
    rtliSetLogT(stm32_pid_v1_mod_M->rtwLogInfo, "tout");
    rtliSetLogX(stm32_pid_v1_mod_M->rtwLogInfo, "");
    rtliSetLogXFinal(stm32_pid_v1_mod_M->rtwLogInfo, "");
    rtliSetSigLog(stm32_pid_v1_mod_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(stm32_pid_v1_mod_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(stm32_pid_v1_mod_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(stm32_pid_v1_mod_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(stm32_pid_v1_mod_M->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &stm32_pid_v1_mod_Y.Out1
      };

      rtliSetLogYSignalPtrs(stm32_pid_v1_mod_M->rtwLogInfo, ((LogSignalPtrsType)
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
        2
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
        "stm32_pid_v1_mod/Out1" };

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

      rtliSetLogYSignalInfo(stm32_pid_v1_mod_M->rtwLogInfo,
                            rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
    }

    rtliSetLogY(stm32_pid_v1_mod_M->rtwLogInfo, "yout");
  }

  stm32_pid_v1_mod_M->solverInfoPtr = (&stm32_pid_v1_mod_M->solverInfo);
  stm32_pid_v1_mod_M->Timing.stepSize = (5.0E-5);
  rtsiSetFixedStepSize(&stm32_pid_v1_mod_M->solverInfo, 5.0E-5);
  rtsiSetSolverMode(&stm32_pid_v1_mod_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  stm32_pid_v1_mod_M->ModelData.blockIO = ((void *) &stm32_pid_v1_mod_B);
  (void) memset(((void *) &stm32_pid_v1_mod_B), 0,
                sizeof(B_stm32_pid_v1_mod_T));

  /* parameters */
  stm32_pid_v1_mod_M->ModelData.defaultParam = ((real_T *)&stm32_pid_v1_mod_P);

  /* states (dwork) */
  stm32_pid_v1_mod_M->ModelData.dwork = ((void *) &stm32_pid_v1_mod_DW);
  (void) memset((void *)&stm32_pid_v1_mod_DW, 0,
                sizeof(DW_stm32_pid_v1_mod_T));

  /* external inputs */
  stm32_pid_v1_mod_M->ModelData.inputs = (((void*)&stm32_pid_v1_mod_U));
  stm32_pid_v1_mod_U.In1 = 0.0;

  /* external outputs */
  stm32_pid_v1_mod_M->ModelData.outputs = (&stm32_pid_v1_mod_Y);
  stm32_pid_v1_mod_Y.Out1 = 0.0;

  /* Initialize DataMapInfo substructure containing ModelMap for C API */
  stm32_pid_v1_mod_InitializeDataMapInfo(stm32_pid_v1_mod_M);

  /* Initialize Sizes */
  stm32_pid_v1_mod_M->Sizes.numContStates = (0);/* Number of continuous states */
  stm32_pid_v1_mod_M->Sizes.numY = (1);/* Number of model outputs */
  stm32_pid_v1_mod_M->Sizes.numU = (1);/* Number of model inputs */
  stm32_pid_v1_mod_M->Sizes.sysDirFeedThru = (1);/* The model is direct feedthrough */
  stm32_pid_v1_mod_M->Sizes.numSampTimes = (1);/* Number of sample times */
  stm32_pid_v1_mod_M->Sizes.numBlocks = (25);/* Number of blocks */
  stm32_pid_v1_mod_M->Sizes.numBlockIO = (22);/* Number of block outputs */
  stm32_pid_v1_mod_M->Sizes.numBlockPrms = (35);/* Sum of parameter "widths" */
  return stm32_pid_v1_mod_M;
}

/*========================================================================*
 * End of Classic call interface                                          *
 *========================================================================*/
