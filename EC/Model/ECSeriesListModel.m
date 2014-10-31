//
//  GLSeriesListModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECSeriesListModel.h"

@implementation ECSeriesListModel
- (id)mapAttributes
{
    NSDictionary *param = @{@"seriesId"     :   @"series_id",
                            @"enVideoName"  :   @"en_video_name",
                            @"zhVideoName"  :   @"zh_video_name",
                            @"thumb"        :   @"thumb",
                            @"type"         :   @"type",
                            @"videoType"    :   @"video_type",
                            @"requetsParam" :   @"requetsParam",
                            @"videoStatus"  :   @"video_status"
                            };
    return param;
}
@end
