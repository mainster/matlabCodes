#ifndef __L4TKA5lKCXheIhQN4RietB_h__
#define __L4TKA5lKCXheIhQN4RietB_h__

/* Include files */
#include "simstruc.h"
#include "rtwtypes.h"
#include "multiword_types.h"

/* Type Definitions */
#ifndef struct_slE07I4lDg6FknjQ3k8Q9CG
#define struct_slE07I4lDg6FknjQ3k8Q9CG

struct slE07I4lDg6FknjQ3k8Q9CG
{
  real_T Index;
  real_T DataType;
  real_T IsSigned;
  real_T MantBits;
  real_T FixExp;
  real_T Slope;
  real_T Bias;
};

#endif                                 /*struct_slE07I4lDg6FknjQ3k8Q9CG*/

#ifndef typedef_slE07I4lDg6FknjQ3k8Q9CG
#define typedef_slE07I4lDg6FknjQ3k8Q9CG

typedef struct slE07I4lDg6FknjQ3k8Q9CG slE07I4lDg6FknjQ3k8Q9CG;

#endif                                 /*typedef_slE07I4lDg6FknjQ3k8Q9CG*/

#ifndef struct_saG5948SFTrUFnIbVUb0TZH
#define struct_saG5948SFTrUFnIbVUb0TZH

struct saG5948SFTrUFnIbVUb0TZH
{
  int32_T isInitialized;
};

#endif                                 /*struct_saG5948SFTrUFnIbVUb0TZH*/

#ifndef typedef_AddOne
#define typedef_AddOne

typedef struct saG5948SFTrUFnIbVUb0TZH AddOne;

#endif                                 /*typedef_AddOne*/

#ifndef struct_sfOd2wElE6un66xmZCZog7F
#define struct_sfOd2wElE6un66xmZCZog7F

struct sfOd2wElE6un66xmZCZog7F
{
  real_T dimModes;
  real_T dims[3];
  real_T dType;
  real_T complexity;
  real_T outputBuiltInDTEqUsed;
};

#endif                                 /*struct_sfOd2wElE6un66xmZCZog7F*/

#ifndef typedef_sfOd2wElE6un66xmZCZog7F
#define typedef_sfOd2wElE6un66xmZCZog7F

typedef struct sfOd2wElE6un66xmZCZog7F sfOd2wElE6un66xmZCZog7F;

#endif                                 /*typedef_sfOd2wElE6un66xmZCZog7F*/

#ifndef struct_sRzepbcAzWdfpiYnMYop13F
#define struct_sRzepbcAzWdfpiYnMYop13F

struct sRzepbcAzWdfpiYnMYop13F
{
  real_T dimModes;
  real_T dims[4];
  real_T dType;
  real_T complexity;
  real_T outputBuiltInDTEqUsed;
};

#endif                                 /*struct_sRzepbcAzWdfpiYnMYop13F*/

#ifndef typedef_sRzepbcAzWdfpiYnMYop13F
#define typedef_sRzepbcAzWdfpiYnMYop13F

typedef struct sRzepbcAzWdfpiYnMYop13F sRzepbcAzWdfpiYnMYop13F;

#endif                                 /*typedef_sRzepbcAzWdfpiYnMYop13F*/

#ifndef struct_sZVQz5WVraeIWEljxFvLe8
#define struct_sZVQz5WVraeIWEljxFvLe8

struct sZVQz5WVraeIWEljxFvLe8
{
  char_T names;
  real_T dims[3];
  real_T dType;
  real_T complexity;
};

#endif                                 /*struct_sZVQz5WVraeIWEljxFvLe8*/

#ifndef typedef_sZVQz5WVraeIWEljxFvLe8
#define typedef_sZVQz5WVraeIWEljxFvLe8

typedef struct sZVQz5WVraeIWEljxFvLe8 sZVQz5WVraeIWEljxFvLe8;

#endif                                 /*typedef_sZVQz5WVraeIWEljxFvLe8*/

#ifndef struct_sIvmHumfM4VG8K4LjAjoqqB
#define struct_sIvmHumfM4VG8K4LjAjoqqB

struct sIvmHumfM4VG8K4LjAjoqqB
{
  char_T names;
  real_T dims[3];
  real_T dType;
  real_T dTypeSize;
  char_T dTypeName;
  real_T dTypeIndex;
  char_T dTypeChksum;
  real_T complexity;
};

#endif                                 /*struct_sIvmHumfM4VG8K4LjAjoqqB*/

#ifndef typedef_sIvmHumfM4VG8K4LjAjoqqB
#define typedef_sIvmHumfM4VG8K4LjAjoqqB

typedef struct sIvmHumfM4VG8K4LjAjoqqB sIvmHumfM4VG8K4LjAjoqqB;

#endif                                 /*typedef_sIvmHumfM4VG8K4LjAjoqqB*/

#ifndef struct_s7UBIGHSehQY1gCsIQWwr5C
#define struct_s7UBIGHSehQY1gCsIQWwr5C

struct s7UBIGHSehQY1gCsIQWwr5C
{
  real_T chksum[4];
};

#endif                                 /*struct_s7UBIGHSehQY1gCsIQWwr5C*/

#ifndef typedef_s7UBIGHSehQY1gCsIQWwr5C
#define typedef_s7UBIGHSehQY1gCsIQWwr5C

typedef struct s7UBIGHSehQY1gCsIQWwr5C s7UBIGHSehQY1gCsIQWwr5C;

#endif                                 /*typedef_s7UBIGHSehQY1gCsIQWwr5C*/

#ifndef struct_sznE3FlCyo7TBPrpitCkVZC
#define struct_sznE3FlCyo7TBPrpitCkVZC

struct sznE3FlCyo7TBPrpitCkVZC
{
  s7UBIGHSehQY1gCsIQWwr5C dlgPrmChksum;
  s7UBIGHSehQY1gCsIQWwr5C propChksum[3];
  s7UBIGHSehQY1gCsIQWwr5C CGOnlyParamChksum;
  s7UBIGHSehQY1gCsIQWwr5C postPropOnlyChksum;
};

#endif                                 /*struct_sznE3FlCyo7TBPrpitCkVZC*/

#ifndef typedef_sznE3FlCyo7TBPrpitCkVZC
#define typedef_sznE3FlCyo7TBPrpitCkVZC

typedef struct sznE3FlCyo7TBPrpitCkVZC sznE3FlCyo7TBPrpitCkVZC;

#endif                                 /*typedef_sznE3FlCyo7TBPrpitCkVZC*/

#ifndef typedef_InstanceStruct_L4TKA5lKCXheIhQN4RietB
#define typedef_InstanceStruct_L4TKA5lKCXheIhQN4RietB

typedef struct {
  SimStruct *S;
  covrtInstance covInst;
  AddOne sysobj;
  boolean_T sysobj_not_empty;
} InstanceStruct_L4TKA5lKCXheIhQN4RietB;

#endif                                 /*typedef_InstanceStruct_L4TKA5lKCXheIhQN4RietB*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */

/* Function Definitions */
extern void method_dispatcher_L4TKA5lKCXheIhQN4RietB(SimStruct *S, int_T method,
  void* data);
extern int autoInfer_dispatcher_L4TKA5lKCXheIhQN4RietB(mxArray *lhs[], const
  char* commandName);

#endif
