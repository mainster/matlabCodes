/*
 * File: Equalizer.h
 *
 * Code generated for Simulink model 'Equalizer'.
 *
 * Model version                  : 1.393
 * Simulink Coder version         : 8.4 (R2013a) 13-Feb-2013
 * TLC version                    : 8.4 (Jan 18 2013)
 * C/C++ source code generated on : Sat Nov 15 02:12:07 2014
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Analog Devices->Blackfin
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Equalizer_h_
#define RTW_HEADER_Equalizer_h_
#ifndef Equalizer_COMMON_INCLUDES_
# define Equalizer_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* Equalizer_COMMON_INCLUDES_ */

#include "Equalizer_types.h"

/* Includes for objects with custom storage classes. */
#include "biquad_coeffs.h"

/* Macros for accessing real-time model data structure */

/* Block signals (auto storage) */
typedef struct {
  real32_T DiscreteFilter[5];          /* '<S5>/Discrete Filter' */
  real32_T DiscreteFilter_j[5];        /* '<S4>/Discrete Filter' */
  real32_T BiquadFilter[1024];         /* '<S4>/Biquad Filter' */
  real32_T DiscreteFilter_i[5];        /* '<S3>/Discrete Filter' */
  real32_T BiquadFilter_n[1024];       /* '<S3>/Biquad Filter' */
} BlockIO_Equalizer;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real32_T DiscreteFilter_states[5];   /* '<S5>/Discrete Filter' */
  real32_T BiquadFilter_FILT_STATES[2];/* '<S5>/Biquad Filter' */
  real32_T DiscreteFilter_states_f[5]; /* '<S4>/Discrete Filter' */
  real32_T BiquadFilter_FILT_STATES_c[2];/* '<S4>/Biquad Filter' */
  real32_T DiscreteFilter_states_o[5]; /* '<S3>/Discrete Filter' */
  real32_T BiquadFilter_ZERO_STATES[2];/* '<S3>/Biquad Filter' */
  real32_T BiquadFilter_POLE_STATES[2];/* '<S3>/Biquad Filter' */
  real32_T DiscreteFilter_tmp[5];      /* '<S5>/Discrete Filter' */
  real32_T DiscreteFilter_tmp_f[5];    /* '<S4>/Discrete Filter' */
  real32_T DiscreteFilter_tmp_fa[5];   /* '<S3>/Discrete Filter' */
} D_Work_Equalizer;

/* Block signals (auto storage) */
extern BlockIO_Equalizer Equalizer_B;

/* Block states (auto storage) */
extern D_Work_Equalizer Equalizer_DWork;

/*
 * Exported Global Signals
 *
 * Note: Exported global signals are block signals with an exported global
 * storage class designation.  Code generation will declare the memory for
 * these signals and export their symbols.
 *
 */
extern real32_T in[1024];              /* '<Root>/In' */
extern real32_T out[1024];             /* '<S5>/Biquad Filter' */

/* Model entry point functions */
extern void Equalizer_initialize(void);
extern void Equalizer_step(void);

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
 * hilite_system('dspparameq/Equalizer')    - opens subsystem dspparameq/Equalizer
 * hilite_system('dspparameq/Equalizer/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'dspparameq'
 * '<S1>'   : 'dspparameq/Equalizer'
 * '<S3>'   : 'dspparameq/Equalizer/Band 1  DF1'
 * '<S4>'   : 'dspparameq/Equalizer/Band 2  DF2'
 * '<S5>'   : 'dspparameq/Equalizer/Band 3  DF2T'
 * '<S6>'   : 'dspparameq/Equalizer/Band 1  DF1/Split Coefficients'
 * '<S7>'   : 'dspparameq/Equalizer/Band 2  DF2/Split Coefficients'
 * '<S8>'   : 'dspparameq/Equalizer/Band 3  DF2T/Split Coefficients'
 */
#endif                                 /* RTW_HEADER_Equalizer_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
