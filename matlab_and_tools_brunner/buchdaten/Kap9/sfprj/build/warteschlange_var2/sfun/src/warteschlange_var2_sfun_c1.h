#ifndef __warteschlange_var2_sfun_c1_h__
#define __warteschlange_var2_sfun_c1_h__
#include "sfc_sf.h"
#include "sfc_mex.h"
extern void sf_warteschlange_var2_sfun_c1_get_check_sum(mxArray *plhs[]);
extern void warteschlange_var2_sfun_c1_registry(SimStruct *simStructPtr);
extern void warteschlange_var2_sfun_c1_sizes_registry(SimStruct *simStructPtr);
extern void warteschlange_var2_sfun_c1(void);
typedef struct SFwarteschlange_var2_sfun_c1LocalDataStruct{
  int16_T c1_d5_iz;
  int16_T c1_d1_az;
  int16_T c1_d6_sz;
  int16_T c1_d2_bz;
  real_T c1_d4_imin;
  real_T c1_d3_imax;
} SFwarteschlange_var2_sfun_c1LocalDataStruct;

typedef struct SFwarteschlange_var2_sfun_c1ConstantDataStruct{
  real_T c1_d9_smin;
  real_T c1_d8_smax;
} SFwarteschlange_var2_sfun_c1ConstantDataStruct;
typedef struct SFwarteschlange_var2_sfun_c1StateStruct{
  unsigned int is_active_warteschlange_var2_sfun_c1 : 1;
  unsigned int is_warteschlange_var2_sfun_c1 : 1;
  unsigned int is_active_c1_s2_Kunden_prozess : 1;
  unsigned int is_c1_s2_Kunden_prozess : 1;
  unsigned int is_active_c1_s4_Server_prozess : 1;
  unsigned int is_c1_s4_Server_prozess : 2;
} SFwarteschlange_var2_sfun_c1StateStruct;

typedef struct SFwarteschlange_var2_sfun_c1_InstanceStruct {

  SFwarteschlange_var2_sfun_c1LocalDataStruct LocalData;
  SFwarteschlange_var2_sfun_c1ConstantDataStruct ConstantData;
  SFwarteschlange_var2_sfun_c1StateStruct State;
  SimStruct *S;
  ChartInfoStruct chartInfo;
  unsigned int chartNumber;
  unsigned int instanceNumber;
} SFwarteschlange_var2_sfun_c1InstanceStruct;

#endif

