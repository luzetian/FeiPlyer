//
//  LTRecorder.h
//  
//
//  Created by lynd on 13-12-18.
//  Copyright (c) 2013年 PES. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
@protocol GLRecorderDelegate<NSObject>

- (void)updateVolume:(Float32)volume;

@end

@interface GLRecorder : NSObject

- (BOOL)startRecordWithPath:(NSString *)path recoderFormat:(NSDictionary *)format;

- (void)stopRecordWithCompletionBlock:(void (^)())completion;

- (void)stopRecordWithCompletionFilePathBlock:(void (^)(NSURL *filePath))completion;

- (void)pause;

- (BOOL)isRecording;

+ (NSDictionary *)pcmFormate;

@property (nonatomic,readonly) NSURL *recorderPath;
@property (nonatomic,assign) id<GLRecorderDelegate> delegate;
@property (nonatomic) NSString * recordPath;
@property (nonatomic) float      recordTime;
@end
