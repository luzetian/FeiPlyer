//
//  ECFillBlankModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECFillBlankModel.h"

@implementation ECFillBlankModel
- (id)mapAttributes
{
    NSDictionary *param = @{
                            @"testId"   : @"test_id",
                            @"testType" : @"test_type",
                            @"videoId"  : @"video_id",
                            @"subject"  : @"subject",
                            @"cnSubject": @"cn_subject",
                            @"integral" : @"integral",
                            @"status"   : @"status",
                            @"optionId" : @"option_id",
                            @"optionType": @"option_type",
                            @"cnOption" : @"cn_option",
                            @"option"   :@"option"
                            };
    return param;
}
@end
