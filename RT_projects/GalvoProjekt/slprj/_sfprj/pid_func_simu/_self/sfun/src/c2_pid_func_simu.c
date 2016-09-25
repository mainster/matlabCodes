/* Include files */

#include <stddef.h>
#include "blas.h"
#include "pid_func_simu_sfun.h"
#include "c2_pid_func_simu.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "pid_func_simu_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c2_debug_family_names[15] = { "Kp", "Ki", "Kd", "Tf", "Ts",
  "LE", "yi", "yd", "e", "k", "nargin", "nargout", "setPoint", "processValue",
  "Y" };

/* Function Declarations */
static void initialize_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void initialize_params_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct *
  chartInstance);
static void enable_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void disable_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void c2_update_debugger_state_c2_pid_func_simu
  (SFc2_pid_func_simuInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c2_pid_func_simu
  (SFc2_pid_func_simuInstanceStruct *chartInstance);
static void set_sim_state_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_st);
static void finalize_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void sf_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct *chartInstance);
static void initSimStructsc2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void registerMessagesc2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance);
static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber);
static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData);
static void c2_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct *chartInstance,
  const mxArray *c2_Y, const char_T *c2_identifier, real_T c2_y[35]);
static void c2_b_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y[35]);
static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static real_T c2_c_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static int32_T c2_d_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static uint8_T c2_e_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_pid_func_simu, const char_T
  *c2_identifier);
static uint8_T c2_f_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void init_dsm_address_info(SFc2_pid_func_simuInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
  chartInstance->c2_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c2_is_active_c2_pid_func_simu = 0U;
}

static void initialize_params_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct *
  chartInstance)
{
}

static void enable_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c2_update_debugger_state_c2_pid_func_simu
  (SFc2_pid_func_simuInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c2_pid_func_simu
  (SFc2_pid_func_simuInstanceStruct *chartInstance)
{
  const mxArray *c2_st;
  const mxArray *c2_y = NULL;
  int32_T c2_i0;
  real_T c2_u[35];
  const mxArray *c2_b_y = NULL;
  uint8_T c2_hoistedGlobal;
  uint8_T c2_b_u;
  const mxArray *c2_c_y = NULL;
  real_T (*c2_Y)[35];
  c2_Y = (real_T (*)[35])ssGetOutputPortSignal(chartInstance->S, 1);
  c2_st = NULL;
  c2_st = NULL;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_createcellarray(2), FALSE);
  for (c2_i0 = 0; c2_i0 < 35; c2_i0++) {
    c2_u[c2_i0] = (*c2_Y)[c2_i0];
  }

  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", c2_u, 0, 0U, 1U, 0U, 2, 1, 35),
                FALSE);
  sf_mex_setcell(c2_y, 0, c2_b_y);
  c2_hoistedGlobal = chartInstance->c2_is_active_c2_pid_func_simu;
  c2_b_u = c2_hoistedGlobal;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_b_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 1, c2_c_y);
  sf_mex_assign(&c2_st, c2_y, FALSE);
  return c2_st;
}

static void set_sim_state_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_st)
{
  const mxArray *c2_u;
  real_T c2_dv0[35];
  int32_T c2_i1;
  real_T (*c2_Y)[35];
  c2_Y = (real_T (*)[35])ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c2_doneDoubleBufferReInit = TRUE;
  c2_u = sf_mex_dup(c2_st);
  c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 0)), "Y",
                      c2_dv0);
  for (c2_i1 = 0; c2_i1 < 35; c2_i1++) {
    (*c2_Y)[c2_i1] = c2_dv0[c2_i1];
  }

  chartInstance->c2_is_active_c2_pid_func_simu = c2_e_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 1)),
     "is_active_c2_pid_func_simu");
  sf_mex_destroy(&c2_u);
  c2_update_debugger_state_c2_pid_func_simu(chartInstance);
  sf_mex_destroy(&c2_st);
}

static void finalize_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
}

static void sf_c2_pid_func_simu(SFc2_pid_func_simuInstanceStruct *chartInstance)
{
  int32_T c2_i2;
  int32_T c2_i3;
  real_T c2_hoistedGlobal;
  real_T c2_setPoint;
  int32_T c2_i4;
  real_T c2_processValue[35];
  uint32_T c2_debug_family_var_map[15];
  real_T c2_Kp;
  real_T c2_Ki;
  real_T c2_Kd;
  real_T c2_Tf;
  real_T c2_Ts;
  real_T c2_LE;
  real_T c2_yi[35];
  real_T c2_yd[35];
  real_T c2_e[35];
  real_T c2_k;
  real_T c2_nargin = 2.0;
  real_T c2_nargout = 1.0;
  real_T c2_Y[35];
  int32_T c2_i5;
  int32_T c2_i6;
  int32_T c2_i7;
  int32_T c2_i8;
  real_T c2_b;
  real_T c2_y;
  real_T c2_b_b;
  real_T c2_b_y;
  real_T c2_A;
  real_T c2_x;
  real_T c2_b_x;
  real_T c2_c_y;
  int32_T c2_b_k;
  real_T c2_c_b;
  real_T c2_d_y;
  real_T c2_d_b;
  real_T c2_e_y;
  real_T c2_e_b;
  real_T c2_f_y;
  real_T c2_b_A;
  real_T c2_c_x;
  real_T c2_d_x;
  real_T c2_g_y;
  int32_T c2_i9;
  real_T *c2_b_setPoint;
  real_T (*c2_b_Y)[35];
  real_T (*c2_b_processValue)[35];
  c2_b_processValue = (real_T (*)[35])ssGetInputPortSignal(chartInstance->S, 1);
  c2_b_Y = (real_T (*)[35])ssGetOutputPortSignal(chartInstance->S, 1);
  c2_b_setPoint = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c2_b_setPoint, 0U);
  for (c2_i2 = 0; c2_i2 < 35; c2_i2++) {
    _SFD_DATA_RANGE_CHECK((*c2_b_Y)[c2_i2], 1U);
  }

  for (c2_i3 = 0; c2_i3 < 35; c2_i3++) {
    _SFD_DATA_RANGE_CHECK((*c2_b_processValue)[c2_i3], 2U);
  }

  chartInstance->c2_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  c2_hoistedGlobal = *c2_b_setPoint;
  c2_setPoint = c2_hoistedGlobal;
  for (c2_i4 = 0; c2_i4 < 35; c2_i4++) {
    c2_processValue[c2_i4] = (*c2_b_processValue)[c2_i4];
  }

  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 15U, 15U, c2_debug_family_names,
    c2_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_Kp, 0U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_Ki, 1U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_Kd, 2U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_Tf, 3U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_Ts, 4U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_LE, 5U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c2_yi, 6U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c2_yd, 7U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c2_e, 8U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_k, 9U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_nargin, 10U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_nargout, 11U, c2_b_sf_marshallOut,
    c2_b_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_setPoint, 12U, c2_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(c2_processValue, 13U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(c2_Y, 14U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 3);
  c2_Kp = 1.84;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 4);
  c2_Ki = 4840.0;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 5);
  c2_Kd = 0.000123;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 6);
  c2_Tf = 6.13E-5;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 7);
  c2_Ts = 5.0E-5;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 9);
  c2_LE = 35.0;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 11);
  for (c2_i5 = 0; c2_i5 < 35; c2_i5++) {
    c2_yi[c2_i5] = 0.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 12);
  for (c2_i6 = 0; c2_i6 < 35; c2_i6++) {
    c2_yd[c2_i6] = 0.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 13);
  for (c2_i7 = 0; c2_i7 < 35; c2_i7++) {
    c2_Y[c2_i7] = 0.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 14);
  for (c2_i8 = 0; c2_i8 < 35; c2_i8++) {
    c2_e[c2_i8] = 0.0;
  }

  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 16);
  c2_e[0] = c2_setPoint - c2_processValue[0];
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 17);
  c2_b = c2_e[0];
  c2_y = 0.24200000000000002 * c2_b;
  c2_yi[0] = c2_y;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 18);
  c2_b_b = c2_e[0];
  c2_b_y = 0.000123 * c2_b_b;
  c2_A = c2_b_y;
  c2_x = c2_A;
  c2_b_x = c2_x;
  c2_c_y = c2_b_x / 0.0001113;
  c2_yd[0] = c2_c_y;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 19);
  c2_Y[0] = (c2_Kp + c2_yi[0]) + c2_yd[0];
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 21);
  c2_k = 2.0;
  c2_b_k = 0;
  while (c2_b_k < 34) {
    c2_k = 2.0 + (real_T)c2_b_k;
    CV_EML_FOR(0, 1, 0, 1);
    _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 22);
    (real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("setPoint", (int32_T)_SFD_INTEGER_CHECK(
      "k", c2_k), 1, 1, 1, 0);
    c2_e[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("e", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1] = c2_setPoint
      - c2_processValue[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK(
      "processValue", (int32_T)_SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1];
    _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 23);
    c2_c_b = c2_e[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("e", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1];
    c2_d_y = 0.24200000000000002 * c2_c_b;
    c2_yi[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("yi", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1] = c2_d_y - c2_yi[(int32_T)
      (real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("yi", (int32_T)_SFD_INTEGER_CHECK(
      "k-1", c2_k - 1.0), 1, 35, 1, 0) - 1];
    _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 24);
    c2_d_b = c2_e[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("e", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1] - c2_e[(int32_T)(real_T)
      _SFD_EML_ARRAY_BOUNDS_CHECK("e", (int32_T)_SFD_INTEGER_CHECK("k-1", c2_k -
      1.0), 1, 35, 1, 0) - 1];
    c2_e_y = 0.000123 * c2_d_b;
    c2_e_b = c2_yd[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("yd", (int32_T)
      _SFD_INTEGER_CHECK("k-1", c2_k - 1.0), 1, 35, 1, 0) - 1];
    c2_f_y = 6.13E-5 * c2_e_b;
    c2_b_A = c2_e_y + c2_f_y;
    c2_c_x = c2_b_A;
    c2_d_x = c2_c_x;
    c2_g_y = c2_d_x / 0.0001113;
    c2_yd[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("yd", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1] = c2_g_y;
    _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 25);
    c2_Y[(int32_T)(real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("Y", (int32_T)
      _SFD_INTEGER_CHECK("k", c2_k), 1, 35, 1, 0) - 1] = (c2_Kp + c2_yi[(int32_T)
      (real_T)_SFD_EML_ARRAY_BOUNDS_CHECK("yi", (int32_T)_SFD_INTEGER_CHECK("k",
      c2_k), 1, 35, 1, 0) - 1]) + c2_yd[(int32_T)(real_T)
      _SFD_EML_ARRAY_BOUNDS_CHECK("yd", (int32_T)_SFD_INTEGER_CHECK("k", c2_k),
      1, 35, 1, 0) - 1];
    c2_b_k++;
    _SF_MEX_LISTEN_FOR_CTRL_C(chartInstance->S);
  }

  CV_EML_FOR(0, 1, 0, 0);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, -25);
  _SFD_SYMBOL_SCOPE_POP();
  for (c2_i9 = 0; c2_i9 < 35; c2_i9++) {
    (*c2_b_Y)[c2_i9] = c2_Y[c2_i9];
  }

  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_pid_func_simuMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
}

static void registerMessagesc2_pid_func_simu(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
}

static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber)
{
}

static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_i10;
  real_T c2_b_inData[35];
  int32_T c2_i11;
  real_T c2_u[35];
  const mxArray *c2_y = NULL;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  for (c2_i10 = 0; c2_i10 < 35; c2_i10++) {
    c2_b_inData[c2_i10] = (*(real_T (*)[35])c2_inData)[c2_i10];
  }

  for (c2_i11 = 0; c2_i11 < 35; c2_i11++) {
    c2_u[c2_i11] = c2_b_inData[c2_i11];
  }

  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", c2_u, 0, 0U, 1U, 0U, 2, 1, 35), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static void c2_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct *chartInstance,
  const mxArray *c2_Y, const char_T *c2_identifier, real_T c2_y[35])
{
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_Y), &c2_thisId, c2_y);
  sf_mex_destroy(&c2_Y);
}

static void c2_b_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId,
  real_T c2_y[35])
{
  real_T c2_dv1[35];
  int32_T c2_i12;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), c2_dv1, 1, 0, 0U, 1, 0U, 2, 1, 35);
  for (c2_i12 = 0; c2_i12 < 35; c2_i12++) {
    c2_y[c2_i12] = c2_dv1[c2_i12];
  }

  sf_mex_destroy(&c2_u);
}

static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_Y;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y[35];
  int32_T c2_i13;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_Y = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_Y), &c2_thisId, c2_y);
  sf_mex_destroy(&c2_Y);
  for (c2_i13 = 0; c2_i13 < 35; c2_i13++) {
    (*(real_T (*)[35])c2_outData)[c2_i13] = c2_y[c2_i13];
  }

  sf_mex_destroy(&c2_mxArrayInData);
}

static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  real_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(real_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static real_T c2_c_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  real_T c2_y;
  real_T c2_d0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_d0, 1, 0, 0U, 0, 0U, 0);
  c2_y = c2_d0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_nargout;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_nargout = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_nargout), &c2_thisId);
  sf_mex_destroy(&c2_nargout);
  *(real_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

const mxArray *sf_c2_pid_func_simu_get_eml_resolved_functions_info(void)
{
  const mxArray *c2_nameCaptureInfo;
  c2_ResolvedFunctionInfo c2_info[5];
  c2_ResolvedFunctionInfo (*c2_b_info)[5];
  const mxArray *c2_m0 = NULL;
  int32_T c2_i14;
  c2_ResolvedFunctionInfo *c2_r0;
  c2_nameCaptureInfo = NULL;
  c2_nameCaptureInfo = NULL;
  c2_b_info = (c2_ResolvedFunctionInfo (*)[5])c2_info;
  (*c2_b_info)[0].context = "";
  (*c2_b_info)[0].name = "mtimes";
  (*c2_b_info)[0].dominantType = "double";
  (*c2_b_info)[0].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  (*c2_b_info)[0].fileTimeLo = 1289519692U;
  (*c2_b_info)[0].fileTimeHi = 0U;
  (*c2_b_info)[0].mFileTimeLo = 0U;
  (*c2_b_info)[0].mFileTimeHi = 0U;
  (*c2_b_info)[1].context = "";
  (*c2_b_info)[1].name = "mrdivide";
  (*c2_b_info)[1].dominantType = "double";
  (*c2_b_info)[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  (*c2_b_info)[1].fileTimeLo = 1357951548U;
  (*c2_b_info)[1].fileTimeHi = 0U;
  (*c2_b_info)[1].mFileTimeLo = 1319729966U;
  (*c2_b_info)[1].mFileTimeHi = 0U;
  (*c2_b_info)[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  (*c2_b_info)[2].name = "rdivide";
  (*c2_b_info)[2].dominantType = "double";
  (*c2_b_info)[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c2_b_info)[2].fileTimeLo = 1346510388U;
  (*c2_b_info)[2].fileTimeHi = 0U;
  (*c2_b_info)[2].mFileTimeLo = 0U;
  (*c2_b_info)[2].mFileTimeHi = 0U;
  (*c2_b_info)[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c2_b_info)[3].name = "eml_scalexp_compatible";
  (*c2_b_info)[3].dominantType = "double";
  (*c2_b_info)[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  (*c2_b_info)[3].fileTimeLo = 1286818796U;
  (*c2_b_info)[3].fileTimeHi = 0U;
  (*c2_b_info)[3].mFileTimeLo = 0U;
  (*c2_b_info)[3].mFileTimeHi = 0U;
  (*c2_b_info)[4].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  (*c2_b_info)[4].name = "eml_div";
  (*c2_b_info)[4].dominantType = "double";
  (*c2_b_info)[4].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  (*c2_b_info)[4].fileTimeLo = 1313347810U;
  (*c2_b_info)[4].fileTimeHi = 0U;
  (*c2_b_info)[4].mFileTimeLo = 0U;
  (*c2_b_info)[4].mFileTimeHi = 0U;
  sf_mex_assign(&c2_m0, sf_mex_createstruct("nameCaptureInfo", 1, 5), FALSE);
  for (c2_i14 = 0; c2_i14 < 5; c2_i14++) {
    c2_r0 = &c2_info[c2_i14];
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->context)), "context", "nameCaptureInfo",
                    c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c2_r0->name)), "name", "nameCaptureInfo", c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c2_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", c2_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->resolved)), "resolved", "nameCaptureInfo",
                    c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c2_i14);
    sf_mex_addfield(c2_m0, sf_mex_create("nameCaptureInfo", &c2_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c2_i14);
  }

  sf_mex_assign(&c2_nameCaptureInfo, c2_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c2_nameCaptureInfo);
  return c2_nameCaptureInfo;
}

static const mxArray *c2_c_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(int32_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static int32_T c2_d_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  int32_T c2_y;
  int32_T c2_i15;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_i15, 1, 6, 0U, 0, 0U, 0);
  c2_y = c2_i15;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_c_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_b_sfEvent;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y;
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)chartInstanceVoid;
  c2_b_sfEvent = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_d_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_sfEvent),
    &c2_thisId);
  sf_mex_destroy(&c2_b_sfEvent);
  *(int32_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static uint8_T c2_e_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_pid_func_simu, const char_T
  *c2_identifier)
{
  uint8_T c2_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_f_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c2_b_is_active_c2_pid_func_simu), &c2_thisId);
  sf_mex_destroy(&c2_b_is_active_c2_pid_func_simu);
  return c2_y;
}

static uint8_T c2_f_emlrt_marshallIn(SFc2_pid_func_simuInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  uint8_T c2_y;
  uint8_T c2_u0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_u0, 1, 3, 0U, 0, 0U, 0);
  c2_y = c2_u0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void init_dsm_address_info(SFc2_pid_func_simuInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c2_pid_func_simu_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(2487122670U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1706735517U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(574938940U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(353185325U);
}

mxArray *sf_c2_pid_func_simu_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("rMq5gbs7TvRMa97dwapl1B");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(35);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(35);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c2_pid_func_simu_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c2_pid_func_simu(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"Y\",},{M[8],M[0],T\"is_active_c2_pid_func_simu\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c2_pid_func_simu_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc2_pid_func_simuInstanceStruct *chartInstance;
    chartInstance = (SFc2_pid_func_simuInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _pid_func_simuMachineNumber_,
           2,
           1,
           1,
           3,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_pid_func_simuMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_pid_func_simuMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _pid_func_simuMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"setPoint");
          _SFD_SET_DATA_PROPS(1,2,0,1,"Y");
          _SFD_SET_DATA_PROPS(2,1,1,0,"processValue");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,1,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,591);
        _SFD_CV_INIT_EML_FOR(0,1,0,382,393,586);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_b_sf_marshallOut,(MexInFcnForType)NULL);

        {
          unsigned int dimVector[2];
          dimVector[0]= 1;
          dimVector[1]= 35;
          _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,2,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)
            c2_sf_marshallIn);
        }

        {
          unsigned int dimVector[2];
          dimVector[0]= 1;
          dimVector[1]= 35;
          _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,2,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        }

        {
          real_T *c2_setPoint;
          real_T (*c2_Y)[35];
          real_T (*c2_processValue)[35];
          c2_processValue = (real_T (*)[35])ssGetInputPortSignal
            (chartInstance->S, 1);
          c2_Y = (real_T (*)[35])ssGetOutputPortSignal(chartInstance->S, 1);
          c2_setPoint = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c2_setPoint);
          _SFD_SET_DATA_VALUE_PTR(1U, *c2_Y);
          _SFD_SET_DATA_VALUE_PTR(2U, *c2_processValue);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _pid_func_simuMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "2w31XJFhSjUt9u3oKBm8FE";
}

static void sf_opaque_initialize_c2_pid_func_simu(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc2_pid_func_simuInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
    chartInstanceVar);
  initialize_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c2_pid_func_simu(void *chartInstanceVar)
{
  enable_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c2_pid_func_simu(void *chartInstanceVar)
{
  disable_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c2_pid_func_simu(void *chartInstanceVar)
{
  sf_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c2_pid_func_simu(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c2_pid_func_simu
    ((SFc2_pid_func_simuInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_pid_func_simu();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c2_pid_func_simu(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_pid_func_simu();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c2_pid_func_simu(SimStruct* S)
{
  return sf_internal_get_sim_state_c2_pid_func_simu(S);
}

static void sf_opaque_set_sim_state_c2_pid_func_simu(SimStruct* S, const mxArray
  *st)
{
  sf_internal_set_sim_state_c2_pid_func_simu(S, st);
}

static void sf_opaque_terminate_c2_pid_func_simu(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc2_pid_func_simuInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_pid_func_simu_optimization_info();
    }

    finalize_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
      chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c2_pid_func_simu(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c2_pid_func_simu((SFc2_pid_func_simuInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c2_pid_func_simu(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_pid_func_simu_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      2);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,2,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,2,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,2);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,2,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,2,1);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=1; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 2; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,2);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(365898788U));
  ssSetChecksum1(S,(3297845614U));
  ssSetChecksum2(S,(2664474927U));
  ssSetChecksum3(S,(2725744614U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c2_pid_func_simu(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c2_pid_func_simu(SimStruct *S)
{
  SFc2_pid_func_simuInstanceStruct *chartInstance;
  chartInstance = (SFc2_pid_func_simuInstanceStruct *)utMalloc(sizeof
    (SFc2_pid_func_simuInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc2_pid_func_simuInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c2_pid_func_simu;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c2_pid_func_simu;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c2_pid_func_simu;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c2_pid_func_simu;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c2_pid_func_simu;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c2_pid_func_simu;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c2_pid_func_simu;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c2_pid_func_simu;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c2_pid_func_simu;
  chartInstance->chartInfo.mdlStart = mdlStart_c2_pid_func_simu;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c2_pid_func_simu;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c2_pid_func_simu_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c2_pid_func_simu(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c2_pid_func_simu(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c2_pid_func_simu(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c2_pid_func_simu_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
