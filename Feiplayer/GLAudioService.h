//
//  GLAudioService.h
//  VLC For IOS
//
//  Created by lynd on 14-5-5.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol GLAudioServiceDelegate <NSObject>
@optional
- (void) convertMp3Finish:(NSString *)destinationPath;
- (void) updateSynthesisProgress:(float)progress;
- (void) synthesisCompletionFilePath:(NSString *)filePath;
- (void) synthesisCompletionError:(NSError *)error;
@end

@interface GLAudioService : NSObject
@property (nonatomic,assign) CMTime firstFileStartTime;
@property (nonatomic,assign) CMTime secondFileStartTime;

- (void)synthesisAudioFirstFilePath:(NSString *)firstPath
                         secondPath:(NSString *)secondPath
           synthesisDestinationPath:(NSString *)destinationPath;

- (void)startConvertMp3WithSampleRate:(CGFloat)sampleRate
                          PCMFilePath:(NSString *)PCMPath
                   MP3DestinationPath:(NSString *)mp3Path;

- (void)speechText:(NSString *)text withVoice:(NSString *)voice;
- (void)stopSpeech;
- (BOOL)isSpeeking;
@property (nonatomic,assign) id<GLAudioServiceDelegate>delegate;

@end
