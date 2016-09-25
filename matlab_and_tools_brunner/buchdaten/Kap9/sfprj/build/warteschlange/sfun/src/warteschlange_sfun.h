/*
 *
 * Stateflow code generation for machine:
 *    warteschlange
 * 
 * Target Name                          : sfun
 * Model Version                        : 1.188
 * Stateflow Version                    : 4.0.0.12.07.1.000000
 * Date of code generation              : 01-Sep-2001 08:19:32
 *
 */
	
#ifndef __warteschlange_sfun_h__
#define __warteschlange_sfun_h__
#include <string.h>
#include <stdlib.h>
#include <math.h>
#define S_FUNCTION_NAME sf_sfun
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "tmwtypes.h"
#include "sfcdebug.h"

#ifndef min
#define min(a,b)    (((a) < (b)) ? (a) : (b))
#endif
#ifndef max
#define max(a,b)    (((a) > (b)) ? (a) : (b))
#endif


#define SF_DEBUG_MACHINE_CALL(v1,v2,v3) sf_debug_call(_warteschlangeMachineNumber_,UNREASONABLE_NUMBER,UNREASONABLE_NUMBER,MACHINE_OBJECT,v1,v2,v3,_sfEvent_,-1,NULL,_sfTime_,1)
extern unsigned int _warteschlangeMachineNumber_;
/* Enumeration of all the events used in this machine */
#define CALL_EVENT (-1)
 
extern int8_T _sfEvent_;
 
#ifndef _sfTime_
/* Stateflow time variable */
extern real_T _sfTime_;
#endif

#endif


