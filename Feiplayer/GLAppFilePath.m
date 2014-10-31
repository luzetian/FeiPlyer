//
//  LTFileManager.m
//  checkVLCFile
//
//  Created by lynd on 13-12-20.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import "GLAppFilePath.h"
@interface GLAppFilePath(){
    
}

@end

@implementation GLAppFilePath

+ (BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (NSString *)documentPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = searchPaths[0];
    return directoryPath;
}

+ (NSString *)tempFloderPath
{
    NSString *tempPath = [[self documentPath] stringByAppendingPathComponent:@"Temp"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:tempPath]) {
        NSError *error;
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
            return nil;
        }
    }
    return tempPath;
}

+ (BOOL)createDirectorAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
            return NO;
        }
    }
    return YES;
}

+ (NSString *)audioPathWithFileName:(NSString *)name
{
    NSString *audioPath = [[self documentPath] stringByAppendingPathComponent:@"Audio"];
    if (![self createDirectorAtPath:audioPath]) {
        return nil;
    }
    return [audioPath stringByAppendingPathComponent:name];
}

+ (NSString *)flacFilePath
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"aaa.flac"];
    return filePath;
}

+ (NSString *)wavFilePath
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bbb.wav"];
    return filePath;
}

+ (NSString *)pcmFilePath
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ccc.caf"];
    return filePath;
}

@end
