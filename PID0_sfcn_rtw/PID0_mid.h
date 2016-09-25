/*
 * PID0_mid.h
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
 *
 * SOURCES: PID0_sf.c
 */

#include "simstruc.h"
#include "PID0_sf.h"
#if defined(MATLAB_MEX_FILE) || defined(RT_MALLOC)

static int_T RegNumInputPorts(SimStruct *S, int_T nInputPorts)
{
  _ssSetNumInputPorts(S,nInputPorts);
  return TRUE;
}

static int_T RegNumOutputPorts(SimStruct *S, int_T nOutputPorts)
{
  _ssSetNumOutputPorts(S,nOutputPorts);
  return TRUE;
}

static int_T FcnSetErrorStatus(const SimStruct *S, DTypeId arg2)
{
  static char msg[256];
  if (strlen(ssGetModelName(S)) < 128) {
    sprintf(msg,
            "S-function %s does not have a tlc file. It cannot use macros that access regDataType field in simstruct.",
            ssGetModelName(S));
  } else {
    sprintf(msg,
            "A S-function does not have a tlc file. It cannot use macros that access regDataType field in simstruct.");
  }

  ssSetErrorStatus(S, msg);
  UNUSED_PARAMETER(arg2);
  return 0;
}

#endif

/* Instance data for model: PID0 */
void *PID0_malloc(SimStruct *rts)
{
  /* Local SimStruct for the generated S-Function */
  LocalS *lS = (LocalS *) malloc(sizeof(LocalS));
  rt_VALIDATE_MEMORY(rts,lS);
  (void) memset((char *) lS, 0,
                sizeof(LocalS));
  ssSetUserData(rts, lS);

  /* block I/O */
  {
    void *b = malloc(sizeof(B_PID0_T));
    rt_VALIDATE_MEMORY(rts,b);
    ssSetLocalBlockIO(rts, b);
    (void) memset(b, 0,
                  sizeof(B_PID0_T));
  }

  /* model checksums */
  ssSetChecksumVal(rts, 0, 105880331U);
  ssSetChecksumVal(rts, 1, 3332762590U);
  ssSetChecksumVal(rts, 2, 1607264141U);
  ssSetChecksumVal(rts, 3, 793156340U);
  return (NULL);
}
