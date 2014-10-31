//
//  ECCorrectionViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECCorrectionViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "ECFillBlankViewController.h"
#import "ECAnswerTableViewCell.h"
#import "ECCorretionModel.h"
#import "GLAudioService.h"
@interface ECCorrectionViewController ()<UITextFieldDelegate,UITableViewDataSource>
@property (strong, nonatomic) ECCorretionModel *correctionModel;
@property (weak, nonatomic) IBOutlet UITextView *testTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSourceObject;
@property (strong, nonatomic) NSMutableArray *answerList;


@end

@implementation ECCorrectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.correctionModel = [[ECCorretionModel alloc]initWithContent:[self.info.correction firstObject]];
    self.testTextView.text = self.correctionModel.subject;
    self.answerList = [NSMutableArray array];
    [self.answerList addObject:@"2"];
    self.tableView.dataSource = self;
    [self.tableView registerNib:[ECAnswerTableViewCell nib] forCellReuseIdentifier:[ECAnswerTableViewCell identifer]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.answerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ECAnswerTableViewCell identifer]];
    if (cell == nil) {
        cell = [[ECAnswerTableViewCell alloc]initWithStyle:0 reuseIdentifier:[ECAnswerTableViewCell identifer]];
    }
    cell.indexLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.wordTextField.delegate = self;
    cell.modifyTextField.delegate = self;
    return cell;
}

- (IBAction)addAnswer:(id)sender {
    [self.answerList addObject:@"2"];
    [self.tableView reloadData];
}

- (IBAction)voiceTips:(id)sender {
    if (![self.testTextView.text length]) {
        
        return;
    }
  
    GLAudioService *audioService = [[GLAudioService alloc]init];
    [audioService speechText:self.testTextView.text withVoice:nil];
}

- (IBAction)next:(id)sender {
    NSArray *answser = [self.tableView visibleCells];
    if (![answser count] || ![self answer]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写答案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ECFillBlankViewController *viewController = [[ECFillBlankViewController alloc]init];
    viewController.examAnswers = self.examAnswers;
    viewController.info = self.info;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)answer
{
    NSArray *answser = [self.tableView visibleCells];
    NSMutableArray *correctionWord = [NSMutableArray array];
    NSMutableArray *correctionType = [NSMutableArray array];
    NSMutableArray *correctionAnwser = [NSMutableArray array];
    for (ECAnswerTableViewCell *cell in answser) {
        if (![cell.wordTextField.text length] || ![cell.modifyTextField.text length]) {
            return NO;
        }
        [correctionWord addObject:cell.wordTextField.text];
        [correctionAnwser addObject:cell.modifyTextField.text];
        [correctionType addObject:@"modify"];
    }
    self.examAnswers.videoId = self.info.videoId;
    self.examAnswers.coreectionType = correctionType;
    self.examAnswers.coreectionAnswer = correctionAnwser;
    self.examAnswers.correctionWord = correctionWord;
    return YES;
}

@end
