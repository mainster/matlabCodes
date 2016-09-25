/*
 * File: Equalizer.c
 *
 * Code generated for Simulink model Equalizer.
 *
 * Model version                        : 1.393
 * Simulink Coder file generated on : Sat Nov 15 02:12:06 2014
 * C/C++ source code generated on       : Sat Nov 15 02:12:07 2014
 *
 * Description:
 */

#include "Equalizer.h"
#include "Equalizer_private.h"

/* Exported block signals */
real32_T in[1024];                     /* '<Root>/In' */
real32_T out[1024];                    /* '<S5>/Biquad Filter' */

/* Block signals (auto storage) */
BlockIO_Equalizer Equalizer_B;

/* Block states (auto storage) */
D_Work_Equalizer Equalizer_DWork;

/* Output and update for atomic system: '<S1>/Band 1  DF1' */
void Equalizer_Band1DF1(void)
{
  int32_T k;
  real32_T denAccum;
  int32_T i;

  /* DiscreteFilter: '<S3>/Discrete Filter' incorporates:
   *  Constant: '<S1>/Coeffs for Band1'
   */
  Equalizer_DWork.DiscreteFilter_tmp_fa[0U] = 0.0F;
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_tmp_fa[k] = CoeffsMatrix1[k] - -0.75F *
      Equalizer_DWork.DiscreteFilter_states_o[k];
    Equalizer_B.DiscreteFilter_i[k] = 0.25F *
      Equalizer_DWork.DiscreteFilter_tmp_fa[k];
  }

  /* End of DiscreteFilter: '<S3>/Discrete Filter' */

  /* S-Function (sdspbiquad): '<S3>/Biquad Filter' incorporates:
   *  Inport: '<Root>/In'
   */
  k = 0;
  for (i = 0; i < 1024; i++) {
    denAccum = (((Equalizer_B.DiscreteFilter_i[0] * in[k] +
                  Equalizer_B.DiscreteFilter_i[1] *
                  Equalizer_DWork.BiquadFilter_ZERO_STATES[0]) +
                 Equalizer_B.DiscreteFilter_i[2] *
                 Equalizer_DWork.BiquadFilter_ZERO_STATES[1]) -
                Equalizer_B.DiscreteFilter_i[3] *
                Equalizer_DWork.BiquadFilter_POLE_STATES[0]) -
      Equalizer_B.DiscreteFilter_i[4] *
      Equalizer_DWork.BiquadFilter_POLE_STATES[1];
    Equalizer_DWork.BiquadFilter_ZERO_STATES[1] =
      Equalizer_DWork.BiquadFilter_ZERO_STATES[0];
    Equalizer_DWork.BiquadFilter_ZERO_STATES[0] = in[k];
    Equalizer_DWork.BiquadFilter_POLE_STATES[1] =
      Equalizer_DWork.BiquadFilter_POLE_STATES[0];
    Equalizer_DWork.BiquadFilter_POLE_STATES[0] = denAccum;
    Equalizer_B.BiquadFilter_n[k] = denAccum;
    k++;
  }

  /* End of S-Function (sdspbiquad): '<S3>/Biquad Filter' */

  /* Update for DiscreteFilter: '<S3>/Discrete Filter' */
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_states_o[k] =
      Equalizer_DWork.DiscreteFilter_tmp_fa[k];
  }

  /* End of Update for DiscreteFilter: '<S3>/Discrete Filter' */
}

/* Output and update for atomic system: '<S1>/Band 2  DF2' */
void Equalizer_Band2DF2(void)
{
  int32_T k;
  real32_T numAccum;
  real32_T denAccum;
  int32_T i;

  /* DiscreteFilter: '<S4>/Discrete Filter' incorporates:
   *  Constant: '<S1>/Coeffs for Band2'
   */
  Equalizer_DWork.DiscreteFilter_tmp_f[0U] = 0.0F;
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_tmp_f[k] = CoeffsMatrix2[k] - -0.75F *
      Equalizer_DWork.DiscreteFilter_states_f[k];
    Equalizer_B.DiscreteFilter_j[k] = 0.25F *
      Equalizer_DWork.DiscreteFilter_tmp_f[k];
  }

  /* End of DiscreteFilter: '<S4>/Discrete Filter' */

  /* S-Function (sdspbiquad): '<S4>/Biquad Filter' */
  k = 0;
  for (i = 0; i < 1024; i++) {
    denAccum = (Equalizer_B.BiquadFilter_n[k] - Equalizer_B.DiscreteFilter_j[3] *
                Equalizer_DWork.BiquadFilter_FILT_STATES_c[0]) -
      Equalizer_B.DiscreteFilter_j[4] *
      Equalizer_DWork.BiquadFilter_FILT_STATES_c[1];
    numAccum = (Equalizer_B.DiscreteFilter_j[0] * denAccum +
                Equalizer_B.DiscreteFilter_j[1] *
                Equalizer_DWork.BiquadFilter_FILT_STATES_c[0]) +
      Equalizer_B.DiscreteFilter_j[2] *
      Equalizer_DWork.BiquadFilter_FILT_STATES_c[1];
    Equalizer_DWork.BiquadFilter_FILT_STATES_c[1] =
      Equalizer_DWork.BiquadFilter_FILT_STATES_c[0];
    Equalizer_DWork.BiquadFilter_FILT_STATES_c[0] = denAccum;
    Equalizer_B.BiquadFilter[k] = numAccum;
    k++;
  }

  /* End of S-Function (sdspbiquad): '<S4>/Biquad Filter' */

  /* Update for DiscreteFilter: '<S4>/Discrete Filter' */
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_states_f[k] =
      Equalizer_DWork.DiscreteFilter_tmp_f[k];
  }

  /* End of Update for DiscreteFilter: '<S4>/Discrete Filter' */
}

/* Output and update for atomic system: '<S1>/Band 3  DF2T' */
void Equalizer_Band3DF2T(void)
{
  int32_T k;
  real32_T stageOut;
  int32_T i;

  /* DiscreteFilter: '<S5>/Discrete Filter' incorporates:
   *  Constant: '<S1>/Coeffs for Band3'
   */
  Equalizer_DWork.DiscreteFilter_tmp[0U] = 0.0F;
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_tmp[k] = CoeffsMatrix3[k] - -0.75F *
      Equalizer_DWork.DiscreteFilter_states[k];
    Equalizer_B.DiscreteFilter[k] = 0.25F * Equalizer_DWork.DiscreteFilter_tmp[k];
  }

  /* End of DiscreteFilter: '<S5>/Discrete Filter' */

  /* S-Function (sdspbiquad): '<S5>/Biquad Filter' */
  k = 0;
  for (i = 0; i < 1024; i++) {
    stageOut = Equalizer_B.DiscreteFilter[0] * Equalizer_B.BiquadFilter[k] +
      Equalizer_DWork.BiquadFilter_FILT_STATES[0];
    Equalizer_DWork.BiquadFilter_FILT_STATES[0] = (Equalizer_B.DiscreteFilter[1]
      * Equalizer_B.BiquadFilter[k] + Equalizer_DWork.BiquadFilter_FILT_STATES[1])
      - Equalizer_B.DiscreteFilter[3] * stageOut;
    Equalizer_DWork.BiquadFilter_FILT_STATES[1] = Equalizer_B.DiscreteFilter[2] *
      Equalizer_B.BiquadFilter[k] - Equalizer_B.DiscreteFilter[4] * stageOut;
    out[k] = stageOut;
    k++;
  }

  /* End of S-Function (sdspbiquad): '<S5>/Biquad Filter' */

  /* Update for DiscreteFilter: '<S5>/Discrete Filter' */
  for (k = 0; k < 5; k++) {
    Equalizer_DWork.DiscreteFilter_states[k] =
      Equalizer_DWork.DiscreteFilter_tmp[k];
  }

  /* End of Update for DiscreteFilter: '<S5>/Discrete Filter' */
}

/* Model step function */
void Equalizer_step(void)
{
  /* Outputs for Atomic SubSystem: '<Root>/Equalizer' */

  /* Outputs for Atomic SubSystem: '<S1>/Band 1  DF1' */
  Equalizer_Band1DF1();

  /* End of Outputs for SubSystem: '<S1>/Band 1  DF1' */

  /* Outputs for Atomic SubSystem: '<S1>/Band 2  DF2' */
  Equalizer_Band2DF2();

  /* End of Outputs for SubSystem: '<S1>/Band 2  DF2' */

  /* Outputs for Atomic SubSystem: '<S1>/Band 3  DF2T' */
  Equalizer_Band3DF2T();

  /* End of Outputs for SubSystem: '<S1>/Band 3  DF2T' */

  /* End of Outputs for SubSystem: '<Root>/Equalizer' */
}

/* Model initialize function */
void Equalizer_initialize(void)
{
  /* (no initialization code required) */
}

/* File trailer for Simulink Coder generated code.
 *
 * [EOF]
 */
