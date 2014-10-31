//
//  GLMianClassificationModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECMianClassificationModel.h"

@implementation ECMianClassificationModel
- (id)mapAttributes
{
    NSDictionary *params = @{@"errorCode"         : @"error_code",
                             @"errorMsg"          : @"error_msg",
                             @"classification"    : @"classification",
                             };
    return params;
}
@end
