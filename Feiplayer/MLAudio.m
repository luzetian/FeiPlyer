//
//  MLAudio.m
//  Feiplayer
//
//  Created by PES on 14/10/30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "MLAudio.h"
#import "MLFile.h"


@implementation MLAudio

- (NSString *)hkPath
{
    if (self.file == nil) {
        NSLog(@" %@",self.file);
        return  nil;
    }
    NSString *hkAudioPath = [[[self rootPath] stringByAppendingPathComponent:self.file.basePath] stringByAppendingPathComponent:@"hk"];
    return hkAudioPath;
}

- (NSString *)enPath
{
    if (self.file == nil) {
        NSLog(@"%@",self.file);
        return nil;
    }
    NSString *enPath = [[[self rootPath] stringByAppendingPathComponent:self.file.basePath] stringByAppendingPathComponent:@"en"];
    return enPath;
}

- (NSString *)zhPath
{
    if (self.file == nil) {
        NSLog(@" %@",self.file);
        return  nil;
    }
    NSString *zhAudioPath = [[[self rootPath] stringByAppendingPathComponent:self.file.basePath] stringByAppendingPathComponent:@"zh"];
    return zhAudioPath;
}

- (NSString *)rootPath
{
    NSArray *searchArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentPath = [searchArray firstObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"username"];
    NSString *path = [doucmentPath stringByAppendingPathComponent:name];
    return path;
}

@dynamic enUrl;
@dynamic hkUrl;

@dynamic zhUrl;
@dynamic zhDownload;
@dynamic hkDwonload;
@dynamic file;
@dynamic hkPath;
@dynamic zhPath;
@dynamic enPath;
@end
