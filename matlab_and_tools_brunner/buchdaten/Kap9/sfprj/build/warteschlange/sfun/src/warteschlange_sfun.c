#define IN_SF_MACHINE_SOURCE            1
#include "warteschlange_sfun.h"
#include "warteschlange_sfun_c1.h"

int8_T _sfEvent_=0;
unsigned int _warteschlangeMachineNumber_=UNREASONABLE_NUMBER;
unsigned int sf_warteschlange_process_check_sum_call( int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
#ifdef MATLAB_MEX_FILE
  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) ) return 0;
  
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if(strcmp(commandName,"sf_get_check_sum")) return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if(nrhs>1 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if(!strcmp(commandName,"machine")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3135679143U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(649377168U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2527455608U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3148787354U);
    }else if(!strcmp(commandName,"makefile")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1023534188U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2662175753U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(4077751658U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2055117310U);
    }else if(nrhs==3 && !strcmp(commandName,"chart")) {
      unsigned int chartFileNumber;
      chartFileNumber = (unsigned int)mxGetScalar(prhs[2]);
      switch(chartFileNumber) {
       case 1:
        {
          extern void sf_warteschlange_sfun_c1_get_check_sum(mxArray *plhs[]);
          sf_warteschlange_sfun_c1_get_check_sum(plhs);
          break;
        }

       default:
        ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
        ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
      }
    }else if(!strcmp(commandName,"target")) {
      ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1523190960U);
      ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1621465013U);
      ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1299527585U);
      ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1741449626U);
    }else {
      return 0;
    }
  } else{
    ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3810158515U);
    ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(385083547U);
    ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3924219799U);
    ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1284421285U);
  }
  return 1;
#else
  return 0;
#endif
}

real_T _sfTime_;

void warteschlange_initializer( void )
{
  
  _sfEvent_ = CALL_EVENT;

  _warteschlangeMachineNumber_ = sf_debug_initialize_machine("warteschlange","sfun",0,1,0,0,0);
  sf_debug_set_machine_event_thresholds(_warteschlangeMachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(_warteschlangeMachineNumber_,0);
}

unsigned int warteschlange_registry(SimStruct *simstructPtr,char *chartName, int initializeFlag)
{
  if(!strcmp_ignore_ws(chartName,"warteschlange/Warteschlan- gensystem/ SFunction ")) {
    warteschlange_sfun_c1_registry(simstructPtr);
    return 1;
  }
  return 0;
}
unsigned int warteschlange_sizes_registry(SimStruct *simstructPtr,char *chartName)
{
  if(!strcmp_ignore_ws(chartName,"warteschlange/Warteschlan- gensystem/ SFunction ")) {
    warteschlange_sfun_c1_sizes_registry(simstructPtr);
    return 1;
  }
  return 0;
}
void warteschlange_terminator(void)
{
}

