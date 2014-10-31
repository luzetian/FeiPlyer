//
//  GLSubtitleParse.m
//  VLC For IOS
//
//  Created by lynd on 14-6-26.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLSubtitleParse.h"
#import "GLAudioService.h"
@interface GLSubtitleParse()
{
    BOOL _cutWord;
    BOOL _isSpell;
    GLAudioService *_audioService;
}

@property (nonatomic,strong) NSString *subtitle;
@property (nonatomic,assign) NSInteger subtitleIndex;
@end

@implementation GLSubtitleParse
- (id)initWithSubtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        self.subtitle = subtitle;
    }
    return self;
}

- (void)setNextSubtitle
{
    if ([_subtitle length]) {
        NSArray *array = [_subtitle componentsSeparatedByString:@" "];
        if (_subtitleIndex < ([array count] - 1)) {
            _subtitleIndex++;
        }
    }
    [self speechSingleSubtitle];
}

- (void)setBackSubtitle
{
    if (_subtitleIndex == 0) {
        return;
    }
    _subtitleIndex--;
    [self speechSingleSubtitle];
}

- (void)speechSeriesSubtitle
{
    [self speechText:_subtitle];
}

- (void)speechSingleSubtitle
{
    if ([_subtitle length]) {
        NSArray *array = [_subtitle componentsSeparatedByString:@" "];
        NSString *word;
        if (_subtitleIndex < [array count]) {
            word = [array objectAtIndex:_subtitleIndex];
        }else{
            word = [array lastObject];
        }
        [self speechText:word];
    }
}

- (void)spellSingleSubtile
{
    if ([_subtitle length]) {
        NSArray *array = [_subtitle componentsSeparatedByString:@" "];
        NSString *word;
        if (_subtitleIndex < [array count]) {
            word = [array objectAtIndex:_subtitleIndex];
        }else{
            word = [array lastObject];
        }
        for (NSInteger index = 0; index < [word length]; index ++) {
            NSRange range = NSMakeRange(index, 1);
            NSString *str = [word substringWithRange:range];
            _isSpell = YES;
            [self speechText:str];
        }
    }
}

- (void)speechSubtitle
{
    if ([_subtitle length]) {
        NSArray *array = [_subtitle componentsSeparatedByString:@" "];
        for (NSString *word in array) {
            _isSpell = YES;
            [self speechText:word];
        }
    }else{
        NSLog(@"%@",_subtitle);
    }
}

- (void)speechText:(NSString *)content
{
    if (![content length]) {
        NSLog(@"speechText %@",content);
    }
    if (!_audioService) {
         _audioService = [[GLAudioService alloc]init];
    }
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".+@／;（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+?'!\""];
    NSString *str = [content stringByTrimmingCharactersInSet:set];
   
    //NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
  //  NSNumber *gb = [defualt objectForKey:kVLCSettingVoiceSelector];
    NSString *voiceStr;
//    if ([gb boolValue]) {
//        voiceStr = @"en-GB";
//    }else{
//        voiceStr = @"en-US";
//    }
    voiceStr = @"zh-TW";
    str = [str lowercaseString];
    if (_isSpell || !_audioService.isSpeeking) {
      [_audioService speechText:str withVoice:voiceStr];
       _isSpell = NO;
    }
}

- (void)stopSpeech
{
    if (_audioService.isSpeeking) {
        [_audioService stopSpeech];
    }
}

- (void)cutWord
{
    _cutWord = YES;
}

- (void)chooseCutWord
{
    if (_cutWord == YES) {
        if ([_subtitle length]) {
            NSArray *array = [_subtitle componentsSeparatedByString:@" "];
            NSLog(@"%@",array);
            NSMutableString *mutableStr = [[NSMutableString alloc]init];
            if (_subtitleIndex < [array count]) {
                for (NSUInteger index = 0; index < _subtitleIndex+1; index++) {
                    [mutableStr appendString:array[index]];
                    [mutableStr appendString:@" "];
                }
                _subtitle = mutableStr;
                _subtitleIndex = 0;
            }
        }
    }
}

- (void)cancelCutWord:(NSString *)subtitle;
{
    self.subtitle = subtitle;
    _cutWord = NO;
}

@end
