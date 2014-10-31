//
//  GLAudioService.m
//  VLC For IOS
//
//  Created by lynd on 14-5-5.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLAudioService.h"

@interface GLAudioService ()
{
     NSMutableArray *_audioMixParams;
     UIWebView *_webView;
     NSString *_category;
     AVSpeechSynthesizer *_synth;
     BOOL _isSpell;
}

@end

@implementation GLAudioService
#pragma mark
#pragma mark ---- 语音合成 ----

- (id)init
{
    self = [super init];
    if (self) {
          _category = [[AVAudioSession sharedInstance] category];
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

- (void)dealloc
{
    [[AVAudioSession sharedInstance] setCategory:_category error:nil];
}

- (void)synthesisAudioFirstFilePath:(NSString *)firstPath
                         secondPath:(NSString *)secondPath
           synthesisDestinationPath:(NSString *)destinationPath{
    
    NSFileManager *manage = [NSFileManager defaultManager];
    if (![manage fileExistsAtPath:firstPath]) {
        NSLog(@" firstPath :%@",firstPath);
        return;
    }
    if (![manage fileExistsAtPath:secondPath]) {
        NSLog(@" firstPath :%@",secondPath);
        return;
    }
    if ([manage fileExistsAtPath:destinationPath]) {
        NSError *error;
        [manage removeItemAtPath:destinationPath error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    [self firstSynthesisAudioPath:firstPath andSecondAudioPath:secondPath exportSynthesizedPath:destinationPath];
    
}

- (void) firstSynthesisAudioPath:(NSString *)pathOne andSecondAudioPath:(NSString *)pathTow exportSynthesizedPath:(NSString *)exportPath
{
    
    CMTime startTime = self.firstFileStartTime;
    CMTime startTime1 = self.secondFileStartTime;
    AVMutableComposition *composition = [AVMutableComposition composition];
    _audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
    //Add Audio Tracks to Composition
    
    NSURL *sourceURL = [NSURL fileURLWithPath:pathOne];
    [self setUpAndAddAudioAtPath:sourceURL toComposition:composition startTime:startTime];
    
    NSURL *sourceURL1 = [NSURL fileURLWithPath:pathTow];
    [self setUpAndAddAudioAtPath:sourceURL1 toComposition:composition startTime:startTime1];
    
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:_audioMixParams];
    
    //If you need to query what formats you can export to, here's a way to find out
    NSLog (@"compatible presets for songAsset: %@",
           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName: AVAssetExportPresetAppleM4A];
    
    exporter.audioMix = audioMix;
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                NSLog (@"AVAssetExportSessionStatusFailed: ");
                break;
            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted"); break;
            case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
            case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
            case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
            case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
            default:  NSLog (@"didn't get export status"); break;
        }
    }];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector (updateExportProgress:)
                                   userInfo:exporter
                                    repeats:YES];
    
}

- (void) setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition startTime:(CMTime)time{
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    CMTime trackDuration = songAsset.duration;

    CMTime startTime = CMTimeMake(0, 44100);
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:1.0f atTime:time];
    [_audioMixParams addObject:trackMix];
    
    //Insert audio into track
   [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:time error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (void)updateExportProgress:(id)time
{
    AVAssetExportSession *session;
    if([time isKindOfClass:[NSTimer class]])
        session = (AVAssetExportSession *)[time userInfo];
    else if([time isKindOfClass:[AVAssetExportSession class]])
        session = time;
    
    if (session.status == AVAssetExportSessionStatusExporting)
    {
        if ([self.delegate respondsToSelector:@selector(updateSynthesisProgress:)]) {
            [self.delegate updateSynthesisProgress:session.progress];
        }
    }
    else if(session.status == AVAssetExportSessionStatusCompleted)
    {
        NSLog(@"Exporting Ended");
        NSURL  *exportURL =  session.outputURL;
        if ([self.delegate respondsToSelector:@selector(synthesisCompletionFilePath:)]){
            [self.delegate synthesisCompletionFilePath:[exportURL path]];
        }
        if([time isKindOfClass:[NSTimer class]])
            [time invalidate];
    }
    else if(session.status == AVAssetExportSessionStatusFailed)
    {
        if ([self.delegate respondsToSelector:@selector(synthesisCompletionError:)]) {
            [self.delegate synthesisCompletionError:session.error];
        }
        if([time isKindOfClass:[NSTimer class]])
            [time invalidate];
        
    }
    else if(session.status == AVAssetExportSessionStatusCancelled)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Recording Export Cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
        if([time isKindOfClass:[NSTimer class]])
            [time invalidate];
    }
}

#pragma mark
#pragma mark ---- MP3 转码 ----
- (void)startConvertMp3WithSampleRate:(CGFloat)sampleRate
                          PCMFilePath:(NSString *)PCMPath
                   MP3DestinationPath:(NSString *)mp3Path
{
    
    if (!sampleRate || !PCMPath || !mp3Path) {
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:PCMPath]) {
        NSLog(@"%@",PCMPath);
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("com.pes.converMP3", NULL);
    dispatch_async(queue, ^{
        [self toMp3WithAudioSampleRate:sampleRate PCMFilePath:PCMPath MP3DestinationPath:mp3Path];
    });
    
}

- (void) toMp3WithAudioSampleRate:(CGFloat)sampleRate
                      PCMFilePath:(NSString *)PCMPath
               MP3DestinationPath:(NSString *)mp3Path
{
    /*
    
    if (!PCMPath || !mp3Path || !sampleRate) {
        return;
    }
    
    NSString *cafFilePath = PCMPath;
    NSString *mp3FilePath = mp3Path;
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, sampleRate);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        if ([self.delegate respondsToSelector:@selector(convertMp3Finish:)]) {
            [self.delegate convertMp3Finish:mp3FilePath];
        }
    }
     */
}

- (void)speechText:(NSString *)text withVoice:(NSString *)voiceStr
{
    if (![text length]) {
        NSLog(@"%@ , %@",text,voiceStr);
        return;
    }
    if (![voiceStr length]) {
        voiceStr = @"zh-TW";
    }
    if (SYSTEM_RUNS_IOS7_OR_LATER) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:voiceStr];
        utterance.voice = voice;
        utterance.rate = 0.3;
        if (!_synth) {
            _synth = [[AVSpeechSynthesizer alloc]init];
        }
        [_synth speakUtterance:utterance];
    }else{
        NSString *str = [NSString stringWithFormat:@"http: //translate.google.com/translate_tts?tl=en&q=%@",text];
        NSURL *url    = [NSURL URLWithString:str];
        NSURLRequest *request =
        [[NSURLRequest alloc]initWithURL:url];
        _webView = [[UIWebView alloc]init];
        [_webView loadRequest:request];
    }
}

- (BOOL)isSpeeking
{
    return _synth.isSpeaking;
}

- (void)stopSpeech
{
    if (_synth.isSpeaking) {
        [_synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (void)alertMsg:(NSError *)error
{
    NSString  *msg = [error localizedDescription];
    NSInteger code = [error code];
    NSString  *codeStr = [NSString stringWithFormat:@"错误代码:%d",code];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:codeStr message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
