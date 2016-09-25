function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <Root>/Phi */
	this.urlHashMap["rtwdemo_roll:1"] = "rtwdemo_roll.c:95&rtwdemo_roll.h:54";
	/* <Root>/Psi */
	this.urlHashMap["rtwdemo_roll:2"] = "rtwdemo_roll.h:55";
	/* <Root>/P */
	this.urlHashMap["rtwdemo_roll:3"] = "rtwdemo_roll.h:56";
	/* <Root>/TAS */
	this.urlHashMap["rtwdemo_roll:4"] = "rtwdemo_roll.h:57";
	/* <Root>/AP_Eng */
	this.urlHashMap["rtwdemo_roll:5"] = "rtwdemo_roll.c:74,88&rtwdemo_roll.h:58";
	/* <Root>/HDG_Mode */
	this.urlHashMap["rtwdemo_roll:6"] = "rtwdemo_roll.c:50&rtwdemo_roll.h:59";
	/* <Root>/HDG_Ref */
	this.urlHashMap["rtwdemo_roll:7"] = "rtwdemo_roll.h:60";
	/* <Root>/Turn_Knob */
	this.urlHashMap["rtwdemo_roll:8"] = "rtwdemo_roll.c:51&rtwdemo_roll.h:61";
	/* <Root>/BasicRollMode */
	this.urlHashMap["rtwdemo_roll:9"] = "rtwdemo_roll.c:68,122&rtwdemo_roll.h:47";
	/* <Root>/EngSwitch */
	this.urlHashMap["rtwdemo_roll:10"] = "rtwdemo_roll.c:72,82";
	/* <Root>/HeadingMode */
	this.urlHashMap["rtwdemo_roll:11"] = "rtwdemo_roll.c:41,126&rtwdemo_roll.h:48";
	/* <Root>/ModeSwitch */
	this.urlHashMap["rtwdemo_roll:12"] = "rtwdemo_roll.c:47,66";
	/* <Root>/Zero */
	this.urlHashMap["rtwdemo_roll:32"] = "rtwdemo_roll.c:73";
	/* <Root>/Ail_Cmd */
	this.urlHashMap["rtwdemo_roll:33"] = "rtwdemo_roll.c:84&rtwdemo_roll.h:66";
	/* <S1>/Abs */
	this.urlHashMap["rtwdemo_roll:18"] = "rtwdemo_roll.c:48";
	/* <S1>/MinusSix */
	this.urlHashMap["rtwdemo_roll:25"] = "rtwdemo_roll.c:93";
	/* <S1>/NotEngaged */
	this.urlHashMap["rtwdemo_roll:20"] = "rtwdemo_roll.c:89";
	/* <S1>/Or */
	this.urlHashMap["rtwdemo_roll:26"] = "rtwdemo_roll.c:96";
	/* <S1>/RefSwitch */
	this.urlHashMap["rtwdemo_roll:27"] = "rtwdemo_roll.c:92,110";
	/* <S1>/RefThreshold1 */
	this.urlHashMap["rtwdemo_roll:21"] = "rtwdemo_roll.c:97";
	/* <S1>/RefThreshold2 */
	this.urlHashMap["rtwdemo_roll:22"] = "rtwdemo_roll.c:98";
	/* <S1>/Six */
	this.urlHashMap["rtwdemo_roll:28"] = "rtwdemo_roll.c:94";
	/* <S1>/TKSwitch */
	this.urlHashMap["rtwdemo_roll:24"] = "rtwdemo_roll.c:53,58";
	/* <S1>/TKThreshold */
	this.urlHashMap["rtwdemo_roll:23"] = "rtwdemo_roll.c:52";
	/* <S1>/Three */
	this.urlHashMap["rtwdemo_roll:29"] = "rtwdemo_roll.c:49";
	/* <S1>/Zero */
	this.urlHashMap["rtwdemo_roll:30"] = "rtwdemo_roll.c:105";
	/* <S2>/Enable */
	this.urlHashMap["rtwdemo_roll:19:3"] = "rtwdemo_roll.c:87,116";
	/* <S2>/FixPt
Data Type
Duplicate1 */
	this.urlHashMap["rtwdemo_roll:19:4"] = "msg=rtwMsg_notTraceable&block=rtwdemo_roll/RollAngleReference/LatchPhi/FixPt%20Data%20Type%20Duplicate1";
	/* <S2>/FixPt
Unit Delay1 */
	this.urlHashMap["rtwdemo_roll:19:5"] = "rtwdemo_roll.c:44,59,101,104,111&rtwdemo_roll.h:49";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
	RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
