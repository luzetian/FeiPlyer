//
//  ECFillBlankViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECFillBlankViewController.h"
#import "ECDictationViewController.h"
#import "ECFillBlankTableViewCell.h"
#import "GLTableViewDataSourceObject.h"
#import "GLAudioService.h"
#import "ECFillBlankModel.h"
@interface ECFillBlankViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) ECFillBlankModel *fillBlankModel;

@property (weak, nonatomic) IBOutlet UITextView *testTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSourceObject;

@end

@implementation ECFillBlankViewController

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
    self.fillBlankModel = [[ECFillBlankModel alloc]initWithContent:[self.info.fillBlank firstObject]];
    self.testTextView.text = self.fillBlankModel.subject;
    [self setup];
}

- (void)setup
{
    TableViewCellConfigureBlock configure = ^(ECFillBlankTableViewCell *cell, id item,NSIndexPath *indexPath){
        cell.fillBlanTextField.delegate = self;
        cell.indexLabel.text = [NSString stringWithFormat:@"在位置%d中填写",indexPath.row];
    };
    [self.tableView registerNib:[ECFillBlankTableViewCell nib] forCellReuseIdentifier:[ECFillBlankTableViewCell identifer]];
    self.tableViewDataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:self.info.fillBlank cellIdentifier:[ECFillBlankTableViewCell identifer] configureCellBlock:configure];
    self.tableView.dataSource = self.tableViewDataSourceObject;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)voiceTips:(id)sender {
    if (![self.testTextView.text length]) {
        return;
    }
    GLAudioService *audioService = [[GLAudioService alloc]init];
    [audioService speechText:self.testTextView.text withVoice:nil];
}

- (IBAction)next:(id)sender {
    if (![self answer]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写答案" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ECDictationViewController *viewController = [[ECDictationViewController alloc]init];
    viewController.info = self.info;
    viewController.examAnswers = self.examAnswers;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)answer
{
    NSInteger index = 0;
    NSMutableArray *list = [NSMutableArray array];
    for (ECFillBlankTableViewCell *cell in [self.tableView visibleCells]) {
        if (![cell.fillBlanTextField.text length]) {
            return NO;
        }
        ECFillBlankModel *model = [[ECFillBlankModel alloc]initWithContent:self.info.fillBlank[index]];
        NSDictionary *dic = @{model.optionId: cell.fillBlanTextField.text};
        [list addObject:dic];
        index++;
    }
    
    self.examAnswers.fillBlank = list;
    return YES;
}

//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"DictationSegue"]) {
//        ECDictationViewController *viewController = segue.destinationViewController;
//        viewController.info = self.info;
//        viewController.examAnswers = self.examAnswers;
//    }
//}


@end
