#include "__cf_GalvoModel_v53.h"
#ifndef RTW_HEADER_GalvoModel_v53_private_h_
#define RTW_HEADER_GalvoModel_v53_private_h_
#include "rtwtypes.h"
#ifndef rtmIsFirstInitCond
#define rtmIsFirstInitCond(rtm) ssIsFirstInitCond((rtm)->_mdlRefSfcnS)
#endif
#ifndef rtmIsMajorTimeStep
#define rtmIsMajorTimeStep(rtm) ssIsMajorTimeStep((rtm)->_mdlRefSfcnS)
#endif
#ifndef rtmIsMinorTimeStep
#define rtmIsMinorTimeStep(rtm) ssIsMinorTimeStep((rtm)->_mdlRefSfcnS)
#endif
#ifndef __RTWTYPES_H__
#error This file requires rtwtypes.h to be included
#else
#ifdef TMWTYPES_PREVIOUSLY_INCLUDED
#error This file requires rtwtypes.h to be included before tmwtypes.h
#else
#ifndef RTWTYPES_ID_C08S16I32L64N64F1
#error This code was generated with a different "rtwtypes.h" than the file included
#endif
#endif
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) ((rtm)->DataMapInfo)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) ((rtm)->DataMapInfo = (val))
#endif
#ifndef rtmGetClockTick0
#define rtmGetClockTick0(rtm) ssGetClockTick( ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[0])
#endif
#ifndef rtmGetClockTickH0
#define rtmGetClockTickH0(rtm) ssGetClockTickH( ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[0])
#endif
#ifndef rtmGetLogOutput
#define rtmGetLogOutput(rtm) ssGetLogOutput((rtm)->_mdlRefSfcnS)
#endif
#ifndef rtmSetSampleHit
#define rtmSetSampleHit(rtm, sti, tid, val) _ssSetSampleHit(ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[sti], val)
#endif
#ifndef rtmIsSampleHit
#define rtmIsSampleHit(rtm, sti, tid) ssIsSampleHit( ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[sti], tid)
#endif
#ifndef rtmGetT
#define rtmGetT(rtm) (ssGetT((rtm)->_mdlRefSfcnS))
#endif
#ifndef rtmGetTFinal
#define rtmGetTFinal(rtm) (ssGetTFinal((rtm)->_mdlRefSfcnS))
#endif
#ifndef rtmGetTNextWasAdjusted
#define rtmGetTNextWasAdjusted(rtm, sti) (ssGetTNextWasAdjusted((rtm)->_mdlRefSfcnS,  o1netmgexj[sti]))
#endif
#ifndef rtmGetTStart
#define rtmGetTStart(rtm) (ssGetTStart((rtm)->_mdlRefSfcnS))
#endif
#ifndef rtmGetTaskTime
#define rtmGetTaskTime(rtm, sti) ssGetTaskTime( ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[sti])
#endif
#ifndef rtmSetTaskTime
#define rtmSetTaskTime(rtm, sti, val) _ssSetTaskTime(ssGetRootSS((rtm)->_mdlRefSfcnS), o1netmgexj[sti], val)
#endif
#ifndef rtmGetTimeOfLastOutput
#define rtmGetTimeOfLastOutput(rtm) (ssGetTimeOfLastOutput((rtm)->_mdlRefSfcnS))
#endif
#ifndef rtmGetVarNextHitTime
#define rtmGetVarNextHitTime(rtm, sti) (_ssGetVarNextHitTime((rtm)->_mdlRefSfcnS,  o1netmgexj[sti]))
#endif
#ifndef rtmSetVarNextHitTime
#define rtmSetVarNextHitTime(rtm, sti, val) ssSetTimeOfNextVarHit((rtm)->_mdlRefSfcnS,  o1netmgexj[sti], val)
#endif
extern int_T o1netmgexj [ 1 ] ;
#endif
