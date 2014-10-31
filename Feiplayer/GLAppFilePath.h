//
//  LTFileManager.h
//  checkVLCFile
//
//  Created by lynd on 13-12-20.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLAppFilePath : NSObject
+ (NSString *)documentPath;

+ (NSString *)tempFloderPath;

+ (NSString *)audioPathWithFileName:(NSString *)name;

+ (NSString *)flacFilePath;

+ (NSString *)wavFilePath;

+ (NSString *)pcmFilePath;

+ (BOOL)isExistFile:(NSString *)fileName;
@end
