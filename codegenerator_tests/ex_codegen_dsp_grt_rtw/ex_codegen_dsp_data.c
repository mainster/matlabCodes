/*
 * ex_codegen_dsp_data.c
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
#include "ex_codegen_dsp.h"
#include "ex_codegen_dsp_private.h"

/* Block parameters (auto storage) */
P_ex_codegen_dsp_T ex_codegen_dsp_P = {
  1.0,                                 /* Expression: Amplitude
                                        * Referenced by: '<Root>/Sine Wave'
                                        */
  0.5,                                 /* Expression: Frequency
                                        * Referenced by: '<Root>/Sine Wave'
                                        */
  0.0,                                 /* Expression: Phase
                                        * Referenced by: '<Root>/Sine Wave'
                                        */
  0.0,                                 /* Expression: MeanVal
                                        * Referenced by: '<Root>/Random Source'
                                        */
  1.0,                                 /* Computed Parameter: RandomSource_VarianceRTP
                                        * Referenced by: '<Root>/Random Source'
                                        */
  0.0,                                 /* Expression: 0
                                        * Referenced by: '<S1>/Generated Filter Block'
                                        */

  /*  Expression: [-0.00116169847246078432 -0.00138798082963417953 0.0019553437659341746 0.00292510641051443258 -0.00436604908256792157 -0.00635958912648804022 0.00900883950647731087 0.012454637566874099 -0.016904897878442366 -0.0226914396301924441 0.0303890031459586353 0.0410928751247308099 -0.0571719340677344853 -0.0848277531991029066 0.146887215886567446 0.449095734750016462 0.449095734750016462 0.146887215886567446 -0.0848277531991029066 -0.0571719340677344853 0.0410928751247308099 0.0303890031459586353 -0.0226914396301924441 -0.016904897878442366 0.012454637566874099 0.00900883950647731087 -0.00635958912648804022 -0.00436604908256792157 0.00292510641051443258 0.0019553437659341746 -0.00138798082963417953 -0.00116169847246078432]
   * Referenced by: '<S1>/Generated Filter Block'
   */
  { -0.0011616984724607843, -0.0013879808296341795, 0.0019553437659341746,
    0.0029251064105144326, -0.0043660490825679216, -0.00635958912648804,
    0.0090088395064773109, 0.012454637566874099, -0.016904897878442366,
    -0.022691439630192444, 0.030389003145958635, 0.04109287512473081,
    -0.057171934067734485, -0.0848277531991029, 0.14688721588656745,
    0.44909573475001646, 0.44909573475001646, 0.14688721588656745,
    -0.0848277531991029, -0.057171934067734485, 0.04109287512473081,
    0.030389003145958635, -0.022691439630192444, -0.016904897878442366,
    0.012454637566874099, 0.0090088395064773109, -0.00635958912648804,
    -0.0043660490825679216, 0.0029251064105144326, 0.0019553437659341746,
    -0.0013879808296341795, -0.0011616984724607843 },
  1.0,                                 /* Expression: leakage
                                        * Referenced by: '<Root>/LMS Filter'
                                        */
  0.1,                                 /* Expression: mu
                                        * Referenced by: '<Root>/LMS Filter'
                                        */
  23341U                               /* Computed Parameter: RandomSource_InitSeed
                                        * Referenced by: '<Root>/Random Source'
                                        */
};
