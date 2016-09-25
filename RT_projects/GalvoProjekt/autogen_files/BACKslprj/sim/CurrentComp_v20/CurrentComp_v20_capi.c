#include "__cf_CurrentComp_v20.h"
#include "CurrentComp_v20.h"
#include "rtw_capi.h"
#include "CurrentComp_v20_private.h"
static rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) ,
0 , 0 , 0 , 0 , 0 } } ; static rtwCAPI_States rtBlockStates [ ] = { { 0 , 1 ,
"CurrentComp_v20/Int\nCoil" , "" , "" , 0 , 0 , 0 , 0 , 0 , 1 } , { 1 , 0 ,
"CurrentComp_v20/GF(s)\nCurrent Sens//Filter" , "" , "" , 0 , 0 , 0 , 0 , 0 ,
1 } , { 2 , 2 , "CurrentComp_v20/Gpw(s)\nPower stage" , "" , "" , 0 , 0 , 0 ,
0 , 0 , 1 } , { 0 , - 1 , ( NULL ) , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0
, 0 } } ; static void CurrentComp_v20_InitializeDataAddr ( void * dataAddr [
] , ncz3xaeqao * localX ) { dataAddr [ 0 ] = ( void * ) ( & localX ->
a2sot3odgv ) ; dataAddr [ 1 ] = ( void * ) ( & localX -> ebqidb0xjh ) ;
dataAddr [ 2 ] = ( void * ) ( & localX -> n05r0nwh5t ) ; } static void
CurrentComp_v20_InitializeVarDimsAddr ( int32_T * vardimsAddr [ ] ) {
vardimsAddr [ 0 ] = ( NULL ) ; } static rtwCAPI_DataTypeMap rtDataTypeMap [ ]
= { { "double" , "real_T" , 0 , 0 , sizeof ( real_T ) , SS_DOUBLE , 0 , 0 } }
; static rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 , 0 , 0 , 0 }
, } ; static rtwCAPI_DimensionMap rtDimensionMap [ ] = { { rtwCAPI_SCALAR , 0
, 2 , 0 } } ; static uint_T rtDimensionArray [ ] = { 1 , 1 } ; static const
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
) , 0 } , { rtBlockStates , 3 } , { rtDataTypeMap , rtDimensionMap ,
rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float" ,
& mmiStaticInfoLogging , 0 , } ; const rtwCAPI_ModelMappingStaticInfo *
CurrentComp_v20_GetCAPIStaticMap ( ) { return & mmiStatic ; } static void
CurrentComp_v20_InitializeSystemRan ( gglys5ixm2 * const kmvzalfyjs ,
sysRanDType * systemRan [ ] , int_T systemTid [ ] , void * rootSysRanPtr ,
int rootTid ) { systemRan [ 0 ] = ( sysRanDType * ) rootSysRanPtr ; systemRan
[ 1 ] = ( NULL ) ; systemRan [ 2 ] = ( NULL ) ; systemTid [ 1 ] = dbpvk1s35x
[ 0 ] ; systemTid [ 2 ] = dbpvk1s35x [ 0 ] ; systemTid [ 0 ] = rootTid ;
rtContextSystems [ 0 ] = 0 ; rtContextSystems [ 1 ] = 0 ; rtContextSystems [
2 ] = 0 ; } void CurrentComp_v20_InitializeDataMapInfo ( gglys5ixm2 * const
kmvzalfyjs , ncz3xaeqao * localX , void * sysRanPtr , int contextTid ) {
rtwCAPI_SetVersion ( kmvzalfyjs -> DataMapInfo . mmi , 1 ) ;
rtwCAPI_SetStaticMap ( kmvzalfyjs -> DataMapInfo . mmi , & mmiStatic ) ;
rtwCAPI_SetLoggingStaticMap ( kmvzalfyjs -> DataMapInfo . mmi , &
mmiStaticInfoLogging ) ; CurrentComp_v20_InitializeDataAddr ( kmvzalfyjs ->
DataMapInfo . dataAddress , localX ) ; rtwCAPI_SetDataAddressMap ( kmvzalfyjs
-> DataMapInfo . mmi , kmvzalfyjs -> DataMapInfo . dataAddress ) ;
CurrentComp_v20_InitializeVarDimsAddr ( kmvzalfyjs -> DataMapInfo .
vardimsAddress ) ; rtwCAPI_SetVarDimsAddressMap ( kmvzalfyjs -> DataMapInfo .
mmi , kmvzalfyjs -> DataMapInfo . vardimsAddress ) ; rtwCAPI_SetPath (
kmvzalfyjs -> DataMapInfo . mmi , ( NULL ) ) ; rtwCAPI_SetFullPath (
kmvzalfyjs -> DataMapInfo . mmi , ( NULL ) ) ; rtwCAPI_SetInstanceLoggingInfo
( kmvzalfyjs -> DataMapInfo . mmi , & kmvzalfyjs -> DataMapInfo .
mmiLogInstanceInfo ) ; rtwCAPI_SetChildMMIArray ( kmvzalfyjs -> DataMapInfo .
mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen ( kmvzalfyjs -> DataMapInfo .
mmi , 0 ) ; CurrentComp_v20_InitializeSystemRan ( kmvzalfyjs , kmvzalfyjs ->
DataMapInfo . systemRan , kmvzalfyjs -> DataMapInfo . systemTid , sysRanPtr ,
contextTid ) ; rtwCAPI_SetSystemRan ( kmvzalfyjs -> DataMapInfo . mmi ,
kmvzalfyjs -> DataMapInfo . systemRan ) ; rtwCAPI_SetSystemTid ( kmvzalfyjs
-> DataMapInfo . mmi , kmvzalfyjs -> DataMapInfo . systemTid ) ;
rtwCAPI_SetGlobalTIDMap ( kmvzalfyjs -> DataMapInfo . mmi , & dbpvk1s35x [ 0
] ) ; }
