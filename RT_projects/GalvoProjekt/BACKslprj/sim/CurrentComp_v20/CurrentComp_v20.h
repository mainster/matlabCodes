#include "__cf_CurrentComp_v20.h"
#ifndef RTW_HEADER_CurrentComp_v20_h_
#define RTW_HEADER_CurrentComp_v20_h_
#include "rtw_modelmap.h"
#ifndef CurrentComp_v20_COMMON_INCLUDES_
#define CurrentComp_v20_COMMON_INCLUDES_
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rt_nonfinite.h"
#endif
#include "CurrentComp_v20_types.h"
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { real_T cazu11504z ; real_T ansyvs11z0 ; real_T p225jiomuu ;
real_T iuphobyjje ; real_T po3x1ixty3 ; real_T ebdhh1jx04 ; } dv5lujxcl0 ;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { real_T ebqidb0xjh ; real_T a2sot3odgv ; real_T n05r0nwh5t ;
} ncz3xaeqao ;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { real_T ebqidb0xjh ; real_T a2sot3odgv ; real_T n05r0nwh5t ;
} auz4n1bxfd ;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { boolean_T ebqidb0xjh ; boolean_T a2sot3odgv ; boolean_T
n05r0nwh5t ; } dsqexfpcbz ;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { real_T ebqidb0xjh ; real_T a2sot3odgv ; real_T n05r0nwh5t ;
} btjta0ostk ;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
struct gbrjsykxhi { struct SimStruct_tag * _mdlRefSfcnS ; struct {
rtwCAPI_ModelMappingInfo mmi ; rtwCAPI_ModelMapLoggingInstanceInfo
mmiLogInstanceInfo ; void * dataAddress [ 3 ] ; int32_T * vardimsAddress [ 3
] ; sysRanDType * systemRan [ 3 ] ; int_T systemTid [ 3 ] ; } DataMapInfo ; }
;
#endif
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
typedef struct { dv5lujxcl0 rtb ; gglys5ixm2 rtm ; } bdrtdqqlsto ;
#endif
extern void gqm3dsuqas ( real_T * localX_ ) ; extern void dmwts2mozn ( const
real_T * bh3chofgz5 , const real_T * gvtiojoghj , real_T * nsqaozr3ha ,
real_T * localX_ , real_T * localXdot_ ) ; extern void awm2gknfws ( const
real_T * bh3chofgz5 , const real_T * gvtiojoghj ) ; extern void
CurrentComp_v20 ( real_T * nsqaozr3ha , real_T * localX_ ) ; extern void
c3htb1vvhz ( SimStruct * _mdlRefSfcnS , int_T mdlref_TID0 , real_T * localX_
, void * sysRanPtr , int contextTid , rtwCAPI_ModelMappingInfo * rt_ParentMMI
, const char_T * rt_ChildPath , int_T rt_ChildMMIIdx , int_T rt_CSTATEIdx ) ;
extern void mr_CurrentComp_v20_MdlInfoRegFcn ( SimStruct * mdlRefSfcnS ,
char_T * modelName , int_T * retVal ) ; extern const
rtwCAPI_ModelMappingStaticInfo * CurrentComp_v20_GetCAPIStaticMap ( void ) ;
#ifndef CurrentComp_v20_MDLREF_HIDE_CHILD_
extern bdrtdqqlsto bdrtdqqlst ;
#endif
#endif
