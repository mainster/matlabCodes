/*
 * PID0_sf.c
 *
 * Code generation for model "PID0_sf".
 *
 * Model version              : 1.32
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Jul 20 07:34:52 2014
 *
 * Target selection: rtwsfcn.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Emulation hardware selection:
 *    Differs from embedded hardware (MATLAB Host)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include <math.h>
#include "PID0_sf.h"
#include "PID0_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *PID0_malloc(SimStruct *S);

#endif

#ifndef __RTW_UTFREE__
#if defined (MATLAB_MEX_FILE)

extern void * utMalloc(size_t);
extern void utFree(void *);

#endif
#endif                                 /* #ifndef __RTW_UTFREE__ */

#if defined(MATLAB_MEX_FILE)
#include "rt_nonfinite.c"
#endif

static const char_T *RT_MEMORY_ALLOCATION_ERROR =
  "memory allocation error in generated S-Function";

/* Initial conditions for root system: '<Root>' */
#define MDL_INITIALIZE_CONDITIONS

static void mdlInitializeConditions(SimStruct *S)
{
  /* InitializeConditions for DiscreteIntegrator: '<S1>/Filter' */
  ((real_T *)ssGetDWork(S, 0))[0] = 0.0;

  /* InitializeConditions for DiscreteIntegrator: '<S1>/Integrator' */
  ((real_T *)ssGetDWork(S, 1))[0] = 0.0;
}

/* Start for root system: '<Root>' */
#define MDL_START

static void mdlStart(SimStruct *S)
{
  /* instance underlying S-Function data */
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)
#  if defined(MATLAB_MEX_FILE)

  /* non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

#  endif

  PID0_malloc(S);
  if (ssGetErrorStatus(S) != (NULL) ) {
    return;
  }

#endif

  {
  }
}

/* Outputs for root system: '<Root>' */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  B_PID0_T *_rtB;
  _rtB = ((B_PID0_T *) ssGetLocalBlockIO(S));
  if (ssIsSampleHit(S, 1, 0)) {
    /* Gain: '<S1>/Filter Coefficient' incorporates:
     *  DiscreteIntegrator: '<S1>/Filter'
     *  Gain: '<S1>/Derivative Gain'
     *  Inport: '<Root>/u'
     *  Sum: '<S1>/SumD'
     */
    _rtB->FilterCoefficient = (-0.00826902631159402 * *((const real_T **)
      ssGetInputPortSignalPtrs(S, 0))[0] - ((real_T *)ssGetDWork(S, 0))[0]) *
      118738.277278908;

    /* Gain: '<S1>/Integral Gain' incorporates:
     *  Inport: '<Root>/u'
     */
    _rtB->IntegralGain = -5096.57986519734 * *((const real_T **)
      ssGetInputPortSignalPtrs(S, 0))[0];

    /* Outport: '<Root>/y' incorporates:
     *  DiscreteIntegrator: '<S1>/Integrator'
     *  Gain: '<S1>/Proportional Gain'
     *  Inport: '<Root>/u'
     *  Sum: '<S1>/Sum'
     */
    ((real_T *)ssGetOutputPortSignal(S, 0))[0] = (-14.0184615901254 * *((const
      real_T **)ssGetInputPortSignalPtrs(S, 0))[0] + ((real_T *)ssGetDWork(S, 1))
      [0]) + _rtB->FilterCoefficient;
  }

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

/* Update for root system: '<Root>' */
#define MDL_UPDATE

static void mdlUpdate(SimStruct *S, int_T tid)
{
  B_PID0_T *_rtB;
  _rtB = ((B_PID0_T *) ssGetLocalBlockIO(S));
  if (ssIsSampleHit(S, 1, 0)) {
    /* Update for DiscreteIntegrator: '<S1>/Filter' */
    ((real_T *)ssGetDWork(S, 0))[0] = 1.0E-6 * _rtB->FilterCoefficient +
      ((real_T *)ssGetDWork(S, 0))[0];

    /* Update for DiscreteIntegrator: '<S1>/Integrator' */
    ((real_T *)ssGetDWork(S, 1))[0] = 1.0E-6 * _rtB->IntegralGain + ((real_T *)
      ssGetDWork(S, 1))[0];
  }

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

/* Termination for root system: '<Root>' */
static void mdlTerminate(SimStruct *S)
{

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

  if (ssGetUserData(S) != (NULL) ) {
    rt_FREE(ssGetLocalBlockIO(S));
  }

  rt_FREE(ssGetUserData(S));

#endif

}

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)
#  include "PID0_mid.h"
#endif

/* Function to initialize sizes. */
static void mdlInitializeSizes(SimStruct *S)
{
  ssSetNumSampleTimes(S, 2);           /* Number of sample times */
  ssSetNumContStates(S, 0);            /* Number of continuous states */
  ssSetNumNonsampledZCs(S, 0);         /* Number of nonsampled ZCs */
  ssSetZCCacheNeedsReset(S, 0);
  ssSetDerivCacheNeedsReset(S, 0);

  /* Number of output ports */
  if (!ssSetNumOutputPorts(S, 1))
    return;

  /* outport number: 0 */
  if (!ssSetOutputPortVectorDimension(S, 0, 1))
    return;
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
  }

  ssSetOutputPortSampleTime(S, 0, 1.0E-6);
  ssSetOutputPortOffsetTime(S, 0, 0.0);
  ssSetOutputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);

  /* Number of input ports */
  if (!ssSetNumInputPorts(S, 1))
    return;

  /* inport number: 0 */
  {
    if (!ssSetInputPortVectorDimension(S, 0, 1))
      return;
    if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {
      ssSetInputPortDataType(S, 0, SS_DOUBLE);
    }

    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortSampleTime(S, 0, 1.0E-6);
    ssSetInputPortOffsetTime(S, 0, 0.0);
    ssSetInputPortOverWritable(S, 0, 0);
    ssSetInputPortOptimOpts(S, 0, SS_NOT_REUSABLE_AND_GLOBAL);
  }

  ssSetRTWGeneratedSFcn(S, 1);         /* Generated S-function */

  /* DWork */
  if (!ssSetNumDWork(S, 2)) {
    return;
  }

  /* '<S1>/Filter': DSTATE */
  ssSetDWorkName(S, 0, "DWORK0");
  ssSetDWorkWidth(S, 0, 1);
  ssSetDWorkUsedAsDState(S, 0, 1);

  /* '<S1>/Integrator': DSTATE */
  ssSetDWorkName(S, 1, "DWORK1");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkUsedAsDState(S, 1, 1);

  /* Tunable Parameters */
  ssSetNumSFcnParams(S, 0);

  /* Number of expected parameters */
#if defined(MATLAB_MEX_FILE)

  if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {

#if defined(MDL_CHECK_PARAMETERS)

    mdlCheckParameters(S);

#endif                                 /* MDL_CHECK_PARAMETERS */

    if (ssGetErrorStatus(S) != (NULL) ) {
      return;
    }
  } else {
    return;                            /* Parameter mismatch will be reported by Simulink */
  }

#endif                                 /* MATLAB_MEX_FILE */

  /* Options */
  ssSetOptions(S, (SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE |
                   SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED ));

#if SS_SFCN_FOR_SIM

  {
    ssSupportsMultipleExecInstances(S, true);
    ssHasStateInsideForEachSS(S, false);
  }

#endif

}

/* Function to initialize sample times. */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  /* task periods */
  ssSetSampleTime(S, 0, 0.0);
  ssSetSampleTime(S, 1, 1.0E-6);

  /* task offsets */
  ssSetOffsetTime(S, 0, 1.0);
  ssSetOffsetTime(S, 1, 0.0);
}

#if defined(MATLAB_MEX_FILE)
# include "fixedpoint.c"
# include "simulink.c"
#else
# undef S_FUNCTION_NAME
# define S_FUNCTION_NAME               PID0_sf
# include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
