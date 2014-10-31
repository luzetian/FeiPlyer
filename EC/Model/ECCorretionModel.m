//
//  ECCorretionModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECCorretionModel.h"

@implementation ECCorretionModel
- (id)mapAttributes
{
    NSDictionary *param = @{@"actionType"       : @"action_type",
                            @"actionTypeName"   : @"action_type_name",
                            @"cnOption"         : @"cn_option",
                            @"integral"         : @"integral",
                            @"optionId"         : @"option_id",
                            @"optionType"       : @"option_type",
                            @"optionTypeName"   : @"option_type_name",
                            @"createTime"       : @"r_create_time",
                            @"modifyStaff"      : @"r_modify_staff",
                            @"sort"             : @"sort",
                            @"status"           : @"status",
                            @"subject"          : @"subject",
                            @"testId"           : @"test_id",
                            @"testType"         : @"test_type",
                            @"videoId"          : @"video_id"
                            };
    return param;
}
@end

/*
 {
 "action_type" = delbehind;
 "action_type_name" = "\U540e\U9762\U5220\U9664";
 "cn_option" = "";
 "cn_subject" = "";
 integral = 0;
 option = that;
 "option_id" = 5242;
 "option_type" = syntax;
 "option_type_name" = "\U8bed\U6cd5";
 "r_create_staff" = test5;
 "r_create_time" = "2014-08-09 15:50:44";
 "r_modify_staff" = "<null>";
 "r_modify_time" = "<null>";
 sort = 100;
 status = 1;
 subject = "said ";
 "test_id" = 4207;
 "test_type" = A;
 "video_id" = 3612;
 }
 */