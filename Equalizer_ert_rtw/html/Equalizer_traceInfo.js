function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S1>/Band 1 
DF1 */
	this.urlHashMap["dspparameq:3"] = "Equalizer.c:26,181,184";
	/* <S1>/Band 2 
DF2 */
	this.urlHashMap["dspparameq:21"] = "Equalizer.c:81,186,189";
	/* <S1>/Band 3 
DF2T */
	this.urlHashMap["dspparameq:39"] = "Equalizer.c:132,191,194";
	/* <S1>/Coeffs for Band1 */
	this.urlHashMap["dspparameq:57"] = "Equalizer.c:34";
	/* <S1>/Coeffs for Band2 */
	this.urlHashMap["dspparameq:58"] = "Equalizer.c:90";
	/* <S1>/Coeffs for Band3 */
	this.urlHashMap["dspparameq:59"] = "Equalizer.c:140";
	/* <S3>/Biquad Filter */
	this.urlHashMap["dspparameq:6"] = "Equalizer.c:46,70&Equalizer.h:37,47,48";
	/* <S3>/Discrete Filter */
	this.urlHashMap["dspparameq:113"] = "Equalizer.c:33,44,72,78&Equalizer.h:36,46,51";
	/* <S4>/Biquad Filter */
	this.urlHashMap["dspparameq:24"] = "Equalizer.c:102,121&Equalizer.h:35,45";
	/* <S4>/Discrete Filter */
	this.urlHashMap["dspparameq:114"] = "Equalizer.c:89,100,123,129&Equalizer.h:34,44,50";
	/* <S5>/Biquad Filter */
	this.urlHashMap["dspparameq:42"] = "Equalizer.c:18,151,165&Equalizer.h:43,69";
	/* <S5>/Discrete Filter */
	this.urlHashMap["dspparameq:115"] = "Equalizer.c:139,149,167,173&Equalizer.h:33,42,49";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
	RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
