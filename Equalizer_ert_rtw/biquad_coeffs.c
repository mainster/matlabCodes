/*
 * File: biquad_coeffs.c
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

#include "rtwtypes.h"
#include "Equalizer_types.h"

/* Exported data definition */

/* Design Specifications
   Sampling Frequency : 48 kHz
   Response           : Parametric Equalizer
   Specification      : N,F0,BW,Gref,G0,GBW
   Filter Order       : 2
   F0                 : 763.9437 Hz
   BW                 : 2.2918 kHz
   Gref               : 0 dB
   G0                 : 5 dB
   GBW                : 3.535 dB
 */
real32_T CoeffsMatrix1[5] = { 1.11763632F, -1.68922007F, 0.580065072F,
  -1.68922007F, 0.697701454F } ;

/* Design Specifications
   Sampling Frequency : 48 kHz
   Response           : Parametric Equalizer
   Specification      : N,F0,BW,Gref,G0,GBW
   Filter Order       : 2
   F0                 : 4.8 kHz
   BW                 : 2.2918 kHz
   Gref               : 0 dB
   G0                 : 7.999 dB
   GBW                : 5.6553 dB
 */
real32_T CoeffsMatrix2[5] = { 1.19997728F, -1.40397763F, 0.535434604F,
  -1.40397763F, 0.735411882F } ;

/* Design Specifications
   Sampling Frequency : 48 kHz
   Response           : Parametric Equalizer
   Specification      : N,F0,BW,Gref,G0,GBW
   Filter Order       : 2
   F0                 : 6 kHz
   BW                 : 2.2918 kHz
   Gref               : 0 dB
   G0                 : -4.7917 dB
   GBW                : -3.3877 dB
 */
real32_T CoeffsMatrix3[5] = { 0.899025202F, -1.07742751F, 0.624687254F,
  -1.07742751F, 0.523712397F } ;

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
