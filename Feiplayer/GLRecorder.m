//
//  LTRecorder.m
//  VLC for iOS
//
//  Created by lynd on 13-12-18.
//  Copyright (c) 2013年 PES. All rights reserved.
//

#import "GLRecorder.h"

#import "GLAppFilePath.h"
@interface GLRecorder()<AVAudioRecorderDelegate>
{
    NSTimer * _timer;
    AVAudioRecorder * _recorder;
   
}
@end
@implementation GLRecorder
#define WAVE_UPDATE_FREQUENCY   0.05
@synthesize recorderPath = _recorderPath;
- (BOOL)startRecordWithPath:(NSString *)path recoderFormat:(NSDictionary *)format
{
    NSError * err = nil;
    NSLog(@"path %@",path);
	[[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&err];
    
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return NO;
	}
    
	//[audioSession setActive:YES error:&err];
    
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return NO;
	}
    self.recordPath = path;
	NSURL * url = [NSURL fileURLWithPath:self.recordPath];
	
	err = nil;
	
	NSData * audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
	if(audioData) {
        
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;

    if(_recorder) {
        [_recorder stop];
        _recorder = nil;
    }
    
	_recorder = [[AVAudioRecorder alloc] initWithURL:url settings:format error:&err];
    
	if(!_recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        return NO;
	}
	
	[_recorder setDelegate:self];

    if ([_recorder prepareToRecord]) {
        [_recorder record];
    }else{
        return NO;
    }
	_recorder.meteringEnabled = YES;
	
	
	[_recorder recordForDuration:(NSTimeInterval) 60];
    
    self.recordTime = 0;
    [self resetTimer];
    
	_timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    return YES;
}

- (void)stopRecordWithCompletionFilePathBlock:(void (^)(NSURL *filePath))completion
{
    [_recorder stop];
    completion(_recorder.url);

    [self resetTimer];

}

- (void)pause
{
    [_recorder pause];
}

- (void)stopRecordWithCompletionBlock:(void (^)())completion {
    
    if (_recorder.isRecording) {
        [_recorder stop];
    }
    [_recorder stop];
    _recorder = nil;
    [self resetTimer];
    completion();
}

-(void) resetTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    /*  发送updateMeters消息来刷新平均和峰值功率。
     *  此计数是以对数刻度计量的，-160表示完全安静，
     *  0表示最大输入值
     */
    
    if (_recorder) {
        [_recorder updateMeters];
    }
    
    float peakPower = [_recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    if ([self.delegate respondsToSelector:@selector(updateVolume:)]) {
        [self.delegate updateVolume:peakPowerForChannel];
    }
}

- (BOOL)isRecording
{
    if (_recorder) {
        return _recorder.isRecording;
    }
    return NO;
}

+ (NSDictionary *)pcmFormate
{
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    [recordSetting setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    
    return [recordSetting mutableCopy];
}

- (NSURL *)recorderPath
{
  return _recorder.url;
}

@end
