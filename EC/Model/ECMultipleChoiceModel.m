//
//  ECMultipleChoice.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECMultipleChoiceModel.h"

@implementation ECMultipleChoiceModel
- (id)mapAttributes
{
    NSDictionary *params = @{@"cnSubject": @"cn_subject",
                             @"enSubject": @"subject",
                             @"integral": @"integral",
                             @"options": @"options",
                             @"testId": @"test_id",
                             @"testType": @"test_type",
                             };
    return params;
}
@end
