#include "__cf_GalvoModel_v53.h"
#include "GalvoModel_v53.h"
#include "rtw_capi.h"
#include "GalvoModel_v53_private.h"
static rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , ( NULL ) , ( NULL ) ,
0 , 0 , 0 , 0 , 0 } } ; static rtwCAPI_States rtBlockStates [ ] = { { 0 , 0 ,
"GalvoModel_v53/Int\nInertia" , "" , "" , 0 , 0 , 0 , 0 , 0 , 1 } , { 1 , 1 ,
"GalvoModel_v53/int3" , "" , "" , 0 , 0 , 0 , 0 , 0 , 1 } , { 0 , - 1 , (
NULL ) , ( NULL ) , ( NULL ) , 0 , 0 , 0 , 0 , 0 , 0 } } ; static void
GalvoModel_v53_InitializeDataAddr ( void * dataAddr [ ] , ji45t3fxlq *
localDW , ksmwlcv2xl * localX ) { dataAddr [ 0 ] = ( void * ) ( & localX ->
dqmkzrbaiy ) ; dataAddr [ 1 ] = ( void * ) ( & localX -> lppk5jtuup ) ; }
static void GalvoModel_v53_InitializeVarDimsAddr ( int32_T * vardimsAddr [ ]
) { vardimsAddr [ 0 ] = ( NULL ) ; } static rtwCAPI_DataTypeMap rtDataTypeMap
[ ] = { { "double" , "real_T" , 0 , 0 , sizeof ( real_T ) , SS_DOUBLE , 0 , 0
} } ; static rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 , 0 , 0 ,
0 } , } ; static rtwCAPI_DimensionMap rtDimensionMap [ ] = { { rtwCAPI_SCALAR
, 0 , 2 , 0 } } ; static uint_T rtDimensionArray [ ] = { 1 , 1 } ; static
const real_T rtcapiStoredFloats [ ] = { 0.0 } ; static rtwCAPI_FixPtMap
rtFixPtMap [ ] = { { ( NULL ) , ( NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , 0 }
, } ; static rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const void * )
& rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [ 0 ] , 0
, 0 } } ; static int_T rtContextSystems [ 3 ] ; static
rtwCAPI_LoggingMetaInfo loggingMetaInfo [ ] = { { 0 , 0 , "" , 0 } } ; static
rtwCAPI_ModelMapLoggingStaticInfo mmiStaticInfoLogging = { 3 ,
rtContextSystems , loggingMetaInfo , 0 , NULL , { 0 , NULL , NULL } , 0 , (
NULL ) } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { {
rtBlockSignals , 0 , ( NULL ) , 0 , ( NULL ) , 0 } , { ( NULL ) , 0 , ( NULL
) , 0 } , { rtBlockStates , 2 } , { rtDataTypeMap , rtDimensionMap ,
rtFixPtMap , rtElementMap , rtSampleTimeMap , rtDimensionArray } , "float" ,
& mmiStaticInfoLogging , 0 , } ; const rtwCAPI_ModelMappingStaticInfo *
GalvoModel_v53_GetCAPIStaticMap ( ) { return & mmiStatic ; } static void
GalvoModel_v53_InitializeSystemRan ( oml3hqtcy5 * const czvgkvhwqf ,
sysRanDType * systemRan [ ] , ji45t3fxlq * localDW , int_T systemTid [ ] ,
void * rootSysRanPtr , int rootTid ) { systemRan [ 0 ] = ( sysRanDType * )
rootSysRanPtr ; systemRan [ 1 ] = ( NULL ) ; systemRan [ 2 ] = ( NULL ) ;
systemTid [ 1 ] = o1netmgexj [ 0 ] ; systemTid [ 2 ] = o1netmgexj [ 0 ] ;
systemTid [ 0 ] = rootTid ; rtContextSystems [ 0 ] = 0 ; rtContextSystems [ 1
] = 0 ; rtContextSystems [ 2 ] = 0 ; } void
GalvoModel_v53_InitializeDataMapInfo ( oml3hqtcy5 * const czvgkvhwqf ,
ji45t3fxlq * localDW , ksmwlcv2xl * localX , void * sysRanPtr , int
contextTid ) { rtwCAPI_SetVersion ( czvgkvhwqf -> DataMapInfo . mmi , 1 ) ;
rtwCAPI_SetStaticMap ( czvgkvhwqf -> DataMapInfo . mmi , & mmiStatic ) ;
rtwCAPI_SetLoggingStaticMap ( czvgkvhwqf -> DataMapInfo . mmi , &
mmiStaticInfoLogging ) ; GalvoModel_v53_InitializeDataAddr ( czvgkvhwqf ->
DataMapInfo . dataAddress , localDW , localX ) ; rtwCAPI_SetDataAddressMap (
czvgkvhwqf -> DataMapInfo . mmi , czvgkvhwqf -> DataMapInfo . dataAddress ) ;
GalvoModel_v53_InitializeVarDimsAddr ( czvgkvhwqf -> DataMapInfo .
vardimsAddress ) ; rtwCAPI_SetVarDimsAddressMap ( czvgkvhwqf -> DataMapInfo .
mmi , czvgkvhwqf -> DataMapInfo . vardimsAddress ) ; rtwCAPI_SetPath (
czvgkvhwqf -> DataMapInfo . mmi , ( NULL ) ) ; rtwCAPI_SetFullPath (
czvgkvhwqf -> DataMapInfo . mmi , ( NULL ) ) ; rtwCAPI_SetInstanceLoggingInfo
( czvgkvhwqf -> DataMapInfo . mmi , & czvgkvhwqf -> DataMapInfo .
mmiLogInstanceInfo ) ; rtwCAPI_SetChildMMIArray ( czvgkvhwqf -> DataMapInfo .
mmi , ( NULL ) ) ; rtwCAPI_SetChildMMIArrayLen ( czvgkvhwqf -> DataMapInfo .
mmi , 0 ) ; GalvoModel_v53_InitializeSystemRan ( czvgkvhwqf , czvgkvhwqf ->
DataMapInfo . systemRan , localDW , czvgkvhwqf -> DataMapInfo . systemTid ,
sysRanPtr , contextTid ) ; rtwCAPI_SetSystemRan ( czvgkvhwqf -> DataMapInfo .
mmi , czvgkvhwqf -> DataMapInfo . systemRan ) ; rtwCAPI_SetSystemTid (
czvgkvhwqf -> DataMapInfo . mmi , czvgkvhwqf -> DataMapInfo . systemTid ) ;
rtwCAPI_SetGlobalTIDMap ( czvgkvhwqf -> DataMapInfo . mmi , & o1netmgexj [ 0
] ) ; }
