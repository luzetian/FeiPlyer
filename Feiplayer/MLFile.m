//
//  MLFile.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "MLFile.h"
#import "GLDownloadHelp.h"
#import "GLMediaLibrary.h"
@implementation MLFile

+ (MLFile *)createFile
{
    GLMediaLibrary *library = [GLMediaLibrary sharedMediaLibrary];
    MLFile *file = (MLFile *)[library newObjectWithEntityName:@"File"];
    file.audio = (MLAudio *)[library newObjectWithEntityName:@"Audio"];
    file.subtitle = (MLSubtitle *)[library newObjectWithEntityName:@"Subtitle"];
    file.video = (MLVideo *)[library newObjectWithEntityName:@"Video"];
    return file;
}

- (void)setFilePath
{
    if (!self.audio || !self.video) {
        NSLog(@"%@",[self description]);
        return;
    }
    GLDownloadHelp *help = [[GLDownloadHelp alloc]init];
    NSString *path = [[[self class] rootPath]stringByAppendingPathComponent:self.basePath];
    [help createFileAtPath:path];
}

- (NSString *)basePath
{
    NSString *downloadPath = [self.fileID stringByAppendingPathComponent:self.episode];
    return downloadPath;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Video :\n%@\n%@\nAudio :\n%@\n%@\n%@\n%@\n Subtitle :\n%@\n%@\n",self.video.url,self.video.path,self.audio.enUrl,self.audio.hkUrl,self.audio.zhUrl,self.subtitle.enUrl,self.subtitle.zhUrl,self.subtitle.hkUrl];
}

+ (BOOL)deleteFileWithObject:(MLFile *)movie
{
    if (movie == nil) {
        NSLog(@"%@",movie);
        return NO;
    }
    NSError *error = nil;
    GLMediaLibrary *library = [GLMediaLibrary sharedMediaLibrary];
    NSFileManager *manager = [NSFileManager defaultManager];

    if ([manager fileExistsAtPath:movie.video.path]) {
        [manager removeItemAtPath:movie.video.path error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    if ([manager fileExistsAtPath:movie.audio.enPath]) {
        [manager removeItemAtPath:movie.audio.enPath error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    if ([manager fileExistsAtPath:movie.audio.hkPath]) {
        [manager removeItemAtPath:movie.audio.hkPath error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    if ([manager fileExistsAtPath:movie.audio.zhPath]) {
        [manager removeItemAtPath:movie.audio.zhPath error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    if (error) {
        NSLog(@"%@",error);
    }
    return [library deleteObject:movie atEntity:@"File"];
}

+ (NSString *)rootPath
{
    NSArray *searchArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentPath = [searchArray firstObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"username"];
    NSString *path = [doucmentPath stringByAppendingPathComponent:name];
    return path;
}

- (BOOL)isEqualFile:(MLFile *)file
{
    if ([self.video.url isEqualToString:file.video.url]) {
        return YES;
    }
    return NO;
}
@dynamic basePath;
@dynamic name;
@dynamic fileID;
@dynamic episode;
@dynamic video;
@dynamic audio;
@dynamic subtitle;

@end
