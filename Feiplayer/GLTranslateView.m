//
//  GLTranslateView.m
//  VLC For IOS
//
//  Created by lynd on 14-5-7.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLTranslateView.h"

#import "GLNetworkRequest.h"
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <AVFoundation/AVFoundation.h>
#define APPID @"537051bf"
@interface GLTranslateView()<UIWebViewDelegate,IFlyRecognizerViewDelegate>
{
    NSMutableString *_resultStr;
    NSString *_category;
    IFlyRecognizerView *_iflyRecognizerView;
}

@property (weak,   nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) CGPoint beginPoint;
@end
@implementation GLTranslateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (GLTranslateView *)translateView
{
    NSArray *nibArray;
    if (SYSTEM_RUNS_IOS7_OR_LATER) {
        nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLTranslateView" owner:nil options:nil];
    }
    else
    {
        nibArray = [[NSBundle mainBundle] loadNibNamed:@"GLTranslateView" owner:nil options:nil];
        NSAssert([nibArray count] == 1, @"meh");
        NSAssert([[nibArray lastObject] isKindOfClass:[GLTranslateView class]], @"meh meh");
    }
    GLTranslateView *view = (GLTranslateView *)[nibArray lastObject];
    view.layer.cornerRadius = 10;
    return view;
}

- (IBAction)translate:(id)sender
{
    if (![self.textField.text length]) {
        return;
    }
    [GLNetworkRequest youdaoTranslateWithText:self.textField.text returnJson:^(id result) {
        NSDictionary *transResults = result;
        NSArray *translations = [transResults objectForKey:@"translation"];
        if ([translations count]) {
            self.textView.text = [translations objectAtIndex:0];
        }
    }];
}

- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [_resultStr appendFormat:@"%@",key];
    }
    NSLog(@"%@",_resultStr);
}

- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
{
    [[AVAudioSession sharedInstance] setCategory:_category error:nil];
    self.textField.text = _resultStr;
    NSLog(@"errorCode:%d",[error errorCode]);
}

- (IBAction)voiceRecognizer:(id)sender {
   
    _category = [[AVAudioSession sharedInstance] category];
    _resultStr = [[NSMutableString alloc]init];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.center initParam:initString];
    _iflyRecognizerView.delegate = self;
    
    [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
    [_iflyRecognizerView setParameter:@"sample_rate" value:@"16000"];
    [_iflyRecognizerView setParameter:@"vad_bos" value:@"1800"];
    [_iflyRecognizerView setParameter:@"vad_eos" value:@"1600"];
    [_iflyRecognizerView setParameter:@"language" value:@"en_us"];
    
    [_iflyRecognizerView start];
 
}

- (IBAction)close:(id)sender
{
    self.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    CGRect frame = self.frame;
    frame.origin.y += currentLocation.y - self.beginPoint.y;
    frame.origin.x += currentLocation.x - self.beginPoint.x;
    if (frame.origin.y > (768 - self.frame.size.height)||frame.origin.y < 0) {
        return;
    }
    if (frame.origin.x > (1024 - self.frame.size.width) || frame.origin.x < 0) {
        return;
    }
    self.frame = frame;
}

@end
