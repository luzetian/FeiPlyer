//
//  ECDictationModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECDictationModel.h"

@implementation ECDictationModel
- (id)mapAttributes
{
    NSDictionary *param = @{
                            @"testId"       : @"test_id",
                            @"testType"     : @"test_type",
                            @"videoId"      : @"video_id",
                            @"cnSubject"    : @"cn_subject",
                            @"integral"     : @"integral",
                            @"optionId"     : @"option_id",
                            @"optionType"   : @"option_type",
                            @"actionType"   : @"action_type",
                            @"option"       : @"option",
                            @"cnOption"     : @"cn_option",
                            @"beginTime"    : @"time1",
                            @"Endtime"      : @"time2",
                            };
    return param;
}
@end
