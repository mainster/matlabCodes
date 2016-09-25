/*
 * Discrete_sf.h
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
#ifndef RTW_HEADER_Discrete_sf_h_
#define RTW_HEADER_Discrete_sf_h_
#ifndef Discrete_sf_COMMON_INCLUDES_
# define Discrete_sf_COMMON_INCLUDES_
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#define S_FUNCTION_NAME                Discrete_sf
#define S_FUNCTION_LEVEL               2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "multiword_types.h"
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
#endif                                 /* Discrete_sf_COMMON_INCLUDES_ */

#include "Discrete_sf_types.h"

/* Block signals (auto storage) */
typedef struct {
  real_T SFunction[16];                /* '<S1>/S-Function ' */
} B_Discrete_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T *uk;                          /* '<Root>/u(k)' */
} ExternalUPtrs_Discrete_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T *Out[16];                     /* '<Root>/Out' */
} ExtY_Discrete_T;

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
 * hilite_system('spiBitbang_complete_v1_3_billigShiftreg/RxSubsystem1/Discrete Shift Register2')    - opens subsystem spiBitbang_complete_v1_3_billigShiftreg/RxSubsystem1/Discrete Shift Register2
 * hilite_system('spiBitbang_complete_v1_3_billigShiftreg/RxSubsystem1/Discrete Shift Register2/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'spiBitbang_complete_v1_3_billigShiftreg/RxSubsystem1'
 * '<S1>'   : 'spiBitbang_complete_v1_3_billigShiftreg/RxSubsystem1/Discrete Shift Register2'
 */
#endif                                 /* RTW_HEADER_Discrete_sf_h_ */
