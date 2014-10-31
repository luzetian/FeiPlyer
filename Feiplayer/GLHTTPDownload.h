//
//  GLHTTPDownload.h
//  DownloadDemo
//
//  Created by PES on 14-9-24.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLFile.h"

typedef NS_ENUM(NSUInteger, GLFileType) {
    GLVideoType,
    GLAudioCNType,
    GLAudioHKType,
    GLAudioENType,
};

@protocol GLHTTPDownloadDelegate <NSObject>

@optional
- (void)downloadFailedWithErrorDescription:(NSString *)description;
- (void)downloadProgress:(NSString *)progress fractionCompleted:(CGFloat)fraction speedRate:(NSString *)rate;

- (void)downloadFile:(MLFile *)file progress:(NSString *)progress fractionCompleted:(CGFloat)fraction speedRate:(NSString *)rate;
- (void)downloadCompleted;
- (void)stopDownloadWithFile:(MLFile *)file;
- (void)startDownloadName:(NSString *)name;
@end

@interface GLHTTPDownload : NSObject
+ (id)shareHTTPDowload;

- (void)addDownloadFile:(MLFile *)file;

- (void)startDownloadWithFile:(MLFile *)file;


- (void)pause;

- (BOOL)downloading;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic, readonly) NSArray *downloadList;
@property (strong, nonatomic) NSURL *url;
@property (assign, nonatomic) id<GLHTTPDownloadDelegate> delegate;

@end
