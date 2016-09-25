/*
 * File: test_private.h
 *
 * Code generated for Simulink model 'test'.
 *
 * Model version                  : 1.2
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Thu Apr 24 11:32:24 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_test_private_h_
#define RTW_HEADER_test_private_h_
#include "rtwtypes.h"
#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error "Code was generated for compiler with different sized uchar/char. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compiler's limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, which will disable the preprocessor word size checks."
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error "Code was generated for compiler with different sized ushort/short. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error "Code was generated for compiler with different sized uint/int. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

#if ( ULONG_MAX != (0xFFFFFFFFU) ) || ( LONG_MAX != (0x7FFFFFFF) )
#error "Code was generated for compiler with different sized ulong/long. Consider adjusting Emulation Hardware word size settings on the Hardware Implementation pane to match your compiler word sizes as defined in the compilers limits.h header file. Alternatively, you can select 'None' for Emulation Hardware and select the 'Enable portable word sizes' option for ERT based targets, this will disable the preprocessor word size checks."
#endif

#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#endif                                 /* TMWTYPES_PREVIOUSLY_INCLUDED */
#endif                                 /* __RTWTYPES_H__ */

extern uint32_T MWDSP_EPH_R_D(real_T evt, uint32_T *sta);
extern uint32_T MWDSP_EPH_R_B(boolean_T evt, uint32_T *sta);
extern void test_DFlipFlop_Start(B_DFlipFlop_test_T *localB, P_DFlipFlop_test_T *
  localP);
extern void test_DFlipFlop_Disable(B_DFlipFlop_test_T *localB,
  DW_DFlipFlop_test_T *localDW, P_DFlipFlop_test_T *localP);
extern void test_DFlipFlop(boolean_T rtu_0, real_T rtu_1, boolean_T rtu_2,
  B_DFlipFlop_test_T *localB, DW_DFlipFlop_test_T *localDW, P_DFlipFlop_test_T
  *localP, ZCE_DFlipFlop_test_T *localZCE);

#endif                                 /* RTW_HEADER_test_private_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
