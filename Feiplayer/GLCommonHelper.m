//
//  LTCommonHelper.m
//  checkVLCFile
//
//  Created by lynd on 13-12-21.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import "GLCommonHelper.h"
#import <CommonCrypto/CommonDigest.h>
@implementation GLCommonHelper
+ (NSString *)md5StringForData:(NSData*)data{
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, data.length, r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (NSString *)md5StringForString:(NSString*)str{
   
    if (![str length]) {
        NSLog(@"MD5 Str %@",str);
        return nil;
    }
    const char *ptr = [str UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return [NSString stringWithString:output];
}

+ (NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)getTargetPathWithBasepath:(NSString *)name subpath:(NSString *)subpath {
    
    NSString *pathstr = [[self class]getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr = [pathstr stringByAppendingPathComponent:subpath];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathstr])
    {
        [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    return pathstr;
}

+ (NSArray *)getTargetPathWithBasepath:(NSString *)name subpatharr:(NSArray *)arr{
    NSMutableArray *patharr = [[NSMutableArray alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *pathstr = [[self class]getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    for (NSString *str in arr) {
        NSString *path = [pathstr stringByAppendingPathComponent:str];
        
        if(![fileManager fileExistsAtPath:path])
        {
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            if(!error)
            {
                NSLog(@"%@",[error description]);
            }
        }
        [patharr addObject:path];
    }
    return patharr;
}

+ (NSString *)getFilePlistFloderPathWithBasepath:(NSString *)name subpath:(NSString *)str{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *pathstr = [[self class]getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr = [pathstr stringByAppendingPathComponent:str];
    if(![fileManager fileExistsAtPath:pathstr])
    {
        BOOL t =  [fileManager createDirectoryAtPath:pathstr withIntermediateDirectories:YES attributes:nil error:&error];
        if (!t) {
            return nil;
        }
    }
    pathstr = [pathstr stringByAppendingPathComponent:@"FileInfo.plist"];
    return pathstr;
}

+ (NSDate *)makeDate:(NSString *)birthday
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd HH:mm:ss"];    
    NSDate *date=[df dateFromString:birthday];
    NSLog(@"%@",date);
    return date;
}

+ (NSString *)dateToString:(NSDate*)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    /*[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];*/
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    return datestr;
}

+ (uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    return totalFreeSpace;
}

+ (uint64_t)getTotalDiskspace {
    uint64_t totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    return totalSpace;
}

+ (NSString *)getDiskSpaceInfo {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    }else
        return nil;
    NSString *infostr = [NSString stringWithFormat:@"%.2f GB 可用/总共 %.2f GB", ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f, ((totalSpace/1024.0f)/1024.0f)/1024.0f];
    return infostr;
}

@end
