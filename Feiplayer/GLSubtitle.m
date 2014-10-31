//
//  LTSubtitle.m
//  Subtitle_Demo
//
//  Created by lynd on 13-11-21.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import "GLSubtitle.h"
@implementation GLSubtitle
- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"sequence number %d\n ,content : %@\n",self.sequenceNumber,self.content];
    return description;
}
@end
