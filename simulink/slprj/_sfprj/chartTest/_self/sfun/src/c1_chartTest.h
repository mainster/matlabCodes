#ifndef __c1_chartTest_h__
#define __c1_chartTest_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef typedef_SFc1_chartTestInstanceStruct
#define typedef_SFc1_chartTestInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c1_sfEvent;
  uint8_T c1_tp_on;
  uint8_T c1_tp_off;
  uint8_T c1_tp_ab;
  boolean_T c1_isStable;
  uint8_T c1_is_active_c1_chartTest;
  uint8_T c1_is_c1_chartTest;
  uint8_T c1_doSetSimStateSideEffects;
  const mxArray *c1_setSimStateSideEffectsInfo;
} SFc1_chartTestInstanceStruct;

#endif                                 /*typedef_SFc1_chartTestInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c1_chartTest_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c1_chartTest_get_check_sum(mxArray *plhs[]);
extern void c1_chartTest_method_dispatcher(SimStruct *S, int_T method, void
  *data);

#endif
