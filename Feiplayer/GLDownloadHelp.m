//
//  GLDownloadHelp.m
//  DownloadManage
//
//  Created by lynd on 14-5-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLDownloadHelp.h"

@implementation GLDownloadHelp

- (NSString*)calculateSpeedString:(CGFloat)receivedDataSize startTime:(NSTimeInterval)time
{
    if (time == 0 && receivedDataSize == 0) {
        return nil;
    }
    CGFloat speed = receivedDataSize / ([NSDate timeIntervalSinceReferenceDate] - time);
   NSString *string = [NSByteCountFormatter stringFromByteCount:speed countStyle:NSByteCountFormatterCountStyleDecimal];
    string = [string stringByAppendingString:@"/s"];
    
    return string;
}

- (NSString *)getFileSizeString:(float )size
{
    if(size >=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",size /1024/1024];
    }
    else if(size>=1024&&size<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",size/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",size];
    }
}

- (NSString *)audioPathWithFileName:(NSString *)name audioType:(GLAudioType)type
{
    NSString *path = nil;
    if (type == GLZHType) {
        path = [[[self documentPath]stringByAppendingPathComponent:@"Audio"] stringByAppendingPathComponent:@"zh"];
    }else if (type == GLHKType){
        path = [[[self documentPath]stringByAppendingPathComponent:@"Audio"] stringByAppendingPathComponent:@"hk"];
    }else if(type == GLENType){
        path = [[[self documentPath]stringByAppendingPathComponent:@"Audio"] stringByAppendingPathComponent:@"en"];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",name];
    BOOL succeed =  [self createFileAtPath:path];
    if (!succeed) {
        return nil;
    }
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}

- (NSString *)videoTempPathWithFileName:(NSString *)name
{
    NSString *fileName = [NSString stringWithFormat:@"%@.rmvb",name];
    NSString *path = [[self tempFolder] stringByAppendingPathComponent:fileName];
    return path;
}

- (NSString *)audioTempPathWithFileName:(NSString *)name
{
    NSString *fileName = [NSString stringWithFormat:@"%@.mp3",name];
    NSString *path = [[self tempFolder] stringByAppendingPathComponent:fileName];
    
    return path;
}

- (NSString *)tempFolder
{
    NSString *path = [[self documentPath] stringByAppendingPathComponent:@"Temp"];
    BOOL succeed =  [self createFileAtPath:path];
    if (!succeed) {
        NSLog(@"临时文件创建失败");
        return nil;
    }
    return path;
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:path];
}

- (BOOL)createFileAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL succeed;
    if (![self fileExistsAtPath:path]) {
        NSError *error;
        succeed = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }else{
        succeed = YES;
    }
    return succeed;
}
//documents/user/xxxx/audio
- (NSString *)audioPathWithFileID:(NSString *)fileId
{
    NSString *path = [[self userPath] stringByAppendingPathComponent:fileId];
    path = [path stringByAppendingPathComponent:@"audio"];
    [self createFileAtPath:path];
    return path;
}

- (NSString *)videoPathWithFileName:(NSString *)name andFileId:(NSString *)fileID
{
    NSString *fileName = [NSString stringWithFormat:@"%@.rmvb",name];
    NSString *path = [[self userPath] stringByAppendingPathComponent:fileID];
    [self createFileAtPath:path];
    
    path = [path stringByAppendingPathComponent:fileName];
    return path;
}

- (NSString *)downloadPathWith:(NSString *)fileId andEpisode:(NSString *)episode
{
    
    NSParameterAssert(fileId);
    NSParameterAssert(episode);
    NSString *path = [[[self userPath] stringByAppendingPathComponent:fileId] stringByAppendingPathComponent:episode];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"username"];
    [self createFileAtPath:path];
    
    NSString *filePath = [[userName stringByAppendingPathComponent:fileId] stringByAppendingPathComponent:episode];
    return filePath;
}

- (NSString *)userPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"username"];
    NSString *path = [[self documentPath] stringByAppendingPathComponent:userName];
    [self createFileAtPath:path];
    return path;
}

- (NSString *)documentPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = searchPaths[0];
    return documentDirectory;
}

@end
