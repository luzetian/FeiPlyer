//
//  GLClassificationModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECClassificationModel.h"

@implementation ECClassificationModel
- (id)mapAttributes
{
    NSDictionary *params = @{@"subitems"                     : @"subitems",
                             @"status"                       : @"r_status",
                             @"classificationTitle"          : @"dict_desc",
                             @"classificationType"           : @"type"
                             };
    return params;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"subitems : %@ \n classificationTitle :%@\n classificationType : %@\n",self.subitems,self.classificationTitle,self.classificationType];
    return description;
}

@end
