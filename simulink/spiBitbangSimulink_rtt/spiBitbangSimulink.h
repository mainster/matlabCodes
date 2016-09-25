/*
 * File: spiBitbangSimulink.h
 *
 * Code generated for Simulink model 'spiBitbangSimulink'.
 *
 * Model version                  : 1.15
 * Simulink Coder version         : 8.5 (R2013b) 08-Aug-2013
 * TLC version                    : 8.5 (Aug  6 2013)
 * C/C++ source code generated on : Sat Apr 19 21:32:51 2014
 *
 * Target selection: realtime.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_spiBitbangSimulink_h_
#define RTW_HEADER_spiBitbangSimulink_h_
#ifndef spiBitbangSimulink_COMMON_INCLUDES_
# define spiBitbangSimulink_COMMON_INCLUDES_
#include <string.h>
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "MW_gpio_lct.h"
#endif                                 /* spiBitbangSimulink_COMMON_INCLUDES_ */

#include "spiBitbangSimulink_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmStepTask
# define rtmStepTask(rtm, idx)         ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmTaskCounter
# define rtmTaskCounter(rtm, idx)      ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

/* Block signals (auto storage) */
typedef struct {
  uint8_T FixPtSwitch;                 /* '<S4>/FixPt Switch' */
} B_spiBitbangSimulink_T;

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  uint8_T Output_DSTATE;               /* '<S2>/Output' */
} DW_spiBitbangSimulink_T;

/* Parameters (auto storage) */
struct P_spiBitbangSimulink_T_ {
  uint32_T GPIOWrite_p1;               /* Computed Parameter: GPIOWrite_p1
                                        * Referenced by: '<Root>/GPIO Write'
                                        */
  uint32_T GPIOWrite_p2;               /* Computed Parameter: GPIOWrite_p2
                                        * Referenced by: '<Root>/GPIO Write'
                                        */
  uint32_T GPIOWrite_p3;               /* Computed Parameter: GPIOWrite_p3
                                        * Referenced by: '<Root>/GPIO Write'
                                        */
  uint8_T Constant_Value;              /* Computed Parameter: Constant_Value
                                        * Referenced by: '<S4>/Constant'
                                        */
  uint8_T Output_InitialCondition;     /* Computed Parameter: Output_InitialCondition
                                        * Referenced by: '<S2>/Output'
                                        */
  uint8_T GPIOWrite_p4;                /* Expression: pinName
                                        * Referenced by: '<Root>/GPIO Write'
                                        */
  uint8_T FixPtConstant_Value;         /* Computed Parameter: FixPtConstant_Value
                                        * Referenced by: '<S3>/FixPt Constant'
                                        */
  uint8_T FixPtSwitch_Threshold;       /* Computed Parameter: FixPtSwitch_Threshold
                                        * Referenced by: '<S4>/FixPt Switch'
                                        */
  boolean_T Vector_Value[2];           /* Computed Parameter: Vector_Value
                                        * Referenced by: '<S1>/Vector'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_spiBitbangSimulink_T {
  const char_T * volatile errorStatus;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    struct {
      uint8_T TID[2];
    } TaskCounters;
  } Timing;
};

/* Block parameters (auto storage) */
extern P_spiBitbangSimulink_T spiBitbangSimulink_P;

/* Block signals (auto storage) */
extern B_spiBitbangSimulink_T spiBitbangSimulink_B;

/* Block states (auto storage) */
extern DW_spiBitbangSimulink_T spiBitbangSimulink_DW;

/* Model entry point functions */
extern void spiBitbangSimulink_initialize(void);
extern void spiBitbangSimulink_output0(void);
extern void spiBitbangSimulink_update0(void);
extern void spiBitbangSimulink_output1(void);
extern void spiBitbangSimulink_update1(void);
extern void spiBitbangSimulink_terminate(void);

/* Real-time Model object */
extern RT_MODEL_spiBitbangSimulink_T *const spiBitbangSimulink_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'spiBitbangSimulink'
 * '<S1>'   : 'spiBitbangSimulink/Repeating Sequence Stair'
 * '<S2>'   : 'spiBitbangSimulink/Repeating Sequence Stair/LimitedCounter'
 * '<S3>'   : 'spiBitbangSimulink/Repeating Sequence Stair/LimitedCounter/Increment Real World'
 * '<S4>'   : 'spiBitbangSimulink/Repeating Sequence Stair/LimitedCounter/Wrap To Zero'
 */
#endif                                 /* RTW_HEADER_spiBitbangSimulink_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
