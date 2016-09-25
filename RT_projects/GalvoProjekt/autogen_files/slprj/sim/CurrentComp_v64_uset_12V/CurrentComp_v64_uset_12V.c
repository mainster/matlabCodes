#include "__cf_CurrentComp_v64_uset_12V.h"
#include "CurrentComp_v64_uset_12V_capi.h"
#include "CurrentComp_v64_uset_12V.h"
#include "CurrentComp_v64_uset_12V_private.h"
int_T emnrm1kqnq [ 1 ] ; static RegMdlInfo rtMdlInfo_CurrentComp_v64_uset_12V
[ 28 ] = { { "fp4morojtbn" , MDL_INFO_NAME_MDLREF_DWORK , 0 , - 1 , ( void *
) "CurrentComp_v64_uset_12V" } , { "c3ioio0a50" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "da0zvfkftx" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "cyndvxwrnm" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "kboftbsicp" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "g4mabh0lwt" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "abcvnc5ukn" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "mfrglrh3d1" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "nyu1o4uwrv" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "kcwp0odlux" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "ldyvqjpmm4" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "jvze1vue32" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "o3afooa05z" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "bszssqpoid" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "ji0h0q341h" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "lxe4guq4an" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "oygw3surmc" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "gnz3ta13nu" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "cvp0yqqtz0" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "igxhpnwb2h" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "CurrentComp_v64_uset_12V" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , 0 , ( NULL ) } , { "dafafqsv13" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "mw45ox052b" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "emnrm1kqnq" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "j101vp0dasn" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "j101vp0das" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"CurrentComp_v64_uset_12V" } , { "CurrentComp_v64_uset_12V.h" ,
MDL_INFO_MODEL_FILENAME , 0 , 0 , ( NULL ) } , { "CurrentComp_v64_uset_12V.c"
, MDL_INFO_MODEL_FILENAME , 0 , 0 , ( NULL ) } } ; void gnz3ta13nu (
g4mabh0lwt * localX ) { localX -> gwgxdckjar = 0.0 ; } void
CurrentComp_v64_uset_12V ( mw45ox052b * const cpttgbwffw , const real_T *
fm5rb20cek , real_T * fwa4qspoh5 , real_T mvto2yv3xt [ 2 ] , jvze1vue32 *
localB , ldyvqjpmm4 * localDW , g4mabh0lwt * localX ) { real_T jvx4feknkp ;
jvx4feknkp = localX -> gwgxdckjar ; * fwa4qspoh5 = 6249.9999999999991 *
jvx4feknkp ; localB -> n3fin3td2x = ( * fm5rb20cek - * fwa4qspoh5 ) *
6.3432542926282 ; localB -> poie5rqgn4 = 1.51 * * fwa4qspoh5 ; if (
rtmIsMajorTimeStep ( cpttgbwffw ) ) { localDW -> aozis12kvb = localB ->
n3fin3td2x >= 12.0 ? 1 : localB -> n3fin3td2x > - 13.0 ? 0 : - 1 ; } localB
-> insx5fnvtr = localDW -> aozis12kvb == 1 ? 12.0 : localDW -> aozis12kvb ==
- 1 ? - 13.0 : localB -> n3fin3td2x ; mvto2yv3xt [ 0 ] = localB -> insx5fnvtr
; mvto2yv3xt [ 1 ] = localB -> n3fin3td2x ; } void oygw3surmc ( const real_T
* nvtqropxrm , jvze1vue32 * localB ) { localB -> korvulmiuj = ( localB ->
insx5fnvtr - localB -> poie5rqgn4 ) - * nvtqropxrm ; } void lxe4guq4an (
const real_T * nvtqropxrm , jvze1vue32 * localB , kboftbsicp * localXdot ) {
localB -> korvulmiuj = ( localB -> insx5fnvtr - localB -> poie5rqgn4 ) - *
nvtqropxrm ; { localXdot -> gwgxdckjar = localB -> korvulmiuj ; } } void
ji0h0q341h ( const real_T * nvtqropxrm , jvze1vue32 * localB , c3ioio0a50 *
localZCSV ) { localB -> korvulmiuj = ( localB -> insx5fnvtr - localB ->
poie5rqgn4 ) - * nvtqropxrm ; localZCSV -> csabynkgsz = localB -> n3fin3td2x
- 12.0 ; localZCSV -> pauyeacjaj = localB -> n3fin3td2x - - 13.0 ; } void
cvp0yqqtz0 ( SimStruct * _mdlRefSfcnS , int_T mdlref_TID0 , mw45ox052b *
const cpttgbwffw , jvze1vue32 * localB , ldyvqjpmm4 * localDW , g4mabh0lwt *
localX , void * sysRanPtr , int contextTid , rtwCAPI_ModelMappingInfo *
rt_ParentMMI , const char_T * rt_ChildPath , int_T rt_ChildMMIIdx , int_T
rt_CSTATEIdx ) { rt_InitInfAndNaN ( sizeof ( real_T ) ) ; ( void ) memset ( (
void * ) cpttgbwffw , 0 , sizeof ( mw45ox052b ) ) ; emnrm1kqnq [ 0 ] =
mdlref_TID0 ; cpttgbwffw -> _mdlRefSfcnS = ( _mdlRefSfcnS ) ; { localB ->
n3fin3td2x = 0.0 ; localB -> poie5rqgn4 = 0.0 ; localB -> insx5fnvtr = 0.0 ;
localB -> korvulmiuj = 0.0 ; } ( void ) memset ( ( void * ) localDW , 0 ,
sizeof ( ldyvqjpmm4 ) ) ; CurrentComp_v64_uset_12V_InitializeDataMapInfo (
cpttgbwffw , localDW , localX , sysRanPtr , contextTid ) ; if ( (
rt_ParentMMI != ( NULL ) ) && ( rt_ChildPath != ( NULL ) ) ) {
rtwCAPI_SetChildMMI ( * rt_ParentMMI , rt_ChildMMIIdx , & ( cpttgbwffw ->
DataMapInfo . mmi ) ) ; rtwCAPI_SetPath ( cpttgbwffw -> DataMapInfo . mmi ,
rt_ChildPath ) ; rtwCAPI_MMISetContStateStartIndex ( cpttgbwffw ->
DataMapInfo . mmi , rt_CSTATEIdx ) ; } } void
mr_CurrentComp_v64_uset_12V_MdlInfoRegFcn ( SimStruct * mdlRefSfcnS , char_T
* modelName , int_T * retVal ) { * retVal = 0 ; * retVal = 0 ;
ssRegModelRefMdlInfo ( mdlRefSfcnS , modelName ,
rtMdlInfo_CurrentComp_v64_uset_12V , 28 ) ; * retVal = 1 ; }
