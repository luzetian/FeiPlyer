//
//  MLFile.h
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MLAudio.h"
#import "MLVideo.h"
#import "MLSubtitle.h"

@interface MLFile : NSManagedObject
+ (BOOL)deleteFileWithObject:(MLFile *)movie;
+ (MLFile *)createFile;
- (void)setFilePath;
- (BOOL)isEqualFile:(MLFile *)file;

@property (nonatomic, retain, readonly) NSString * basePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * fileID;
@property (nonatomic, retain) NSString * episode;
@property (nonatomic, retain) MLVideo *video;
@property (nonatomic, retain) MLAudio *audio;
@property (nonatomic, retain) MLSubtitle *subtitle;

@end
