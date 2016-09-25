/*
 * stm32_pid_v1_mod_capi.c
 *
 * Code generation for model "stm32_pid_v1_mod".
 *
 * Model version              : 1.48
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Wed Aug 13 07:05:03 2014
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Atmel->AVR
 * Code generation objective: Debugging
 * Validation result: Not run
 */

#include "stm32_pid_v1_mod.h"
#include "rtw_capi.h"
#include "stm32_pid_v1_mod_private.h"

/* Block output signal information */
static const rtwCAPI_Signals rtBlockSignals[] = {
  /* addrMapIndex, sysNum, blockPath,
   * signalName, portNumber, dataTypeIndex, dimIndex, fxpIndex, sTimeIndex
   */
  { 0, 0, "stm32_pid_v1_mod/Pulse Generator",
    "", 0, 0, 0, 0, 0 },

  { 1, 0, "stm32_pid_v1_mod/Discrete Zero-Pole1",
    "", 0, 0, 0, 0, 0 },

  { 2, 0, "stm32_pid_v1_mod/Sum",
    "", 0, 0, 0, 0, 0 },

  { 3, 0, "stm32_pid_v1_mod/Sum1",
    "", 0, 0, 0, 0, 0 },

  { 4, 0, "stm32_pid_v1_mod/Discrete PID Controller/Filter",
    "", 0, 0, 0, 0, 0 },

  { 5, 0, "stm32_pid_v1_mod/Discrete PID Controller/Integrator",
    "", 0, 0, 0, 0, 0 },

  { 6, 0, "stm32_pid_v1_mod/Discrete PID Controller/Derivative Gain",
    "", 0, 0, 0, 0, 0 },

  { 7, 0, "stm32_pid_v1_mod/Discrete PID Controller/Filter Coefficient",
    "", 0, 0, 0, 0, 0 },

  { 8, 0, "stm32_pid_v1_mod/Discrete PID Controller/Integral Gain",
    "", 0, 0, 0, 0, 0 },

  { 9, 0, "stm32_pid_v1_mod/Discrete PID Controller/Proportional Gain",
    "", 0, 0, 0, 0, 0 },

  { 10, 0, "stm32_pid_v1_mod/Discrete PID Controller/Sum",
    "", 0, 0, 0, 0, 0 },

  { 11, 0, "stm32_pid_v1_mod/Discrete PID Controller/SumD",
    "", 0, 0, 0, 0, 0 },

  { 12, 0, "stm32_pid_v1_mod/DiscretePIDController1/Filter",
    "", 0, 0, 0, 0, 0 },

  { 13, 0, "stm32_pid_v1_mod/DiscretePIDController1/Integrator",
    "", 0, 0, 0, 0, 0 },

  { 14, 0, "stm32_pid_v1_mod/DiscretePIDController1/Derivative Gain",
    "", 0, 0, 0, 0, 0 },

  { 15, 0, "stm32_pid_v1_mod/DiscretePIDController1/Filter Coefficient",
    "", 0, 0, 0, 0, 0 },

  { 16, 0, "stm32_pid_v1_mod/DiscretePIDController1/Integral Gain",
    "", 0, 0, 0, 0, 0 },

  { 17, 0, "stm32_pid_v1_mod/DiscretePIDController1/Proportional Gain",
    "", 0, 0, 0, 0, 0 },

  { 18, 0, "stm32_pid_v1_mod/DiscretePIDController1/Saturation",
    "", 0, 0, 0, 0, 0 },

  { 19, 0, "stm32_pid_v1_mod/DiscretePIDController1/Sum",
    "", 0, 0, 0, 0, 0 },

  { 20, 0, "stm32_pid_v1_mod/DiscretePIDController1/SumD",
    "", 0, 0, 0, 0, 0 },

  {
    0, 0, (NULL), (NULL), 0, 0, 0, 0, 0
  }
};

/* Tunable block parameters */
static const rtwCAPI_BlockParameters rtBlockParameters[] = {
  /* addrMapIndex, blockPath,
   * paramName, dataTypeIndex, dimIndex, fixPtIdx
   */
  { 21, "stm32_pid_v1_mod/Constant",
    "Value", 0, 0, 0 },

  { 22, "stm32_pid_v1_mod/Pulse Generator",
    "Amplitude", 0, 0, 0 },

  { 23, "stm32_pid_v1_mod/Pulse Generator",
    "Period", 0, 0, 0 },

  { 24, "stm32_pid_v1_mod/Pulse Generator",
    "PulseWidth", 0, 0, 0 },

  { 25, "stm32_pid_v1_mod/Pulse Generator",
    "PhaseDelay", 0, 0, 0 },

  { 26, "stm32_pid_v1_mod/Discrete Zero-Pole",
    "A", 0, 1, 0 },

  { 27, "stm32_pid_v1_mod/Discrete Zero-Pole",
    "B", 0, 0, 0 },

  { 28, "stm32_pid_v1_mod/Discrete Zero-Pole",
    "C", 0, 2, 0 },

  { 29, "stm32_pid_v1_mod/Discrete Zero-Pole1",
    "A", 0, 1, 0 },

  { 30, "stm32_pid_v1_mod/Discrete Zero-Pole1",
    "B", 0, 0, 0 },

  { 31, "stm32_pid_v1_mod/Discrete Zero-Pole1",
    "C", 0, 2, 0 },

  { 32, "stm32_pid_v1_mod/Discrete PID Controller/Filter",
    "gainval", 0, 0, 0 },

  { 33, "stm32_pid_v1_mod/Discrete PID Controller/Filter",
    "InitialCondition", 0, 0, 0 },

  { 34, "stm32_pid_v1_mod/Discrete PID Controller/Integrator",
    "gainval", 0, 0, 0 },

  { 35, "stm32_pid_v1_mod/Discrete PID Controller/Integrator",
    "InitialCondition", 0, 0, 0 },

  { 36, "stm32_pid_v1_mod/Discrete PID Controller/Derivative Gain",
    "Gain", 0, 0, 0 },

  { 37, "stm32_pid_v1_mod/Discrete PID Controller/Filter Coefficient",
    "Gain", 0, 0, 0 },

  { 38, "stm32_pid_v1_mod/Discrete PID Controller/Integral Gain",
    "Gain", 0, 0, 0 },

  { 39, "stm32_pid_v1_mod/Discrete PID Controller/Proportional Gain",
    "Gain", 0, 0, 0 },

  { 40, "stm32_pid_v1_mod/DiscretePIDController1/Filter",
    "gainval", 0, 0, 0 },

  { 41, "stm32_pid_v1_mod/DiscretePIDController1/Filter",
    "InitialCondition", 0, 0, 0 },

  { 42, "stm32_pid_v1_mod/DiscretePIDController1/Integrator",
    "gainval", 0, 0, 0 },

  { 43, "stm32_pid_v1_mod/DiscretePIDController1/Integrator",
    "InitialCondition", 0, 0, 0 },

  { 44, "stm32_pid_v1_mod/DiscretePIDController1/Derivative Gain",
    "Gain", 0, 0, 0 },

  { 45, "stm32_pid_v1_mod/DiscretePIDController1/Filter Coefficient",
    "Gain", 0, 0, 0 },

  { 46, "stm32_pid_v1_mod/DiscretePIDController1/Integral Gain",
    "Gain", 0, 0, 0 },

  { 47, "stm32_pid_v1_mod/DiscretePIDController1/Proportional Gain",
    "Gain", 0, 0, 0 },

  { 48, "stm32_pid_v1_mod/DiscretePIDController1/Saturation",
    "UpperLimit", 0, 0, 0 },

  { 49, "stm32_pid_v1_mod/DiscretePIDController1/Saturation",
    "LowerLimit", 0, 0, 0 },

  {
    0, (NULL), (NULL), 0, 0, 0
  }
};

/* Tunable variable parameters */
static const rtwCAPI_ModelParameters rtModelParameters[] = {
  /* addrMapIndex, varName, dataTypeIndex, dimIndex, fixPtIndex */
  { 0, (NULL), 0, 0, 0 }
};

/* Declare Data Addresses statically */
static void* rtDataAddrMap[] = {
  &stm32_pid_v1_mod_B.PulseGenerator,  /* 0: Signal */
  &stm32_pid_v1_mod_B.DiscreteZeroPole1,/* 1: Signal */
  &stm32_pid_v1_mod_B.Sum_o,           /* 2: Signal */
  &stm32_pid_v1_mod_B.Sum1,            /* 3: Signal */
  &stm32_pid_v1_mod_B.Filter,          /* 4: Signal */
  &stm32_pid_v1_mod_B.Integrator,      /* 5: Signal */
  &stm32_pid_v1_mod_B.DerivativeGain,  /* 6: Signal */
  &stm32_pid_v1_mod_B.FilterCoefficient,/* 7: Signal */
  &stm32_pid_v1_mod_B.IntegralGain,    /* 8: Signal */
  &stm32_pid_v1_mod_B.ProportionalGain,/* 9: Signal */
  &stm32_pid_v1_mod_B.Sum,             /* 10: Signal */
  &stm32_pid_v1_mod_B.SumD,            /* 11: Signal */
  &stm32_pid_v1_mod_B.Filter_c,        /* 12: Signal */
  &stm32_pid_v1_mod_B.Integrator_o,    /* 13: Signal */
  &stm32_pid_v1_mod_B.DerivativeGain_o,/* 14: Signal */
  &stm32_pid_v1_mod_B.FilterCoefficient_m,/* 15: Signal */
  &stm32_pid_v1_mod_B.IntegralGain_m,  /* 16: Signal */
  &stm32_pid_v1_mod_B.ProportionalGain_a,/* 17: Signal */
  &stm32_pid_v1_mod_B.Saturation,      /* 18: Signal */
  &stm32_pid_v1_mod_B.Sum_ot,          /* 19: Signal */
  &stm32_pid_v1_mod_B.SumD_e,          /* 20: Signal */
  &stm32_pid_v1_mod_P.Constant_Value,  /* 21: Block Parameter */
  &stm32_pid_v1_mod_P.PulseGenerator_Amp,/* 22: Block Parameter */
  &stm32_pid_v1_mod_P.PulseGenerator_Period,/* 23: Block Parameter */
  &stm32_pid_v1_mod_P.PulseGenerator_Duty,/* 24: Block Parameter */
  &stm32_pid_v1_mod_P.PulseGenerator_PhaseDelay,/* 25: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole_A[0],/* 26: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole_B,/* 27: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole_C[0],/* 28: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole1_A[0],/* 29: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole1_B,/* 30: Block Parameter */
  &stm32_pid_v1_mod_P.DiscreteZeroPole1_C[0],/* 31: Block Parameter */
  &stm32_pid_v1_mod_P.Filter_gainval,  /* 32: Block Parameter */
  &stm32_pid_v1_mod_P.Filter_IC,       /* 33: Block Parameter */
  &stm32_pid_v1_mod_P.Integrator_gainval,/* 34: Block Parameter */
  &stm32_pid_v1_mod_P.Integrator_IC,   /* 35: Block Parameter */
  &stm32_pid_v1_mod_P.DerivativeGain_Gain,/* 36: Block Parameter */
  &stm32_pid_v1_mod_P.FilterCoefficient_Gain,/* 37: Block Parameter */
  &stm32_pid_v1_mod_P.IntegralGain_Gain,/* 38: Block Parameter */
  &stm32_pid_v1_mod_P.ProportionalGain_Gain,/* 39: Block Parameter */
  &stm32_pid_v1_mod_P.Filter_gainval_c,/* 40: Block Parameter */
  &stm32_pid_v1_mod_P.Filter_IC_h,     /* 41: Block Parameter */
  &stm32_pid_v1_mod_P.Integrator_gainval_l,/* 42: Block Parameter */
  &stm32_pid_v1_mod_P.Integrator_IC_o, /* 43: Block Parameter */
  &stm32_pid_v1_mod_P.DerivativeGain_Gain_e,/* 44: Block Parameter */
  &stm32_pid_v1_mod_P.FilterCoefficient_Gain_a,/* 45: Block Parameter */
  &stm32_pid_v1_mod_P.IntegralGain_Gain_n,/* 46: Block Parameter */
  &stm32_pid_v1_mod_P.ProportionalGain_Gain_o,/* 47: Block Parameter */
  &stm32_pid_v1_mod_P.Saturation_UpperSat,/* 48: Block Parameter */
  &stm32_pid_v1_mod_P.Saturation_LowerSat,/* 49: Block Parameter */
};

/* Declare Data Run-Time Dimension Buffer Addresses statically */
static int32_T* rtVarDimsAddrMap[] = {
  (NULL)
};

/* Data Type Map - use dataTypeMapIndex to access this structure */
static const rtwCAPI_DataTypeMap rtDataTypeMap[] = {
  /* cName, mwName, numElements, elemMapIndex, dataSize, slDataId, *
   * isComplex, isPointer */
  { "double", "real_T", 0, 0, sizeof(real_T), SS_DOUBLE, 0, 0 }
};

/* Structure Element Map - use elemMapIndex to access this structure */
static const rtwCAPI_ElementMap rtElementMap[] = {
  /* elementName, elementOffset, dataTypeIndex, dimIndex, fxpIndex */
  { (NULL), 0, 0, 0, 0 },
};

/* Dimension Map - use dimensionMapIndex to access elements of ths structure*/
static const rtwCAPI_DimensionMap rtDimensionMap[] = {
  /* dataOrientation, dimArrayIndex, numDims, vardimsIndex */
  { rtwCAPI_SCALAR, 0, 2, 0 },

  { rtwCAPI_VECTOR, 2, 2, 0 },

  { rtwCAPI_VECTOR, 4, 2, 0 }
};

/* Dimension Array- use dimArrayIndex to access elements of this array */
static const uint_T rtDimensionArray[] = {
  1,                                   /* 0 */
  1,                                   /* 1 */
  3,                                   /* 2 */
  1,                                   /* 3 */
  2,                                   /* 4 */
  1                                    /* 5 */
};

/* C-API stores floating point values in an array. The elements of this  *
 * are unique. This ensures that values which are shared across the model*
 * are stored in the most efficient way. These values are referenced by  *
 *           - rtwCAPI_FixPtMap.fracSlopePtr,                            *
 *           - rtwCAPI_FixPtMap.biasPtr,                                 *
 *           - rtwCAPI_SampleTimeMap.samplePeriodPtr,                    *
 *           - rtwCAPI_SampleTimeMap.sampleOffsetPtr                     */
static const real_T rtcapiStoredFloats[] = {
  5.0E-5, 0.0
};

/* Fixed Point Map */
static const rtwCAPI_FixPtMap rtFixPtMap[] = {
  /* fracSlopePtr, biasPtr, scaleType, wordLength, exponent, isSigned */
  { (NULL), (NULL), rtwCAPI_FIX_RESERVED, 0, 0, 0 },
};

/* Sample Time Map - use sTimeIndex to access elements of ths structure */
static const rtwCAPI_SampleTimeMap rtSampleTimeMap[] = {
  /* samplePeriodPtr, sampleOffsetPtr, tid, samplingMode */
  { (const void *) &rtcapiStoredFloats[0], (const void *) &rtcapiStoredFloats[1],
    0, 0 }
};

static rtwCAPI_ModelMappingStaticInfo mmiStatic = {
  /* Signals:{signals, numSignals},
   * Params: {blockParameters, numBlockParameters,
   *          modelParameters, numModelParameters},
   * States: {states, numStates},
   * Root Inputs: {rootInputs, numRootInputs}
   * Root Outputs: {rootOutputs, numRootOutputs}
   * Maps:   {dataTypeMap, dimensionMap, fixPtMap,
   *          elementMap, sampleTimeMap, dimensionArray},
   * TargetType: targetType
   */
  { rtBlockSignals, 21,
    (NULL), 0,
    (NULL), 0 },

  { rtBlockParameters, 29,
    rtModelParameters, 0 },

  { (NULL), 0 },

  { rtDataTypeMap, rtDimensionMap, rtFixPtMap,
    rtElementMap, rtSampleTimeMap, rtDimensionArray },
  "float", (NULL), 0,
};

/* Function to get C API Model Mapping Static Info */
const rtwCAPI_ModelMappingStaticInfo*
  stm32_pid_v1_mod_GetCAPIStaticMap()
{
  return &mmiStatic;
}

/* Cache pointers into DataMapInfo substructure of RTModel */
void stm32_pid_v1_mod_InitializeDataMapInfo(RT_MODEL_stm32_pid_v1_mod_T *const
  stm32_pid_v1_mod_M)
{
  /* Set C-API version */
  rtwCAPI_SetVersion(stm32_pid_v1_mod_M->DataMapInfo.mmi, 1);

  /* Cache static C-API data into the Real-time Model Data structure */
  rtwCAPI_SetStaticMap(stm32_pid_v1_mod_M->DataMapInfo.mmi, &mmiStatic);

  /* Cache static C-API logging data into the Real-time Model Data structure */
  rtwCAPI_SetLoggingStaticMap(stm32_pid_v1_mod_M->DataMapInfo.mmi, (NULL));

  /* Cache C-API Data Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetDataAddressMap(stm32_pid_v1_mod_M->DataMapInfo.mmi, rtDataAddrMap);

  /* Cache C-API Data Run-Time Dimension Buffer Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetVarDimsAddressMap(stm32_pid_v1_mod_M->DataMapInfo.mmi,
    rtVarDimsAddrMap);

  /* Cache the instance C-API logging pointer */
  rtwCAPI_SetInstanceLoggingInfo(stm32_pid_v1_mod_M->DataMapInfo.mmi, (NULL));

  /* Set reference to submodels */
  rtwCAPI_SetChildMMIArray(stm32_pid_v1_mod_M->DataMapInfo.mmi, (NULL));
  rtwCAPI_SetChildMMIArrayLen(stm32_pid_v1_mod_M->DataMapInfo.mmi, 0);
}

/* EOF: stm32_pid_v1_mod_capi.c */
