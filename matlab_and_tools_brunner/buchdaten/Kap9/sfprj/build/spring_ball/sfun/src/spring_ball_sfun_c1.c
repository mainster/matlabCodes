#include "spring_ball_sfun.h"
#include "spring_ball_sfun_c1.h"

#define mexPrintf                       sf_mex_printf
#ifdef printf
#undef printf
#endif
#define printf                          sf_mex_printf
#define SF_DEBUG_SET_DATA_VALUE_PTR(v1,v2)\
  sf_debug_set_instance_data_value_ptr(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,v1,(void *)(v2));
#define SF_DEBUG_UNSET_DATA_VALUE_PTR(v1)\
  sf_debug_unset_instance_data_value_ptr(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,v1);
#define SF_DEBUG_DATA_RANGE_CHECK_MIN_MAX(dVal,dNum,dMin,dMax)\
  sf_debug_data_range_error_wrapper_min_max(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMin,(double)dMax)
#define SF_DEBUG_DATA_RANGE_CHECK_MIN(dVal,dNum,dMin)\
  sf_debug_data_range_error_wrapper_min(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMin)
#define SF_DEBUG_DATA_RANGE_CHECK_MAX(dVal,dNum,dMax)\
  sf_debug_data_range_error_wrapper_max(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMax)
#define SF_DEBUG_ARRAY_BOUNDS_CHECK(v1,v2,v3,v4,v5) \
  sf_debug_data_array_bounds_error_check(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),(v2),(v3),(v4),(v5))
#define SF_DEBUG_CAST_TO_UINT8(v1) \
  sf_debug_cast_to_uint8_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_UINT16(v1) \
  sf_debug_cast_to_uint16_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_UINT32(v1) \
  sf_debug_cast_to_uint32_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT8(v1) \
  sf_debug_cast_to_int8_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT16(v1) \
  sf_debug_cast_to_int16_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT32(v1) \
  sf_debug_cast_to_int32_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_SINGLE(v1) \
  sf_debug_cast_to_real32_T(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_TRANSITION_CONFLICT(v1,v2) sf_debug_transition_conflict_error(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   v1,v2)
#define SF_DEBUG_CHART_CALL(v1,v2,v3) sf_debug_call(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   CHART_OBJECT,v1,v2,v3,_sfEvent_,\
   0,NULL,_sfTime_,1)
#define SF_DEBUG_CHART_COVERAGE_CALL(v1,v2,v3,v4) sf_debug_call(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   CHART_OBJECT,v1,v2,v3,_sfEvent_,\
   v4,NULL,_sfTime_,1)
#define SF_DEBUG_STATE_TEMPORAL_THRESHOLD(v1,v2,v4) sf_debug_temporal_threshold(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (unsigned int)(v1),(v2),STATE_OBJECT,(v4))
#define SF_DEBUG_TRANS_TEMPORAL_THRESHOLD(v1,v2,v4) sf_debug_temporal_threshold(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (unsigned int)(v1),(v2),TRANSITION_OBJECT,(v4))
#define CV_EVAL(v1,v2,v3,v4) cv_eval_point(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),(v2),(v3),(boolean_T)(v4))
#define CV_TRANSITION_EVAL(v1,v2) cv_eval_point(_spring_ballMachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   TRANSITION_OBJECT,(v1),0,(boolean_T)(v2))
#define IN_NO_ACTIVE_CHILD              (0)
#define IN_c1_s1_Ball_fallend           1
#define IN_c1_s2_Ball_steigend          2
#define event_c1_e4_Aufprall            0
#define event_c1_e5_Enable              1
#define event_c1_e6_Umkehr              2
static SFspring_ball_sfun_c1InstanceStruct chartInstance;
#define InputData_c1_d1_velocity        (*(real_T *)(ssGetInputPortSignalPtrs(chartInstance.S,0)[0]))
#define c1_e4_Aufprall                  (*(real_T *)(ssGetInputPortSignalPtrs(chartInstance.S,1)[0]))
#define c1_e5_Enable                    (*(real_T *)(ssGetInputPortSignalPtrs(chartInstance.S,1)[1]))
#define c1_e6_Umkehr                    (*(real_T *)(ssGetInputPortSignalPtrs(chartInstance.S,1)[2]))
#define OutputData_c1_d2_Reset          (((real_T *)(ssGetOutputPortSignal(chartInstance.S,1)))[0])
#define OutputData_c1_d3_v0             (((real_T *)(ssGetOutputPortSignal(chartInstance.S,2)))[0])
void spring_ball_sfun_c1(void);
static void enter_atomic_c1_s1_Ball_fallend(void);
static void broadcast_c1_e4_Aufprall(void);
static void broadcast_c1_e5_Enable(void);
static void broadcast_c1_e6_Umkehr(void);

void spring_ball_sfun_c1(void)
{
  SF_DEBUG_CHART_CALL(CHART_OBJECT,CHART_ENTER_DURING_FUNCTION_TAG,0);
  if(chartInstance.State.is_active_spring_ball_sfun_c1==0) {
    SF_DEBUG_CHART_CALL(CHART_OBJECT,CHART_ENTER_ENTRY_FUNCTION_TAG,0);
    chartInstance.State.is_active_spring_ball_sfun_c1=1;
    SF_DEBUG_CHART_CALL(CHART_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,2);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,2);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,2);
    enter_atomic_c1_s1_Ball_fallend();
  } else {
    switch(CV_EVAL(CHART_OBJECT,0,0,chartInstance.State.is_spring_ball_sfun_c1)) {
     case IN_NO_ACTIVE_CHILD:
      break;
     case IN_c1_s1_Ball_fallend:
      SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,1);
      SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,1,0);
      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,1);
      if(CV_TRANSITION_EVAL(1,(_sfEvent_ == event_c1_e4_Aufprall) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,1,0)))) {
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,1);
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,1);
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,1);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_EXIT_FUNCTION_TAG,1);
        SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_EXIT_COVERAGE_TAG,1,0);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_INACTIVE_TAG,1);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,0);
        SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,2);
        chartInstance.State.is_spring_ball_sfun_c1=IN_c1_s2_Ball_steigend;
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,0);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_BEFORE_ENTRY_ACTION_TAG,0);
        OutputData_c1_d3_v0 = (real_T ) - InputData_c1_d1_velocity;
        SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,0);
        OutputData_c1_d2_Reset = (real_T )1;
        SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,1);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_AFTER_ENTRY_ACTION_TAG,0);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
      }
      SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
      break;
     case IN_c1_s2_Ball_steigend:
      SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,0);
      SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,0,0);
      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,0);
      if(CV_TRANSITION_EVAL(0,(_sfEvent_ == event_c1_e6_Umkehr) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,0,0)))) {
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,0);
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,0);
        SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,0);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_EXIT_FUNCTION_TAG,0);
        SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_EXIT_COVERAGE_TAG,0,0);
        chartInstance.State.is_spring_ball_sfun_c1=IN_NO_ACTIVE_CHILD;
        SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_INACTIVE_TAG,0);
        SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
        enter_atomic_c1_s1_Ball_fallend();
      }
      SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
      break;
    }
  }
  SF_DEBUG_CHART_CALL(CHART_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
}

static void enter_atomic_c1_s1_Ball_fallend(void)
{
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,1);
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,2);
  chartInstance.State.is_spring_ball_sfun_c1=IN_c1_s1_Ball_fallend;
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,1);
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_BEFORE_ENTRY_ACTION_TAG,1);
  OutputData_c1_d2_Reset = (real_T )0;
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,0);
  OutputData_c1_d3_v0 = (real_T )0;
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,1);
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_AFTER_ENTRY_ACTION_TAG,1);
  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
}

static void broadcast_c1_e4_Aufprall(void)
{
  int8_T previousEvent;
  previousEvent=_sfEvent_;
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_ENTER_BROADCAST_FUNCTION_TAG,event_c1_e4_Aufprall);
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_BEFORE_BROADCAST_TAG,event_c1_e4_Aufprall);
  _sfEvent_=event_c1_e4_Aufprall;
  sf_mex_listen_for_ctrl_c();
  spring_ball_sfun_c1();
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_AFTER_BROADCAST_TAG,event_c1_e4_Aufprall);
  _sfEvent_=previousEvent;
}

static void broadcast_c1_e5_Enable(void)
{
  int8_T previousEvent;
  previousEvent=_sfEvent_;
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_ENTER_BROADCAST_FUNCTION_TAG,event_c1_e5_Enable);
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_BEFORE_BROADCAST_TAG,event_c1_e5_Enable);
  _sfEvent_=event_c1_e5_Enable;
  sf_mex_listen_for_ctrl_c();
  spring_ball_sfun_c1();
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_AFTER_BROADCAST_TAG,event_c1_e5_Enable);
  _sfEvent_=previousEvent;
}

static void broadcast_c1_e6_Umkehr(void)
{
  int8_T previousEvent;
  previousEvent=_sfEvent_;
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_ENTER_BROADCAST_FUNCTION_TAG,event_c1_e6_Umkehr);
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_BEFORE_BROADCAST_TAG,event_c1_e6_Umkehr);
  _sfEvent_=event_c1_e6_Umkehr;
  sf_mex_listen_for_ctrl_c();
  spring_ball_sfun_c1();
  SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_AFTER_BROADCAST_TAG,event_c1_e6_Umkehr);
  _sfEvent_=previousEvent;
}

void sf_spring_ball_sfun_c1_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1028406609U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3897277426U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(95883268U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3558537913U);
}

static void initialize_spring_ball_sfun_c1( SimStruct *S)
{
  
  OutputData_c1_d2_Reset = (real_T) 0.00000;
  OutputData_c1_d3_v0 = (real_T) 0.00000;
  
  memset((void*)&(chartInstance.State),0,sizeof(chartInstance.State));

  if(ssIsFirstInitCond(S)) {
    {
      unsigned int chartAlreadyPresent;
      chartAlreadyPresent = sf_debug_initialize_chart(_spring_ballMachineNumber_,
       1,
       2,
       3,
       3,
       3,
       0,
       0,
       0,
       &(chartInstance.chartNumber),
       &(chartInstance.instanceNumber),
       ssGetPath((SimStruct *)S),
       (void *)S);
      if(chartAlreadyPresent==0) {
        
        sf_debug_set_chart_disable_implicit_casting(_spring_ballMachineNumber_,chartInstance.chartNumber,0);
        sf_debug_set_chart_event_thresholds(_spring_ballMachineNumber_,
         chartInstance.chartNumber,
         3,
         3,
         3);

#define SF_DEBUG_SET_DATA_PROPS(dataNumber,dataScope,isInputData,isOutputData,dataType,numDims,dimArray)\
          sf_debug_set_chart_data_props(_spring_ballMachineNumber_,chartInstance.chartNumber,\
           (dataNumber),(dataScope),(isInputData),(isOutputData),\
           (dataType),(numDims),(dimArray))
        SF_DEBUG_SET_DATA_PROPS(1,2,0,1,SF_DOUBLE,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(2,2,0,1,SF_DOUBLE,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(0,1,1,0,SF_DOUBLE,0,NULL);
        sf_debug_set_chart_event_scope(_spring_ballMachineNumber_,chartInstance.chartNumber,0,1);
        sf_debug_set_chart_event_scope(_spring_ballMachineNumber_,chartInstance.chartNumber,1,1);
        sf_debug_set_chart_event_scope(_spring_ballMachineNumber_,chartInstance.chartNumber,2,1);
#define SF_DEBUG_STATE_INFO(v1,v2,v3)\
          sf_debug_set_chart_state_info(_spring_ballMachineNumber_,chartInstance.chartNumber,(v1),(v2),(v3))
        SF_DEBUG_STATE_INFO(1,0,0);
        SF_DEBUG_STATE_INFO(0,0,0);
#define SF_DEBUG_CH_SUBSTATE_INDEX(v1,v2)\
          sf_debug_set_chart_substate_index(_spring_ballMachineNumber_,chartInstance.chartNumber,(v1),(v2))
#define SF_DEBUG_ST_SUBSTATE_INDEX(v1,v2,v3)\
          sf_debug_set_chart_state_substate_index(_spring_ballMachineNumber_,chartInstance.chartNumber,(v1),(v2),(v3))
#define SF_DEBUG_ST_SUBSTATE_COUNT(v1,v2)\
          sf_debug_set_chart_state_substate_count(_spring_ballMachineNumber_,chartInstance.chartNumber,(v1),(v2))
        sf_debug_set_chart_substate_count(_spring_ballMachineNumber_,chartInstance.chartNumber,2);
        sf_debug_set_chart_decomposition(_spring_ballMachineNumber_,chartInstance.chartNumber,0);
        SF_DEBUG_CH_SUBSTATE_INDEX(0,1);
        SF_DEBUG_CH_SUBSTATE_INDEX(1,0);
        SF_DEBUG_ST_SUBSTATE_COUNT(1,0);
        SF_DEBUG_ST_SUBSTATE_COUNT(0,0);
      }
      sf_debug_cv_init_chart(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,2,1,0,0);
      sf_debug_cv_init_state(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,1,0,0,0,0);
      sf_debug_cv_init_state(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,0,0,0,0,0);

      sf_debug_cv_init_trans(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,2,0);
      sf_debug_cv_init_trans(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,1,1);
      sf_debug_cv_init_trans(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,0,1);
#define SF_DEBUG_STATE_COV_WTS(v1,v2,v3,v4)\
        sf_debug_set_instance_state_coverage_weights(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,(v1),(v2),(v3),(v4))
#define SF_DEBUG_STATE_COV_MAPS(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10) \
        sf_debug_set_chart_state_coverage_maps(_spring_ballMachineNumber_,chartInstance.chartNumber,\
         (v1),(v2),(v3),(v4),(v5),(v6),(v7),(v8),(v9),(v10))
#define SF_DEBUG_TRANS_COV_WTS(v1,v2,v3,v4,v5) \
        sf_debug_set_instance_transition_coverage_weights(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,\
         (v1),(v2),(v3),(v4),(v5))
#define SF_DEBUG_TRANS_COV_MAPS(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13) \
        sf_debug_set_chart_transition_coverage_maps(_spring_ballMachineNumber_,chartInstance.chartNumber,\
         (v1),\
         (v2),(v3),(v4),\
         (v5),(v6),(v7),\
         (v8),(v9),(v10),\
         (v11),(v12),(v13))
      SF_DEBUG_STATE_COV_WTS(1,3,1,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {20,29,0};
        static unsigned int sEndEntryMap[] = {28,34,0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};
        static unsigned int sStartExitMap[] = {0};
        static unsigned int sEndExitMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(1,
         3,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         1,&(sStartExitMap[0]),&(sEndExitMap[0]));
      }
      SF_DEBUG_STATE_COV_WTS(0,3,1,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {22,36,0};
        static unsigned int sEndEntryMap[] = {35,44,0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};
        static unsigned int sStartExitMap[] = {0};
        static unsigned int sEndExitMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(0,
         3,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         1,&(sStartExitMap[0]),&(sEndExitMap[0]));
      }
      SF_DEBUG_TRANS_COV_WTS(2,0,0,0,0);
      if(chartAlreadyPresent==0)
      {
        SF_DEBUG_TRANS_COV_MAPS(2,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(1,0,1,0,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {0};
        static unsigned int sEndGuardMap[] = {8};
        SF_DEBUG_TRANS_COV_MAPS(1,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(0,0,1,0,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {0};
        static unsigned int sEndGuardMap[] = {6};
        SF_DEBUG_TRANS_COV_MAPS(0,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_SET_DATA_VALUE_PTR(1,(void *)(&OutputData_c1_d2_Reset));
      SF_DEBUG_SET_DATA_VALUE_PTR(2,(void *)(&OutputData_c1_d3_v0));
      SF_DEBUG_SET_DATA_VALUE_PTR(0,(void *)(&InputData_c1_d1_velocity));
    }
  }else{
    sf_debug_reset_current_state_configuration(_spring_ballMachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber);
  }
  chartInstance.chartInfo.chartInitialized = 1;
}

void spring_ball_sfun_c1_sizes_registry(SimStruct *S)
{
  ssSetNumInputPorts((SimStruct *)S, 2);
  ssSetInputPortDataType((SimStruct *)S,0,SS_DOUBLE);
  ssSetInputPortWidth((SimStruct *)S,0,1);
  ssSetInputPortDirectFeedThrough((SimStruct *)S,0,1);
  ssSetInputPortDataType((SimStruct *)S,1,SS_DOUBLE);
  ssSetInputPortWidth((SimStruct *)S,1,3);
  ssSetInputPortDirectFeedThrough((SimStruct *)S,1,1);
  ssSetNumOutputPorts((SimStruct *)S, 3);
  ssSetOutputPortDataType((SimStruct *)S,0,SS_DOUBLE);
  ssSetOutputPortWidth((SimStruct *)S,0,1);
  ssSetOutputPortDataType((SimStruct *)S,1,SS_DOUBLE);
  ssSetOutputPortWidth((SimStruct *)S,1,1);
  ssSetOutputPortDataType((SimStruct *)S,2,SS_DOUBLE);
  ssSetOutputPortWidth((SimStruct *)S,2,1);
}

void terminate_spring_ball_sfun_c1(SimStruct *S)
{
}
static void mdlRTW_spring_ball_sfun_c1(SimStruct *S)
{
  if (!ssWriteRTWWorkVect(S, "PWork", 1,"ChartInstance", 1)) {
    return;
  }
}

void sf_spring_ball_sfun_c1( void *);
void spring_ball_sfun_c1_registry(SimStruct *S)
{
  chartInstance.chartInfo.chartInstance = NULL;
  chartInstance.chartInfo.chartInitialized = 0;
  chartInstance.chartInfo.sFunctionGateway = sf_spring_ball_sfun_c1;
  chartInstance.chartInfo.initializeChart = initialize_spring_ball_sfun_c1;
  chartInstance.chartInfo.terminateChart = terminate_spring_ball_sfun_c1;
  chartInstance.chartInfo.mdlRTW = mdlRTW_spring_ball_sfun_c1;
  chartInstance.chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance.chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance.chartInfo.storeCurrentConfiguration = NULL;
  chartInstance.chartInfo.sampleTime = INHERITED_SAMPLE_TIME;
  chartInstance.S = S;
  ssSetUserData((SimStruct *)S,(void *)(&(chartInstance.chartInfo)));
  ssSetSampleTime((SimStruct *)S, 0, chartInstance.chartInfo.sampleTime);
  if (chartInstance.chartInfo.sampleTime == INHERITED_SAMPLE_TIME) {
    ssSetOffsetTime((SimStruct *)S, 0, FIXED_IN_MINOR_STEP_OFFSET);
  } else if (chartInstance.chartInfo.sampleTime == CONTINUOUS_SAMPLE_TIME) {
    ssSetOffsetTime((SimStruct *)S, 0, 0.0);
  }
  ssSetCallSystemOutput((SimStruct *)S,0);
}

void sf_spring_ball_sfun_c1( void *chartInstanceVoidPtr)
{
  
  int previousEvent;
  previousEvent = _sfEvent_;

  _sfTime_ = ssGetT(chartInstance.S);

  if (c1_e4_Aufprall==1.0) {
    broadcast_c1_e4_Aufprall();
  }
  if (c1_e5_Enable!=0.0) {
    broadcast_c1_e5_Enable();
  }
  if (c1_e6_Umkehr==1.0) {
    broadcast_c1_e6_Umkehr();
  }
}

