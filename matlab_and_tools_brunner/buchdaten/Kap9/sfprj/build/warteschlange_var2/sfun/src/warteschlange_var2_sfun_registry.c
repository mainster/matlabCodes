#include "warteschlange_var2_sfun.h"
#include "sfcdebug.h"
#define PROCESS_MEX_SFUNCTION_CMD_LINE_CALL
unsigned int sf_process_check_sum_call( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  extern unsigned int sf_warteschlange_var2_process_check_sum_call( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] );

  if(sf_warteschlange_var2_process_check_sum_call(nlhs,plhs,nrhs,prhs)) return 1;
  return 0;
}
extern unsigned int sf_debug_api( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] );
static unsigned int ProcessMexSfunctionCmdLineCall(int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
  if(sf_debug_api(nlhs,plhs,nrhs,prhs)) return 1;
  if(sf_process_check_sum_call(nlhs,plhs,nrhs,prhs)) return 1;
  return 0;
}
static unsigned int sfMachineGlobalTerminatorCallable = 0;
static unsigned int sfMachineGlobalInitializerCallable = 1;
extern unsigned int warteschlange_var2_registry(SimStruct *S,char *chartName,int initializeFlag);
unsigned int sf_machine_global_registry(SimStruct *simstructPtr, char *chartName, int initializeFlag)
{
  if(warteschlange_var2_registry(simstructPtr,chartName,initializeFlag)) return 1;
  return 0;
}
extern unsigned int warteschlange_var2_sizes_registry(SimStruct *S,char *chartName);
unsigned int sf_machine_global_sizes_registry(SimStruct *simstructPtr, char *chartName)
{
  if(warteschlange_var2_sizes_registry(simstructPtr,chartName)) return 1;
  return 0;
}
extern void warteschlange_var2_terminator(void);
void sf_machine_global_terminator(void)
{
  if(sfMachineGlobalTerminatorCallable) {
    sfMachineGlobalTerminatorCallable = 0;
    sfMachineGlobalInitializerCallable = 1;
    warteschlange_var2_terminator();
    sf_debug_terminate();
  }
  return;
}
extern void warteschlange_var2_initializer(void);
void sf_machine_global_initializer(void)
{
  if(sfMachineGlobalInitializerCallable) {
    sfMachineGlobalInitializerCallable = 0;
    sfMachineGlobalTerminatorCallable =1;
    warteschlange_var2_initializer();
  }
  return;
}
#include "simulink.c"

