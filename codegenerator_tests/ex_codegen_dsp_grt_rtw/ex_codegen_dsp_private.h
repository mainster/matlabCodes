/*
 * ex_codegen_dsp_private.h
 *
 * Code generation for model "ex_codegen_dsp".
 *
 * Model version              : 1.12
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Mar  1 08:43:59 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#ifndef RTW_HEADER_ex_codegen_dsp_private_h_
#define RTW_HEADER_ex_codegen_dsp_private_h_
#include "rtwtypes.h"
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else

/* Check for inclusion of an incorrect version of rtwtypes.h */
#ifndef RTWTYPES_ID_C08S16I32L32N32F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif                                 /* RTWTYPES_ID_C08S16I32L32N32F1 */
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

extern void RandSrcInitState_GZ(const uint32_T seed[], uint32_T state[], int32_T
  nChans);
extern void RandSrc_GZ_D(real_T y[], const real_T mean[], int32_T meanLen, const
  real_T xstd[], int32_T xstdLen, uint32_T state[], int32_T nChans, int32_T
  nSamps);
extern void MWSPCGlmsnw_D(const real_T x[], const real_T d[], const real_T mu,
  uint32_T *startIdx, real_T xBuf[], real_T wBuf[], const int32_T wLen, const
  real_T leakFac, const int32_T xLen, real_T y[], real_T eY[], real_T wY[]);

#endif                                 /* RTW_HEADER_ex_codegen_dsp_private_h_ */
