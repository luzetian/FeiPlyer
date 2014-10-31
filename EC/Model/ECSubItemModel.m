//
//  GLSeriesModel.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECSubItemModel.h"

@implementation ECSubItemModel
- (id)mapAttributes
{
    NSDictionary *params = @{@"seriesTitle": @"dict_desc",
                             @"state": @"r_status",
                             @"type": @"type",
                             @"seriesRequesParam": @"requetsParam",
                             @"subItem": @"subitems"
                             };
    return params;
}
@end
