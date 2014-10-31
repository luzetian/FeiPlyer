//
//  GLNetworkConstants.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#ifndef Feiplayer_GLNetworkConstants_h
#define Feiplayer_GLNetworkConstants_h

#define kYOUDAO_BASE_AIP  @"http://fanyi.youdao.com/"
#define kYOUDAO_TRANS     @"openapi.do?"
#define kBAIDU_BASE_AIP   @"http://openapi.baidu.com/"
#define GOOGLE_AUDIO_URL  @"http://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=zh-CN"
#define BASE_URL          @"http://42.121.253.181/"
#define kWORD_BOOK_URL    @"http://42.121.253.181/index.php/movie/newword?sessionid="
#define kEXAM_URL         @"http://42.121.253.181/index.php/exam/kaoshi?sessionid="
//URL PATH
#define kSERIES_LIST      @"index.php/englishclassmobile/series"
#define kENGLISH_CLASS_MAIN @"index.php/englishclassmobile/classification"
#define kVIDEO_LIST       @"index.php/englishclassmobile/videolist"
#define kVIDEO_INFO       @"index.php/englishclassmobile/videoinfo"
#define kSUBMIT_TEST      @"index.php/englishclassmobile/dotest"
#define kTEST_RESULTS     @"index.php/englishclassmobile/result"
#define kHALF_TIPS        @"index.php/englishclassmobile/showtipshalf"
#define kALL_TIPS         @"index.php/englishclassmobile/showtipsfull"
#define SHOW_SUBTITLE     @"index.php/interface/showsubtitlepay/"
#define kBAIDU_TRANS      @"public/2.0/bmt/translate"
#define kGET_VIDEO        @"index.php/interface/getvideo"
#define kLOGIN_PATH       @"api/ipad/login.php/"
#define kMOVIE_DETAILS    @"api/ipad/details.php/"
#define kMOVIE_LIST       @"api/ipad/list.php/"
#define kSEND_TOKEN       @"index.php/interface/savetoken/"
#define kUSER_RIGHT       @"index.php/interface/getvideo"
#define kWORD_BOOK_TRANS  @"index.php/interface/trans"
#define kNEWS_STUDY_SERIES @"index.php/englishclassmobile/series"
#define kNEWS_STUDY       @"index.php/englishclassmobile/classification"
#define kNEWS_STUDY_VIDEOLIST @"index.php/englishclassmobile/videolist"
#define kNEWS_STUDY_VIDEOINFO @"index.php/englishclassmobile/videoinfo"
#define kTRANSLATE        @"index.php/interface/trans"
#define kTRANSLATESTUDY   @"index.php/interface/studytrans"
#define kSEARCH_MOVIE     @"api/ipad/search.php?"
//JS
#define kTranslateJS      @"document.getElementsByTagName('ul').item(1).innerHTML;"
#define kPhoneticJS       @"document.getElementsByClassName('phonetic').item(0).innerHTML;"

#define kCLICKED_ELEMENT  @"var element=document.getElementsByTagName('a').item(2);var evObj = document.createEvent('MouseEvents');evObj.initEvent('click',true,true);element.dispatchEvent(evObj)"

#define kGET_MOVIE_NAME   @"document.getElementsByTagName('a').item(2).innerHTML"
#define kGET_ALL_HTML     @"document.body.innerHTML"


#endif
