//
//  GLAppUserDefaults.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLModelConstants.h"
#define FIREST_LAUNCH @"app first launch"
#define REMEMBER_PASSWORD @"RememberPassword"

@interface GLAppUserDefaults : NSObject
+ (void)setBoolValue:(BOOL)value forKey:(NSString *)key;
+ (void)setUserDefaultsValue:(NSString *)value forKey:(NSString *)key;

+ (BOOL)boolValueForKey:(NSString *)key;
+ (NSString *)stringValueForKey:(NSString *)key;
@end
