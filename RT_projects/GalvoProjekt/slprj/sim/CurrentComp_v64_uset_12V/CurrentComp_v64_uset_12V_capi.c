#include "__cf_CurrentComp_v64_uset_12V.h"
#include "CurrentComp_v64_uset_12V.h"
#include "rtw_capi.h"
#include "CurrentComp_v64_uset_12V_private.h"
static rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) ,
0 , 0 , 0 , 0 , 0 } } ; static rtwCAPI_States rtBlockStates [ ] = { { 0 , 0 ,
"CurrentComp_v64_uset_12V/Int\nCoil" , "" , "" , 0 , 0 , 0 , 0 , 0 , 1 } , {
0 , - 1 , ( NULL ) , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 , 0 } } ; static
void CurrentComp_v64_uset_12V_InitializeDataAddr ( void * dataAddr [ ] ,
ldyvqjpmm4 * localDW , g4mabh0lwt * localX ) { dataAddr [ 0 ] = ( void * ) (
& localX -> gwgxdckjar ) ; } static void
CurrentComp_v64_uset_12V_InitializeVarDimsAddr ( int32_T * vardimsAddr [ ] )
{ vardimsAddr [ 0 ] = ( NULL ) ; } static rtwCAPI_DataTypeMap rtDataTypeMap [
] = { { "double" , "real_T" , 0 , 0 , sizeof ( real_T ) , SS_DOUBLE , 0 , 0 }
} ; static rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 , 0 , 0 , 0
} , } ; static rtwCAPI_DimensionMap rtDimensionMap [ ] = { { rtwCAPI_SCALAR ,
0 , 2 , 0 } } ; static uint_T rtDimensionArray [ ] = { 1 , 1 } ; static const
real_T rtcapiStoredFloats [ ] = { 0.0 } ; static rtwCAPI_FixPtMap rtFixPtMap
[ ] = { { ( NULL ) , ( NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , 0 } , } ;
static rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * ) &
rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , 0 ,
0 } } ; static int_T rtContextSystems [ 3 ] ; static rtwCAPI_LoggingMetaInfo
loggingMetaInfo [ ] = { { 0 , 0 , "" , 0 } } ; static
rtwCAPI_ModelMapLoggingStaticInfo mmiStaticInfoLogging = { 3 ,
rtContextSystems , loggingMetaInfo , 0 , NULL , { 0 , NULL , NULL } , 0 , (
NULL ) } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { {
rtBlockSignals , 0 , ( NULL ) , 0 , ( NULL ) , 0 } , { ( NULL ) , 0 , ( NULL
) , 0 } , { rtBlockStates , 1 } , { rtDataTypeMap , rtDimensionMap ,
rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float" ,
& mmiStaticInfoLogging , 0 , } ; const rtwCAPI_ModelMappingStaticInfo *
CurrentComp_v64_uset_12V_GetCAPIStaticMap ( ) { return & mmiStatic ; } static
void CurrentComp_v64_uset_12V_InitializeSystemRan ( mw45ox052b * const
cpttgbwffw , sysRanDType * systemRan [ ] , ldyvqjpmm4 * localDW , int_T
systemTid [ ] , void * rootSysRanPtr , int rootTid ) { systemRan [ 0 ] = (
sysRanDType * ) rootSysRanPtr ; systemRan [ 1 ] = ( NULL ) ; systemRan [ 2 ]
= ( NULL ) ; systemTid [ 1 ] = emnrm1kqnq [ 0 ] ; systemTid [ 2 ] =
emnrm1kqnq [ 0 ] ; systemTid [ 0 ] = rootTid ; rtContextSystems [ 0 ] = 0 ;
rtContextSystems [ 1 ] = 0 ; rtContextSystems [ 2 ] = 0 ; } void
CurrentComp_v64_uset_12V_InitializeDataMapInfo ( mw45ox052b * const
cpttgbwffw , ldyvqjpmm4 * localDW , g4mabh0lwt * localX , void * sysRanPtr ,
int contextTid ) { rtwCAPI_SetVersion ( cpttgbwffw -> DataMapInfo . mmi , 1 )
; rtwCAPI_SetStaticMap ( cpttgbwffw -> DataMapInfo . mmi , & mmiStatic ) ;
rtwCAPI_SetLoggingStaticMap ( cpttgbwffw -> DataMapInfo . mmi , &
mmiStaticInfoLogging ) ; CurrentComp_v64_uset_12V_InitializeDataAddr (
cpttgbwffw -> DataMapInfo . dataAddress , localDW , localX ) ;
rtwCAPI_SetDataAddressMap ( cpttgbwffw -> DataMapInfo . mmi , cpttgbwffw ->
DataMapInfo . dataAddress ) ; CurrentComp_v64_uset_12V_InitializeVarDimsAddr
( cpttgbwffw -> DataMapInfo . vardimsAddress ) ; rtwCAPI_SetVarDimsAddressMap
( cpttgbwffw -> DataMapInfo . mmi , cpttgbwffw -> DataMapInfo .
vardimsAddress ) ; rtwCAPI_SetPath ( cpttgbwffw -> DataMapInfo . mmi , ( NULL
) ) ; rtwCAPI_SetFullPath ( cpttgbwffw -> DataMapInfo . mmi , ( NULL ) ) ;
rtwCAPI_SetInstanceLoggingInfo ( cpttgbwffw -> DataMapInfo . mmi , &
cpttgbwffw -> DataMapInfo . mmiLogInstanceInfo ) ; rtwCAPI_SetChildMMIArray (
cpttgbwffw -> DataMapInfo . mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen (
cpttgbwffw -> DataMapInfo . mmi , 0 ) ;
CurrentComp_v64_uset_12V_InitializeSystemRan ( cpttgbwffw , cpttgbwffw ->
DataMapInfo . systemRan , localDW , cpttgbwffw -> DataMapInfo . systemTid ,
sysRanPtr , contextTid ) ; rtwCAPI_SetSystemRan ( cpttgbwffw -> DataMapInfo .
mmi , cpttgbwffw -> DataMapInfo . systemRan ) ; rtwCAPI_SetSystemTid (
cpttgbwffw -> DataMapInfo . mmi , cpttgbwffw -> DataMapInfo . systemTid ) ;
rtwCAPI_SetGlobalTIDMap ( cpttgbwffw -> DataMapInfo . mmi , & emnrm1kqnq [ 0
] ) ; }
