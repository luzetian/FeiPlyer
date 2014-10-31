//
//  FeiBaseModel.m
//  Feiplayer
//
//  Created by Lt on 13-9-10.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import "GLBaseModel.h"

@implementation GLBaseModel

- (id)initWithContent:(NSDictionary *)json
{
    self = [super init];
    
    if (self) {
        
        [self setModelData:json];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)mapAttributes
{
    return nil;
}

- (SEL)setterMethod:(NSString *)key
{
    NSString *first = [[key substringToIndex:1] capitalizedString];
    NSString *end = [key substringFromIndex:1];
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:", first, end];
    return NSSelectorFromString(setterName);
}

- (void)setModelData:(NSDictionary *)json 
{
    // 建立映射关系
    NSDictionary *mapDic = [self mapAttributes];
    
    for (id key in mapDic) {
        
        // setter 方法
        SEL sel = [self setterMethod:key];
       // SEL sce = @selector(sel);
        if ([self respondsToSelector:sel]) {
            
            // 得到JSON key
            id jsonKey = [mapDic objectForKey:key];
            
            // 得到JSON value
            id jsonValue = [json objectForKey:jsonKey];
            [self performSelector:sel withObject:jsonValue];
        }
    }
} // 属性赋值

@end
