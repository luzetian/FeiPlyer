//
//  GLMovieViewController.m
//  VLC For IOS
//
//  Created by lynd on 14-6-27.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMovieViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GLSpeechRecognitionViewController.h"
#import "GLSubtitle.h"
#import "GLSubtitleList.h"
#import "GLMediaLibrary.h"
#import "MLSubtitleComparison.h"
#import "GLRecorder.h"
#import "GLCommonHelper.h"
#import "MLRecorder.h"
#import "GLSubtitleParse.h"
#import "SIAlertView.h"
#import "GLNetworkRequest.h"
#import "GLAppDelegate.h"
#import "GLLoginViewController.h"
#import "GLStoryHintViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GLMovieViewController ()<AVAudioSessionDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,GLSpeechRecognitionDelegate,GLStoryHintViewControllerDelegate>
{
    BOOL _controlsHidden;
    BOOL _firstHint;
    BOOL _hasSubtitle;
    BOOL _isDub;
    BOOL _isEnSubtitle;
    BOOL _isRepeatPlayMode;
    BOOL _isScrubbing;
    BOOL _positionSet;
    BOOL _shouldResumePlaying;
    BOOL _storyHint;
    BOOL _viewAppeared;
    GLRecorder *_recoder;
    NSInteger _currentSubtitleIndex;
    NSString *_currentSelectorSubtilte;
    NSTimer *_hiddenAlertTimer;
    NSTimer *_idleTimer;
    NSTimer *_repeatTimer;
    UIAlertView *_alertView;
    UITapGestureRecognizer *_tapOnVideoRecognizer;
    VLCMediaPlayer *_audiaPlayer;
    VLCMediaPlayer *_listenTest;
    VLCMediaPlayer *_repeatAudio;
    VLCTime *_currentTime;
    VLCTime *_dubBeginTime;
    CGFloat _repeatBeginTime;
    CGFloat _repeatEndTime;
    VLCMediaPlayer *_viedoPlayer;
}

@property (nonatomic, strong) UIWindow              * externalWindow;
@property (nonatomic, strong) GLSubtitle            * subtitleNode;
@property (nonatomic, strong) GLSubtitleList        * subtitleList;
@property (nonatomic, strong) UIPopoverController   * popCtrl;
@property (nonatomic, strong) IBOutlet UIView       * adjustControlsPanel;
@property (nonatomic, strong) IBOutlet UIView       * dictationControlsPanel;
@property (nonatomic, strong) IBOutlet UIView       * dubControlsPanel;
@property (weak, nonatomic) IBOutlet UIButton       * changeToDub;
@property (weak, nonatomic) IBOutlet UIButton       * dubButton;
@property (weak, nonatomic) IBOutlet UILabel        * timeDisplay;
@property (weak, nonatomic) IBOutlet UISlider       * slider;
@property (weak, nonatomic) IBOutlet UIView         * centerControlsPanel;
@property (weak, nonatomic) IBOutlet UIView         * loopControlsPanel;
@property (weak, nonatomic) IBOutlet UIView         * movieView;
@property (weak, nonatomic) IBOutlet UIView         * navControlsPanel;
@property (weak, nonatomic) IBOutlet UIView         * playerControlsPanel;
@property (weak, nonatomic) IBOutlet UIButton       * recoderButton;
@property (weak, nonatomic) IBOutlet UIButton       * saveSubtitleButton;
@property (weak, nonatomic) IBOutlet UIButton       * playPauseButton;
@property (weak, nonatomic) IBOutlet UITextView     * subtitleTextView;
@property (weak, nonatomic) IBOutlet UITextView     * textView;
@property (weak, nonatomic) IBOutlet UITextField    * loopATextField;
@property (weak, nonatomic) IBOutlet UITextField    * loopBTextField;
@property (weak, nonatomic) IBOutlet UITextField    * subtitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@property (nonatomic, strong) GLSpeechRecognitionViewController *speechRecognitionViewController;
@end

@implementation GLMovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeGestureRecognizer:_tapOnVideoRecognizer];
    _tapOnVideoRecognizer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_storyHint == NO) {
       [self _stopPlayback];
    }
    self.subtitleTextView.text = @"";
    _viewAppeared = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (_viewAppeared == NO && _storyHint == NO) {
        [_subtitleList clear];
        [self _startPlayback];
        self.subtitleTextView.text = @"";
    }
   // [self _resetIdleTimer];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.centerControlsPanel addSubview:self.dubControlsPanel];
        [self.centerControlsPanel addSubview:self.dictationControlsPanel];
        [self.centerControlsPanel addSubview:self.loopControlsPanel];
        [self.centerControlsPanel addSubview:self.adjustControlsPanel];
    }
    
    self.adjustControlsPanel.hidden = YES;
    self.loopControlsPanel.hidden = YES;
    self.dubControlsPanel.hidden = YES;
    self.dictationControlsPanel.hidden = YES;
    _storyHint = NO;
    _viewAppeared = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slider setThumbImage:[UIImage imageNamed:@"volumeballslider"] forState:UIControlStateNormal];
    _isEnSubtitle = YES;
    if (!_tapOnVideoRecognizer) {
        _tapOnVideoRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControlsVisible)];
        _tapOnVideoRecognizer.delegate = self;
        [self.view addGestureRecognizer:_tapOnVideoRecognizer];
    }
   
    [self.dubButton setImage:[UIImage imageNamed:@"recorderVIew_dub_button_h"] forState:UIControlStateSelected];
    {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(applicationWillResignActive:)
                   name:UIApplicationWillResignActiveNotification object:nil];
    [center addObserver:self selector:@selector(applicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification object:nil];
    [center addObserver:self selector:@selector(applicationDidEnterBackground:)
                   name:UIApplicationDidEnterBackgroundNotification object:nil];
  
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    {
    UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:NSLocalizedString(@"TRANS", @"") action:@selector(showVoiceRecognize:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
    }
    [self _resetIdleTimer];
}

- (GLSpeechRecognitionViewController *)speechRecognitionViewController
{
    if (_speechRecognitionViewController == nil) {
        _speechRecognitionViewController = [[GLSpeechRecognitionViewController alloc]init];
        _speechRecognitionViewController.view.frame = CGRectMake(0, 0, 624, 604);
        _speechRecognitionViewController.delegate = self;
            }
    return _speechRecognitionViewController;
}

- (UIPopoverController *)popCtrl
{
    if (_popCtrl == nil) {
        _popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.speechRecognitionViewController];
        _popCtrl.popoverContentSize = CGSizeMake(624, 604);

    }
    return _popCtrl;
}

- (void)showVoiceRecognize:(UIMenuItem *)item
{
   
    if (![_currentSelectorSubtilte length]) {
        return;
    }
     _viewAppeared = NO;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        if (self.popCtrl.popoverVisible) {
            [self.popCtrl dismissPopoverAnimated:YES];
        } else {
            self.speechRecognitionViewController.selectSubtitle
            = _currentSelectorSubtilte;
            self.speechRecognitionViewController.currentSubtitle
            = _subtitleTextView.text;
            [self.popCtrl presentPopoverFromRect:_subtitleTextView.bounds inView:_subtitleTextView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        self.subtitleTextView.hidden = YES;
    }else{
        if (![_subtitleNode.content length]) {
            return;
        }
        if (_viedoPlayer.isPlaying) {
            [_viedoPlayer pause];
        }
        if (_audiaPlayer.isPlaying) {
            [_audiaPlayer pause];
        }
        GLStoryHintViewController *viewController = [[GLStoryHintViewController alloc]init];
        viewController.subtitle = _subtitleNode.content;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        _storyHint = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (_idleTimer) {
        [_idleTimer invalidate];
        _idleTimer = nil;
    }
    CGRect keyboardRect = [value CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat height = kDEVICE_WIDTH - keyboardRect.size.width;
    [self movieInputbarWithKeyboardHeight:height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self movieInputbarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

- (void)movieInputbarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration
{
    CGRect frame = self.playerControlsPanel.frame;
    if (height) {
        frame.origin.y = height - frame.size.height;
    }else{
        frame.origin.y = kDEVICE_WIDTH - frame.size.height;
    }
    [UIView animateWithDuration:duration animations:^{
        self.playerControlsPanel.frame = frame;
    }];
}

#pragma mark
#pragma mark ---- Button Action ----
- (IBAction)playPause:(id)sender {
    if ([_viedoPlayer isPlaying]){
        [_viedoPlayer pause];
        [_audiaPlayer pause];
    }
    else{
        self.dictationControlsPanel.hidden = YES;
        [_audiaPlayer play];
        [_viedoPlayer play];
    }
}

- (IBAction)previousSubtitle:(id)sender {
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
  
    _subtitleNode = [_subtitleList subtitle:_subtitleNode.sequenceNumber - 2];
    self.subtitleTextView.text = _subtitleNode.content;
    CGFloat position = [_subtitleNode beginPosition] / [_viedoPlayer.media.length intValue];
    [_viedoPlayer setPosition:position];
    [_audiaPlayer setPosition:position];

}

- (IBAction)repeatSubtitle:(id)sender {
    [self repeatCurrentSubtitle];
}

- (IBAction)nextSubtitle:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
    _subtitleNode = [_subtitleList subtitle:_subtitleNode.sequenceNumber + 1];
    self.subtitleTextView.text = _subtitleNode.content;
    CGFloat position = [_subtitleNode beginPosition] / [_viedoPlayer.media.length intValue];
    
    [_viedoPlayer setPosition:position];
    [_audiaPlayer setPosition:position];
}

- (IBAction)subtitleEndtimeForward:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
    
    if (_subtitleNode != nil) {
        _subtitleNode.endPosition += 500.;
       // [_subtitleList setSubtitle:_subtitleNode AtIndex:_subtitleNode.sequenceNumber];
       
    }
}

- (IBAction)subtilteEndTimeBack:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
    if (_subtitleNode != nil) {
        CGFloat position = _subtitleNode.endPosition - 500.;
        if (position) {
            if (_subtitleNode.beginPosition < position) {
                CGFloat p = position - _subtitleNode.beginPosition;
                if (p < 1000) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:@"结束时间必须大于开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                _subtitleNode.endPosition = position;
            }
        }
    }
}

- (IBAction)subtitleBeginTimeBack:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
    if (_subtitleNode != nil) {
        CGFloat position = _subtitleNode.beginPosition - 500.;
        if (position) {
            _subtitleNode.beginPosition = position;
        }
    }
}

- (IBAction)subtitleBeginTimeForward:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (!_hasSubtitle) {
        return;
    }
    if (_subtitleNode != nil) {
        CGFloat position = _subtitleNode.beginPosition + 500;
        if (position < _subtitleNode.endPosition) {
                CGFloat p = _subtitleNode.endPosition - position;
                if (p < 1000) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:@"开始时间必须小于结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                _subtitleNode.beginPosition = position;
            }
        
        
        [_subtitleList setSubtitle:_subtitleNode AtIndex:_subtitleNode.sequenceNumber];
        [self updateSubtitle];
    }
}

- (IBAction)stroyHint:(id)sender {
    
    self.repeatLabel.hidden = YES;
    _isRepeatPlayMode = NO;
    self.loopATextField.text = @"";
    self.loopBTextField.text = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (![_subtitleNode.content length]) {
            NSLog(@"%@",_subtitleNode.content);
            return;
        }
        if (_viedoPlayer.isPlaying) {
            [_viedoPlayer pause];
        }
        if (_audiaPlayer.isPlaying) {
            [_audiaPlayer pause];
        }
        GLStoryHintViewController *viewController = [[GLStoryHintViewController alloc]init];
        viewController.subtitle = _subtitleNode.content;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
        _storyHint = YES;
    }else{
        if (self.popCtrl.popoverVisible) {
            [self.popCtrl dismissPopoverAnimated:YES];
        } else {
            if ([_viedoPlayer isPlaying]) {
                return;
            }
            self.subtitleTextView.hidden = YES;
            self.speechRecognitionViewController.selectSubtitle = _subtitleTextView.text;
            self.speechRecognitionViewController.currentSubtitle
            = _subtitleTextView.text;
            [self.popCtrl presentPopoverFromRect:_subtitleTextView.bounds inView:_subtitleTextView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    }
}

- (IBAction)showLoopController:(id)sender {
    
    self.loopATextField.text = @"";
    self.loopBTextField.text = @"";
    self.repeatLabel.hidden = YES;
    _isRepeatPlayMode = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.dictationControlsPanel.hidden && self.dubControlsPanel.hidden && self.adjustControlsPanel.hidden) {
            self.loopControlsPanel.hidden = self.loopControlsPanel.isHidden ? NO : YES;
            if (self.loopControlsPanel.isHidden) {
                _isRepeatPlayMode = NO;
            }
        }
    }else{
       self.loopControlsPanel.hidden = self.loopControlsPanel.isHidden ? NO : YES; 
    }
   
}

- (IBAction)movieDub:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.dubControlsPanel.hidden && self.loopControlsPanel.hidden && self.adjustControlsPanel.hidden){
            self.dictationControlsPanel.hidden = self.dictationControlsPanel.isHidden ? NO : YES;
        }
    }
}

- (IBAction)record:(id)sender {

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.dictationControlsPanel.hidden && self.loopControlsPanel.hidden&& self.adjustControlsPanel.hidden) {
            self.dubControlsPanel.hidden = self.dubControlsPanel.isHidden ? NO : YES;
            self.subtitleTextView.hidden = !self.dictationControlsPanel.hidden;
        }
    }else{
        self.dubControlsPanel.hidden = self.dubControlsPanel.isHidden ? NO : YES;
    }
    
}

- (IBAction)showOrHiddenSubtitle:(id)sender {
    self.subtitleTextView.hidden = self.subtitleTextView.isHidden ? NO : YES;
}

- (IBAction)closeView:(id)sender {
    [self _stopPlayback];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)positionSliderAction:(id)sender {
    
    [self performSelector:@selector(_setPositionForReal) withObject:nil afterDelay:0.3];
    NSInteger duration = [_viedoPlayer.time intValue] / 1000;
    VLCTime *newPosition = [VLCTime timeWithInt:(int)(_slider.value * duration)];
    [self.timeDisplay setText:newPosition.stringValue];
    _positionSet = NO;
   // [self _resetIdleTimer];
}

- (void)_setPositionForReal
{
    if (!_positionSet) {
        _viedoPlayer.position = _slider.value;
        _audiaPlayer.position = _slider.value;
        _positionSet = YES;
    }
}

- (IBAction)positionSliderTouchDown:(id)sender {
    _isScrubbing = YES;
}

- (IBAction)positionSliderTouchUp:(id)sender {
    _isScrubbing = NO;
}

- (IBAction)recorder:(id)sender {
    if (_recoder == nil) {
        _recoder = [[GLRecorder alloc]init];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *data = [NSDate date];
    NSString *fileName = [GLCommonHelper md5StringForString:[formatter stringFromDate:data]];
    NSString *recorderPath = [self recoderPath:fileName];
    NSDictionary *format = [GLRecorder pcmFormate];
    if ([_recoder startRecordWithPath:recorderPath recoderFormat:format]) {
        float s = (self.subtitleNode.endPosition - self.subtitleNode.beginPosition) / 1000;
        [NSTimer scheduledTimerWithTimeInterval:s target:self selector:@selector(completionRecord:) userInfo:nil repeats:NO];
    }
}

- (void)completionRecord:(NSTimer *)timer
{
    if (_recoder != nil) {
        [_recoder stopRecordWithCompletionFilePathBlock:^(NSURL *filePath) {
            GLMediaLibrary *library = [[GLMediaLibrary alloc]init];
            MLRecorder *recorderInfo = (MLRecorder *)[library newObjectWithEntityName:@"Recorder"];
            if (recorderInfo) {
                recorderInfo.userName = [self userName];
                recorderInfo.subtitleStr = self.subtitleTextView.text;
                recorderInfo.recorderPath = [filePath path];
                recorderInfo.fileName = self.fileFromMediaLibrary.name;
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *data = [NSDate date];
                recorderInfo.time = [formatter stringFromDate:data];
            }
            if (![library save]) {
                NSLog(@"录音保存失败");
            }
        }];
    }
}

- (NSString *)recoderPath:(NSString *)filmName
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = searchPaths[0];
    directoryPath = [directoryPath stringByAppendingPathComponent:@"recorder"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:directoryPath]) {
        NSError *error;
        [[NSFileManager defaultManager]createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            
        }
    }
    directoryPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",filmName]];
    return directoryPath;
}

- (IBAction)saveUserInput:(id)sender {
    GLMediaLibrary *lib = [GLMediaLibrary sharedMediaLibrary];
    MLSubtitleComparison *info = (MLSubtitleComparison *)[lib newObjectWithEntityName:@"SubtitleComparison"];
    if (info == nil) {
        NSLog(@"%@",info);
        return;
    }
    if (self.fileFromMediaLibrary) {
        info.fileName = self.fileFromMediaLibrary.name;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        info.userSubtitle = self.subtitleTextField.text;
    }else{
        info.userSubtitle = self.textView.text;
    }
    info.userName = [self userName];
    info.subtitle = self.subtitleTextView.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *data = [NSDate date];
    info.time = [formatter stringFromDate:data];
    if ([lib save]) {
        self.textView.text = @"";
        self.subtitleTextField.text = @"";
        self.dictationControlsPanel.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:@"字幕保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)listeningTest:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([fileManager fileExistsAtPath:[_recoder.recorderPath path]]) {
        
        if (_listenTest == nil) {
            _listenTest = [[VLCMediaPlayer alloc]init];
            
        }
        VLCMedia *media = [VLCMedia mediaWithPath:[_recoder.recorderPath path]];
        [_listenTest setMedia:media];
        [_listenTest play];
    }
    NSLog(@"%@",_recoder.recorderPath);
}

- (IBAction)saveDub:(id)sender {
    [self completeDub];
}

- (IBAction)changeToDub:(id)sender {
    
    if (_recoder.isRecording || ![[_recoder.recorderPath path]length]) {
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSFileManager *manager = [NSFileManager defaultManager];

 
    if ([manager fileExistsAtPath:[_recoder.recorderPath path]]) {
        VLCMedia *media = [VLCMedia mediaWithPath:[_recoder.recorderPath path]];
        if (_isDub) {
            [self.changeToDub setTitle:NSLocalizedString(@"CHANGE_TO_DUB", @"") forState:UIControlStateNormal];
            [self setOriginalAudio];
            _isDub = NO;
        }else {
            [self.changeToDub setTitle:NSLocalizedString(@"CHANGE_TO_SOUNDS", @"") forState:UIControlStateNormal];
            [_audiaPlayer setMedia:media];
           
            _isDub = YES;
        }
    }else{
        [self setOriginalAudio];
    }
    [_viedoPlayer setTime:_dubBeginTime];
    if (!_audiaPlayer.isPlaying) {
         [_audiaPlayer play];
    }
    if (!_viedoPlayer.isPlaying) {
        [_viedoPlayer play];
    }

}

- (void)setOriginalAudio
{
    VLCMedia *audio;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (self.isWLAN) {
        if (self.videoPath == nil || self.audioPath == nil) {
            NSLog(@"局域网URL错误");
            return;
        }
        audio = [VLCMedia mediaWithURL:self.audioPath];
    }else{
        if(!self.fileFromMediaLibrary){
            return;
        }
        NSString *audioPath = self.fileFromMediaLibrary.audio.enPath;
        audio = [VLCMedia mediaWithPath:audioPath];
        self.subtitleURL = self.fileFromMediaLibrary.subtitle.enUrl;
    }
    [_audiaPlayer setMedia:audio];
    [_audiaPlayer play];
    [_audiaPlayer setTime:_dubBeginTime];
}

- (IBAction)beginDub:(id)sender {
    
    if (!self.dubButton.selected) {
        self.dubButton.selected = YES;
        _dubBeginTime = [_viedoPlayer time];
        [self dub];
    }else {
         [_recoder pause];
        self.dubButton.selected = NO;
    }
}

- (void)dub
{
    if (_recoder == nil) {
        _recoder = [[GLRecorder alloc]init];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *data = [NSDate date];
    NSString *fileName = [GLCommonHelper md5StringForString:[formatter stringFromDate:data]];
    NSString *recorderPath = [self recoderPath:fileName];
    NSDictionary *format = [GLRecorder pcmFormate];
    [_recoder startRecordWithPath:recorderPath recoderFormat:format];
}

- (void)completeDub
{
    if (!_recoder) {
        return;
    }
    [_recoder stopRecordWithCompletionFilePathBlock:^(NSURL *filePath) {
            GLMediaLibrary *library = [[GLMediaLibrary alloc]init];
            MLRecorder *recorderInfo = (MLRecorder *)[library newObjectWithEntityName:@"Recorder"];
            if (recorderInfo) {
                NSString *name = [self.fileFromMediaLibrary.name stringByAppendingString:@"dub"];
                recorderInfo.subtitleStr = self.subtitleTextView.text;
                recorderInfo.recorderPath = [filePath path];
                recorderInfo.fileName = name;
                recorderInfo.userName = [self userName];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *data = [NSDate date];
                recorderInfo.time = [formatter stringFromDate:data];
            }
            if (![library save]) {
                NSLog(@"录音保存失败");
            }
    }];

}

- (IBAction)showAdjustPanel:(id)sender {
    
    if (_viedoPlayer.isPlaying) {
        return;
    }
    if (![_subtitleTextView.text length]) {
        return;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.dictationControlsPanel.hidden && self.dubControlsPanel.hidden && self.loopControlsPanel.hidden) {
            self.adjustControlsPanel.hidden = self.adjustControlsPanel.isHidden ? NO :YES;
        }
    } else {
        self.adjustControlsPanel.hidden = self.adjustControlsPanel.isHidden ? NO :YES;
    }
}

#pragma mark
#pragma mark ---- Play Action ----
- (void)_playNewMedia
{
    NSNumber *playbackPositionInTime = @(0);
    CGFloat lastPosition = .0;
    NSInteger duration = 0;
    //MLFile *matchedFile = self.fileFromMediaLibrary;

    if (_viedoPlayer == nil || _audiaPlayer == nil) {
        NSLog(@"%@%@",_viedoPlayer,_audiaPlayer);
        return;
    }

    duration = _viedoPlayer.media.length.intValue;
    if (lastPosition < .95) {
        if (duration != 0)
            playbackPositionInTime = @(lastPosition * (duration / 1000.));
    }
    if (playbackPositionInTime == nil) {
        return;
    }
    
    if (playbackPositionInTime.intValue > 0 && (duration * lastPosition - duration) < -60000) {
        
        [_viedoPlayer.media addOptions:@{@"start-time": playbackPositionInTime}];
        [_audiaPlayer.media addOptions:@{@"start-time": playbackPositionInTime}];
        NSLog(@"set starttime to %i", playbackPositionInTime.intValue);
    }
    [_viedoPlayer addObserver:self forKeyPath:@"time" options:0 context:nil];
    [_viedoPlayer addObserver:self forKeyPath:@"remainingTime" options:0 context:nil];

    _viedoPlayer.videoAspectRatio = NULL;
    if (lastPosition < .95 && _viedoPlayer.position < lastPosition && (duration * lastPosition - duration) < -60000){
        _viedoPlayer.position = lastPosition;
        _audiaPlayer.position = lastPosition;
    }
    
    [_viedoPlayer play];
}

- (void)_startPlayback
{
    
    VLCMedia *media;
    VLCMedia *audio;
    
    if (self.isWLAN) {
        if (self.videoPath == nil || self.audioPath == nil) {
            return;
        }
        media = [VLCMedia mediaWithURL:self.videoPath];
        audio = [VLCMedia mediaWithURL:self.audioPath];
       
    }else{
        if(!self.fileFromMediaLibrary){
            return;
        }
      
        media = [VLCMedia mediaWithPath:self.fileFromMediaLibrary.video.path];
        audio = [VLCMedia mediaWithPath:self.fileFromMediaLibrary.audio.enPath];
        self.subtitleURL = self.fileFromMediaLibrary.subtitle.enUrl;
    }
    _viedoPlayer = [[VLCMediaPlayer alloc] init];
    _audiaPlayer = [[VLCMediaPlayer alloc]init];
    
    [_viedoPlayer setDelegate:self];
    [_viedoPlayer setDrawable:self.movieView];
    self.slider.value = 0.;
    if ([self.subtitleURL length]) {
       [self loadSubtitleForUrl:self.subtitleURL];
    }
    
    [self configSubtitleView];
    _audiaPlayer.media = audio;
    _repeatAudio.media = audio;
    _viedoPlayer.media = media;
    _viedoPlayer.videoCropGeometry = "16:9";
    
    [self _playNewMedia];
    
}

- (void)_stopPlayback
{
    _currentTime = _viedoPlayer.time;
    @try {
        [_viedoPlayer removeObserver:self forKeyPath:@"time"];
        [_viedoPlayer removeObserver:self forKeyPath:@"remainingTime"];
    }
    @catch (NSException *exception) {
        NSLog(@"we weren't an observer yet");
    }
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    if (_viedoPlayer) {
        [_viedoPlayer pause];
        [_viedoPlayer stop];
    }
    if (_viedoPlayer){
        _viedoPlayer = nil;;
    }
    if (_audiaPlayer) {
        [_audiaPlayer pause];
        [_audiaPlayer stop];
    }
    if (_audiaPlayer) {
        _audiaPlayer = nil;
    }
    if (_repeatAudio) {
        [_repeatAudio pause];
        [_repeatAudio stop];
    }
    if (_repeatAudio) {
        _repeatAudio = nil;
    }
    if (_listenTest.media) {
        [_listenTest pause];
        [_listenTest stop];
    }
    if (_listenTest) {
        _listenTest = nil;
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_isRepeatPlayMode) {
        if (_viedoPlayer.position > _repeatEndTime) {
            [_viedoPlayer setPosition:_repeatBeginTime];
            [_audiaPlayer setPosition:_repeatBeginTime];
        }
    }
    if (!_audiaPlayer.isPlaying) {
        [_audiaPlayer play];
    }
    if (!_isScrubbing) {
        self.slider.value = [_viedoPlayer position];
    }
    [self.timeDisplay setText:[[_viedoPlayer time] stringValue]];
    [self updateSubtitle];
}

- (void)updateSubtitle
{
    if (_hasSubtitle) {
        GLSubtitle *tempSubtitle =
        [_subtitleList findSubtitle:[[_viedoPlayer time] intValue]];
        _firstHint = YES;
        if ([tempSubtitle.content length]) {
            _subtitleNode = tempSubtitle;
            _currentSelectorSubtilte = tempSubtitle.content;
            _currentSubtitleIndex = tempSubtitle.sequenceNumber;
        }
        _firstHint = YES;
        _subtitleTextView.text = tempSubtitle.content;
    }
}

- (void)loadSubtitleForUrl:(NSString *)urlStr
{
    if (urlStr != nil) {
        _subtitleList = [[GLSubtitleList alloc]init];
        _subtitleList.isEnglish = YES;
        NSURL *url = [NSURL URLWithString:urlStr];
        if ([_subtitleList loadSubtitleForUrl:url]){
            _subtitleTextView.hidden = NO;
            _hasSubtitle = YES;
        }else{
            _subtitleTextView.hidden = YES;
            _hasSubtitle = NO;
        }
    }else{
        NSLog(@"Subtitle URL is empty %@",urlStr);
    }
}

#pragma mark
#pragma mark ---- Text View ----
- (void)configSubtitleView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *subtitleFont = [defaults objectForKey:kVLCSettingSubtitlesFont];
    NSString *fontColor = [defaults objectForKey:kVLCSettingSubtitlesFontColor];
    NSNumber *number = [defaults objectForKey:kVLCSettingSubtitlesFontSize];
    CGFloat subtitleSize = [number floatValue];
    if (IS_IPHONE) {
        subtitleSize = subtitleSize - 10;
    }
    BOOL bold = [[defaults objectForKey:kVLCSettingSubtitlesBoldFont] boolValue];
    UIFont *myFont;
    if (bold) {
        myFont = [UIFont boldSystemFontOfSize:subtitleSize];
    }else{
        myFont = [UIFont fontWithName: subtitleFont size: subtitleSize];
    }
    _subtitleTextView.textColor = UIColorFromRGB([fontColor integerValue]);
    _subtitleTextView.font = myFont;
    _subtitleTextView.editable = NO;
    _subtitleTextView.selectable = NO;
    _subtitleTextView.secureTextEntry = YES;
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSString *text = textView.text;
    _currentSelectorSubtilte = [text substringWithRange:textView.selectedRange];
}

- (void)languageChange
{
    if (self.fileFromMediaLibrary == nil) {
        return;
    }
    
    if (_isEnSubtitle) {
        [_subtitleList clear];
        NSURL *url = [NSURL URLWithString:self.fileFromMediaLibrary.subtitle.zhUrl];
        if (url) {
            [_subtitleList loadSubtitleForUrl:url];
            _isEnSubtitle = NO;
        }
    }else{
        [_subtitleList clear];
        NSURL *url = [NSURL URLWithString:self.fileFromMediaLibrary.subtitle.enUrl];
        if (url) {
            [_subtitleList loadSubtitleForUrl:url];
            _isEnSubtitle = YES;
        }
    }
    _subtitleNode =
    [_subtitleList findSubtitle:[[_viedoPlayer time] intValue]];
    _subtitleTextView.text = _subtitleNode.content;
    
 
}

#pragma mark

- (void)repeatCurrentSubtitle
{
    if (!_hasSubtitle) {
        return;
    }
    if (_audiaPlayer.isPlaying) {
        return;
    }
    if (_repeatTimer) {
        return;
    }
    if (_repeatAudio.isPlaying) {
        return;
    }
    if (self.fileFromMediaLibrary == nil) {
        NSLog(@"%@",self.fileFromMediaLibrary);
        return;
    }
    
    if (_repeatAudio == nil) {
        VLCMedia  *meida = [VLCMedia mediaWithPath:self.fileFromMediaLibrary.audio.enPath];
        _repeatAudio = [[VLCMediaPlayer alloc]init];
        _repeatAudio.media = meida;
    }
 
    NSNumber *playbackPositionInTime = [NSNumber numberWithFloat:_subtitleNode.beginPosition / 1000];
    [_repeatAudio.media addOptions:@{@"start-time": playbackPositionInTime}];
    CGFloat begin = _subtitleNode.beginPosition / 1000;
    CGFloat end   = _subtitleNode.endPosition / 1000;
    CGFloat repeatTime = end - begin;
    if (!repeatTime) {
        return;
    }
    if ([_repeatAudio play]) {
        NSLog(@"%f",repeatTime);
        _repeatTimer =[NSTimer scheduledTimerWithTimeInterval:repeatTime target:self selector:@selector(stopRepeat) userInfo:nil repeats:NO];
    }
}

- (void)stopRepeat {
    [_repeatTimer invalidate];
    _repeatTimer = nil;
    [_repeatAudio pause];
    [_repeatAudio stop];
    _repeatAudio = nil;
}

#pragma mark 
#pragma mark ---- VLC Delegate ----
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    UIImage *playPauseImage = [_viedoPlayer isPlaying]? [UIImage imageNamed:@"pauseIcon"] : [UIImage imageNamed:@"playIcon"];
    self.subtitleTextView.selectable = [_viedoPlayer isPlaying] ? NO : YES;
    VLCMediaState state = _viedoPlayer.state;
    if (state == VLCMediaStateError) {
        NSLog(@"VLCMediaStateError");
    }else if (state == VLCMediaStateBuffering){
        NSLog(@"VLCMediaStateBuffering");
    }
    
    if (_viedoPlayer.isPlaying) {
        self.subtitleTextView.hidden = NO;
        self.subtitleTextField.hidden = YES;
        self.saveSubtitleButton.hidden = YES;
        self.recoderButton.hidden = YES;
    }else{
        self.adjustControlsPanel.hidden = YES;
        if (_hasSubtitle) {
            if ([self.subtitleTextView.text length]) {
                self.subtitleTextField.hidden = NO;
                self.subtitleTextField.hidden = NO;
                self.saveSubtitleButton.hidden = NO;
                self.recoderButton.hidden = NO;
            }
        }
    }
    [self.playPauseButton setImage:playPauseImage forState:UIControlStateNormal];
}

- (void)_saveCurrentState
{
    /*
    if (self.fileFromMediaLibrary) {
        @try {
            DBMovie *item = self.fileFromMediaLibrary;
            item.lastPosition = @([_viedoPlayer position]);
        }
        @catch (NSException *exception) {
            NSLog(@"failed to save current media state - file removed?");
        }
    }
     */
 
}

#pragma mark - background interaction

- (void)applicationWillResignActive:(NSNotification *)aNotification
{
    _viedoPlayer.currentVideoTrackIndex = 0;
    if ([_viedoPlayer isPlaying] || [_audiaPlayer isPlaying]) {
        [_viedoPlayer pause];
        [_audiaPlayer pause];
        _shouldResumePlaying = YES;
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    _shouldResumePlaying = NO;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    _viedoPlayer.currentVideoTrackIndex = 1;
    if (_shouldResumePlaying) {
        _shouldResumePlaying = NO;
        [_viedoPlayer play];
        [_audiaPlayer play];
    }
}

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated
{
    _controlsHidden = hidden;
    CGFloat alpha = _controlsHidden ? 0.0f: 1.0f;
    
    if (!_controlsHidden) {
        self.playerControlsPanel.alpha = 0.0f;
        self.navControlsPanel.alpha = 0.0f;
       // self.navigationController.navigationBar.alpha = 0.0;
    }
    
    void (^animationBlock)() = ^() {
        self.navControlsPanel.alpha = alpha;
        self.playerControlsPanel.alpha = alpha;
       // self.navigationController.navigationBar.alpha = alpha;
    };
    void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
        self.navControlsPanel.hidden =  hidden;
        self.playerControlsPanel.hidden = hidden;
    };
    
    NSTimeInterval animationDuration = animated? 0.3: 0.0;
    [UIView animateWithDuration:animationDuration animations:animationBlock completion:completionBlock];
}

- (void)toggleControlsVisible
{
    [self setControlsHidden:!_controlsHidden animated:YES];
    if (_controlsHidden == NO) {
        [_idleTimer invalidate];
        [self _resetIdleTimer];
    }
}

- (void)_resetIdleTimer
{
    if (_idleTimer) {
         [_idleTimer invalidate];
        _idleTimer = nil;
    }
   
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:10.
                                                  target:self
                                                selector:@selector(idleTimerExceeded)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)idleTimerExceeded
{
    [self setControlsHidden:YES animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.playerControlsPanel){
        [self idleTimerExceeded];
        return NO;
    }
    if (touch.view == self.loopControlsPanel) {
        [self idleTimerExceeded];
        return NO;
    }
    if (touch.view == self.adjustControlsPanel) {
        [self idleTimerExceeded];
        return NO;
    }
    if (touch.view == self.navControlsPanel) {
        [self idleTimerExceeded];
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark ----- Text View Delegate ----
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.subtitleTextView.hidden = YES;
    return YES;
}

#pragma mark - AVSession delegate
- (void)beginInterruption
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kVLCSettingContinueAudioInBackgroundKey] boolValue])
        _shouldResumePlaying = YES;
    [_viedoPlayer pause];
    [_audiaPlayer pause];

}

- (void)endInterruption
{
    if (_shouldResumePlaying) {
        [_viedoPlayer play];
        [_audiaPlayer play];
        _shouldResumePlaying = NO;
    }
}

#pragma mark
#pragma mark ---- Segment Delegate ----

- (NSString *)languageType:(LanguageType )type
{
    if (type == ZHLanguageType) {
        return @"EN";
    }
    return nil;
}

- (void)languageTypeChange:(LanguageType)type
{
    if (_firstHint) {
        _firstHint = NO;
        SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"提示" andMessage:@"该操作将产生费用"];
        
        [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [self speechSubtitleWithType:[self languageType:type]];
        }];
        [alert addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:nil];
        [alert show];
    }else{
       [self speechSubtitleWithType:[self languageType:type]];
    }
}

- (void)speechSubtitleWithType:(NSString *)type
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [userDefaults stringForKey:@"sessionid"];
    NSString *f = self.fileFromMediaLibrary.fileID;
    NSString *fe = self.fileFromMediaLibrary.episode;
    NSString *language  = type;
    
    
    NSDictionary *params = @{@"sessionid"   : sessionid,
                             @"f"           : f,
                             @"fe"          : fe,
                             @"language"    : language,
                             @"position"    : _subtitleNode.strPostion
                             };
    
    [GLNetworkRequest switchSubtitleLanguage:params costResults:^(id result) {
        if (!result) {
            return;
        }
        NSDictionary *dic = (NSDictionary *)result;
        NSInteger state = [[dic objectForKey:@"error_code"] integerValue];
        NSString  *msg = [dic objectForKey:@"error_msg"];
        
        if (state == 0) {
            NSLog(@"%@",dic);
            NSString *subtitle = [dic objectForKey:@"trans"];
            if ([subtitle length]) {
                GLSubtitleParse *parse = [[GLSubtitleParse alloc]initWithSubtitle:subtitle];
                [parse speechSeriesSubtitle];
            }
        }else if (state == 1){
            GLLoginViewController *loginViewController = [[GLLoginViewController alloc]init];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }else{
            _firstHint = YES;
            [self alertShow:msg];
        }
    }];

}

- (void)alertShow:(NSString *)messge
{
    if (![messge length]) {
        return;
    }
    if (_hiddenAlertTimer) {
        [_hiddenAlertTimer invalidate];
        _hiddenAlertTimer = nil;
    }
    _alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:messge delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
 
    [_alertView show];
    _hiddenAlertTimer = [NSTimer scheduledTimerWithTimeInterval:2.
                                                         target:self
                                                       selector:@selector(hiddenAlertView)
                                                       userInfo:nil
                                                        repeats:NO];
   
}

- (void)hiddenAlertView
{
    [_hiddenAlertTimer invalidate];
    _hiddenAlertTimer = nil;
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)repeatAB:(id)sender
{
    if (_repeatBeginTime && _repeatEndTime) {
         _isRepeatPlayMode = YES;
        self.repeatLabel.hidden = NO;
        self.loopControlsPanel.hidden = YES;
        [_viedoPlayer setPosition:_repeatBeginTime];
        [_audiaPlayer setPosition:_repeatBeginTime];
    }
}

- (IBAction)aRereadPointMarkTime:(id)sender
{
    _repeatBeginTime = [_viedoPlayer position];
    self.loopATextField.text = [_viedoPlayer.time stringValue];
}

- (IBAction)bRereadPointMarkTime:(id)sender
{
    _repeatEndTime = [_viedoPlayer position];
    self.loopBTextField.text = [_viedoPlayer.time stringValue];
}

- (IBAction)cancelChoose:(id)sender
{
    if (_isRepeatPlayMode) {
        if (_repeatEndTime) {
            _isRepeatPlayMode = NO;
            [_viedoPlayer setPosition:_repeatEndTime];
            [_audiaPlayer setPosition:_repeatEndTime];
        }
    }
    self.loopControlsPanel.hidden = YES;
    self.repeatLabel.hidden = YES;
}

- (NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"username"];
    return name;
}

- (void)hiddenSubtitle:(BOOL)isHidden
{
    self.subtitleTextView.hidden = isHidden;
}

@end
