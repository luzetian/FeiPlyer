//
//  GLVideoInfoModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECVideoInfoModel.h"

@implementation ECVideoInfoModel
- (id)mapAttributes
{
    NSDictionary *params = @{@"errorCode"   : @"error_code",
                             @"errorMsg"    : @"error_msg",
                             @"videoInfo"   : @"video_info",
                             @"multipleChoice": @"data_c",
                             @"correction"  : @"data_a",
                             @"fillBlank"   : @"data_b",
                             @"dictation"   : @"data_d",
                             @"testResults" : @"userAnswers",
                             @"testSort"    : @"testSort"
                             };
    return params;
}

/*
 
 video_id":"视频ID",
 "en_video_name":"英文标题",
 "zh_video_name":"中文标题",
 "thumb":"缩略图",
 "type":"视频分类",
 "video_type":"顶级分类",
 "video_type1":"下级分类",
 "total_episodes":"总集数",
 "upload_episodes":"已上传集数",
 "file_type":"文件类型",
 "is_focus":"是否焦点新闻，1-是，0-否",
 "is_compilations":"是否合集，Y-是，N-否",
 "compilations_id":"合集ID",
 "r_create_staff":"创建人",
 "r_create_time":"创建时间",
 "r_modify_staff":"修改人",
 "r_modify_time":"修改时间",
 "sort_nbr":"排序",
 "video_status":"视频状态,0-下架,1-正常",
 "episode_id":"42",
 "video_episode":"视频集数，表明是视频的第几集",
 "video_mins":"视频时长，以分为单位",
 "video_url":"视频地址",
 "zh_audio_url":"中文音频地址",
 "en_audio_url":"英文音频地址",
 "zh_subtitle_url":"中文字幕地址",
 "en_subtitle_url":"英文字幕地址",
 "ja_subtitle_url":"日漫原声字幕",
 "en_background":"英文视频背景",
 "zh_background":"中文视频背景",
 "content_need_correction":"视频内容,需要纠错",
 "content_half_tips":"视频内容,半提示",
 "content_all_tips":"频内容,全提示",
 "is_encrypted":"加密状态，Y-加密,N-不加密",
 "episode_status":"分集状态，取值为：Y-正常 N-下架",
 "video_ordinary_url":"普通视频地址",
 "video_360_url":"360视频地址",
 "en_audio_ordinary_url":"普通音频地址",
 "en_audio_360_url":"360音频地址",
 "hk_audio_url":"粤语音频地址",
 "hk_audio_ordinary_url":"粤语普通音频地址",
 "hk_audio_360_url":"粤语360音频地址",
 "hk_subtitle_url":"粤语字幕地址",
 "video_type_name":"视频所属顶级分类名称",
 "video_type1_name":"视频所属下级分类名称 "}
 */
- (NSString *)videoId
{
    return [self JSONValueFor:@"video_id"];
}

- (NSString *)enVideoName
{
   return [self JSONValueFor:@"en_video_name"];
}

- (NSString *)zhVideoName
{
     return [self JSONValueFor:@"zh_video_name"];
}

- (NSString *)thumb
{
    return [self JSONValueFor:@"thumb"];
}

- (NSString *)videoType
{
    return [self JSONValueFor:@"video_type"];
}

- (NSString *)videoType1
{
    return [self JSONValueFor:@"video_type1"];
}

- (NSString *)totalEpisodes
{
   return [self JSONValueFor:@"total_episodes"];
}

- (NSString *)uploadEpisodes
{
    return [self JSONValueFor:@"upload_episodes"];
}

- (NSString *)fileType
{
    return [self JSONValueFor:@"file_type"];
}

- (NSString *)compilationsId
{
    return [self JSONValueFor:@"compilations_id"];
}

- (NSString *)zhAudioUrl
{
    return [self JSONValueFor:@"zh_audio_url"];
}

- (NSString *)enAudioUrl
{
    return [self JSONValueFor:@"en_audio_url"];
}

- (NSString *)zhSubtitleUrl
{
    return [self JSONValueFor:@"zh_subtitle_url"];
}

- (NSString *)enSubtitleUrl
{
    return [self JSONValueFor:@"en_subtitle_url"];
}

- (NSString *)jaSubtitleUrl
{
    return [self JSONValueFor:@"ja_subtitle_url"];
}

- (NSString *)enBackground
{
    return [self JSONValueFor:@"en_background"];
}

- (NSString *)zhBackground
{
    return [self JSONValueFor:@"zh_background"];
}

- (NSString *)contentNeedCorrection
{
    return [self JSONValueFor:@"content_need_correction"];
}

- (NSString *)contentHalfTips
{
    return [self JSONValueFor:@"content_half_tips"];
}

- (NSString *)contentAllTips
{
    return [self JSONValueFor:@"content_all_tips"];
}

- (NSString *)videoOrdinaryUrl
{
    return [self JSONValueFor:@"video_ordinary_url"];
}

- (NSString *)video360Url
{
    return [self JSONValueFor:@"video_360_url"];
}

- (NSString *)enAudioOrdinaryUrl
{
    return [self JSONValueFor:@"en_audio_ordinary_url"];
}

- (NSString *)enAudio360Url
{
    return [self JSONValueFor:@"en_audio_360_url"];
}

- (NSString *)hkAudioUrl
{
    return [self JSONValueFor:@"hk_audio_url"];
}

- (NSString *)hkAudioOrdinaryUrl
{
   return [self JSONValueFor:@"hk_audio_ordinary_url"];
}

- (NSString *)hkAudio360Url
{
    return [self JSONValueFor:@"hk_audio_360_url"];
}

- (NSString *)hkSubtitleUrl
{
    return [self JSONValueFor:@"hk_subtitle_url"];
}

- (NSString *)JSONValueFor:(NSString *)key
{
    if (!self.videoInfo || ![self.videoInfo count]) {
        return nil;
    }
    return self.videoInfo[key];
}

- (NSString *)description
{
    return [self.videoInfo description];
}

@end
