//
//  ECGLDictationViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECDictationViewController.h"
#import "ECTestResultsViewController.h"
#import "ECDictationModel.h"
#import "GLAudioService.h"
#import "GLNetworkRequest.h"
#import "GLAppUserDefaults.h"
@interface ECDictationViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) ECDictationModel *firstExamModel;
@property (strong, nonatomic) ECDictationModel *secondExamModel;
@property (weak, nonatomic) IBOutlet UITextField *firstExamTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondExamTextField;
@property (weak, nonatomic) IBOutlet UITextView *tipsLabel;
@property (strong, nonatomic) GLAudioService *audioService;

@end

@implementation ECDictationViewController

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
    if ([self.info.dictation count]) {
        self.firstExamModel = [[ECDictationModel alloc]initWithContent:self.info.dictation[0]];
        self.secondExamModel = [[ECDictationModel alloc]initWithContent:self.info.dictation[1]];
        self.audioService = [[GLAudioService alloc]init];
    }
    
    self.firstExamTextField.delegate = self;
    self.secondExamTextField.delegate = self;
}

- (IBAction)firsExamVoice:(id)sender {
    if (![self.info.dictation count]) {
        return;
    }
   [self.audioService speechText:self.firstExamModel.option withVoice:nil];
}

- (IBAction)firstExamText:(id)sender {
    if (![self.info.dictation count]) {
        return;
    }
    self.tipsLabel.text = self.firstExamModel.option;
}

- (IBAction)secondExamVoice:(id)sender {
    if (![self.info.dictation count]) {
        return;
    }
    [self.audioService speechText:self.secondExamModel.option withVoice:nil];
}

- (IBAction)secondExamText:(id)sender {
    if (![self.info.dictation count]) {
        return;
    }
    self.tipsLabel.text = self.secondExamModel.option;
}

- (IBAction)next:(id)sender {
    if (![self anwser]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写答案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self submitTest];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)anwser
{
    if (![self.firstExamTextField.text length] || ![self.secondExamTextField.text length]) {
        return NO;
    }
    if (!self.firstExamModel || !self.secondExamModel) {
        return NO;
    }
    NSDictionary *first = @{self.firstExamModel.optionId: self.firstExamTextField.text};
    NSDictionary *second = @{self.secondExamModel.optionId: self.firstExamTextField.text};
    NSArray *anwserList = @[first,second];
    self.examAnswers.dictation = anwserList;
    return YES;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"DictationSegue"]) {
//        ECTestResultsViewController *testResults = segue.destinationViewController;
//        testResults.examAnswers = self.examAnswers;
//    }
//}

- (void)submitTest
{
    if (!self.examAnswers) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [defaults objectForKey:kLOGIN_SESSIONID];
    NSDictionary *dic = @{
                          @"video_id": self.examAnswers.videoId,
                          @"start_time": self.examAnswers.startTime,
                          @"data_c": self.examAnswers.multipleChoice,
                          @"data_a_subject": self.examAnswers.correctionWord,
                          @"data_a_action_type": self.examAnswers.coreectionType,
                          @"data_a_option": self.examAnswers.coreectionAnswer,
                          @"data_b": self.examAnswers.fillBlank,
                          @"data_d": self.examAnswers.dictation,
                          @"sessionid" : sessionid,
                          @"ip": @"127.0.0.1"
                          };
    [GLNetworkRequest englishClassSubmitTestRequestWithType:dic success:^(id result){
        ECTestResultsViewController *testResults = [[ECTestResultsViewController alloc]init];
        testResults.examAnswers = self.examAnswers;
        [self.navigationController pushViewController:testResults animated:YES];
    }];
}


@end
