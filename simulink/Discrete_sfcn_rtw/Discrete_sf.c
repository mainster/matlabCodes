/*
 * Discrete_sf.c
 *
 * Code generation for model "Discrete_sf".
 *
 * Model version              : 1.69
 * Simulink Coder version : 8.5 (R2013b) 08-Aug-2013
 * C source code generated on : Thu Apr 24 03:20:16 2014
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
#include "Discrete_sf.h"
#include "Discrete_sf_private.h"
#include "simstruc.h"
#include "fixedpoint.h"
#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

extern void *Discrete_malloc(SimStruct *S);

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

  Discrete_malloc(S);
  if (ssGetErrorStatus(S) != (NULL) ) {
    return;
  }

#endif

  {
    B_Discrete_T *_rtB;
    _rtB = ((B_Discrete_T *) ssGetLocalBlockIO(S));

    /* S-Function Block: <S1>/S-Function  */
    {
      ((pointer_T*) ssGetDWork(S, 0))[0] = calloc(16, sizeof(real_T));
      ss_VALIDATE_MEMORY(S,((pointer_T*) ssGetDWork(S, 0))[0])
    }

      {
        int ids;

        /* Assign default sample(s) */
        if (((pointer_T*) ssGetDWork(S, 0))[0] != NULL) {
          for (ids = 0; ids < 16; ++ids)
            ((real_T *)((pointer_T*) ssGetDWork(S, 0))[0])[ids] = (real_T)0.0;
        }

        /* Set work values */
        ((int_T*) ssGetDWork(S, 1))[0] = 0;
      }
    }
  }

  /* Outputs for root system: '<Root>' */
  static void mdlOutputs(SimStruct *S, int_T tid)
  {
    B_Discrete_T *_rtB;
    _rtB = ((B_Discrete_T *) ssGetLocalBlockIO(S));

    /* S-Function block: <S1>/S-Function  */
    {
      int nSamples = 16 ;
      int io = 0;
      int iv;
      int ind_Ps = ((int_T*) ssGetDWork(S, 1))[0];

      /* Input present value(s) */
      ((real_T *)((pointer_T*) ssGetDWork(S, 0))[0])[ind_Ps] = *((const real_T**)
        ssGetInputPortSignalPtrs(S, 0))[0];

      /* Output past value(s) */
      /* Output from present sample index to 0 */
      for (iv = ind_Ps; iv >= 0; --iv)
        (&_rtB->SFunction[0])[io++] = ((real_T *)((pointer_T*) ssGetDWork(S, 0))
          [0])[iv];

      /* Output from end of buffer to present sample index excl. */
      for (iv = nSamples-1; iv > ind_Ps; --iv)
        (&_rtB->SFunction[0])[io++] = ((real_T *)((pointer_T*) ssGetDWork(S, 0))
          [0])[iv];

      /* Update ring buffer index */
      if (++(((int_T*) ssGetDWork(S, 1))[0]) == nSamples)
        ((int_T*) ssGetDWork(S, 1))[0] = 0;
    }

    /* Outport: '<Root>/Out' */
    memcpy(&((real_T *)ssGetOutputPortSignal(S, 0))[0], &_rtB->SFunction[0],
           sizeof(real_T) << 4U);
    UNUSED_PARAMETER(tid);
  }

  /* Update for root system: '<Root>' */
#define MDL_UPDATE

  static void mdlUpdate(SimStruct *S, int_T tid)
  {
    UNUSED_PARAMETER(tid);
  }

  /* Termination for root system: '<Root>' */
  static void mdlTerminate(SimStruct *S)
  {
    B_Discrete_T *_rtB;
    _rtB = ((B_Discrete_T *) ssGetLocalBlockIO(S));

    /* S-Function block: <S1>/S-Function  */
    {
      /* Free memory */
      if (((pointer_T*) ssGetDWork(S, 0))[0] != NULL) {
        free(((pointer_T*) ssGetDWork(S, 0))[0]);
      }
    }

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)

    if (ssGetUserData(S) != (NULL) ) {
      rt_FREE(ssGetLocalBlockIO(S));
    }

    rt_FREE(ssGetUserData(S));

#endif

  }

#if defined(RT_MALLOC) || defined(MATLAB_MEX_FILE)
#  include "Discrete_mid.h"
#endif

  /* Function to initialize sizes. */
  static void mdlInitializeSizes(SimStruct *S)
  {
    ssSetNumSampleTimes(S, 1);         /* Number of sample times */
    ssSetNumContStates(S, 0);          /* Number of continuous states */
    ssSetNumNonsampledZCs(S, 0);       /* Number of nonsampled ZCs */

    /* Number of output ports */
    if (!ssSetNumOutputPorts(S, 1))
      return;

    /* outport number: 0 */
    if (!ssSetOutputPortVectorDimension(S, 0, 16))
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

    ssSetRTWGeneratedSFcn(S, 1);       /* Generated S-function */

    /* DWork */
    if (!ssSetNumDWork(S, 2)) {
      return;
    }

    /* '<S1>/S-Function ': PWORK */
    ssSetDWorkName(S, 0, "DWORK0");
    ssSetDWorkWidth(S, 0, 1);
    ssSetDWorkDataType(S, 0, SS_POINTER);

    /* '<S1>/S-Function ': IWORK */
    ssSetDWorkName(S, 1, "DWORK1");
    ssSetDWorkWidth(S, 1, 2);
    ssSetDWorkDataType(S, 1, SS_INTEGER);

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
      return;                          /* Parameter mismatch will be reported by Simulink */
    }

#endif                                 /* MATLAB_MEX_FILE */

    /* Options */
    ssSetOptions(S, (SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE |
                     SS_OPTION_PORT_SAMPLE_TIMES_ASSIGNED ));

#if SS_SFCN_FOR_SIM

    {
      ssSupportsMultipleExecInstances(S, false);
      ssRegisterMsgForNotSupportingMultiExecInst(S,
        "<diag_root><diag id=\"Simulink:blocks:BlockDoesNotSupportMultiExecInstances\"><arguments><arg type=\"encoded\">RABpAHMAYwByAGUAdABlAC8ARABpAHMAYwByAGUAdABlACAAUwBoAGkAZgB0ACAAUgBlAGcAaQBzAHQAZQByADIALwBTAC0ARgB1AG4AYwB0AGkAbwBuACAAAAA=</arg><arg type=\"encoded\">PABfAF8AaQBpAFMAUwBfAF8APgA8AC8AXwBfAGkAaQBTAFMAXwBfAD4AAAA=</arg><arg type=\"encoded\">PABfAF8AaQB0AGUAcgBCAGwAawBfAF8APgA8AC8AXwBfAGkAdABlAHIAQgBsAGsAXwBfAD4AAAA=</arg></arguments></diag>\n</diag_root>");
      ssHasStateInsideForEachSS(S, false);
    }

#endif

  }

  /* Function to initialize sample times. */
  static void mdlInitializeSampleTimes(SimStruct *S)
  {
    /* task periods */
    ssSetSampleTime(S, 0, 1.0E-6);

    /* task offsets */
    ssSetOffsetTime(S, 0, 0.0);
  }

#if defined(MATLAB_MEX_FILE)
# include "fixedpoint.c"
# include "simulink.c"
#else
# undef S_FUNCTION_NAME
# define S_FUNCTION_NAME               Discrete_sf
# include "cg_sfun.h"
#endif                                 /* defined(MATLAB_MEX_FILE) */
