#include "__cf_GalvoModel_v53.h"
#include "GalvoModel_v53_capi.h"
#include "GalvoModel_v53.h"
#include "GalvoModel_v53_private.h"
int_T o1netmgexj [ 1 ] ; static RegMdlInfo rtMdlInfo_GalvoModel_v53 [ 29 ] =
{ { "jycjl4j2ddp" , MDL_INFO_NAME_MDLREF_DWORK , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "jycjl4j2dd" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "bndrfrkptd" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "inn304mpew" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "gvp5axjljx" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "mwhievh55p" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "ksmwlcv2xl" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "gab5xcex3x" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "nbe0qd34ym" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "nvxe1raao0" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "e0jslmtl0f" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "ji45t3fxlq" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "h2btwmg4e0" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "fjlyi5akpb" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "kieouthb4t" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "ewvetx1tlq" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "nibvssgug0" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "musrh40ndy" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "kvvmqzdoiu" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "dgz4m3u3m1" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "ovbcscrygm" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "GalvoModel_v53" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , 0 , ( NULL ) } ,
{ "psq0yla42i" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "oml3hqtcy5" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "o1netmgexj" ,
MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * ) "GalvoModel_v53" } ,
{ "kwrlbl1yb3j" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 , - 1 , ( void * )
"GalvoModel_v53" } , { "kwrlbl1yb3" , MDL_INFO_ID_GLOBAL_RTW_CONSTRUCT , 0 ,
- 1 , ( void * ) "GalvoModel_v53" } , { "GalvoModel_v53.h" ,
MDL_INFO_MODEL_FILENAME , 0 , 0 , ( NULL ) } , { "GalvoModel_v53.c" ,
MDL_INFO_MODEL_FILENAME , 0 , 0 , ( NULL ) } } ; jycjl4j2ddp jycjl4j2dd ;
void kvvmqzdoiu ( real_T * localX_ ) { ksmwlcv2xl * localX = ( ksmwlcv2xl * )
localX_ ; localX -> dqmkzrbaiy = 0.0 ; localX -> lppk5jtuup = 0.0 ; } void
GalvoModel_v53 ( real_T * kfpnfjrahl , real_T * ojwk2equzc , real_T *
avxpotx1yo , real_T * localX_ ) { oml3hqtcy5 * const czvgkvhwqf = & (
jycjl4j2dd . rtm ) ; h2btwmg4e0 * localB = & ( jycjl4j2dd . rtb ) ;
ji45t3fxlq * localDW = & ( jycjl4j2dd . rtdw ) ; ksmwlcv2xl * localX = (
ksmwlcv2xl * ) localX_ ; real_T hdowmpvr4x ; hdowmpvr4x = localX ->
dqmkzrbaiy ; * ojwk2equzc = 1.6666666666666668E+7 * hdowmpvr4x ; * kfpnfjrahl
= 0.0097402825172239957 * * ojwk2equzc ; localB -> cps43hxgyx = localX ->
lppk5jtuup ; if ( rtmIsMajorTimeStep ( czvgkvhwqf ) ) { localDW -> ftsjqejhwn
= localB -> cps43hxgyx >= 0.3490658503988659 ? 1 : localB -> cps43hxgyx > -
0.3490658503988659 ? 0 : - 1 ; } * avxpotx1yo = localDW -> ftsjqejhwn == 1 ?
0.3490658503988659 : localDW -> ftsjqejhwn == - 1 ? - 0.3490658503988659 :
localB -> cps43hxgyx ; localB -> hmathssibw = 4.0E-12 * * ojwk2equzc ; } void
musrh40ndy ( const real_T * malqimew2r ) { h2btwmg4e0 * localB = & (
jycjl4j2dd . rtb ) ; localB -> iamo4hgwh2 = 0.0093 * * malqimew2r ; localB ->
eoojnoviir = ( localB -> iamo4hgwh2 - 0.0 ) - localB -> hmathssibw ; } void
nibvssgug0 ( const real_T * malqimew2r , real_T * ojwk2equzc , real_T *
localXdot_ ) { h2btwmg4e0 * localB = & ( jycjl4j2dd . rtb ) ; mwhievh55p *
localXdot = ( mwhievh55p * ) localXdot_ ; localB -> iamo4hgwh2 = 0.0093 * *
malqimew2r ; localB -> eoojnoviir = ( localB -> iamo4hgwh2 - 0.0 ) - localB
-> hmathssibw ; { localXdot -> dqmkzrbaiy = localB -> eoojnoviir ; } {
localXdot -> lppk5jtuup = ( * ojwk2equzc ) ; } } void ewvetx1tlq ( const
real_T * malqimew2r , real_T * localZCSV_ ) { h2btwmg4e0 * localB = & (
jycjl4j2dd . rtb ) ; bndrfrkptd * localZCSV = ( bndrfrkptd * ) localZCSV_ ;
localB -> iamo4hgwh2 = 0.0093 * * malqimew2r ; localB -> eoojnoviir = (
localB -> iamo4hgwh2 - 0.0 ) - localB -> hmathssibw ; localZCSV -> gv5btpivpr
= localB -> cps43hxgyx - 0.3490658503988659 ; localZCSV -> bmmozip2yo =
localB -> cps43hxgyx - - 0.3490658503988659 ; } void dgz4m3u3m1 ( SimStruct *
_mdlRefSfcnS , int_T mdlref_TID0 , real_T * localX_ , void * sysRanPtr , int
contextTid , rtwCAPI_ModelMappingInfo * rt_ParentMMI , const char_T *
rt_ChildPath , int_T rt_ChildMMIIdx , int_T rt_CSTATEIdx ) { oml3hqtcy5 *
const czvgkvhwqf = & ( jycjl4j2dd . rtm ) ; h2btwmg4e0 * localB = & (
jycjl4j2dd . rtb ) ; ji45t3fxlq * localDW = & ( jycjl4j2dd . rtdw ) ;
ksmwlcv2xl * localX = ( ksmwlcv2xl * ) localX_ ; rt_InitInfAndNaN ( sizeof (
real_T ) ) ; ( void ) memset ( ( void * ) czvgkvhwqf , 0 , sizeof (
oml3hqtcy5 ) ) ; o1netmgexj [ 0 ] = mdlref_TID0 ; czvgkvhwqf -> _mdlRefSfcnS
= ( _mdlRefSfcnS ) ; { localB -> cps43hxgyx = 0.0 ; localB -> hmathssibw =
0.0 ; localB -> iamo4hgwh2 = 0.0 ; localB -> eoojnoviir = 0.0 ; } ( void )
memset ( ( void * ) localDW , 0 , sizeof ( ji45t3fxlq ) ) ;
GalvoModel_v53_InitializeDataMapInfo ( czvgkvhwqf , localDW , localX ,
sysRanPtr , contextTid ) ; if ( ( rt_ParentMMI != ( NULL ) ) && (
rt_ChildPath != ( NULL ) ) ) { rtwCAPI_SetChildMMI ( * rt_ParentMMI ,
rt_ChildMMIIdx , & ( czvgkvhwqf -> DataMapInfo . mmi ) ) ; rtwCAPI_SetPath (
czvgkvhwqf -> DataMapInfo . mmi , rt_ChildPath ) ;
rtwCAPI_MMISetContStateStartIndex ( czvgkvhwqf -> DataMapInfo . mmi ,
rt_CSTATEIdx ) ; } } void mr_GalvoModel_v53_MdlInfoRegFcn ( SimStruct *
mdlRefSfcnS , char_T * modelName , int_T * retVal ) { * retVal = 0 ; * retVal
= 0 ; ssRegModelRefMdlInfo ( mdlRefSfcnS , modelName ,
rtMdlInfo_GalvoModel_v53 , 29 ) ; * retVal = 1 ; }
