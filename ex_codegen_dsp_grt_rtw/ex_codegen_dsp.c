/*
 * ex_codegen_dsp.c
 *
 * Code generation for model "ex_codegen_dsp".
 *
 * Model version              : 1.11
 * Simulink Coder version : 8.4 (R2013a) 13-Feb-2013
 * C source code generated on : Sun Mar  1 08:40:39 2015
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */
#include "ex_codegen_dsp.h"
#include "ex_codegen_dsp_private.h"

/* Block signals (auto storage) */
B_ex_codegen_dsp_T ex_codegen_dsp_B;

/* Block states (auto storage) */
DW_ex_codegen_dsp_T ex_codegen_dsp_DW;

/* Real-time model */
RT_MODEL_ex_codegen_dsp_T ex_codegen_dsp_M_;
RT_MODEL_ex_codegen_dsp_T *const ex_codegen_dsp_M = &ex_codegen_dsp_M_;
void RandSrcInitState_GZ(const uint32_T seed[], uint32_T state[], int32_T nChans)
{
  int32_T i;

  /* InitializeConditions for S-Function (sdsprandsrc2): '<Root>/Random Source' */
  /* RandSrcInitState_GZ */
  for (i = 0; i < nChans; i++) {
    state[i << 1] = 362436069U;
    state[(i << 1) + 1] = seed[i] == 0U ? 521288629U : seed[i];
  }

  /* End of InitializeConditions for S-Function (sdsprandsrc2): '<Root>/Random Source' */
}

void RandSrc_GZ_D(real_T y[], const real_T mean[], int32_T meanLen, const real_T
                  xstd[], int32_T xstdLen, uint32_T state[], int32_T nChans,
                  int32_T nSamps)
{
  int32_T i;
  int32_T j;
  real_T r;
  real_T x;
  real_T s;
  real_T y_0;
  int32_T chan;
  real_T std;
  uint32_T icng;
  uint32_T jsr;
  int32_T samp;
  real_T mean_0;
  static const real_T vt[65] = { 0.340945, 0.4573146, 0.5397793, 0.6062427,
    0.6631691, 0.7136975, 0.7596125, 0.8020356, 0.8417227, 0.8792102, 0.9148948,
    0.9490791, 0.9820005, 1.0138492, 1.044781, 1.0749254, 1.1043917, 1.1332738,
    1.161653, 1.189601, 1.2171815, 1.2444516, 1.2714635, 1.298265, 1.3249008,
    1.3514125, 1.3778399, 1.4042211, 1.4305929, 1.4569915, 1.4834527, 1.5100122,
    1.5367061, 1.5635712, 1.5906454, 1.617968, 1.6455802, 1.6735255, 1.7018503,
    1.7306045, 1.7598422, 1.7896223, 1.8200099, 1.851077, 1.8829044, 1.9155831,
    1.9492166, 1.9839239, 2.0198431, 2.0571356, 2.095993, 2.136645, 2.1793713,
    2.2245175, 2.2725186, 2.3239338, 2.3795008, 2.4402218, 2.5075117, 2.5834658,
    2.6713916, 2.7769942, 2.7769942, 2.7769942, 2.7769942 };

  /* S-Function (sdsprandsrc2): '<Root>/Random Source' */
  /* RandSrc_GZ_D */
  for (chan = 0; chan < nChans; chan++) {
    mean_0 = mean[meanLen > 1 ? chan : 0];
    std = xstd[xstdLen > 1 ? chan : 0];
    icng = state[chan << 1];
    jsr = state[(chan << 1) + 1];
    for (samp = 0; samp < nSamps; samp++) {
      icng = 69069U * icng + 1234567U;
      jsr ^= jsr << 13;
      jsr ^= jsr >> 17;
      jsr ^= jsr << 5;
      i = (int32_T)(icng + jsr);
      j = (i & 63) + 1;
      r = (real_T)i * 4.6566128730773926E-10 * vt[j];
      if (!(fabs(r) <= vt[j - 1])) {
        x = (fabs(r) - vt[j - 1]) / (vt[j] - vt[j - 1]);
        icng = 69069U * icng + 1234567U;
        jsr ^= jsr << 13;
        jsr ^= jsr >> 17;
        jsr ^= jsr << 5;
        y_0 = (real_T)(int32_T)(icng + jsr) * 2.328306436538696E-10 + 0.5;
        s = x + y_0;
        if (s > 1.301198) {
          r = r < 0.0 ? 0.4878992 * x - 0.4878992 : 0.4878992 - 0.4878992 * x;
        } else {
          if (!(s <= 0.9689279)) {
            x = 0.4878992 - 0.4878992 * x;
            if (y_0 > 12.67706 - exp(-0.5 * x * x) * 12.37586) {
              r = r < 0.0 ? -x : x;
            } else {
              if (!(exp(-0.5 * vt[j] * vt[j]) + y_0 * 0.01958303 / vt[j] <= exp(
                    -0.5 * r * r))) {
                do {
                  icng = 69069U * icng + 1234567U;
                  jsr ^= jsr << 13;
                  jsr ^= jsr >> 17;
                  jsr ^= jsr << 5;
                  x = log((real_T)(int32_T)(icng + jsr) * 2.328306436538696E-10
                          + 0.5) / 2.776994;
                  icng = 69069U * icng + 1234567U;
                  jsr ^= jsr << 13;
                  jsr ^= jsr >> 17;
                  jsr ^= jsr << 5;
                } while (log((real_T)(int32_T)(icng + jsr) *
                             2.328306436538696E-10 + 0.5) * -2.0 <= x * x);

                r = r < 0.0 ? x - 2.776994 : 2.776994 - x;
              }
            }
          }
        }
      }

      y[chan * nSamps + samp] = std * r + mean_0;
    }

    state[chan << 1] = icng;
    state[(chan << 1) + 1] = jsr;
  }

  /* End of S-Function (sdsprandsrc2): '<Root>/Random Source' */
}

void MWSPCGlmsnw_D(const real_T x[], const real_T d[], const real_T mu, uint32_T
                   *startIdx, real_T xBuf[], real_T wBuf[], const int32_T wLen,
                   const real_T leakFac, const int32_T xLen, real_T y[], real_T
                   eY[], real_T wY[])
{
  int32_T i;
  int32_T j;
  real_T divideResult;
  real_T bufEnergy;
  int32_T j_0;

  /* S-Function (sdsplms): '<Root>/LMS Filter' */
  for (i = 0; i < xLen; i++) {
    y[i] = 0.0;
  }

  for (i = 0; i < xLen; i++) {
    bufEnergy = 0.0;

    /* Copy the current sample at the END of the circular buffer and update BuffStartIdx
     */
    xBuf[*startIdx] = x[i];
    (*startIdx)++;
    if (*startIdx == (uint32_T)wLen) {
      *startIdx = 0U;
    }

    /* Multiply wgtBuff_vector (not yet updated) and inBuff_vector
     */
    /* Get the energy of the signal in updated buffer
     */
    j_0 = 0;
    for (j = (int32_T)*startIdx; j < wLen; j++) {
      y[i] += wBuf[j_0] * xBuf[j];
      bufEnergy += xBuf[j] * xBuf[j];
      j_0++;
    }

    for (j = 0; j < (int32_T)*startIdx; j++) {
      y[i] += wBuf[j_0] * xBuf[j];
      bufEnergy += xBuf[j] * xBuf[j];
      j_0++;
    }

    /* Ger error for the current sample
     */
    eY[i] = d[i] - y[i];

    /* Update weight-vector for next input sample
     */
    j_0 = 0;
    for (j = (int32_T)*startIdx; j < wLen; j++) {
      divideResult = xBuf[j] / (bufEnergy + 2.2204460492503131E-16);
      wBuf[j_0] = eY[i] * divideResult * mu + leakFac * wBuf[j_0];
      j_0++;
    }

    for (j = 0; j < (int32_T)*startIdx; j++) {
      divideResult = xBuf[j] / (bufEnergy + 2.2204460492503131E-16);
      wBuf[j_0] = eY[i] * divideResult * mu + leakFac * wBuf[j_0];
      j_0++;
    }
  }

  j_0 = wLen;
  for (j = 0; j < wLen; j++) {
    wY[j] = wBuf[j_0 - 1];
    j_0--;
  }

  /* End of S-Function (sdsplms): '<Root>/LMS Filter' */
}

/* Model output function */
static void ex_codegen_dsp_output(void)
{
  /* local block i/o variables */
  real_T rtb_SineWave;
  real_T rtb_Sum;
  real_T rtb_LMSFilter_o2;
  real_T rtb_Sum1;
  int32_T cff;
  real_T acc;
  int32_T j;

  /* S-Function (sdspsine2): '<Root>/Sine Wave' */
  rtb_SineWave = ex_codegen_dsp_P.SineWave_Amplitude * sin
    (ex_codegen_dsp_DW.SineWave_AccFreqNorm);

  /* Update accumulated normalized freq value
     for next sample.  Keep in range [0 2*pi) */
  ex_codegen_dsp_DW.SineWave_AccFreqNorm += ex_codegen_dsp_P.SineWave_Frequency *
    0.31415926535897931;
  if (ex_codegen_dsp_DW.SineWave_AccFreqNorm >= 6.2831853071795862) {
    ex_codegen_dsp_DW.SineWave_AccFreqNorm -= 6.2831853071795862;
  } else {
    if (ex_codegen_dsp_DW.SineWave_AccFreqNorm < 0.0) {
      ex_codegen_dsp_DW.SineWave_AccFreqNorm += 6.2831853071795862;
    }
  }

  /* End of S-Function (sdspsine2): '<Root>/Sine Wave' */

  /* S-Function (sdsprandsrc2): '<Root>/Random Source' */
  RandSrc_GZ_D(&ex_codegen_dsp_B.RandomSource,
               &ex_codegen_dsp_P.RandomSource_MeanRTP, 1,
               &ex_codegen_dsp_P.RandomSource_VarianceRTP, 1,
               ex_codegen_dsp_DW.RandomSource_STATE_DWORK, 1, 1);

  /* DiscreteFir: '<S1>/Generated Filter Block' */
  acc = ex_codegen_dsp_B.RandomSource *
    ex_codegen_dsp_P.GeneratedFilterBlock_Coefficien[0];
  cff = 1;
  for (j = ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf; j < 31; j++) {
    acc += ex_codegen_dsp_DW.GeneratedFilterBlock_states[j] *
      ex_codegen_dsp_P.GeneratedFilterBlock_Coefficien[cff];
    cff++;
  }

  for (j = 0; j < ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf; j++) {
    acc += ex_codegen_dsp_DW.GeneratedFilterBlock_states[j] *
      ex_codegen_dsp_P.GeneratedFilterBlock_Coefficien[cff];
    cff++;
  }

  ex_codegen_dsp_B.GeneratedFilterBlock = acc;

  /* End of DiscreteFir: '<S1>/Generated Filter Block' */

  /* Sum: '<Root>/Sum' */
  rtb_Sum = rtb_SineWave + ex_codegen_dsp_B.GeneratedFilterBlock;

  /* S-Function (sdsplms): '<Root>/LMS Filter' */
  MWSPCGlmsnw_D(&ex_codegen_dsp_B.RandomSource,
                &ex_codegen_dsp_B.GeneratedFilterBlock,
                ex_codegen_dsp_P.LMSFilter_MU_RTP,
                &ex_codegen_dsp_DW.LMSFilter_BUFF_IDX_DWORK,
                &ex_codegen_dsp_DW.LMSFilter_IN_BUFFER_DWORK[0U],
                &ex_codegen_dsp_DW.LMSFilter_WGT_IC_DWORK[0U], 32,
                ex_codegen_dsp_P.LMSFilter_LEAKAGE_RTP, 1, &rtb_Sum1,
                &rtb_LMSFilter_o2, &ex_codegen_dsp_B.LMSFilter_o3[0U]);

  /* Sum: '<Root>/Sum1' */
  rtb_Sum1 = rtb_Sum - rtb_Sum1;

  /* SignalToWorkspace: '<Root>/Signal To Workspace' */
  rt_UpdateLogVar((LogVar *)(LogVar*)
                  (ex_codegen_dsp_DW.SignalToWorkspace_PWORK.LoggedData),
                  ex_codegen_dsp_B.LMSFilter_o3, 0);
}

/* Model update function */
static void ex_codegen_dsp_update(void)
{
  /* Update for DiscreteFir: '<S1>/Generated Filter Block' */
  ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf--;
  if (ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf < 0) {
    ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf = 30;
  }

  ex_codegen_dsp_DW.GeneratedFilterBlock_states[ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf]
    = ex_codegen_dsp_B.RandomSource;

  /* End of Update for DiscreteFir: '<S1>/Generated Filter Block' */

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++ex_codegen_dsp_M->Timing.clockTick0)) {
    ++ex_codegen_dsp_M->Timing.clockTickH0;
  }

  ex_codegen_dsp_M->Timing.t[0] = ex_codegen_dsp_M->Timing.clockTick0 *
    ex_codegen_dsp_M->Timing.stepSize0 + ex_codegen_dsp_M->Timing.clockTickH0 *
    ex_codegen_dsp_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void ex_codegen_dsp_initialize(void)
{
  {
    real_T arg;

    /* Start for S-Function (sdspsine2): '<Root>/Sine Wave' */
    /* Trigonometric mode: compute accumulated
       normalized trig fcn argument for each channel */
    /* Keep normalized value in range [0 2*pi) */
    for (arg = ex_codegen_dsp_P.SineWave_Phase; arg >= 6.2831853071795862; arg -=
         6.2831853071795862) {
    }

    while (arg < 0.0) {
      arg += 6.2831853071795862;
    }

    ex_codegen_dsp_DW.SineWave_AccFreqNorm = arg;

    /* End of Start for S-Function (sdspsine2): '<Root>/Sine Wave' */
    /* Start for SignalToWorkspace: '<Root>/Signal To Workspace' */
    {
      int_T dimensions[2] = { 32, 1 };

      ex_codegen_dsp_DW.SignalToWorkspace_PWORK.LoggedData = rt_CreateLogVar(
        ex_codegen_dsp_M->rtwLogInfo,
        0.0,
        rtmGetTFinal(ex_codegen_dsp_M),
        ex_codegen_dsp_M->Timing.stepSize0,
        (&rtmGetErrorStatus(ex_codegen_dsp_M)),
        "filter_wts",
        SS_DOUBLE,
        0,
        0,
        0,
        32,
        2,
        dimensions,
        NO_LOGVALDIMS,
        (NULL),
        (NULL),
        0,
        1,
        0.05,
        1);
      if (ex_codegen_dsp_DW.SignalToWorkspace_PWORK.LoggedData == (NULL))
        return;
    }
  }

  {
    real_T arg;
    int32_T i;

    /* InitializeConditions for S-Function (sdspsine2): '<Root>/Sine Wave' */
    /* This code only executes when block is re-enabled in an
       enabled subsystem when the enabled subsystem states on
       re-enabling are set to 'Reset' */
    /* Reset to time zero on re-enable */
    /* Trigonometric mode: compute accumulated
       normalized trig fcn argument for each channel */
    /* Keep normalized value in range [0 2*pi) */
    for (arg = ex_codegen_dsp_P.SineWave_Phase; arg >= 6.2831853071795862; arg -=
         6.2831853071795862) {
    }

    while (arg < 0.0) {
      arg += 6.2831853071795862;
    }

    ex_codegen_dsp_DW.SineWave_AccFreqNorm = arg;

    /* End of InitializeConditions for S-Function (sdspsine2): '<Root>/Sine Wave' */

    /* InitializeConditions for S-Function (sdsprandsrc2): '<Root>/Random Source' */
    ex_codegen_dsp_DW.RandomSource_SEED_DWORK =
      ex_codegen_dsp_P.RandomSource_InitSeed;
    RandSrcInitState_GZ(&ex_codegen_dsp_DW.RandomSource_SEED_DWORK,
                        ex_codegen_dsp_DW.RandomSource_STATE_DWORK, 1);

    /* InitializeConditions for DiscreteFir: '<S1>/Generated Filter Block' */
    ex_codegen_dsp_DW.GeneratedFilterBlock_circBuf = 0;
    for (i = 0; i < 31; i++) {
      ex_codegen_dsp_DW.GeneratedFilterBlock_states[i] =
        ex_codegen_dsp_P.GeneratedFilterBlock_InitialSta;
    }

    /* End of InitializeConditions for DiscreteFir: '<S1>/Generated Filter Block' */

    /* InitializeConditions for S-Function (sdsplms): '<Root>/LMS Filter' */
    ex_codegen_dsp_DW.LMSFilter_BUFF_IDX_DWORK = 0U;
    for (i = 0; i < 32; i++) {
      ex_codegen_dsp_DW.LMSFilter_WGT_IC_DWORK[i] = 0.0;
      ex_codegen_dsp_DW.LMSFilter_IN_BUFFER_DWORK[i] = 0.0;
    }

    /* End of InitializeConditions for S-Function (sdsplms): '<Root>/LMS Filter' */
  }
}

/* Model terminate function */
void ex_codegen_dsp_terminate(void)
{
  /* (no terminate code required) */
}

/*========================================================================*
 * Start of Classic call interface                                        *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  ex_codegen_dsp_output();

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

void MdlUpdate(int_T tid)
{
  ex_codegen_dsp_update();

  /* tid is required for a uniform function interface.
   * Argument tid is not used in the function. */
  UNUSED_PARAMETER(tid);
}

void MdlInitializeSizes(void)
{
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  ex_codegen_dsp_initialize();
}

void MdlTerminate(void)
{
  ex_codegen_dsp_terminate();
}

/* Registration function */
RT_MODEL_ex_codegen_dsp_T *ex_codegen_dsp(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)ex_codegen_dsp_M, 0,
                sizeof(RT_MODEL_ex_codegen_dsp_T));

  /* Initialize timing info */
  {
    int_T *mdlTsMap = ex_codegen_dsp_M->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    ex_codegen_dsp_M->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    ex_codegen_dsp_M->Timing.sampleTimes =
      (&ex_codegen_dsp_M->Timing.sampleTimesArray[0]);
    ex_codegen_dsp_M->Timing.offsetTimes =
      (&ex_codegen_dsp_M->Timing.offsetTimesArray[0]);

    /* task periods */
    ex_codegen_dsp_M->Timing.sampleTimes[0] = (0.05);

    /* task offsets */
    ex_codegen_dsp_M->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(ex_codegen_dsp_M, &ex_codegen_dsp_M->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = ex_codegen_dsp_M->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    ex_codegen_dsp_M->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(ex_codegen_dsp_M, 60.0);
  ex_codegen_dsp_M->Timing.stepSize0 = 0.05;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    ex_codegen_dsp_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(ex_codegen_dsp_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(ex_codegen_dsp_M->rtwLogInfo, (NULL));
    rtliSetLogT(ex_codegen_dsp_M->rtwLogInfo, "tout");
    rtliSetLogX(ex_codegen_dsp_M->rtwLogInfo, "");
    rtliSetLogXFinal(ex_codegen_dsp_M->rtwLogInfo, "");
    rtliSetSigLog(ex_codegen_dsp_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(ex_codegen_dsp_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(ex_codegen_dsp_M->rtwLogInfo, 0);
    rtliSetLogMaxRows(ex_codegen_dsp_M->rtwLogInfo, 1000);
    rtliSetLogDecimation(ex_codegen_dsp_M->rtwLogInfo, 1);
    rtliSetLogY(ex_codegen_dsp_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(ex_codegen_dsp_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(ex_codegen_dsp_M->rtwLogInfo, (NULL));
  }

  ex_codegen_dsp_M->solverInfoPtr = (&ex_codegen_dsp_M->solverInfo);
  ex_codegen_dsp_M->Timing.stepSize = (0.05);
  rtsiSetFixedStepSize(&ex_codegen_dsp_M->solverInfo, 0.05);
  rtsiSetSolverMode(&ex_codegen_dsp_M->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  ex_codegen_dsp_M->ModelData.blockIO = ((void *) &ex_codegen_dsp_B);
  (void) memset(((void *) &ex_codegen_dsp_B), 0,
                sizeof(B_ex_codegen_dsp_T));

  /* parameters */
  ex_codegen_dsp_M->ModelData.defaultParam = ((real_T *)&ex_codegen_dsp_P);

  /* states (dwork) */
  ex_codegen_dsp_M->ModelData.dwork = ((void *) &ex_codegen_dsp_DW);
  (void) memset((void *)&ex_codegen_dsp_DW, 0,
                sizeof(DW_ex_codegen_dsp_T));

  /* Initialize Sizes */
  ex_codegen_dsp_M->Sizes.numContStates = (0);/* Number of continuous states */
  ex_codegen_dsp_M->Sizes.numY = (0);  /* Number of model outputs */
  ex_codegen_dsp_M->Sizes.numU = (0);  /* Number of model inputs */
  ex_codegen_dsp_M->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  ex_codegen_dsp_M->Sizes.numSampTimes = (1);/* Number of sample times */
  ex_codegen_dsp_M->Sizes.numBlocks = (9);/* Number of blocks */
  ex_codegen_dsp_M->Sizes.numBlockIO = (3);/* Number of block outputs */
  ex_codegen_dsp_M->Sizes.numBlockPrms = (41);/* Sum of parameter "widths" */
  return ex_codegen_dsp_M;
}

/*========================================================================*
 * End of Classic call interface                                          *
 *========================================================================*/
