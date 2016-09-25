/* Include files */

#include "signalflussalgebra_cgxe.h"
#include "m_L4TKA5lKCXheIhQN4RietB.h"

static unsigned int cgxeModelInitialized = 0;
emlrtContext emlrtContextGlobal = { true, true, EMLRT_VERSION_INFO, NULL, "",
  NULL, false, { 0, 0, 0, 0 }, NULL };

void *emlrtRootTLSGlobal = NULL;
char cgxeRtErrBuf[4096];

/* CGXE Glue Code */
void cgxe_signalflussalgebra_initializer(void)
{
  if (cgxeModelInitialized == 0) {
    cgxeModelInitialized = 1;
    emlrtRootTLSGlobal = NULL;
    emlrtCreateSimulinkRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
      false, 0);
  }
}

void cgxe_signalflussalgebra_terminator(void)
{
  if (cgxeModelInitialized != 0) {
    cgxeModelInitialized = 0;
    emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
    emlrtRootTLSGlobal = NULL;
  }
}

unsigned int cgxe_signalflussalgebra_method_dispatcher(SimStruct* S, int_T
  method, void* data)
{
  if (ssGetChecksum0(S) == 1027452918 &&
      ssGetChecksum1(S) == 4171408440 &&
      ssGetChecksum2(S) == 1052430754 &&
      ssGetChecksum3(S) == 305680582) {
    method_dispatcher_L4TKA5lKCXheIhQN4RietB(S, method, data);
    return 1;
  }

  return 0;
}

int cgxe_signalflussalgebra_autoInfer_dispatcher(const mxArray* prhs, mxArray*
  lhs[], const char* commandName)
{
  char sid[64];
  mxGetString(prhs,sid, sizeof(sid)/sizeof(char));
  sid[(sizeof(sid)/sizeof(char)-1)] = '\0';
  if (strcmp(sid, "signalflussalgebra:4") == 0 ) {
    return autoInfer_dispatcher_L4TKA5lKCXheIhQN4RietB(lhs, commandName);
  }

  return 0;
}
