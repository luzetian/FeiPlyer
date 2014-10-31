//
//  FeiSpeechRecognitionViewController.m
//  VLC for iOS
//
//  Created by lynd on 13-11-27.
//  Copyright (c) 2013年 VideoLAN. All rights reserved.
//

#import "GLSpeechRecognitionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GLNetworkService.h"
#import "GLAppDelegate.h"
#import "GLNetworkRequest.h"
#import "iflyMSC/IFlyRecognizerView.h"

#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "GLSubtitleParse.h"
#import <objc/runtime.h>
static const NSString *kAlertKey = @"Alert key";
@interface GLSpeechRecognitionViewController ()<
    UITextFieldDelegate,IFlyRecognizerViewDelegate>
{
    BOOL    _isSpeech;
    NSString *_selectSubtitle;
    NSString *_currentSubtitle;
    UILabel  *_navLabel;
    NSString *_category;
    NSInteger _recorderCount;
    NSMutableString *_resultStr;
    NSInteger _subtitleIndex;
    IFlyRecognizerView  *_iflyRecognizerView;;
}

@property (strong, nonatomic) IBOutlet UILabel  *showWord;
@property (strong, nonatomic) IBOutlet UILabel  *phonetic;
@property (weak, nonatomic)   IBOutlet UILabel  *translationLabel;
@property (strong, nonatomic) IBOutlet UILabel  *showTranslateResult;
@property (strong, nonatomic) IBOutlet UIButton *translatorbtn;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) GLSubtitleParse *subtitleParse;

@end
const NSString *APPID = @"537051bf";
@implementation GLSpeechRecognitionViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.delegate respondsToSelector:@selector(speechRecognitionViewDidAppear)]) {
        [self.delegate speechRecognitionViewDidAppear];
    }
    
    self.showTranslateResult.text = @"";
    self.phonetic.text            = @"";
    self.textField.text           = @"";
    if ([self.selectSubtitle length]) {
        [self p_subtitleTranslateResults];
    }
    
    [self.textField setEnabled:NO];
    [self.showCurrentSubtitle setEnabled:NO];
    _isSpeech = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.subtitleParse) {
        [self.subtitleParse stopSpeech];
    }
    if ([self.delegate respondsToSelector:@selector(speechRecognitionViewDidDisappear)]) {
        [self.delegate speechRecognitionViewDidDisappear];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setup
{
    self.translatorbtn.enabled = NO;
    self.textField.delegate = self;
    self.textField.inputAccessoryView = [self accessoryView];
    _recorderCount = 0;
    self.translationLabel.hidden = YES;
    self.phonetic.hidden = YES;
    self.showTranslateResult.hidden = YES;
    self.showWord.hidden = YES;
    if (!IS_IPAD) {
        _navLabel = [[UILabel alloc]init];
        _navLabel.text = @"";
        _navLabel.textColor = [UIColor whiteColor];
        [_navLabel sizeToFit];
        self.navigationItem.titleView = _navLabel;
    }
    [self p_voiceRecognizerSetup];
}

- (void)p_voiceRecognizerSetup
{
    NSString *initString = [NSString stringWithFormat:@"appid=%@",APPID];
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center initParam:initString];
    _iflyRecognizerView.delegate = self;
    
    [_iflyRecognizerView setParameter:@"domain" value:@"iat"];
    [_iflyRecognizerView setParameter:@"asr_audio_path" value:@"asrview.pcm"];
    [_iflyRecognizerView setParameter:@"sample_rate" value:@"16000"];
    [_iflyRecognizerView setParameter:@"vad_bos" value:@"1800"];
    [_iflyRecognizerView setParameter:@"vad_eos" value:@"1600"];
    [_iflyRecognizerView setParameter:@"language" value:@"en_us"];
}

- (GLSubtitleParse *)subtitleParse
{
    if (_subtitleParse) {
        return _subtitleParse;
    }
    _subtitleParse = [[GLSubtitleParse alloc]initWithSubtitle:self.selectSubtitle];
    return _subtitleParse;
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if (IS_IPAD) {
        [self.showCurrentSubtitle setEnabled:NO];
        self.textField.frame = CGRectMake(self.textField.origin.x, 412, self.textField.width, self.textField.height);
        self.translatorbtn.frame = CGRectMake(self.translatorbtn.origin.x, self.textField.bottom + 31, self.translatorbtn.width, self.translatorbtn.height);
        [self.translatorbtn setEnabled:NO];
        [self.textField setEnabled:NO];
        self.showWord.hidden = NO;
        if ([self.delegate respondsToSelector:@selector(hiddenSubtitle:)]) {
            [self.delegate hiddenSubtitle:NO];
        }
    }
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if (IS_IPAD) {
        [self.showCurrentSubtitle setEnabled:YES];
        self.textField.frame = CGRectMake(self.textField.origin.x, 252, self.textField.width, self.textField.height);
        [self.translatorbtn setEnabled:YES];
        self.translatorbtn.frame = CGRectMake(self.translatorbtn.origin.x, self.textField.bottom + 10, self.translatorbtn.width, self.translatorbtn.height);
        if ([self.delegate respondsToSelector:@selector(hiddenSubtitle:)]) {
            [self.delegate hiddenSubtitle:YES];
        }
    }
}

- (void)p_subtitleTranslateResults
{
    if (!_selectSubtitle) {
        return;
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".+@／;（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+?'\""];
    NSString *content = [_selectSubtitle stringByTrimmingCharactersInSet:set];
    self.showWord.text = content;
    NSLog(@"%@",content);
   [GLNetworkRequest youdaoTranslateWithText:content returnJson:^(id result) {
       NSDictionary *transResults = result;
       NSDictionary *basic = [transResults objectForKey:@"basic"];
       NSArray *explains = [basic objectForKey:@"explains"];
       NSString *phonetic = [basic objectForKey:@"phonetic"];
       NSArray *translations = [transResults objectForKey:@"translation"];
       NSString *explainsStr = @"";
       for (NSString *str in explains) {
           explainsStr = [explainsStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",str]];
       }
       if ([translations count]) {
           self.translationLabel.text = [translations objectAtIndex:0];
       }
      
       self.showTranslateResult.text = explainsStr;
      
       self.phonetic.text            = phonetic;

   }];
}

- (IBAction)beginRecorder:(id)sender {
    _resultStr = [[NSMutableString alloc] init];
    _category = [[AVAudioSession sharedInstance]category];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    _recorderCount++;
    [_iflyRecognizerView start];
}

- (IBAction)translator:(id)sender {
    if ([_selectSubtitle isEqualToString:self.textField.text]) {
        [self.textField resignFirstResponder];
        self.showTranslateResult.hidden = NO;
        self.phonetic.hidden = NO;
    }else{
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:@"您的输入与字幕不匹配,请重新输入" delegate:self cancelButtonTitle:NSLocalizedString(@"SURE", @"") otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (IBAction)showCurrentWord:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:NSLocalizedString(@"OPEARTION_FEE", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"") otherButtonTitles:NSLocalizedString(@"SURE", @""),nil];
    void (^block)(NSInteger) = ^(NSInteger buttonIndex){
        if (buttonIndex == 1) {
            [self p_showSubtitleRequest];
        }
    };
    objc_setAssociatedObject(alert, &kAlertKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alert show];
}

- (IBAction)readOrWrite:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:NSLocalizedString(@"OPEARTION_FEE", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"") otherButtonTitles:NSLocalizedString(@"SURE", @""),nil];
    
    void (^block)(NSInteger) = ^(NSInteger buttonIndex){
        if (buttonIndex == 1) {
            [self p_showSubtitleRequest];
            self.textField.enabled = YES;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                _navLabel.text = _selectSubtitle;
                [_navLabel sizeToFit];
            }
        }
    };
    objc_setAssociatedObject(alert, &kAlertKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alert show];
}

- (IBAction)speech {

    [self.subtitleParse speechSubtitle];
    _isSpeech = YES;
}

- (IBAction)speechCurrentSubtilte:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(repeatCurrentSubtitle)]) {
        [self.delegate repeatCurrentSubtitle];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde{
    void (^block)(NSInteger) = objc_getAssociatedObject(alertView, &kAlertKey);
    if (block) {
       block(buttonInde);
    }
}

- (void)p_showSubtitleRequest
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [userDefaults stringForKey:@"sessionid"];
    NSString *f = @"1062";
    NSString *fe = @"1";
    NSLog(@"seesionid %@",sessionid);
    NSString *language  = @"EN";
    NSDictionary *params = @{@"sessionid"   : sessionid,
                             @"f"           : f,
                             @"fe"          : fe,
                             @"language"    : language
                             };
    [GLNetworkRequest showSubtitleCost:params costResults:^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        if(dic == nil || [dic count] <= 0){
            NSLog(@"显示字幕扣费网络错误");
            return;
        }
        NSString *code = [dic objectForKey:@"error_code"];
        NSString *msg  = [dic objectForKey:@"error_msg"];
        NSInteger state = [code integerValue];
        if (state == 0) {
            [self p_showAlertText:msg];
            self.showWord.hidden = NO;
            NSLog(@"%@",self.showWord.text);
            if ([self.delegate respondsToSelector:@selector(hiddenSubtitle:)]) {
                [self.delegate hiddenSubtitle:NO];
            }
        }else if(state == 1){
            [self p_showAlertText:msg];
        }else if (state == 2){
            [self p_showAlertText:msg];
        }else if (state == 5) {
            [self p_showAlertText:msg];
        }
    }];
    
//    [GLNetworkServer showSubtitleCost:params costResults:^(id result) {
//       
//    }];
}

- (void)p_showAlertText:(NSString *)messge {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:messge delegate:self cancelButtonTitle:NSLocalizedString(@"SURE", @"") otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)seriesSpeech:(id)sender {
    if (self.subtitleParse) {
        [self.subtitleParse speechSeriesSubtitle];
    }
}

- (IBAction)singleWord:(id)sender {
    
    if (self.subtitleParse) {
        [self.subtitleParse speechSingleSubtitle];
    }
}

- (IBAction)spellRead:(id)sender {
    
    if (self.subtitleParse) {
        [self.subtitleParse spellSingleSubtile];
    }
}

- (IBAction)nextWord:(id)sender {
    
    if (self.subtitleParse) {
        [self.subtitleParse setNextSubtitle];
    }
}

- (IBAction)backWord:(id)sender {
    
    if (self.subtitleParse) {
        [self.subtitleParse setBackSubtitle];
    }
}

#pragma mark IFlyRecognizerView Delegate

- (void)onResult:(IFlyRecognizerView *)iFlyRecognizerView theResult:(NSArray *)resultArray
{
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [_resultStr appendFormat:@"%@",key];
    }
    NSComparisonResult comparisonResult = [_resultStr caseInsensitiveCompare:self.textField.text];
    if (comparisonResult == NSOrderedSame) {
        self.phonetic.hidden = NO;
        self.showTranslateResult.hidden = NO;
        self.translationLabel.hidden = NO;
        _recorderCount = 0;
    }
}

- (void)onEnd:(IFlyRecognizerView *)iFlyRecognizerView theError:(IFlySpeechError *)error
{
    [[AVAudioSession sharedInstance] setCategory:_category error:nil];
    self.textField.text = _resultStr;
    if(_recorderCount == 3){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:NSLocalizedString(@"TRY_INPUT_WORLD", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"SURE", @"") otherButtonTitles:nil];
        [alert show];
        _recorderCount = 0;
        self.textField.enabled = YES;
    }
}

- (void)leaveKeyboradMode
{
    [self.textField resignFirstResponder];
}

- (IBAction)done:(id)sender {
    [sender resignFirstResponder];
}

- (void)clearText
{
    self.textField.text = @"";
}

- (UIToolbar *)accessoryView
{
    UIToolbar *toobar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 44.0f)];
    toobar.tintColor = [UIColor darkGrayColor];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:BARBUTTON(@"清除", @selector(clearText))];
    [items addObject:BARBUTTON(@"完成", @selector(leaveKeyboradMode))];
    toobar.items = items;
    return toobar;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
