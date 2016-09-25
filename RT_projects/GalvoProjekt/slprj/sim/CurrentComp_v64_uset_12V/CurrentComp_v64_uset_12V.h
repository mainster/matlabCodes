#include "__cf_CurrentComp_v64_uset_12V.h"
#ifndef RTW_HEADER_CurrentComp_v64_uset_12V_h_
#define RTW_HEADER_CurrentComp_v64_uset_12V_h_
#include "rtw_modelmap.h"
#ifndef CurrentComp_v64_uset_12V_COMMON_INCLUDES_
#define CurrentComp_v64_uset_12V_COMMON_INCLUDES_
#include <stddef.h>
#include <string.h>
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "rt_nonfinite.h"
#endif
#include "CurrentComp_v64_uset_12V_types.h"
typedef struct { real_T n3fin3td2x ; real_T poie5rqgn4 ; real_T insx5fnvtr ;
real_T korvulmiuj ; } jvze1vue32 ; typedef struct { int_T aozis12kvb ; }
ldyvqjpmm4 ; typedef struct { real_T gwgxdckjar ; } g4mabh0lwt ; typedef
struct { real_T gwgxdckjar ; } kboftbsicp ; typedef struct { boolean_T
gwgxdckjar ; } cyndvxwrnm ; typedef struct { real_T gwgxdckjar ; } da0zvfkftx
; typedef struct { real_T csabynkgsz ; real_T pauyeacjaj ; } c3ioio0a50 ;
typedef struct { ZCSigState nitkz1vp2s ; ZCSigState iiipyqel4b ; } mfrglrh3d1
; struct dafafqsv13 { struct SimStruct_tag * _mdlRefSfcnS ; struct {
rtwCAPI_ModelMappingInfo mmi ; rtwCAPI_ModelMapLoggingInstanceInfo
mmiLogInstanceInfo ; void * dataAddress [ 1 ] ; int32_T * vardimsAddress [ 1
] ; sysRanDType * systemRan [ 3 ] ; int_T systemTid [ 3 ] ; } DataMapInfo ; }
; typedef struct { jvze1vue32 rtb ; ldyvqjpmm4 rtdw ; mw45ox052b rtm ;
mfrglrh3d1 rtzce ; } fp4morojtbn ; extern void cvp0yqqtz0 ( SimStruct *
_mdlRefSfcnS , int_T mdlref_TID0 , mw45ox052b * const cpttgbwffw , jvze1vue32
* localB , ldyvqjpmm4 * localDW , g4mabh0lwt * localX , void * sysRanPtr ,
int contextTid , rtwCAPI_ModelMappingInfo * rt_ParentMMI , const char_T *
rt_ChildPath , int_T rt_ChildMMIIdx , int_T rt_CSTATEIdx ) ; extern void
mr_CurrentComp_v64_uset_12V_MdlInfoRegFcn ( SimStruct * mdlRefSfcnS , char_T
* modelName , int_T * retVal ) ; extern const rtwCAPI_ModelMappingStaticInfo
* CurrentComp_v64_uset_12V_GetCAPIStaticMap ( void ) ; extern void gnz3ta13nu
( g4mabh0lwt * localX ) ; extern void lxe4guq4an ( const real_T * nvtqropxrm
, jvze1vue32 * localB , kboftbsicp * localXdot ) ; extern void ji0h0q341h (
const real_T * nvtqropxrm , jvze1vue32 * localB , c3ioio0a50 * localZCSV ) ;
extern void oygw3surmc ( const real_T * nvtqropxrm , jvze1vue32 * localB ) ;
extern void CurrentComp_v64_uset_12V ( mw45ox052b * const cpttgbwffw , const
real_T * fm5rb20cek , real_T * fwa4qspoh5 , real_T mvto2yv3xt [ 2 ] ,
jvze1vue32 * localB , ldyvqjpmm4 * localDW , g4mabh0lwt * localX ) ;
#endif
