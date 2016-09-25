#ifndef __spring_ball_sfun_c1_h__
#define __spring_ball_sfun_c1_h__
#include "sfc_sf.h"
#include "sfc_mex.h"
extern void sf_spring_ball_sfun_c1_get_check_sum(mxArray *plhs[]);
extern void spring_ball_sfun_c1_registry(SimStruct *simStructPtr);
extern void spring_ball_sfun_c1_sizes_registry(SimStruct *simStructPtr);
extern void spring_ball_sfun_c1(void);
typedef struct SFspring_ball_sfun_c1StateStruct{
  unsigned int is_active_spring_ball_sfun_c1 : 1;
  unsigned int is_spring_ball_sfun_c1 : 2;
} SFspring_ball_sfun_c1StateStruct;

typedef struct SFspring_ball_sfun_c1_InstanceStruct {

  SFspring_ball_sfun_c1StateStruct State;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  unsigned int chartNumber;
  unsigned int instanceNumber;
} SFspring_ball_sfun_c1InstanceStruct;

#endif

