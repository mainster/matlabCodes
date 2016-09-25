#ifndef __signalflussalgebra_cgxe_h__
#define __signalflussalgebra_cgxe_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "emlrt.h"
#include "covrt.h"
#include "cgxert.h"
#define rtInf                          (mxGetInf())
#define rtMinusInf                     (-(mxGetInf()))
#define rtNaN                          (mxGetNaN())
#define rtIsNaN(X)                     ((int)mxIsNaN(X))
#define rtIsInf(X)                     ((int)mxIsInf(X))

extern void *emlrtRootTLSGlobal;
extern char cgxeRtErrBuf[4096];

#define CGXERT_ENTER_CHECK() \
{ \
 jmp_buf emlrtJBEnviron; \
 emlrtSetJmpBuf(emlrtRootTLSGlobal, &emlrtJBEnviron); \
 switch (setjmp(emlrtJBEnviron)) { \
 case 0:
#define CGXERT_LEAVE_CHECK() \
 break; \
 case 1: \
 emlrtRetrieveRunTimeError(emlrtRootTLSGlobal, cgxeRtErrBuf, sizeof(cgxeRtErrBuf)); \
 S->errorStatus.str = cgxeRtErrBuf; \
 case 2: \
 break; \
 default: \
 break; \
 } \
}

extern unsigned int cgxe_signalflussalgebra_method_dispatcher(SimStruct* S,
  int_T method, void* data);
extern int cgxe_signalflussalgebra_autoInfer_dispatcher(const mxArray* prhs,
  mxArray* lhs[], const char* commandName);
extern void cgxe_signalflussalgebra_initializer(void);
extern void cgxe_signalflussalgebra_terminator(void);

#endif
