//
//  GLVideoModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECVideoModel.h"

@implementation ECVideoModel
- (id)mapAttributes
{
    NSDictionary *param = @{@"videoId": @"video_id",
                            @"enVideoName": @"en_video_name",
                            @"zhVideoName": @"zh_video_name",
                            @"thumb": @"thumb",
                            @"type": @"type",
                            @"videoType": @"video_type",
                            @"videoType1": @"video_type1",
                            @"totalEpisodes": @"total_episodes",
                            @"uploadEpisodes": @"upload_episodes",
                            @"fileType": @"file_type",
                            @"focus": @"is_focus",
                            @"compilations": @"is_compilations",
                            @"compilationsId": @"compilations_id",
                            @"createStaff": @"r_create_staff",
                            @"createTime": @"r_create_time",
                            @"modifyStaff": @"r_modify_staff",
                            @"modifyTime": @"r_modify_time",
                            @"sortNbr": @"sort_nbr",
                            @"videoStatus": @"video_status",
                            @"contentAllTips": @"content_all_tips"
                            
                            };
    return param;
}
@end
