//
//  GLVideoInfoModel.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLVideoInfoModel.h"

@implementation GLVideoInfoModel
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"filmEpisode"       : @"film_episode",
                             @"vedioURL"          : @"vedio_url",
                             @"isEncrypted"       : @"is_encrypted",
                             @"audio"             : @"audio",
                             @"subtitle"          : @"subtitle",
                             @"filmId"            : @"film_id",
                             @"filmName"          : @"film_name",
                             @"fileImageURL"      : @"film_pic",
                             @"upDateTime"        : @"update_time",
                             @"synopsis"          : @"synopsis",
                             @"totalEpisodes"     : @"total_episodes",
                             @"uploadEpisodes"    : @"upload_episodes",
                             @"mainActors"        : @"main_actors",
                             @"filmType"          : @"film_type",
                             @"commentTimes"      : @"comment_times",
                             @"commentScores"     : @"comment_scores",
                             @"languages"         : @"languages",
                             @"episodes"          : @"episodes",
                             @"director"          : @"director",
                             @"clickTimes"        : @"click_times",
                             @"fileType"          : @"file_type"
                             };

    return mapDic;
}
@end
