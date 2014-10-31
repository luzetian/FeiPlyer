//
//  ECExamAnswers.m
//  EnglishRoom
//
//  Created by PES on 14-9-19.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECExamAnswers.h"

@implementation ECExamAnswers
- (id)init
{
    self = [super init];
    self.startTime = [NSString stringWithFormat:@"%ld",time(NULL)];
    return self;
}

@end
