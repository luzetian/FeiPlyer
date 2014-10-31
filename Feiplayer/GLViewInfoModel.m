//
//  GLViewInfoModel.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLViewInfoModel.h"
@interface GLViewInfoModel()
@property (strong, nonatomic) NSDictionary *infomation;
@end
@implementation GLViewInfoModel
- (id)initWithItem:(NSDictionary *)item
{
    if (item == nil || ![item count]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _infomation = item;
    }
    return self;
}

-(NSString *)className
{
    return _infomation[@"class"];
}

- (NSString *)categoryName
{
    return _infomation[@"typeName"];
}

- (NSArray *)categoryParameters
{
    return _infomation[@"subTypes"];
}

- (NSArray *)categoryTitle
{
    return _infomation[@"subTypeName"];
}
@end
