/* Include files */

#include <stddef.h>
#include "blas.h"
#include "signalflussalgebra_cgxe.h"
#include "m_L4TKA5lKCXheIhQN4RietB.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static emlrtMCInfo emlrtMCI = { 1, 1, "SystemCore",
  "/opt/matlab/R2015a/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p"
};

/* Function Declarations */
static void cgxe_mdl_start(InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance);
static void cgxe_mdl_initialize(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance);
static void cgxe_mdl_outputs(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance);
static void cgxe_mdl_update(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance);
static void cgxe_mdl_terminate(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance);
static const mxArray *mw__internal__name__resolution__fcn(void);
static void info_helper(const mxArray **info);
static const mxArray *emlrt_marshallOut(const char * u);
static const mxArray *b_emlrt_marshallOut(const uint32_T u);
static const mxArray *mw__internal__autoInference__fcn(void);
static const mxArray *mw__internal__getSimState__fcn
  (InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance);
static AddOne emlrt_marshallIn(const mxArray *b_sysobj, const char_T *identifier);
static AddOne b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static int32_T c_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static boolean_T d_emlrt_marshallIn(const mxArray *b_sysobj_not_empty, const
  char_T *identifier);
static boolean_T e_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static void mw__internal__setSimState__fcn(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance, const mxArray *st);
static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location);
static void error(const mxArray *b, emlrtMCInfo *location);
static int32_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);
static boolean_T g_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);

/* Function Definitions */
static void cgxe_mdl_start(InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance)
{
  AddOne *obj;
  int32_T i0;
  static char_T cv0[51] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'L', 'o', 'c', 'k', 'e', 'd', 'R', 'e', 'l', 'e',
    'a', 's', 'e', 'd', 'C', 'o', 'd', 'e', 'g', 'e', 'n' };

  char_T u[51];
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 51 };

  const mxArray *m0;
  static char_T cv1[5] = { 's', 'e', 't', 'u', 'p' };

  char_T b_u[5];
  const mxArray *b_y;
  static const int32_T iv1[2] = { 1, 5 };

  /* Allocate instance data */
  covrtAllocateInstanceData(&moduleInstance->covInst);

  /* Initialize Coverage Information */
  covrtScriptInit(&moduleInstance->covInst,
                  "/home/mainster/CODES_local/matlab_workspace/AddOne.m", 0, 2,
                  2, 0, 0, 0, 0, 0, 0, 0, 0);

  /* Initialize Function Information */
  covrtFcnInit(&moduleInstance->covInst, 0, 1, "AddOne_stepImpl", 238, -1, 289);
  covrtFcnInit(&moduleInstance->covInst, 0, 0, "AddOne_AddOne", 9, -1, 15);

  /* Initialize Basic Block Information */
  covrtBasicBlockInit(&moduleInstance->covInst, 0, 1, 271, -1, 280);
  covrtBasicBlockInit(&moduleInstance->covInst, 0, 0, 9, -1, 15);

  /* Initialize If Information */
  /* Initialize MCDC Information */
  /* Initialize For Information */
  /* Initialize While Information */
  /* Initialize Switch Information */
  /* Start callback for coverage engine */
  covrtScriptStart(&moduleInstance->covInst, 0U);
  if (!moduleInstance->sysobj_not_empty) {
    covrtLogFcn(&moduleInstance->covInst, 0, 0);
    covrtLogBasicBlock(&moduleInstance->covInst, 0, 0);
    moduleInstance->sysobj.isInitialized = 0;
    moduleInstance->sysobj_not_empty = true;
  }

  obj = &moduleInstance->sysobj;
  if (moduleInstance->sysobj.isInitialized != 0) {
    for (i0 = 0; i0 < 51; i0++) {
      u[i0] = cv0[i0];
    }

    y = NULL;
    m0 = emlrtCreateCharArray(2, iv0);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 51, m0, &u[0]);
    emlrtAssign(&y, m0);
    for (i0 = 0; i0 < 5; i0++) {
      b_u[i0] = cv1[i0];
    }

    b_y = NULL;
    m0 = emlrtCreateCharArray(2, iv1);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 5, m0, &b_u[0]);
    emlrtAssign(&b_y, m0);
    error(message(y, b_y, &emlrtMCI), &emlrtMCI);
  }

  obj->isInitialized = 1;
}

static void cgxe_mdl_initialize(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance)
{
  AddOne *obj;
  int32_T i1;
  static char_T cv2[45] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'R', 'e', 'l', 'e', 'a', 's', 'e', 'd', 'C', 'o',
    'd', 'e', 'g', 'e', 'n' };

  char_T u[45];
  const mxArray *y;
  static const int32_T iv2[2] = { 1, 45 };

  const mxArray *m1;
  static char_T cv3[8] = { 'i', 's', 'L', 'o', 'c', 'k', 'e', 'd' };

  char_T b_u[8];
  const mxArray *b_y;
  static const int32_T iv3[2] = { 1, 8 };

  boolean_T flag;
  char_T c_u[45];
  const mxArray *c_y;
  static const int32_T iv4[2] = { 1, 45 };

  static char_T cv4[5] = { 'r', 'e', 's', 'e', 't' };

  char_T d_u[5];
  const mxArray *d_y;
  static const int32_T iv5[2] = { 1, 5 };

  if (!moduleInstance->sysobj_not_empty) {
    covrtLogFcn(&moduleInstance->covInst, 0, 0);
    covrtLogBasicBlock(&moduleInstance->covInst, 0, 0);
    moduleInstance->sysobj.isInitialized = 0;
    moduleInstance->sysobj_not_empty = true;
  }

  obj = &moduleInstance->sysobj;
  if (moduleInstance->sysobj.isInitialized == 2) {
    for (i1 = 0; i1 < 45; i1++) {
      u[i1] = cv2[i1];
    }

    y = NULL;
    m1 = emlrtCreateCharArray(2, iv2);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m1, &u[0]);
    emlrtAssign(&y, m1);
    for (i1 = 0; i1 < 8; i1++) {
      b_u[i1] = cv3[i1];
    }

    b_y = NULL;
    m1 = emlrtCreateCharArray(2, iv3);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 8, m1, &b_u[0]);
    emlrtAssign(&b_y, m1);
    error(message(y, b_y, &emlrtMCI), &emlrtMCI);
  }

  flag = (obj->isInitialized == 1);
  if (flag && (moduleInstance->sysobj.isInitialized == 2)) {
    for (i1 = 0; i1 < 45; i1++) {
      c_u[i1] = cv2[i1];
    }

    c_y = NULL;
    m1 = emlrtCreateCharArray(2, iv4);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m1, &c_u[0]);
    emlrtAssign(&c_y, m1);
    for (i1 = 0; i1 < 5; i1++) {
      d_u[i1] = cv4[i1];
    }

    d_y = NULL;
    m1 = emlrtCreateCharArray(2, iv5);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 5, m1, &d_u[0]);
    emlrtAssign(&d_y, m1);
    error(message(c_y, d_y, &emlrtMCI), &emlrtMCI);
  }
}

static void cgxe_mdl_outputs(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance)
{
  real_T varargin_1[2];
  int32_T i2;
  AddOne *obj;
  static char_T cv5[45] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'R', 'e', 'l', 'e', 'a', 's', 'e', 'd', 'C', 'o',
    'd', 'e', 'g', 'e', 'n' };

  char_T u[45];
  const mxArray *y;
  static const int32_T iv6[2] = { 1, 45 };

  const mxArray *m2;
  static char_T cv6[4] = { 's', 't', 'e', 'p' };

  char_T b_u[4];
  const mxArray *b_y;
  static const int32_T iv7[2] = { 1, 4 };

  static char_T cv7[51] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'L', 'o', 'c', 'k', 'e', 'd', 'R', 'e', 'l', 'e',
    'a', 's', 'e', 'd', 'C', 'o', 'd', 'e', 'g', 'e', 'n' };

  char_T c_u[51];
  const mxArray *c_y;
  static const int32_T iv8[2] = { 1, 51 };

  static char_T cv8[5] = { 's', 'e', 't', 'u', 'p' };

  char_T d_u[5];
  const mxArray *d_y;
  static const int32_T iv9[2] = { 1, 5 };

  real_T (*b_y0)[2];
  real_T (*u0)[2];
  b_y0 = (real_T (*)[2])ssGetOutputPortSignal(moduleInstance->S, 0U);
  u0 = (real_T (*)[2])ssGetInputPortSignal(moduleInstance->S, 0U);
  for (i2 = 0; i2 < 2; i2++) {
    varargin_1[i2] = (*u0)[i2];
  }

  if (!moduleInstance->sysobj_not_empty) {
    covrtLogFcn(&moduleInstance->covInst, 0, 0);
    covrtLogBasicBlock(&moduleInstance->covInst, 0, 0);
    moduleInstance->sysobj.isInitialized = 0;
    moduleInstance->sysobj_not_empty = true;
  }

  obj = &moduleInstance->sysobj;
  if (moduleInstance->sysobj.isInitialized == 2) {
    for (i2 = 0; i2 < 45; i2++) {
      u[i2] = cv5[i2];
    }

    y = NULL;
    m2 = emlrtCreateCharArray(2, iv6);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m2, &u[0]);
    emlrtAssign(&y, m2);
    for (i2 = 0; i2 < 4; i2++) {
      b_u[i2] = cv6[i2];
    }

    b_y = NULL;
    m2 = emlrtCreateCharArray(2, iv7);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 4, m2, &b_u[0]);
    emlrtAssign(&b_y, m2);
    error(message(y, b_y, &emlrtMCI), &emlrtMCI);
  }

  if (obj->isInitialized != 1) {
    if (obj->isInitialized != 0) {
      for (i2 = 0; i2 < 51; i2++) {
        c_u[i2] = cv7[i2];
      }

      c_y = NULL;
      m2 = emlrtCreateCharArray(2, iv8);
      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 51, m2, &c_u[0]);
      emlrtAssign(&c_y, m2);
      for (i2 = 0; i2 < 5; i2++) {
        d_u[i2] = cv8[i2];
      }

      d_y = NULL;
      m2 = emlrtCreateCharArray(2, iv9);
      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 5, m2, &d_u[0]);
      emlrtAssign(&d_y, m2);
      error(message(c_y, d_y, &emlrtMCI), &emlrtMCI);
    }

    obj->isInitialized = 1;
  }

  covrtLogFcn(&moduleInstance->covInst, 0, 1);
  covrtLogBasicBlock(&moduleInstance->covInst, 0, 1);

  /*  ADDONE Compute an output value one greater than the input value */
  /*  All methods occur inside a methods declaration. */
  /*  The stepImpl method has protected access */
  for (i2 = 0; i2 < 2; i2++) {
    (*b_y0)[i2] = varargin_1[i2] + 1.0;
  }
}

static void cgxe_mdl_update(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance)
{
  (void)moduleInstance;
}

static void cgxe_mdl_terminate(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance)
{
  AddOne *obj;
  int32_T i3;
  static char_T cv9[45] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 's', 'y', 's',
    't', 'e', 'm', ':', 'm', 'e', 't', 'h', 'o', 'd', 'C', 'a', 'l', 'l', 'e',
    'd', 'W', 'h', 'e', 'n', 'R', 'e', 'l', 'e', 'a', 's', 'e', 'd', 'C', 'o',
    'd', 'e', 'g', 'e', 'n' };

  char_T u[45];
  const mxArray *y;
  static const int32_T iv10[2] = { 1, 45 };

  const mxArray *m3;
  static char_T cv10[8] = { 'i', 's', 'L', 'o', 'c', 'k', 'e', 'd' };

  char_T b_u[8];
  const mxArray *b_y;
  static const int32_T iv11[2] = { 1, 8 };

  boolean_T flag;
  char_T c_u[45];
  const mxArray *c_y;
  static const int32_T iv12[2] = { 1, 45 };

  static char_T cv11[7] = { 'r', 'e', 'l', 'e', 'a', 's', 'e' };

  char_T d_u[7];
  const mxArray *d_y;
  static const int32_T iv13[2] = { 1, 7 };

  if (!moduleInstance->sysobj_not_empty) {
    covrtLogFcn(&moduleInstance->covInst, 0, 0);
    covrtLogBasicBlock(&moduleInstance->covInst, 0, 0);
    moduleInstance->sysobj.isInitialized = 0;
    moduleInstance->sysobj_not_empty = true;
  }

  obj = &moduleInstance->sysobj;
  if (moduleInstance->sysobj.isInitialized == 2) {
    for (i3 = 0; i3 < 45; i3++) {
      u[i3] = cv9[i3];
    }

    y = NULL;
    m3 = emlrtCreateCharArray(2, iv10);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m3, &u[0]);
    emlrtAssign(&y, m3);
    for (i3 = 0; i3 < 8; i3++) {
      b_u[i3] = cv10[i3];
    }

    b_y = NULL;
    m3 = emlrtCreateCharArray(2, iv11);
    emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 8, m3, &b_u[0]);
    emlrtAssign(&b_y, m3);
    error(message(y, b_y, &emlrtMCI), &emlrtMCI);
  }

  flag = (obj->isInitialized == 1);
  if (flag) {
    obj = &moduleInstance->sysobj;
    if (moduleInstance->sysobj.isInitialized == 2) {
      for (i3 = 0; i3 < 45; i3++) {
        c_u[i3] = cv9[i3];
      }

      c_y = NULL;
      m3 = emlrtCreateCharArray(2, iv12);
      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 45, m3, &c_u[0]);
      emlrtAssign(&c_y, m3);
      for (i3 = 0; i3 < 7; i3++) {
        d_u[i3] = cv11[i3];
      }

      d_y = NULL;
      m3 = emlrtCreateCharArray(2, iv13);
      emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 7, m3, &d_u[0]);
      emlrtAssign(&d_y, m3);
      error(message(c_y, d_y, &emlrtMCI), &emlrtMCI);
    }

    if (obj->isInitialized == 1) {
      obj->isInitialized = 2;
    }
  }

  /* Free instance data */
  covrtFreeInstanceData(&moduleInstance->covInst);
}

static const mxArray *mw__internal__name__resolution__fcn(void)
{
  const mxArray *nameCaptureInfo;
  nameCaptureInfo = NULL;
  emlrtAssign(&nameCaptureInfo, emlrtCreateStructMatrix(43, 1, 0, NULL));
  info_helper(&nameCaptureInfo);
  emlrtNameCapturePostProcessR2013b(&nameCaptureInfo);
  return nameCaptureInfo;
}

static void info_helper(const mxArray **info)
{
  emlrtAddField(*info, emlrt_marshallOut(""), "context", 0);
  emlrtAddField(*info, emlrt_marshallOut("repmat"), "name", 0);
  emlrtAddField(*info, emlrt_marshallOut("struct"), "dominantType", 0);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m"), "resolved", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 0);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 0);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m"), "context", 1);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.narginchk"), "name", 1);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 1);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/narginchk.m"),
                "resolved", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 1);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 1);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/narginchk.m"),
                "context", 2);
  emlrtAddField(*info, emlrt_marshallOut("floor"), "name", 2);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 2);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m"), "resolved", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 2);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 2);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m"), "context", 3);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.isBuiltInNumeric"),
                "name", 3);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 3);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/isBuiltInNumeric.m"),
                "resolved", 3);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 3);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 3);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 3);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 3);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m"), "context", 4);
  emlrtAddField(*info, emlrt_marshallOut("eml_scalar_floor"), "name", 4);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 4);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m"),
                "resolved", 4);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 4);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 4);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 4);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 4);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m"), "context", 5);
  emlrtAddField(*info, emlrt_marshallOut("eml_assert_valid_size_arg"), "name", 5);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 5);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m"),
                "resolved", 5);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 5);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 5);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 5);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 5);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m"),
                "context", 6);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.isBuiltInNumeric"),
                "name", 6);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 6);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/isBuiltInNumeric.m"),
                "resolved", 6);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 6);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 6);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 6);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 6);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isintegral"),
                "context", 7);
  emlrtAddField(*info, emlrt_marshallOut("isinf"), "name", 7);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 7);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m"), "resolved", 7);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 7);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 7);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 7);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 7);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m"), "context", 8);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.isBuiltInNumeric"),
                "name", 8);
  emlrtAddField(*info, emlrt_marshallOut("double"), "dominantType", 8);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/isBuiltInNumeric.m"),
                "resolved", 8);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 8);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 8);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 8);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 8);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isinbounds"),
                "context", 9);
  emlrtAddField(*info, emlrt_marshallOut("eml_is_integer_class"), "name", 9);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 9);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_is_integer_class.m"),
                "resolved", 9);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 9);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 9);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 9);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 9);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isinbounds"),
                "context", 10);
  emlrtAddField(*info, emlrt_marshallOut("intmax"), "name", 10);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 10);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m"), "resolved", 10);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 10);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 10);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 10);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 10);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m"), "context", 11);
  emlrtAddField(*info, emlrt_marshallOut("eml_switch_helper"), "name", 11);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 11);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_switch_helper.m"),
                "resolved", 11);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 11);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 11);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 11);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 11);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isinbounds"),
                "context", 12);
  emlrtAddField(*info, emlrt_marshallOut("intmin"), "name", 12);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 12);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmin.m"), "resolved", 12);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 12);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 12);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 12);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 12);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmin.m"), "context", 13);
  emlrtAddField(*info, emlrt_marshallOut("eml_switch_helper"), "name", 13);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 13);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_switch_helper.m"),
                "resolved", 13);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 13);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 13);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 13);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 13);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m!isinbounds"),
                "context", 14);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexIntRelop"), "name",
                14);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 14);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/indexIntRelop.m"),
                "resolved", 14);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 14);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 14);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 14);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 14);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/indexIntRelop.m!apply_float_relop"),
                "context", 15);
  emlrtAddField(*info, emlrt_marshallOut("eml_switch_helper"), "name", 15);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 15);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_switch_helper.m"),
                "resolved", 15);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 15);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 15);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 15);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 15);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/indexIntRelop.m!float_class_contains_indexIntClass"),
                "context", 16);
  emlrtAddField(*info, emlrt_marshallOut("eml_float_model"), "name", 16);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 16);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_float_model.m"),
                "resolved", 16);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 16);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 16);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 16);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 16);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/indexIntRelop.m!is_signed_indexIntClass"),
                "context", 17);
  emlrtAddField(*info, emlrt_marshallOut("intmin"), "name", 17);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 17);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmin.m"), "resolved", 17);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 17);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 17);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 17);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 17);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m"),
                "context", 18);
  emlrtAddField(*info, emlrt_marshallOut("eml_index_class"), "name", 18);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 18);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m"),
                "resolved", 18);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 18);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 18);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 18);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 18);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_assert_valid_size_arg.m"),
                "context", 19);
  emlrtAddField(*info, emlrt_marshallOut("intmax"), "name", 19);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 19);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m"), "resolved", 19);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 19);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 19);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 19);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 19);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m"), "context", 20);
  emlrtAddField(*info, emlrt_marshallOut("max"), "name", 20);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 20);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m"), "resolved", 20);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 20);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 20);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 20);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 20);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m"), "context", 21);
  emlrtAddField(*info, emlrt_marshallOut("eml_min_or_max"), "name", 21);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 21);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m"),
                "resolved", 21);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 21);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 21);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 21);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 21);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum"),
                "context", 22);
  emlrtAddField(*info, emlrt_marshallOut("eml_scalar_eg"), "name", 22);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 22);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m"), "resolved",
                22);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 22);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 22);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 22);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 22);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m"), "context",
                23);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.scalarEg"), "name", 23);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 23);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/coder/coder/+coder/+internal/scalarEg.p"),
                "resolved", 23);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731072U), "fileTimeLo", 23);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 23);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 23);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 23);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum"),
                "context", 24);
  emlrtAddField(*info, emlrt_marshallOut("eml_scalexp_alloc"), "name", 24);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 24);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m"),
                "resolved", 24);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 24);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 24);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 24);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 24);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m"),
                "context", 25);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.scalexpAlloc"), "name",
                25);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 25);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/coder/coder/+coder/+internal/scalexpAlloc.p"),
                "resolved", 25);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731072U), "fileTimeLo", 25);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 25);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 25);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 25);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/coder/coder/+coder/+internal/scalexpAlloc.p"),
                "context", 26);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.scalexpAllocNoCheck"),
                "name", 26);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 26);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/coder/coder/+coder/+internal/scalexpAllocNoCheck.p"),
                "resolved", 26);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731072U), "fileTimeLo", 26);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 26);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 26);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 26);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_bin_extremum"),
                "context", 27);
  emlrtAddField(*info, emlrt_marshallOut("eml_index_class"), "name", 27);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 27);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m"),
                "resolved", 27);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 27);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 27);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 27);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 27);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_scalar_bin_extremum"),
                "context", 28);
  emlrtAddField(*info, emlrt_marshallOut("eml_scalar_eg"), "name", 28);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 28);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m"), "resolved",
                28);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 28);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 28);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 28);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 28);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_scalar_bin_extremum"),
                "context", 29);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.isBuiltInNumeric"),
                "name", 29);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 29);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/shared/coder/coder/+coder/+internal/isBuiltInNumeric.m"),
                "resolved", 29);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731101U), "fileTimeLo", 29);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 29);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 29);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 29);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/repmat.m"), "context", 30);
  emlrtAddField(*info, emlrt_marshallOut("eml_int_forloop_overflow_check"),
                "name", 30);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 30);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m"),
                "resolved", 30);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 30);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 30);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 30);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 30);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper"),
                "context", 31);
  emlrtAddField(*info, emlrt_marshallOut("isfi"), "name", 31);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.indexInt"),
                "dominantType", 31);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/fixedpoint/isfi.m"), "resolved", 31);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 31);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 31);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 31);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 31);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/fixedpoint/isfi.m"), "context", 32);
  emlrtAddField(*info, emlrt_marshallOut("isnumerictype"), "name", 32);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 32);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/fixedpoint/isnumerictype.m"), "resolved",
                32);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 32);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 32);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 32);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 32);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper"),
                "context", 33);
  emlrtAddField(*info, emlrt_marshallOut("intmax"), "name", 33);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 33);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m"), "resolved", 33);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 33);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 33);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 33);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 33);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper"),
                "context", 34);
  emlrtAddField(*info, emlrt_marshallOut("intmin"), "name", 34);
  emlrtAddField(*info, emlrt_marshallOut("char"), "dominantType", 34);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmin.m"), "resolved", 34);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731026U), "fileTimeLo", 34);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 34);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 34);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 34);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p"),
                "context", 35);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.matlabCodegenHandle"),
                "name", 35);
  emlrtAddField(*info, emlrt_marshallOut("unknown"), "dominantType", 35);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/matlabCodegenHandle.p"),
                "resolved", 35);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731072U), "fileTimeLo", 35);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 35);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 35);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 35);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p"),
                "context", 36);
  emlrtAddField(*info, emlrt_marshallOut("matlab.system.coder.SystemProp"),
                "name", 36);
  emlrtAddField(*info, emlrt_marshallOut("unknown"), "dominantType", 36);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p"),
                "resolved", 36);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731100U), "fileTimeLo", 36);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 36);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 36);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 36);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p"),
                "context", 37);
  emlrtAddField(*info, emlrt_marshallOut("coder.internal.matlabCodegenHandle"),
                "name", 37);
  emlrtAddField(*info, emlrt_marshallOut("unknown"), "dominantType", 37);
  emlrtAddField(*info, emlrt_marshallOut(
    "[ILXC]$matlabroot$/toolbox/coder/coder/+coder/+internal/matlabCodegenHandle.p"),
                "resolved", 37);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731072U), "fileTimeLo", 37);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 37);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 37);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 37);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p"),
                "context", 38);
  emlrtAddField(*info, emlrt_marshallOut("matlab.system.coder.SystemCore"),
                "name", 38);
  emlrtAddField(*info, emlrt_marshallOut("unknown"), "dominantType", 38);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p"),
                "resolved", 38);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731100U), "fileTimeLo", 38);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 38);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 38);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 38);
  emlrtAddField(*info, emlrt_marshallOut(
    "[C]/home/mainster/CODES_local/matlab_workspace/AddOne.m"), "context", 39);
  emlrtAddField(*info, emlrt_marshallOut("matlab.system.coder.System"), "name",
                39);
  emlrtAddField(*info, emlrt_marshallOut("unknown"), "dominantType", 39);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/System.p"),
                "resolved", 39);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731100U), "fileTimeLo", 39);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 39);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 39);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 39);
  emlrtAddField(*info, emlrt_marshallOut(""), "context", 40);
  emlrtAddField(*info, emlrt_marshallOut("AddOne"), "name", 40);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 40);
  emlrtAddField(*info, emlrt_marshallOut(
    "[C]/home/mainster/CODES_local/matlab_workspace/AddOne.m"), "resolved", 40);
  emlrtAddField(*info, b_emlrt_marshallOut(1459976686U), "fileTimeLo", 40);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 40);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 40);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 40);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p"),
                "context", 41);
  emlrtAddField(*info, emlrt_marshallOut("matlab.system.coder.SystemProp"),
                "name", 41);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 41);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemProp.p"),
                "resolved", 41);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731100U), "fileTimeLo", 41);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 41);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 41);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 41);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p"),
                "context", 42);
  emlrtAddField(*info, emlrt_marshallOut("matlab.system.coder.SystemCore"),
                "name", 42);
  emlrtAddField(*info, emlrt_marshallOut(""), "dominantType", 42);
  emlrtAddField(*info, emlrt_marshallOut(
    "[IXC]$matlabroot$/toolbox/shared/system/coder/+matlab/+system/+coder/SystemCore.p"),
                "resolved", 42);
  emlrtAddField(*info, b_emlrt_marshallOut(1459731100U), "fileTimeLo", 42);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "fileTimeHi", 42);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeLo", 42);
  emlrtAddField(*info, b_emlrt_marshallOut(0U), "mFileTimeHi", 42);
}

static const mxArray *emlrt_marshallOut(const char * u)
{
  const mxArray *y;
  const mxArray *m4;
  y = NULL;
  m4 = emlrtCreateString(u);
  emlrtAssign(&y, m4);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const uint32_T u)
{
  const mxArray *y;
  const mxArray *m5;
  y = NULL;
  m5 = emlrtCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
  *(uint32_T *)mxGetData(m5) = u;
  emlrtAssign(&y, m5);
  return y;
}

static const mxArray *mw__internal__autoInference__fcn(void)
{
  const mxArray *infoCache;
  int8_T Ports_dims_data[4];
  uint32_T RestoreInfo_cgxeChksum[4];
  uint32_T info_VerificationInfo_dlgPrmChksum_chksum[4];
  int32_T i4;
  static int8_T iv14[4] = { 2, 2, 2, 1 };

  static uint32_T uv0[4] = { 1027452918U, 4171408440U, 1052430754U, 305680582U };

  static uint32_T t0_dlgPrmChksum_chksum[4] = { 2110817164U, 1029167598U,
    898437032U, 3113097379U };

  s7UBIGHSehQY1gCsIQWwr5C info_VerificationInfo_propChksum[3];
  static s7UBIGHSehQY1gCsIQWwr5C b_t0_propChksum[3] = { { { 4.57323222E+8,
        1.266902899E+9, 2.062080818E+9, 7.42103504E+8 } }, { { 7.25019261E+8,
        9.350207E+6, 1.380543125E+9, 1.962202275E+9 } }, { { 2.231358449E+9,
        8.46670147E+8, 5.0241063E+8, 1.651697092E+9 } } };

  uint32_T b_t0_dlgPrmChksum_chksum[4];
  uint32_T info_VerificationInfo_postPropOnlyChksum_chksum[4];
  static uint32_T t0_CGOnlyParamChksum_chksum[4] = { 907274058U, 3220786148U,
    779473529U, 2769831971U };

  static uint32_T t0_postPropOnlyChksum_chksum[4] = { 2911221907U, 2308967934U,
    2419390157U, 1906300239U };

  char_T info_slVer[3];
  static char_T cv12[3] = { '8', '.', '5' };

  const mxArray *y;
  const mxArray *b_y;
  const mxArray *c_y;
  const mxArray *d_y;
  const mxArray *e_y;
  const mxArray *m6;
  int32_T u_sizes[2];
  int8_T u_data[4];
  const mxArray *f_y;
  real_T *pData;
  int32_T i;
  const mxArray *g_y;
  const mxArray *h_y;
  const mxArray *i_y;
  const mxArray *j_y;
  int32_T iv15[2];
  const mxArray *k_y;
  static const int32_T iv16[2] = { 1, 0 };

  const mxArray *l_y;
  const mxArray *m_y;
  const mxArray *n_y;
  static const int32_T iv17[2] = { 1, 0 };

  const mxArray *o_y;
  const mxArray *p_y;
  const mxArray *q_y;
  const mxArray *r_y;
  const mxArray *s_y;
  int32_T b_u_sizes[2];
  const mxArray *t_y;
  const mxArray *u_y;
  const mxArray *v_y;
  static const int32_T iv18[2] = { 1, 4 };

  const mxArray *w_y;
  const mxArray *x_y;
  const mxArray *y_y;
  static const int32_T iv19[2] = { 1, 4 };

  s7UBIGHSehQY1gCsIQWwr5C u[3];
  const mxArray *ab_y;
  const s7UBIGHSehQY1gCsIQWwr5C *r0;
  real_T b_u[4];
  const mxArray *bb_y;
  static const int32_T iv20[2] = { 1, 4 };

  const mxArray *cb_y;
  const mxArray *db_y;
  static const int32_T iv21[2] = { 1, 4 };

  const mxArray *eb_y;
  const mxArray *fb_y;
  static const int32_T iv22[2] = { 1, 4 };

  char_T c_u[3];
  const mxArray *gb_y;
  static const int32_T iv23[2] = { 1, 3 };

  infoCache = NULL;
  for (i4 = 0; i4 < 4; i4++) {
    Ports_dims_data[i4] = iv14[i4];
    RestoreInfo_cgxeChksum[i4] = uv0[i4];
    info_VerificationInfo_dlgPrmChksum_chksum[i4] = t0_dlgPrmChksum_chksum[i4];
  }

  for (i4 = 0; i4 < 3; i4++) {
    info_VerificationInfo_propChksum[i4] = b_t0_propChksum[i4];
  }

  for (i4 = 0; i4 < 4; i4++) {
    b_t0_dlgPrmChksum_chksum[i4] = t0_CGOnlyParamChksum_chksum[i4];
    info_VerificationInfo_postPropOnlyChksum_chksum[i4] =
      t0_postPropOnlyChksum_chksum[i4];
  }

  for (i4 = 0; i4 < 3; i4++) {
    info_slVer[i4] = cv12[i4];
  }

  y = NULL;
  emlrtAssign(&y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  b_y = NULL;
  emlrtAssign(&b_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  c_y = NULL;
  emlrtAssign(&c_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  d_y = NULL;
  emlrtAssign(&d_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  e_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&e_y, m6);
  emlrtAddField(d_y, e_y, "dimModes", 0);
  u_sizes[0] = 1;
  u_sizes[1] = 4;
  for (i4 = 0; i4 < 4; i4++) {
    u_data[i4] = Ports_dims_data[i4];
  }

  f_y = NULL;
  m6 = emlrtCreateNumericArray(2, u_sizes, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  i4 = 0;
  for (i = 0; i < u_sizes[1]; i++) {
    pData[i4] = (real_T)u_data[u_sizes[0] * i];
    i4++;
  }

  emlrtAssign(&f_y, m6);
  emlrtAddField(d_y, f_y, "dims", 0);
  g_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&g_y, m6);
  emlrtAddField(d_y, g_y, "dType", 0);
  h_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&h_y, m6);
  emlrtAddField(d_y, h_y, "complexity", 0);
  i_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&i_y, m6);
  emlrtAddField(d_y, i_y, "outputBuiltInDTEqUsed", 0);
  emlrtAddField(c_y, d_y, "Ports", 0);
  j_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 - i4;
  }

  emlrtAssign(&j_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  emlrtAddField(j_y, NULL, "names", 0);
  emlrtAddField(j_y, NULL, "dims", 0);
  emlrtAddField(j_y, NULL, "dType", 0);
  emlrtAddField(j_y, NULL, "complexity", 0);
  emlrtAddField(c_y, j_y, "dWork", 0);
  k_y = NULL;
  m6 = emlrtCreateCharArray(2, iv16);
  emlrtAssign(&k_y, m6);
  emlrtAddField(c_y, k_y, "objTypeName", 0);
  l_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&l_y, m6);
  emlrtAddField(c_y, l_y, "objTypeSize", 0);
  m_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 - i4;
  }

  emlrtAssign(&m_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  emlrtAddField(m_y, NULL, "names", 0);
  emlrtAddField(m_y, NULL, "dims", 0);
  emlrtAddField(m_y, NULL, "dType", 0);
  emlrtAddField(m_y, NULL, "dTypeSize", 0);
  emlrtAddField(m_y, NULL, "dTypeName", 0);
  emlrtAddField(m_y, NULL, "dTypeIndex", 0);
  emlrtAddField(m_y, NULL, "dTypeChksum", 0);
  emlrtAddField(m_y, NULL, "complexity", 0);
  emlrtAddField(c_y, m_y, "persisVarDWork", 0);
  n_y = NULL;
  m6 = emlrtCreateCharArray(2, iv17);
  emlrtAssign(&n_y, m6);
  emlrtAddField(c_y, n_y, "sysObjChksum", 0);
  o_y = NULL;
  emlrtAssign(&o_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  p_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 - i4;
  }

  emlrtAssign(&p_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  emlrtAddField(p_y, NULL, "Index", 0);
  emlrtAddField(p_y, NULL, "DataType", 0);
  emlrtAddField(p_y, NULL, "IsSigned", 0);
  emlrtAddField(p_y, NULL, "MantBits", 0);
  emlrtAddField(p_y, NULL, "FixExp", 0);
  emlrtAddField(p_y, NULL, "Slope", 0);
  emlrtAddField(p_y, NULL, "Bias", 0);
  emlrtAddField(o_y, p_y, "Out", 0);
  q_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 - i4;
  }

  emlrtAssign(&q_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  emlrtAddField(q_y, NULL, "Index", 0);
  emlrtAddField(q_y, NULL, "DataType", 0);
  emlrtAddField(q_y, NULL, "IsSigned", 0);
  emlrtAddField(q_y, NULL, "MantBits", 0);
  emlrtAddField(q_y, NULL, "FixExp", 0);
  emlrtAddField(q_y, NULL, "Slope", 0);
  emlrtAddField(q_y, NULL, "Bias", 0);
  emlrtAddField(o_y, q_y, "DW", 0);
  r_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 - i4;
  }

  emlrtAssign(&r_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  emlrtAddField(r_y, NULL, "Index", 0);
  emlrtAddField(r_y, NULL, "DataType", 0);
  emlrtAddField(r_y, NULL, "IsSigned", 0);
  emlrtAddField(r_y, NULL, "MantBits", 0);
  emlrtAddField(r_y, NULL, "FixExp", 0);
  emlrtAddField(r_y, NULL, "Slope", 0);
  emlrtAddField(r_y, NULL, "Bias", 0);
  emlrtAddField(o_y, r_y, "PersisDW", 0);
  emlrtAddField(c_y, o_y, "mapsInfo", 0);
  s_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&s_y, m6);
  emlrtAddField(c_y, s_y, "objDWorkTypeNameIndex", 0);
  b_u_sizes[0] = 1;
  b_u_sizes[1] = 1;
  t_y = NULL;
  m6 = emlrtCreateNumericArray(2, b_u_sizes, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  pData[0] = 1.0;
  emlrtAssign(&t_y, m6);
  emlrtAddField(c_y, t_y, "inputDFFlagsIndexField", 0);
  u_y = NULL;
  m6 = emlrtCreateDoubleScalar(0.0);
  emlrtAssign(&u_y, m6);
  emlrtAddField(c_y, u_y, "postPropRun", 0);
  emlrtAddField(b_y, c_y, "DispatcherInfo", 0);
  v_y = NULL;
  m6 = emlrtCreateNumericArray(2, iv18, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  for (i = 0; i < 4; i++) {
    pData[i] = (real_T)RestoreInfo_cgxeChksum[i];
  }

  emlrtAssign(&v_y, m6);
  emlrtAddField(b_y, v_y, "cgxeChksum", 0);
  emlrtAddField(y, b_y, "RestoreInfo", 0);
  w_y = NULL;
  emlrtAssign(&w_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  x_y = NULL;
  emlrtAssign(&x_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  y_y = NULL;
  m6 = emlrtCreateNumericArray(2, iv19, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  for (i = 0; i < 4; i++) {
    pData[i] = (real_T)info_VerificationInfo_dlgPrmChksum_chksum[i];
  }

  emlrtAssign(&y_y, m6);
  emlrtAddField(x_y, y_y, "chksum", 0);
  emlrtAddField(w_y, x_y, "dlgPrmChksum", 0);
  for (i4 = 0; i4 < 3; i4++) {
    u[i4] = info_VerificationInfo_propChksum[i4];
  }

  ab_y = NULL;
  for (i4 = 0; i4 < 2; i4++) {
    iv15[i4] = 1 + (i4 << 1);
  }

  emlrtAssign(&ab_y, emlrtCreateStructArray(2, iv15, 0, NULL));
  for (i4 = 0; i4 < 3; i4++) {
    r0 = &u[i4];
    for (i = 0; i < 4; i++) {
      b_u[i] = r0->chksum[i];
    }

    bb_y = NULL;
    m6 = emlrtCreateNumericArray(2, iv20, mxDOUBLE_CLASS, mxREAL);
    pData = (real_T *)mxGetPr(m6);
    for (i = 0; i < 4; i++) {
      pData[i] = b_u[i];
    }

    emlrtAssign(&bb_y, m6);
    emlrtAddField(ab_y, bb_y, "chksum", i4);
  }

  emlrtAddField(w_y, ab_y, "propChksum", 0);
  cb_y = NULL;
  emlrtAssign(&cb_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  db_y = NULL;
  m6 = emlrtCreateNumericArray(2, iv21, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  for (i = 0; i < 4; i++) {
    pData[i] = (real_T)b_t0_dlgPrmChksum_chksum[i];
  }

  emlrtAssign(&db_y, m6);
  emlrtAddField(cb_y, db_y, "chksum", 0);
  emlrtAddField(w_y, cb_y, "CGOnlyParamChksum", 0);
  eb_y = NULL;
  emlrtAssign(&eb_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  fb_y = NULL;
  m6 = emlrtCreateNumericArray(2, iv22, mxDOUBLE_CLASS, mxREAL);
  pData = (real_T *)mxGetPr(m6);
  for (i = 0; i < 4; i++) {
    pData[i] = (real_T)info_VerificationInfo_postPropOnlyChksum_chksum[i];
  }

  emlrtAssign(&fb_y, m6);
  emlrtAddField(eb_y, fb_y, "chksum", 0);
  emlrtAddField(w_y, eb_y, "postPropOnlyChksum", 0);
  emlrtAddField(y, w_y, "VerificationInfo", 0);
  for (i4 = 0; i4 < 3; i4++) {
    c_u[i4] = info_slVer[i4];
  }

  gb_y = NULL;
  m6 = emlrtCreateCharArray(2, iv23);
  emlrtInitCharArrayR2013a(emlrtRootTLSGlobal, 3, m6, &c_u[0]);
  emlrtAssign(&gb_y, m6);
  emlrtAddField(y, gb_y, "slVer", 0);
  emlrtAssign(&infoCache, y);
  return infoCache;
}

static const mxArray *mw__internal__getSimState__fcn
  (InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance)
{
  const mxArray *st;
  const mxArray *y;
  const mxArray *b_y;
  const mxArray *c_y;
  const mxArray *m7;
  const mxArray *d_y;
  st = NULL;
  y = NULL;
  emlrtAssign(&y, emlrtCreateCellMatrix(2, 1));
  b_y = NULL;
  emlrtAssign(&b_y, emlrtCreateStructMatrix(1, 1, 0, NULL));
  c_y = NULL;
  m7 = emlrtCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
  *(int32_T *)mxGetData(m7) = moduleInstance->sysobj.isInitialized;
  emlrtAssign(&c_y, m7);
  emlrtAddField(b_y, c_y, "isInitialized", 0);
  emlrtSetCell(y, 0, b_y);
  d_y = NULL;
  m7 = emlrtCreateLogicalScalar(moduleInstance->sysobj_not_empty);
  emlrtAssign(&d_y, m7);
  emlrtSetCell(y, 1, d_y);
  emlrtAssign(&st, y);
  return st;
}

static AddOne emlrt_marshallIn(const mxArray *b_sysobj, const char_T *identifier)
{
  AddOne y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = b_emlrt_marshallIn(emlrtAlias(b_sysobj), &thisId);
  emlrtDestroyArray(&b_sysobj);
  return y;
}

static AddOne b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  AddOne y;
  emlrtMsgIdentifier thisId;
  static const char * fieldNames[1] = { "isInitialized" };

  thisId.fParent = parentId;
  emlrtCheckStructR2012b(emlrtRootTLSGlobal, parentId, u, 1, fieldNames, 0U, 0);
  thisId.fIdentifier = "isInitialized";
  y.isInitialized = c_emlrt_marshallIn(emlrtAlias(emlrtGetFieldR2013a
    (emlrtRootTLSGlobal, u, 0, "isInitialized")), &thisId);
  emlrtDestroyArray(&u);
  return y;
}

static int32_T c_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  int32_T y;
  y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static boolean_T d_emlrt_marshallIn(const mxArray *b_sysobj_not_empty, const
  char_T *identifier)
{
  boolean_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  y = e_emlrt_marshallIn(emlrtAlias(b_sysobj_not_empty), &thisId);
  emlrtDestroyArray(&b_sysobj_not_empty);
  return y;
}

static boolean_T e_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  boolean_T y;
  y = g_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void mw__internal__setSimState__fcn(InstanceStruct_L4TKA5lKCXheIhQN4RietB
  *moduleInstance, const mxArray *st)
{
  const mxArray *u;
  u = emlrtAlias(st);
  moduleInstance->sysobj = emlrt_marshallIn(emlrtAlias(emlrtGetCell
    (emlrtRootTLSGlobal, "sysobj", u, 0)), "sysobj");
  moduleInstance->sysobj_not_empty = d_emlrt_marshallIn(emlrtAlias(emlrtGetCell
    (emlrtRootTLSGlobal, "sysobj_not_empty", u, 1)), "sysobj_not_empty");
  emlrtDestroyArray(&u);
  emlrtDestroyArray(&st);
}

static const mxArray *message(const mxArray *b, const mxArray *c, emlrtMCInfo
  *location)
{
  const mxArray *pArrays[2];
  const mxArray *m8;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 1, &m8, 2, pArrays, "message",
    true, location);
}

static void error(const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(emlrtRootTLSGlobal, 0, NULL, 1, &pArray, "error", true,
                        location);
}

static int32_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  int32_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "int32", false, 0U, 0);
  ret = *(int32_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static boolean_T g_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  boolean_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "logical", false, 0U,
    0);
  ret = *mxGetLogicals(src);
  emlrtDestroyArray(&src);
  return ret;
}

/* CGXE Glue Code */
static void mdlOutputs_L4TKA5lKCXheIhQN4RietB(SimStruct *S, int_T tid)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  cgxe_mdl_outputs(moduleInstance);
  CGXERT_LEAVE_CHECK();
}

static void mdlInitialize_L4TKA5lKCXheIhQN4RietB(SimStruct *S)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  cgxe_mdl_initialize(moduleInstance);
  CGXERT_LEAVE_CHECK();
}

static void mdlUpdate_L4TKA5lKCXheIhQN4RietB(SimStruct *S, int_T tid)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  cgxe_mdl_update(moduleInstance);
  CGXERT_LEAVE_CHECK();
}

static mxArray* getSimState_L4TKA5lKCXheIhQN4RietB(SimStruct *S)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  mxArray* mxSS;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  mxSS = (mxArray *) mw__internal__getSimState__fcn(moduleInstance);
  CGXERT_LEAVE_CHECK();
  return mxSS;
}

static void setSimState_L4TKA5lKCXheIhQN4RietB(SimStruct *S, const mxArray *ss)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  mw__internal__setSimState__fcn(moduleInstance, emlrtAlias(ss));
  CGXERT_LEAVE_CHECK();
}

static void mdlTerminate_L4TKA5lKCXheIhQN4RietB(SimStruct *S)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)ssGetUserData(S);
  CGXERT_ENTER_CHECK();
  cgxe_mdl_terminate(moduleInstance);
  CGXERT_LEAVE_CHECK();
  free((void *)moduleInstance);
  ssSetUserData(S, NULL);
}

static void mdlStart_L4TKA5lKCXheIhQN4RietB(SimStruct *S)
{
  InstanceStruct_L4TKA5lKCXheIhQN4RietB *moduleInstance;
  moduleInstance = (InstanceStruct_L4TKA5lKCXheIhQN4RietB *)calloc(1, sizeof
    (InstanceStruct_L4TKA5lKCXheIhQN4RietB));
  moduleInstance->S = S;
  ssSetUserData(S, (void *)moduleInstance);
  CGXERT_ENTER_CHECK();
  cgxe_mdl_start(moduleInstance);
  CGXERT_LEAVE_CHECK();

  {
    uint_T options = ssGetOptions(S);
    options |= SS_OPTION_RUNTIME_EXCEPTION_FREE_CODE;
    ssSetOptions(S, options);
  }

  ssSetmdlOutputs(S, mdlOutputs_L4TKA5lKCXheIhQN4RietB);
  ssSetmdlInitializeConditions(S, mdlInitialize_L4TKA5lKCXheIhQN4RietB);
  ssSetmdlUpdate(S, mdlUpdate_L4TKA5lKCXheIhQN4RietB);
  ssSetmdlTerminate(S, mdlTerminate_L4TKA5lKCXheIhQN4RietB);
}

static void mdlProcessParameters_L4TKA5lKCXheIhQN4RietB(SimStruct *S)
{
}

void method_dispatcher_L4TKA5lKCXheIhQN4RietB(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_L4TKA5lKCXheIhQN4RietB(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_L4TKA5lKCXheIhQN4RietB(S);
    break;

   case SS_CALL_MDL_GET_SIM_STATE:
    *((mxArray**) data) = getSimState_L4TKA5lKCXheIhQN4RietB(S);
    break;

   case SS_CALL_MDL_SET_SIM_STATE:
    setSimState_L4TKA5lKCXheIhQN4RietB(S, (const mxArray *) data);
    break;

   default:
    /* Unhandled method */
    /*
       sf_mex_error_message("Stateflow Internal Error:\n"
       "Error calling method dispatcher for module: L4TKA5lKCXheIhQN4RietB.\n"
       "Can't handle method %d.\n", method);
     */
    break;
  }
}

int autoInfer_dispatcher_L4TKA5lKCXheIhQN4RietB(mxArray* plhs[], const char
  * commandName)
{
  if (strcmp(commandName, "NameResolution") == 0) {
    plhs[0] = (mxArray*) mw__internal__name__resolution__fcn();
    return 1;
  }

  if (strcmp(commandName, "AutoInfer") == 0) {
    plhs[0] = (mxArray*) mw__internal__autoInference__fcn();
    return 1;
  }

  return 0;
}

mxArray *cgxe_L4TKA5lKCXheIhQN4RietB_BuildInfoUpdate(void)
{
  mxArray * mxBIArgs;
  mxArray * elem_1;
  mxArray * elem_2;
  mxArray * elem_3;
  mxArray * elem_4;
  mxArray * elem_5;
  mxArray * elem_6;
  mxArray * elem_7;
  mxArray * elem_8;
  mxArray * elem_9;
  mxBIArgs = mxCreateCellMatrix(1,3);
  elem_1 = mxCreateCellMatrix(1,6);
  elem_2 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,0,elem_2);
  elem_3 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,1,elem_3);
  elem_4 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,2,elem_4);
  elem_5 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,3,elem_5);
  elem_6 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,4,elem_6);
  elem_7 = mxCreateCellMatrix(0,0);
  mxSetCell(elem_1,5,elem_7);
  mxSetCell(mxBIArgs,0,elem_1);
  elem_8 = mxCreateCellMatrix(1,0);
  mxSetCell(mxBIArgs,1,elem_8);
  elem_9 = mxCreateCellMatrix(1,0);
  mxSetCell(mxBIArgs,2,elem_9);
  return mxBIArgs;
}
