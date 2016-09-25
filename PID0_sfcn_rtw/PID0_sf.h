/*
 * PID0_sf.h
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
#ifndef RTW_HEADER_PID0_sf_h_
#define RTW_HEADER_PID0_sf_h_
#ifndef PID0_sf_COMMON_INCLUDES_
# define PID0_sf_COMMON_INCLUDES_
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#define S_FUNCTION_NAME                PID0_sf
#define S_FUNCTION_LEVEL               2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
#if !defined(MATLAB_MEX_FILE)
#include "rt_matrx.h"
#endif

#if !defined(RTW_SFUNCTION_DEFINES)
#define RTW_SFUNCTION_DEFINES

typedef struct {
  void *blockIO;
  void *defaultParam;
  void *nonContDerivSig;
} LocalS;

#define ssSetLocalBlockIO(S, io)       ((LocalS *)ssGetUserData(S))->blockIO = ((void *)(io))
#define ssGetLocalBlockIO(S)           ((LocalS *)ssGetUserData(S))->blockIO
#define ssSetLocalDefaultParam(S, paramVector) ((LocalS *)ssGetUserData(S))->defaultParam = (paramVector)
#define ssGetLocalDefaultParam(S)      ((LocalS *)ssGetUserData(S))->defaultParam
#define ssSetLocalNonContDerivSig(S, pSig) ((LocalS *)ssGetUserData(S))->nonContDerivSig = (pSig)
#define ssGetLocalNonContDerivSig(S)   ((LocalS *)ssGetUserData(S))->nonContDerivSig
#endif
#endif                                 /* PID0_sf_COMMON_INCLUDES_ */

#include "PID0_sf_types.h"

/* Block signals (auto storage) */
typedef struct {
  real_T FilterCoefficient;            /* '<S1>/Filter Coefficient' */
  real_T IntegralGain;                 /* '<S1>/Integral Gain' */
} B_PID0_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T *u;                           /* '<Root>/u' */
} ExternalUPtrs_PID0_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T *y;                           /* '<Root>/y' */
} ExtY_PID0_T;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Note that this particular code originates from a subsystem build,
 * and has its own system numbers different from the parent model.
 * Refer to the system hierarchy for this subsystem below, and use the
 * MATLAB hilite_system command to trace the generated code back
 * to the parent model.  For example,
 *
 * hilite_system('GalvoModel_v3_PID_tfCC/PID Controller')    - opens subsystem GalvoModel_v3_PID_tfCC/PID Controller
 * hilite_system('GalvoModel_v3_PID_tfCC/PID Controller/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'GalvoModel_v3_PID_tfCC'
 * '<S1>'   : 'GalvoModel_v3_PID_tfCC/PID Controller'
 */
#endif                                 /* RTW_HEADER_PID0_sf_h_ */
