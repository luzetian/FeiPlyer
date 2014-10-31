//
//  GLMultipleChoiceViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECMultipleChoiceViewController.h"
#import "ECExamAnswers.h"
#import "ECMultipleChoiceModel.h"
#import "ECCorrectionViewController.h"
#import "GLAudioService.h"
@interface ECMultipleChoiceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *cButton;
@property (weak, nonatomic) IBOutlet UIButton *dButton;
@property (weak, nonatomic) IBOutlet UITextView *tipsTextView;

@property (strong, nonatomic) ECMultipleChoiceModel *testInfo;
@property (strong, nonatomic) GLAudioService *audioService;
@property (assign, nonatomic) NSInteger optionIndex;
@property (strong, nonatomic) ECExamAnswers *examAnswers;
@end

@implementation ECMultipleChoiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.optionIndex = -1;
    self.testInfo = [[ECMultipleChoiceModel alloc]initWithContent:[self.info.multipleChoice firstObject]];
    self.audioService = [[GLAudioService alloc]init];
}

- (IBAction)optionAtion:(UIButton *)sender {
    self.aButton.selected = NO;
    self.bButton.selected = NO;
    self.cButton.selected = NO;
    self.dButton.selected = NO;
    sender.selected = YES;
    self.optionIndex = sender.tag;
}

- (IBAction)voiceTest:(id)sender {
    if (!self.testInfo) {
        return;
    }
    
    if (![self.testInfo.enSubject length]) {
        return;
    }
    [self.audioService speechText:self.testInfo.enSubject withVoice:nil];
}

- (IBAction)textTest:(id)sender {
    if (!self.testInfo) {
        return;
    }
    
    if (![self.testInfo.enSubject length]) {
        return;
    }
    self.tipsTextView.text = self.testInfo.enSubject;
}

- (IBAction)voiceTips:(id)sender {
    if (self.optionIndex == -1) {
        return;
    }
    if ([self.testInfo.options count] < self.optionIndex) {
        return;
    }
    NSString *test = [self.testInfo.options[self.optionIndex] objectForKey:@"option"];
    
    [self.audioService speechText:test withVoice:nil];
}

- (IBAction)textTips:(id)sender {
    if (self.optionIndex == -1) {
        return;
    }
    if ([self.testInfo.options count] < self.optionIndex) {
        return;
    }
    self.tipsTextView.text = [self.testInfo.options[self.optionIndex] objectForKey:@"option"];
}

- (IBAction)nextTset:(id)sender {
    if (self.optionIndex == -1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的答案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *key = [self.testInfo.options[self.optionIndex] objectForKey:@"test_id"];
    NSString *value = [self.testInfo.options[self.optionIndex] objectForKey:@"letter"];
    NSDictionary *multipleChoice = @{key: value};
    ECExamAnswers *examAnswers = [[ECExamAnswers alloc]init];
    examAnswers.multipleChoice = multipleChoice;
    examAnswers.testId = self.testInfo.testId;
    examAnswers.videoId = self.info.videoId;
    ECCorrectionViewController *correctionViewController = [[ECCorrectionViewController alloc]init];;
    correctionViewController.info = self.info ;
    correctionViewController.examAnswers = examAnswers;
    [self.navigationController pushViewController:correctionViewController animated:YES];
}

@end
