//
//  GLAppUserDefaults.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLAppUserDefaults.h"

@implementation GLAppUserDefaults
+ (BOOL)boolValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (NSString *)stringValueForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key];
}

+ (void)setBoolValue:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (void)setUserDefaultsValue:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKeyPath:key];
    [defaults synchronize];
}

@end
