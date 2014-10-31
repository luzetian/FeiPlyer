//
//  MLVideo.m
//  Feiplayer
//
//  Created by PES on 14/10/30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "MLVideo.h"
#import "MLFile.h"


@implementation MLVideo

- (NSString *)path
{
    if (self.file == nil) {
        NSLog(@"%@",self.file);
        return nil;
    }
    NSString *videoPath = [[[self rootPath] stringByAppendingPathComponent:self.file.basePath] stringByAppendingPathComponent:@"video"];
    return videoPath;
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

@dynamic path;
@dynamic url;
@dynamic file;

@end
