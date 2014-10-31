//
//  GLVideoInfoModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

/*
 视频详细信息接口
 index.php/englishclassmobile/videoinfo
 error_code: "0",
 error_msg: "",
 video_info: {},
 dict_test_type: {},
 data_c: [ ],
 data_a: [ ],
 data_b: [ ],
 data_d: [ ]
 
 */

#import "GLBaseModel.h"

@interface ECVideoInfoModel : GLBaseModel

@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSDictionary *videoInfo;
@property (strong, nonatomic) NSArray *multipleChoice;
@property (strong, nonatomic) NSArray *correction;
@property (strong, nonatomic) NSArray *fillBlank;
@property (strong, nonatomic) NSArray *dictation;
@property (strong, nonatomic) NSArray *testResults;
@property (strong, nonatomic) NSDictionary *testSort;

//video_id":"视频ID",
@property (strong, nonatomic ,readonly) NSString *videoId;
//"en_video_name":"英文标题",
@property (strong, nonatomic ,readonly) NSString *enVideoName;
//"zh_video_name":"中文标题",
@property (strong, nonatomic ,readonly) NSString *zhVideoName;
//"thumb":"缩略图",
@property (strong, nonatomic ,readonly) NSString *thumb;
//"type":"视频分类",
@property (strong, nonatomic ,readonly) NSString *type;
// "video_type":"顶级分类",
@property (strong, nonatomic ,readonly) NSString *videoType;
//"video_type1":"下级分类",
@property (strong, nonatomic ,readonly) NSString *videoType1;
//"total_episodes":"总集数",
@property (strong, nonatomic ,readonly) NSString *totalEpisodes;
//"upload_episodes":"已上传集数",
@property (strong, nonatomic ,readonly) NSString *uploadEpisodes;
// is_focus":"是否焦点新闻，1-是，0-否",
@property (strong, nonatomic ,readonly) NSString *fileType;
//"compilations_id":"合集ID",
@property (strong, nonatomic ,readonly) NSString *compilationsId;
//"video_url":"视频地址",
@property (strong, nonatomic ,readonly) NSString *videoUrl;
//"zh_audio_url":"中文音频地址",
@property (strong, nonatomic ,readonly) NSString *zhAudioUrl;
//"en_audio_url":"英文音频地址",
@property (strong, nonatomic ,readonly) NSString *enAudioUrl;
//"zh_subtitle_url":"中文字幕地址"
@property (strong, nonatomic ,readonly) NSString *zhSubtitleUrl;
//"en_subtitle_url":"英文字幕地址",
@property (strong, nonatomic ,readonly) NSString *enSubtitleUrl;
//"ja_subtitle_url":"日漫原声字幕",
@property (strong, nonatomic ,readonly) NSString *jaSubtitleUrl;
// "en_background":"英文视频背景",
@property (strong, nonatomic ,readonly) NSString *enBackground;
//"zh_background":"中文视频背景",
@property (strong, nonatomic ,readonly) NSString *zhBackground;
//"content_need_correction":"视频内容,需要纠错",
@property (strong, nonatomic ,readonly) NSString *contentNeedCorrection;
//"content_half_tips":"视频内容,半提示",
@property (strong, nonatomic ,readonly) NSString *contentHalfTips;
//"content_all_tips":"频内容,全提示",
@property (strong, nonatomic ,readonly) NSString *contentAllTips;
// "video_ordinary_url":"普通视频地址",
@property (strong, nonatomic ,readonly) NSString *videoOrdinaryUrl;
// "video_360_url":"360视频地址",
@property (strong, nonatomic ,readonly) NSString *video360Url;
//"en_audio_ordinary_url":"普通音频地址",
@property (strong, nonatomic ,readonly) NSString *enAudioOrdinaryUrl;
//"en_audio_360_url":"360音频地址",
@property (strong, nonatomic ,readonly) NSString *enAudio360Url;
//"hk_audio_url":"粤语音频地址",
@property (strong, nonatomic ,readonly) NSString *hkAudioUrl;
//hk_audio_ordinary_url":"粤语普通音频地址",
@property (strong, nonatomic ,readonly) NSString *hkAudioOrdinaryUrl;
//"hk_audio_360_url":"粤语360音频地址",
@property (strong, nonatomic ,readonly) NSString *hkAudio360Url;
//"hk_subtitle_url":"粤语字幕地址",
@property (strong, nonatomic ,readonly) NSString *hkSubtitleUrl;
@end
