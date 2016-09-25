#include "warteschlange_var2_sfun.h"
#include "warteschlange_var2_sfun_c1.h"

#define mexPrintf                       sf_mex_printf
#ifdef printf
#undef printf
#endif
#define printf                          sf_mex_printf
#define SF_DEBUG_SET_DATA_VALUE_PTR(v1,v2)\
  sf_debug_set_instance_data_value_ptr(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,v1,(void *)(v2));
#define SF_DEBUG_UNSET_DATA_VALUE_PTR(v1)\
  sf_debug_unset_instance_data_value_ptr(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,v1);
#define SF_DEBUG_DATA_RANGE_CHECK_MIN_MAX(dVal,dNum,dMin,dMax)\
  sf_debug_data_range_error_wrapper_min_max(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMin,(double)dMax)
#define SF_DEBUG_DATA_RANGE_CHECK_MIN(dVal,dNum,dMin)\
  sf_debug_data_range_error_wrapper_min(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMin)
#define SF_DEBUG_DATA_RANGE_CHECK_MAX(dVal,dNum,dMax)\
  sf_debug_data_range_error_wrapper_max(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   dNum,(double)(dVal),(double)dMax)
#define SF_DEBUG_ARRAY_BOUNDS_CHECK(v1,v2,v3,v4,v5) \
  sf_debug_data_array_bounds_error_check(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),(v2),(v3),(v4),(v5))
#define SF_DEBUG_CAST_TO_UINT8(v1) \
  sf_debug_cast_to_uint8_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_UINT16(v1) \
  sf_debug_cast_to_uint16_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_UINT32(v1) \
  sf_debug_cast_to_uint32_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT8(v1) \
  sf_debug_cast_to_int8_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT16(v1) \
  sf_debug_cast_to_int16_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_INT32(v1) \
  sf_debug_cast_to_int32_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_CAST_TO_SINGLE(v1) \
  sf_debug_cast_to_real32_T(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),0,0)
#define SF_DEBUG_TRANSITION_CONFLICT(v1,v2) sf_debug_transition_conflict_error(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   v1,v2)
#define SF_DEBUG_CHART_CALL(v1,v2,v3) sf_debug_call(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   CHART_OBJECT,v1,v2,v3,_sfEvent_,\
   0,NULL,_sfTime_,1)
#define SF_DEBUG_CHART_COVERAGE_CALL(v1,v2,v3,v4) sf_debug_call(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   CHART_OBJECT,v1,v2,v3,_sfEvent_,\
   v4,NULL,_sfTime_,1)
#define SF_DEBUG_STATE_TEMPORAL_THRESHOLD(v1,v2,v4) sf_debug_temporal_threshold(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (unsigned int)(v1),(v2),STATE_OBJECT,(v4))
#define SF_DEBUG_TRANS_TEMPORAL_THRESHOLD(v1,v2,v4) sf_debug_temporal_threshold(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (unsigned int)(v1),(v2),TRANSITION_OBJECT,(v4))
#define CV_EVAL(v1,v2,v3,v4) cv_eval_point(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   (v1),(v2),(v3),(boolean_T)(v4))
#define CV_TRANSITION_EVAL(v1,v2) cv_eval_point(_warteschlange_var2MachineNumber_,\
   chartInstance.chartNumber,\
   chartInstance.instanceNumber,\
   TRANSITION_OBJECT,(v1),0,(boolean_T)(v2))
#define IN_NO_ACTIVE_CHILD              (0)
#define IN_c1_s1_Warteschlangensystem   1
#define IN_c1_s3_Hilfszustand           1
#define IN_c1_s5_busy                   1
#define IN_c1_s6_idle                   2
#define c1_d9_smin                      chartInstance.ConstantData.c1_d9_smin
#define c1_d8_smax                      chartInstance.ConstantData.c1_d8_smax
#define event_c1_e10_Ankunft            0
static SFwarteschlange_var2_sfun_c1InstanceStruct chartInstance;
#define OutputData_c1_d7_Kunden         (((real_T *)(ssGetOutputPortSignal(chartInstance.S,1)))[0])
void warteschlange_var2_sfun_c1(void);
static void enter_atomic_c1_s3_Hilfszustand(void);
static void enter_atomic_c1_s5_busy(void);
static void exit_atomic_c1_s5_busy(void);
static void enter_atomic_c1_s6_idle(void);

void warteschlange_var2_sfun_c1(void)
{
  SF_DEBUG_CHART_CALL(CHART_OBJECT,CHART_ENTER_DURING_FUNCTION_TAG,0);
  if(chartInstance.State.is_active_warteschlange_var2_sfun_c1==0) {
    SF_DEBUG_CHART_CALL(CHART_OBJECT,CHART_ENTER_ENTRY_FUNCTION_TAG,0);
    chartInstance.State.is_active_warteschlange_var2_sfun_c1=1;
    SF_DEBUG_CHART_CALL(CHART_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,6);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,6);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,6);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,3);
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,3,0);
    chartInstance.State.is_warteschlange_var2_sfun_c1=IN_c1_s1_Warteschlangensystem;
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,3);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,3);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,5);
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,5,0);
    chartInstance.State.is_active_c1_s2_Kunden_prozess=1;
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,5);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,5);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,0);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,0);
    SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,0);
    enter_atomic_c1_s3_Hilfszustand();
    if(chartInstance.State.is_active_c1_s2_Kunden_prozess) {
      SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,2);
      SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,2,0);
      chartInstance.State.is_active_c1_s4_Server_prozess=1;
      SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,2);
      SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,2);
      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,5);
      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,5);
      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,5);
      enter_atomic_c1_s6_idle();
    }
  } else {
    {
      SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,3);
      SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,3,0);
      if(chartInstance.State.is_warteschlange_var2_sfun_c1==IN_c1_s1_Warteschlangensystem) {
        {
          SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,5);
          SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,5,0);
          if(chartInstance.State.is_active_c1_s2_Kunden_prozess) {
            {
              SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,0);
              SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,0,0);
              if(chartInstance.State.is_c1_s2_Kunden_prozess==IN_c1_s3_Hilfszustand) {
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,2);
                if(CV_TRANSITION_EVAL(2,(_sfTime_ >= chartInstance.LocalData.c1_d1_az) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,2,0)))) {
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,2);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,2);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,2);
                  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_EXIT_FUNCTION_TAG,0);
                  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_EXIT_COVERAGE_TAG,0,0);
                  chartInstance.State.is_c1_s2_Kunden_prozess=IN_NO_ACTIVE_CHILD;
                  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_INACTIVE_TAG,0);
                  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_TRANS_ACTION_TAG,2);
                  mexPrintf("Ankunft\n");
                  {
                    int8_T previousEvent;
                    previousEvent=_sfEvent_;
                    SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_ENTER_BROADCAST_FUNCTION_TAG,event_c1_e10_Ankunft);
                    SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_BEFORE_BROADCAST_TAG,event_c1_e10_Ankunft);
                    _sfEvent_=event_c1_e10_Ankunft;
                    sf_mex_listen_for_ctrl_c();
                    warteschlange_var2_sfun_c1();
                    SF_DEBUG_CHART_CALL(EVENT_OBJECT,EVENT_AFTER_BROADCAST_TAG,event_c1_e10_Ankunft);
                    _sfEvent_=previousEvent;
                  }
                  if(chartInstance.State.is_c1_s2_Kunden_prozess==IN_NO_ACTIVE_CHILD) {
                    if(chartInstance.State.is_active_c1_s2_Kunden_prozess) {
                      SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_TRANSITION_ACTION_COVERAGE_TAG,2,0);
                      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_AFTER_TRANS_ACTION_TAG,2);
                      SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,2);
                      enter_atomic_c1_s3_Hilfszustand();
                    }
                  }
                }
              }
              SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
            }
          }
          SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,5);
        }
        if(chartInstance.State.is_warteschlange_var2_sfun_c1==IN_c1_s1_Warteschlangensystem) {
          SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,2);
          SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,2,0);
          if(chartInstance.State.is_active_c1_s4_Server_prozess) {
            switch(CV_EVAL(STATE_OBJECT,2,0,chartInstance.State.is_c1_s4_Server_prozess)) {
             case IN_NO_ACTIVE_CHILD:
              break;
             case IN_c1_s5_busy:
              SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,1);
              SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,1,1);
              SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,1);
              if(CV_TRANSITION_EVAL(1,(_sfTime_ >= chartInstance.LocalData.c1_d2_bz) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,1,0)))) {
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,1);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,1);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_COND_ACTION_TAG,1);
                sf_echo_expression("Kunden",(real_T)(OutputData_c1_d7_Kunden = (real_T )(int16_T )((int16_T )OutputData_c1_d7_Kunden -
                   1)));
                SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_CONDITION_ACTION_COVERAGE_TAG,1,0);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_AFTER_COND_ACTION_TAG,1);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,1);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,7);
                if(CV_TRANSITION_EVAL(7,((int16_T )OutputData_c1_d7_Kunden == 0) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,7,0)))) {
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,7);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,7);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,7);
                  exit_atomic_c1_s5_busy();
                  if(chartInstance.State.is_c1_s4_Server_prozess==IN_NO_ACTIVE_CHILD) {
                    if(chartInstance.State.is_active_c1_s4_Server_prozess) {
                      enter_atomic_c1_s6_idle();
                    }
                  }
                } else {
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,4);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,4);
                  SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,4);
                  exit_atomic_c1_s5_busy();
                  if(chartInstance.State.is_c1_s4_Server_prozess==IN_NO_ACTIVE_CHILD) {
                    if(chartInstance.State.is_active_c1_s4_Server_prozess) {
                      enter_atomic_c1_s5_busy();
                    }
                  }
                }
              } else {
                SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_BEFORE_DURING_ACTION_TAG,1);
                if(_sfEvent_==event_c1_e10_Ankunft) {
                  OutputData_c1_d7_Kunden = (real_T )(int16_T )((int16_T )OutputData_c1_d7_Kunden + 1);
                  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,1,0);
                }
                SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_AFTER_DURING_ACTION_TAG,1);
              }
              SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
              break;
             case IN_c1_s6_idle:
              SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_DURING_FUNCTION_TAG,4);
              SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_DURING_COVERAGE_TAG,4,0);
              SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_PROCESSING_TAG,3);
              if(CV_TRANSITION_EVAL(3,(_sfEvent_ == event_c1_e10_Ankunft) && (SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_GUARD_COVERAGE_TAG,3,0)))) {
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_ACTIVE_TAG,3);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_WHEN_VALID_TAG,3);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,3);
                SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_EXIT_FUNCTION_TAG,4);
                SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_EXIT_COVERAGE_TAG,4,0);
                chartInstance.State.is_c1_s4_Server_prozess=IN_NO_ACTIVE_CHILD;
                SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_INACTIVE_TAG,4);
                SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,4);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_BEFORE_TRANS_ACTION_TAG,3);
                OutputData_c1_d7_Kunden = (real_T )(int16_T )((int16_T )OutputData_c1_d7_Kunden + 1);
                SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_TRANSITION_ACTION_COVERAGE_TAG,3,0);
                chartInstance.LocalData.c1_d2_bz = (int16_T )_sfTime_;
                SF_DEBUG_CHART_COVERAGE_CALL(TRANSITION_OBJECT,TRANSITION_TRANSITION_ACTION_COVERAGE_TAG,3,1);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_AFTER_TRANS_ACTION_TAG,3);
                SF_DEBUG_CHART_CALL(TRANSITION_OBJECT,TRANSITION_INACTIVE_TAG,3);
                enter_atomic_c1_s5_busy();
              }
              SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,4);
              break;
            }
          }
          SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,2);
        }
      }
      SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,3);
    }
  }
  SF_DEBUG_CHART_CALL(CHART_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
}

static void enter_atomic_c1_s3_Hilfszustand(void)
{
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,0);
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,2);
  if(chartInstance.State.is_c1_s2_Kunden_prozess!=IN_c1_s3_Hilfszustand) {
    chartInstance.State.is_c1_s2_Kunden_prozess=IN_c1_s3_Hilfszustand;
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,0);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_BEFORE_ENTRY_ACTION_TAG,0);
    chartInstance.LocalData.c1_d5_iz = (int16_T )(chartInstance.LocalData.c1_d4_imin + (chartInstance.LocalData.c1_d3_imax - chartInstance.LocalData.c1_d4_imin) *
       sf_matlab("rand"));
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,0);
    chartInstance.LocalData.c1_d1_az = (int16_T )(chartInstance.LocalData.c1_d1_az + chartInstance.LocalData.c1_d5_iz);
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,0,1);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_AFTER_ENTRY_ACTION_TAG,0);
  }
  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,0);
}

static void enter_atomic_c1_s5_busy(void)
{
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,1);
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,2);
  if(chartInstance.State.is_c1_s4_Server_prozess!=IN_c1_s5_busy) {
    chartInstance.State.is_c1_s4_Server_prozess=IN_c1_s5_busy;
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,1);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_BEFORE_ENTRY_ACTION_TAG,1);
    chartInstance.LocalData.c1_d6_sz = (int16_T )(c1_d9_smin + (c1_d8_smax - c1_d9_smin) * sf_matlab("rand"));
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,0);
    chartInstance.LocalData.c1_d2_bz = (int16_T )(chartInstance.LocalData.c1_d2_bz + chartInstance.LocalData.c1_d6_sz);
    SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,1,1);
    SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_AFTER_ENTRY_ACTION_TAG,1);
  }
  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
}

static void exit_atomic_c1_s5_busy(void)
{
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_EXIT_FUNCTION_TAG,1);
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_EXIT_COVERAGE_TAG,1,0);
  chartInstance.State.is_c1_s4_Server_prozess=IN_NO_ACTIVE_CHILD;
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_INACTIVE_TAG,1);
  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,1);
}

static void enter_atomic_c1_s6_idle(void)
{
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ENTER_ENTRY_FUNCTION_TAG,4);
  SF_DEBUG_CHART_COVERAGE_CALL(STATE_OBJECT,STATE_ENTRY_COVERAGE_TAG,4,0);
  chartInstance.State.is_c1_s4_Server_prozess=IN_c1_s6_idle;
  SF_DEBUG_CHART_CALL(STATE_OBJECT,STATE_ACTIVE_TAG,4);
  SF_DEBUG_CHART_CALL(STATE_OBJECT,EXIT_OUT_OF_FUNCTION_TAG,4);
}

void sf_warteschlange_var2_sfun_c1_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(914451523U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1670659854U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2924538618U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2108635959U);
}

static void initialize_warteschlange_var2_sfun_c1( SimStruct *S)
{
  {
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'smin'.\n");
    c1_d9_smin = (real_T)ml_get_typed_scalar("smin",CALLER_WORKSPACE,mxDOUBLE_CLASS,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
  }
  {
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'smax'.\n");
    c1_d8_smax = (real_T)ml_get_typed_scalar("smax",CALLER_WORKSPACE,mxDOUBLE_CLASS,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
  }

  chartInstance.LocalData.c1_d5_iz = (int16_T)0;
  chartInstance.LocalData.c1_d1_az = (int16_T)0;
  chartInstance.LocalData.c1_d6_sz = (int16_T)0;
  chartInstance.LocalData.c1_d2_bz = (int16_T)0;
  {
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'imin'.\n");
    chartInstance.LocalData.c1_d4_imin = (real_T)ml_get_typed_scalar("imin",CALLER_WORKSPACE,mxDOUBLE_CLASS,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
  }
  {
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'imax'.\n");
    chartInstance.LocalData.c1_d3_imax = (real_T)ml_get_typed_scalar("imax",CALLER_WORKSPACE,mxDOUBLE_CLASS,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
  }

  OutputData_c1_d7_Kunden = (int16_T)0;
  
  memset((void*)&(chartInstance.State),0,sizeof(chartInstance.State));

  if(ssIsFirstInitCond(S)) {
    {
      unsigned int chartAlreadyPresent;
      chartAlreadyPresent = sf_debug_initialize_chart(_warteschlange_var2MachineNumber_,
       1,
       6,
       8,
       9,
       1,
       0,
       0,
       0,
       &(chartInstance.chartNumber),
       &(chartInstance.instanceNumber),
       ssGetPath((SimStruct *)S),
       (void *)S);
      if(chartAlreadyPresent==0) {
        
        sf_debug_set_chart_disable_implicit_casting(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,0);
        sf_debug_set_chart_event_thresholds(_warteschlange_var2MachineNumber_,
         chartInstance.chartNumber,
         1,
         1,
         1);

#define SF_DEBUG_SET_DATA_PROPS(dataNumber,dataScope,isInputData,isOutputData,dataType,numDims,dimArray)\
          sf_debug_set_chart_data_props(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,\
           (dataNumber),(dataScope),(isInputData),(isOutputData),\
           (dataType),(numDims),(dimArray))
        SF_DEBUG_SET_DATA_PROPS(8,0,0,0,SF_INT16,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(6,0,0,0,SF_INT16,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(2,0,0,0,SF_INT16,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(0,2,0,1,SF_INT16,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(5,0,0,0,SF_INT16,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(4,7,0,0,SF_DOUBLE,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(7,7,0,0,SF_DOUBLE,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(3,0,0,0,SF_DOUBLE,0,NULL);
        SF_DEBUG_SET_DATA_PROPS(1,0,0,0,SF_DOUBLE,0,NULL);
        sf_debug_set_chart_event_scope(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,0,0);
#define SF_DEBUG_STATE_INFO(v1,v2,v3)\
          sf_debug_set_chart_state_info(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,(v1),(v2),(v3))
        SF_DEBUG_STATE_INFO(3,1,0);
        SF_DEBUG_STATE_INFO(5,0,1);
        SF_DEBUG_STATE_INFO(0,0,0);
        SF_DEBUG_STATE_INFO(2,0,1);
        SF_DEBUG_STATE_INFO(1,0,0);
        SF_DEBUG_STATE_INFO(4,0,0);
#define SF_DEBUG_CH_SUBSTATE_INDEX(v1,v2)\
          sf_debug_set_chart_substate_index(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,(v1),(v2))
#define SF_DEBUG_ST_SUBSTATE_INDEX(v1,v2,v3)\
          sf_debug_set_chart_state_substate_index(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,(v1),(v2),(v3))
#define SF_DEBUG_ST_SUBSTATE_COUNT(v1,v2)\
          sf_debug_set_chart_state_substate_count(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,(v1),(v2))
        sf_debug_set_chart_substate_count(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,1);
        sf_debug_set_chart_decomposition(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,0);
        SF_DEBUG_CH_SUBSTATE_INDEX(0,3);
        SF_DEBUG_ST_SUBSTATE_COUNT(3,2);
        SF_DEBUG_ST_SUBSTATE_INDEX(3,0,5);
        SF_DEBUG_ST_SUBSTATE_INDEX(3,1,2);
        SF_DEBUG_ST_SUBSTATE_COUNT(5,1);
        SF_DEBUG_ST_SUBSTATE_INDEX(5,0,0);
        SF_DEBUG_ST_SUBSTATE_COUNT(0,0);
        SF_DEBUG_ST_SUBSTATE_COUNT(2,2);
        SF_DEBUG_ST_SUBSTATE_INDEX(2,0,1);
        SF_DEBUG_ST_SUBSTATE_INDEX(2,1,4);
        SF_DEBUG_ST_SUBSTATE_COUNT(1,0);
        SF_DEBUG_ST_SUBSTATE_COUNT(4,0);
      }
      sf_debug_cv_init_chart(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,1,0,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,3,2,0,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,5,1,0,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,0,0,0,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,2,2,1,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,1,0,0,0,0);
      sf_debug_cv_init_state(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,4,0,0,0,0);

      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,5,0);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,0,0);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,3,1);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,1,1);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,7,1);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,4,0);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,2,1);
      sf_debug_cv_init_trans(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,6,0);
#define SF_DEBUG_STATE_COV_WTS(v1,v2,v3,v4)\
        sf_debug_set_instance_state_coverage_weights(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,(v1),(v2),(v3),(v4))
#define SF_DEBUG_STATE_COV_MAPS(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10) \
        sf_debug_set_chart_state_coverage_maps(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,\
         (v1),(v2),(v3),(v4),(v5),(v6),(v7),(v8),(v9),(v10))
#define SF_DEBUG_TRANS_COV_WTS(v1,v2,v3,v4,v5) \
        sf_debug_set_instance_transition_coverage_weights(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber,\
         (v1),(v2),(v3),(v4),(v5))
#define SF_DEBUG_TRANS_COV_MAPS(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13) \
        sf_debug_set_chart_transition_coverage_maps(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,\
         (v1),\
         (v2),(v3),(v4),\
         (v5),(v6),(v7),\
         (v8),(v9),(v10),\
         (v11),(v12),(v13))
      SF_DEBUG_STATE_COV_WTS(3,1,1,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {0};
        static unsigned int sEndEntryMap[] = {0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(3,
         1,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         0,NULL,NULL);
      }
      SF_DEBUG_STATE_COV_WTS(5,1,1,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {0};
        static unsigned int sEndEntryMap[] = {0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(5,
         1,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         0,NULL,NULL);
      }
      SF_DEBUG_STATE_COV_WTS(0,3,1,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {20,60,0};
        static unsigned int sEndEntryMap[] = {59,69,0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};
        static unsigned int sStartExitMap[] = {0};
        static unsigned int sEndExitMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(0,
         3,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         1,&(sStartExitMap[0]),&(sEndExitMap[0]));
      }
      SF_DEBUG_STATE_COV_WTS(2,1,1,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {0};
        static unsigned int sEndEntryMap[] = {0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(2,
         1,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         0,NULL,NULL);
      }
      SF_DEBUG_STATE_COV_WTS(1,3,2,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {13,45,0};
        static unsigned int sEndEntryMap[] = {44,54,0};
        static unsigned int sStartDuringMap[] = {67,0};
        static unsigned int sEndDuringMap[] = {83,0};
        static unsigned int sStartExitMap[] = {0};
        static unsigned int sEndExitMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(1,
         3,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         2,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         1,&(sStartExitMap[0]),&(sEndExitMap[0]));
      }
      SF_DEBUG_STATE_COV_WTS(4,1,1,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartEntryMap[] = {0};
        static unsigned int sEndEntryMap[] = {0};
        static unsigned int sStartDuringMap[] = {0};
        static unsigned int sEndDuringMap[] = {0};
        static unsigned int sStartExitMap[] = {0};
        static unsigned int sEndExitMap[] = {0};

        SF_DEBUG_STATE_COV_MAPS(4,
         1,&(sStartEntryMap[0]),&(sEndEntryMap[0]),
         1,&(sStartDuringMap[0]),&(sEndDuringMap[0]),
         1,&(sStartExitMap[0]),&(sEndExitMap[0]));
      }
      SF_DEBUG_TRANS_COV_WTS(5,0,0,0,0);
      if(chartAlreadyPresent==0)
      {
        SF_DEBUG_TRANS_COV_MAPS(5,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(0,0,0,0,0);
      if(chartAlreadyPresent==0)
      {
        SF_DEBUG_TRANS_COV_MAPS(0,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(3,0,1,0,2);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {0};
        static unsigned int sEndGuardMap[] = {7};
        static unsigned int sStartTransitionActionMap[] = {8,24};
        static unsigned int sEndTransitionActionMap[] = {24,29};
        SF_DEBUG_TRANS_COV_MAPS(3,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         0,NULL,NULL,
         2,&(sStartTransitionActionMap[0]),&(sEndTransitionActionMap[0]));
      }
      SF_DEBUG_TRANS_COV_WTS(1,0,1,1,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {1};
        static unsigned int sEndGuardMap[] = {6};
        static unsigned int sStartConditionActionMap[] = {8};
        static unsigned int sEndConditionActionMap[] = {24};
        SF_DEBUG_TRANS_COV_MAPS(1,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         1,&(sStartConditionActionMap[0]),&(sEndConditionActionMap[0]),
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(7,0,1,0,0);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {1};
        static unsigned int sEndGuardMap[] = {10};
        SF_DEBUG_TRANS_COV_MAPS(7,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(4,0,0,0,0);
      if(chartAlreadyPresent==0)
      {
        SF_DEBUG_TRANS_COV_MAPS(4,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_TRANS_COV_WTS(2,0,1,0,1);
      if(chartAlreadyPresent==0)
      {
        static unsigned int sStartGuardMap[] = {1};
        static unsigned int sEndGuardMap[] = {6};
        static unsigned int sStartTransitionActionMap[] = {8};
        static unsigned int sEndTransitionActionMap[] = {15};
        SF_DEBUG_TRANS_COV_MAPS(2,
         0,NULL,NULL,
         1,&(sStartGuardMap[0]),&(sEndGuardMap[0]),
         0,NULL,NULL,
         1,&(sStartTransitionActionMap[0]),&(sEndTransitionActionMap[0]));
      }
      SF_DEBUG_TRANS_COV_WTS(6,0,0,0,0);
      if(chartAlreadyPresent==0)
      {
        SF_DEBUG_TRANS_COV_MAPS(6,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL,
         0,NULL,NULL);
      }
      SF_DEBUG_SET_DATA_VALUE_PTR(8,(void *)(&chartInstance.LocalData.c1_d5_iz));
      SF_DEBUG_SET_DATA_VALUE_PTR(6,(void *)(&chartInstance.LocalData.c1_d1_az));
      SF_DEBUG_SET_DATA_VALUE_PTR(2,(void *)(&chartInstance.LocalData.c1_d6_sz));
      SF_DEBUG_SET_DATA_VALUE_PTR(0,(void *)(&OutputData_c1_d7_Kunden));
      SF_DEBUG_SET_DATA_VALUE_PTR(5,(void *)(&chartInstance.LocalData.c1_d2_bz));
      SF_DEBUG_SET_DATA_VALUE_PTR(4,(void *)(&c1_d9_smin));
      SF_DEBUG_SET_DATA_VALUE_PTR(7,(void *)(&c1_d8_smax));
      SF_DEBUG_SET_DATA_VALUE_PTR(3,(void *)(&chartInstance.LocalData.c1_d4_imin));
      SF_DEBUG_SET_DATA_VALUE_PTR(1,(void *)(&chartInstance.LocalData.c1_d3_imax));
    }
  }else{
    sf_debug_reset_current_state_configuration(_warteschlange_var2MachineNumber_,chartInstance.chartNumber,chartInstance.instanceNumber);
  }
  {
    
    int previousEvent = _sfEvent_;
    _sfEvent_ = CALL_EVENT;
    warteschlange_var2_sfun_c1();
    _sfEvent_ = previousEvent;
  }
  chartInstance.chartInfo.chartInitialized = 1;
}

void warteschlange_var2_sfun_c1_sizes_registry(SimStruct *S)
{
  ssSetNumInputPorts((SimStruct *)S, 1);
  ssSetInputPortWidth((SimStruct *)S,0,1);
  ssSetInputPortDirectFeedThrough((SimStruct *)S,0,1);
  ssSetNumOutputPorts((SimStruct *)S, 2);
  ssSetOutputPortDataType((SimStruct *)S,0,SS_DOUBLE);
  ssSetOutputPortWidth((SimStruct *)S,0,1);
  ssSetOutputPortDataType((SimStruct *)S,1,SS_DOUBLE);
  ssSetOutputPortWidth((SimStruct *)S,1,1);
}

void terminate_warteschlange_var2_sfun_c1(SimStruct *S)
{
}
static void mdlRTW_warteschlange_var2_sfun_c1(SimStruct *S)
{
  if (!ssWriteRTWWorkVect(S, "PWork", 1,"ChartInstance", 1)) {
    return;
  }
  if (!ssWriteRTWStr(S, "ChartWorkspaceData {")) return;
  {
    int indexArray[1];
    const mxArray *mxArrayPtr;
    indexArray[0] = 1;
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'imax' in the chart's parent workspace.\n");
    mxArrayPtr = ml_get_typed_vector("imax",CALLER_WORKSPACE,1,indexArray,mxDOUBLE_CLASS,1,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
    if (!ssWriteRTWVectParam(S, "imax",(const void *)(mxGetPr(mxArrayPtr)),sf_get_sl_type_from_ml_type(mxGetClassID(mxArrayPtr)), 1)) return;
  }
  {
    int indexArray[1];
    const mxArray *mxArrayPtr;
    indexArray[0] = 1;
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'imin' in the chart's parent workspace.\n");
    mxArrayPtr = ml_get_typed_vector("imin",CALLER_WORKSPACE,1,indexArray,mxDOUBLE_CLASS,1,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
    if (!ssWriteRTWVectParam(S, "imin",(const void *)(mxGetPr(mxArrayPtr)),sf_get_sl_type_from_ml_type(mxGetClassID(mxArrayPtr)), 1)) return;
  }
  {
    int indexArray[1];
    const mxArray *mxArrayPtr;
    indexArray[0] = 1;
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'smax' in the chart's parent workspace.\n");
    mxArrayPtr = ml_get_typed_vector("smax",CALLER_WORKSPACE,1,indexArray,mxDOUBLE_CLASS,1,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
    if (!ssWriteRTWVectParam(S, "smax",(const void *)(mxGetPr(mxArrayPtr)),sf_get_sl_type_from_ml_type(mxGetClassID(mxArrayPtr)), 1)) return;
  }
  {
    int indexArray[1];
    const mxArray *mxArrayPtr;
    indexArray[0] = 1;
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): Error evaluating chart workspace data 'smin' in the chart's parent workspace.\n");
    mxArrayPtr = ml_get_typed_vector("smin",CALLER_WORKSPACE,1,indexArray,mxDOUBLE_CLASS,1,0);
    sf_set_error_prefix_string("Stateflow Runtime Error (chart): ");
    if (!ssWriteRTWVectParam(S, "smin",(const void *)(mxGetPr(mxArrayPtr)),sf_get_sl_type_from_ml_type(mxGetClassID(mxArrayPtr)), 1)) return;
  }
  if (!ssWriteRTWStr(S, "}")) return;
}

void sf_warteschlange_var2_sfun_c1( void *);
void warteschlange_var2_sfun_c1_registry(SimStruct *S)
{
  chartInstance.chartInfo.chartInstance = NULL;
  chartInstance.chartInfo.chartInitialized = 0;
  chartInstance.chartInfo.sFunctionGateway = sf_warteschlange_var2_sfun_c1;
  chartInstance.chartInfo.initializeChart = initialize_warteschlange_var2_sfun_c1;
  chartInstance.chartInfo.terminateChart = terminate_warteschlange_var2_sfun_c1;
  chartInstance.chartInfo.mdlRTW = mdlRTW_warteschlange_var2_sfun_c1;
  chartInstance.chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance.chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance.chartInfo.storeCurrentConfiguration = NULL;
  chartInstance.chartInfo.sampleTime = ml_eval_scalar("1",CALLER_WORKSPACE,1);
  if(mxIsNaN(chartInstance.chartInfo.sampleTime)) {
    sf_mex_error_message("Error evaluating sample-time expression '1' for chart 'warteschlange_var2/Warteschlan- gensystem' in the chart's parent workspace.");
  }
  if(chartInstance.chartInfo.sampleTime==CONTINUOUS_SAMPLE_TIME) {
    mexPrintf("Stateflow runtime error in chart warteschlange_var2/Warteschlan- gensystem\n");
    sf_mex_error_message("Runtime value of chart sample time 1 \ncannot be set to 0.0 (continuous). \nPlease change the update method to continuous time  for this chart.\n");
  }
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

void sf_warteschlange_var2_sfun_c1( void *chartInstanceVoidPtr)
{
  
  int previousEvent;
  previousEvent = _sfEvent_;

  _sfTime_ = ssGetT(chartInstance.S);

  _sfEvent_ = CALL_EVENT;
  warteschlange_var2_sfun_c1();
  _sfEvent_ = previousEvent;
}

