#include "__cf_CurrentComp_v20.h"
#if !defined(S_FUNCTION_NAME)
#define S_FUNCTION_NAME CurrentComp_v20_msf
#endif
#define S_FUNCTION_LEVEL 2
#if !defined(RTW_GENERATED_S_FUNCTION)
#define RTW_GENERATED_S_FUNCTION
#endif
#include <stdio.h>
#include <math.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define rt_logging_h
#include "CurrentComp_v20_types.h"
#include "CurrentComp_v20.h"
#include "CurrentComp_v20_private.h"
MdlRefChildMdlRec childModels [ 1 ] = { "CurrentComp_v20" , "CurrentComp_v20"
, 1 } ; static void mdlInitializeSizes ( SimStruct * S ) { ssSetNumSFcnParams
( S , 0 ) ; ssFxpSetU32BitRegionCompliant ( S , 1 ) ; rt_InitInfAndNaN (
sizeof ( real_T ) ) ; if ( S -> mdlInfo -> genericFcn != ( NULL ) ) {
_GenericFcn fcn = S -> mdlInfo -> genericFcn ; real_T lifeSpan = rtInf ;
real_T startTime = 0.0 ; real_T stopTime = 10.0 ; int_T hwSettings [ 13 ] ;
int_T opSettings [ 1 ] ; boolean_T concurrTaskSupport = 0 ; boolean_T
hasDiscTs = 0 ; ModelRefChildSolverInfo solverInfo = { 0 , - 1 , 0.001 ,
0.0001 , 0.0 , 0.0 } ; ( fcn ) ( S , GEN_FCN_CHK_MODELREF_SOLVER_TYPE_EARLY ,
1 , ( NULL ) ) ; ( fcn ) ( S , GEN_FCN_MODELREF_RATE_GROUPED , 0 , ( NULL ) )
; if ( ! ( fcn ) ( S , GEN_FCN_CHK_MODELREF_LIFE_SPAN , - 1 , & lifeSpan ) )
return ; if ( ! ( fcn ) ( S , GEN_FCN_CHK_MODELREF_START_TIME , - 1 , &
startTime ) ) return ; if ( ! ( fcn ) ( S , GEN_FCN_CHK_MODELREF_STOP_TIME ,
- 1 , & stopTime ) ) return ; hwSettings [ 0 ] = 8 ; hwSettings [ 1 ] = 16 ;
hwSettings [ 2 ] = 32 ; hwSettings [ 3 ] = 32 ; hwSettings [ 4 ] = 32 ;
hwSettings [ 5 ] = 64 ; hwSettings [ 6 ] = 32 ; hwSettings [ 7 ] = 2 ;
hwSettings [ 8 ] = 0 ; hwSettings [ 9 ] = 32 ; hwSettings [ 10 ] = 1 ;
hwSettings [ 11 ] = 0 ; hwSettings [ 12 ] = 2 ; if ( ! ( fcn ) ( S ,
GEN_FCN_CHK_MODELREF_HARDWARE_SETTINGS , 13 , hwSettings ) ) return ;
opSettings [ 0 ] = 0 ; if ( ! ( fcn ) ( S ,
GEN_FCN_CHK_MODELREF_OPTIM_SETTINGS , 1 , opSettings ) ) return ; if ( ! (
fcn ) ( S , GEN_FCN_CHK_MODELREF_CONCURRETNT_TASK_SUPPORT , ( int_T )
concurrTaskSupport , NULL ) ) return ; if ( ! ( fcn ) ( S ,
GEN_FCN_CHK_MODELREF_SOLVER_TYPE , 0 , & hasDiscTs ) ) return ; if ( ! ( fcn
) ( S , GEN_FCN_CHK_MODELREF_SOLVER_NAME , 0 , ( void * ) "ode45" ) ) return
; if ( ! ( fcn ) ( S , GEN_FCN_CHK_MODELREF_SOLVER_MODE ,
SOLVER_MODE_SINGLETASKING , ( NULL ) ) ) return ; if ( ! ( fcn ) ( S ,
GEN_FCN_CHK_MODELREF_VSOLVER_OPTS , - 1 , & solverInfo ) ) return ; ( fcn ) (
S , GEN_FCN_CHK_MODELREF_FRAME_UPGRADE_DIAGNOSTICS , 1 , ( NULL ) ) ; }
ssSetRTWGeneratedSFcn ( S , 2 ) ; ssSetNumContStates ( S , 3 ) ;
ssSetNumDiscStates ( S , 0 ) ; if ( ! ssSetNumInputPorts ( S , 2 ) ) return ;
if ( ! ssSetInputPortVectorDimension ( S , 0 , 1 ) ) return ;
ssSetInputPortDimensionsMode ( S , 0 , FIXED_DIMS_MODE ) ;
ssSetInputPortFrameData ( S , 0 , FRAME_NO ) ; if ( ssGetSimMode ( S ) !=
SS_SIMMODE_SIZES_CALL_ONLY ) { ssSetInputPortDataType ( S , 0 , SS_DOUBLE ) ;
} ssSetInputPortDirectFeedThrough ( S , 0 , 0 ) ;
ssSetInputPortRequiredContiguous ( S , 0 , 1 ) ; ssSetInputPortOptimOpts ( S
, 0 , SS_NOT_REUSABLE_AND_GLOBAL ) ; ssSetInputPortOverWritable ( S , 0 ,
FALSE ) ; ssSetInputPortSampleTime ( S , 0 , 0.0 ) ; ssSetInputPortOffsetTime
( S , 0 , 0.0 ) ; if ( ! ssSetInputPortVectorDimension ( S , 1 , 1 ) ) return
; ssSetInputPortDimensionsMode ( S , 1 , FIXED_DIMS_MODE ) ;
ssSetInputPortFrameData ( S , 1 , FRAME_NO ) ; if ( ssGetSimMode ( S ) !=
SS_SIMMODE_SIZES_CALL_ONLY ) { ssSetInputPortDataType ( S , 1 , SS_DOUBLE ) ;
} ssSetInputPortDirectFeedThrough ( S , 1 , 0 ) ;
ssSetInputPortRequiredContiguous ( S , 1 , 1 ) ; ssSetInputPortOptimOpts ( S
, 1 , SS_NOT_REUSABLE_AND_GLOBAL ) ; ssSetInputPortOverWritable ( S , 1 ,
FALSE ) ; ssSetInputPortSampleTime ( S , 1 , 0.0 ) ; ssSetInputPortOffsetTime
( S , 1 , 0.0 ) ; if ( ! ssSetNumOutputPorts ( S , 1 ) ) return ; if ( !
ssSetOutputPortVectorDimension ( S , 0 , 1 ) ) return ;
ssSetOutputPortDimensionsMode ( S , 0 , FIXED_DIMS_MODE ) ;
ssSetOutputPortFrameData ( S , 0 , FRAME_NO ) ; if ( ssGetSimMode ( S ) !=
SS_SIMMODE_SIZES_CALL_ONLY ) { ssSetOutputPortDataType ( S , 0 , SS_DOUBLE )
; } ssSetOutputPortSampleTime ( S , 0 , 0.0 ) ; ssSetOutputPortOffsetTime ( S
, 0 , 0.0 ) ; ssSetOutputPortDiscreteValuedOutput ( S , 0 , 0 ) ;
ssSetOutputPortOkToMerge ( S , 0 , SS_NOT_OK_TO_MERGE ) ;
ssSetOutputPortOptimOpts ( S , 0 , SS_NOT_REUSABLE_AND_GLOBAL ) ; { real_T
minValue = rtMinusInf ; real_T maxValue = rtInf ;
ssSetModelRefInputSignalDesignMin ( S , 0 , & minValue ) ;
ssSetModelRefInputSignalDesignMax ( S , 0 , & maxValue ) ; } { real_T
minValue = rtMinusInf ; real_T maxValue = rtInf ;
ssSetModelRefInputSignalDesignMin ( S , 1 , & minValue ) ;
ssSetModelRefInputSignalDesignMax ( S , 1 , & maxValue ) ; } { real_T
minValue = rtMinusInf ; real_T maxValue = rtInf ;
ssSetModelRefOutputSignalDesignMin ( S , 0 , & minValue ) ;
ssSetModelRefOutputSignalDesignMax ( S , 0 , & maxValue ) ; } { static
ssRTWStorageType storageClass [ 3 ] = { SS_RTW_STORAGE_AUTO ,
SS_RTW_STORAGE_AUTO , SS_RTW_STORAGE_AUTO } ;
ssSetModelRefPortRTWStorageClasses ( S , storageClass ) ; }
ssSetModelRefSignalLoggingSaveFormat ( S , SS_DATASET_FORMAT ) ;
ssSetNumSampleTimes ( S , PORT_BASED_SAMPLE_TIMES ) ; ssSetNumRWork ( S , 0 )
; ssSetNumIWork ( S , 0 ) ; ssSetNumPWork ( S , 0 ) ; ssSetNumModes ( S , 0 )
; { int_T zcsIdx = 0 ; } ssSetOutputPortIsNonContinuous ( S , 0 , 0 ) ;
ssSetOutputPortIsFedByBlockWithModesNoZCs ( S , 0 , 0 ) ;
ssSetInputPortIsNotDerivPort ( S , 0 , 0 ) ; ssSetInputPortIsNotDerivPort ( S
, 1 , 0 ) ; ssSetModelReferenceSampleTimeInheritanceRule ( S ,
DISALLOW_SAMPLE_TIME_INHERITANCE ) ; ssSetOptimizeModelRefInitCode ( S , 0 )
; ssSetAcceptsFcnCallInputs ( S ) ; ssSetModelReferenceNormalModeSupport ( S
, MDL_START_AND_MDL_PROCESS_PARAMS_OK ) ; ssSupportsMultipleExecInstances ( S
, true ) ; ssHasStateInsideForEachSS ( S , false ) ;
ssSetModelRefHasParforForEachSS ( S , false ) ;
ssSetModelRefHasVariantModelOrSubsystem ( S , false ) ; ssSetOptions ( S ,
SS_OPTION_EXCEPTION_FREE_CODE | SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME |
SS_OPTION_SUPPORTS_ALIAS_DATA_TYPES | SS_OPTION_WORKS_WITH_CODE_REUSE ) ; if
( S -> mdlInfo -> genericFcn != ( NULL ) ) { ssRegModelRefChildModel ( S , 1
, childModels ) ; }
#if SS_SFCN_FOR_SIM 
if ( S -> mdlInfo -> genericFcn != ( NULL ) && ssGetSimMode ( S ) !=
SS_SIMMODE_SIZES_CALL_ONLY ) { int_T retVal = 1 ;
mr_CurrentComp_v20_MdlInfoRegFcn ( S , "CurrentComp_v20" , & retVal ) ; if (
! retVal ) return ; }
#endif
ssSetNumDWork ( S , 0 ) ; ssSetNeedAbsoluteTime ( S , 1 ) ;
ssSetModelRefHasEnablePort ( S , 0 ) ; } static void mdlInitializeSampleTimes
( SimStruct * S ) { }
#define MDL_INITIALIZE_CONDITIONS
static void mdlInitializeConditions ( SimStruct * S ) { real_T * rtx = (
real_T * ) ssGetContStates ( S ) ; gqm3dsuqas ( rtx ) ; }
#define MDL_SET_WORK_WIDTHS
static void mdlSetWorkWidths ( SimStruct * S ) { if ( S -> mdlInfo ->
genericFcn != ( NULL ) ) { _GenericFcn fcn = S -> mdlInfo -> genericFcn ;
ssSetSignalSizesComputeType ( S , SS_VARIABLE_SIZE_FROM_INPUT_VALUE_AND_SIZE
) ; } { static const char * toFileNames [ ] = { "" } ; static const char *
fromFileNames [ ] = { "" } ; if ( ! ssSetModelRefFromFiles ( S , 0 ,
fromFileNames ) ) return ; if ( ! ssSetModelRefToFiles ( S , 0 , toFileNames
) ) return ; } }
#define MDL_START
static void mdlStart ( SimStruct * S ) { real_T * rtx = ( real_T * )
ssGetContStates ( S ) ; void * sysRanPtr = ( NULL ) ; int sysTid = 0 ;
ssGetContextSysRanBCPtr ( S , & sysRanPtr ) ; ssGetContextSysTid ( S , &
sysTid ) ; if ( sysTid == CONSTANT_TID ) { sysTid = 0 ; } c3htb1vvhz ( S ,
ssGetSampleTimeTaskID ( S , 0 ) , rtx , sysRanPtr , sysTid , ( NULL ) , (
NULL ) , 0 , - 1 ) ; ssSetModelMappingInfoPtr ( S , & ( bdrtdqqlst . rtm .
DataMapInfo . mmi ) ) ; if ( S -> mdlInfo -> genericFcn != ( NULL ) ) {
_GenericFcn fcn = S -> mdlInfo -> genericFcn ; } } static void mdlOutputs (
SimStruct * S , int_T tid ) { real_T * OutPort_0 = ( real_T * )
ssGetOutputPortSignal ( S , 0 ) ; real_T * rtx = ( real_T * ) ssGetContStates
( S ) ; if ( tid != CONSTANT_TID ) { CurrentComp_v20 ( OutPort_0 , rtx ) ; }
}
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) { const real_T * InPort_0
= ( real_T * ) ssGetInputPortSignal ( S , 0 ) ; const real_T * InPort_1 = (
real_T * ) ssGetInputPortSignal ( S , 1 ) ; awm2gknfws ( InPort_0 , InPort_1
) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { const real_T * InPort_0 = (
real_T * ) ssGetInputPortSignal ( S , 0 ) ; const real_T * InPort_1 = (
real_T * ) ssGetInputPortSignal ( S , 1 ) ; real_T * OutPort_0 = ( real_T * )
ssGetOutputPortSignal ( S , 0 ) ; real_T * rtxdot = ( real_T * ) ssGetdX ( S
) ; real_T * rtx = ( real_T * ) ssGetContStates ( S ) ; dmwts2mozn ( InPort_0
, InPort_1 , OutPort_0 , rtx , rtxdot ) ; } static void mdlTerminate (
SimStruct * S ) { }
#ifdef  MATLAB_MEX_FILE    
#include "simulink.c"
#include "fixedpoint.c"
#else
#include "cg_sfun.h"
#endif
