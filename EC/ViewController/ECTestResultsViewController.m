//
//  ECTestResultsViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECTestResultsViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "ECTestResultTableViewCell.h"
#import "ECVideoInfoModel.h"
#import "ECVideoModel.h"
#import "GLNetworkRequest.h"
@interface ECTestResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIWebView *tipsWebView;
@property (strong, nonatomic) ECVideoInfoModel *testModel;
@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSourceObject;
@property (weak, nonatomic) IBOutlet UILabel *testSortLabel;

@end

@implementation ECTestResultsViewController

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
    [self requestTestResult];
}

- (void)requestTestResult
{
    [GLNetworkRequest englishClassTestResultRequestTestId:self.examAnswers.testId videoId:self.examAnswers.videoId success:^(id results){
        if (results != nil) {
            self.testModel = [[ECVideoInfoModel alloc]initWithContent:results];
            [self setup];
        }
    }];
}

- (void)setup
{
    if (![self.testModel.testResults count]) {
        return;
    }
    NSString *total = [self.testModel.testSort objectForKey:@"total"];
    NSString *rank = [self.testModel.testSort objectForKey:@"mySort"];
    self.testSortLabel.text = [NSString stringWithFormat:@"本题%@人考试,你的排名是第%@",total,rank];
    TableViewCellConfigureBlock configureBlock = ^(ECTestResultTableViewCell *cell, id item,NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    [self.tableView registerNib:[ECTestResultTableViewCell nib] forCellReuseIdentifier:[ECTestResultTableViewCell identifer]];
    self.tableViewDataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:self.testModel.testResults cellIdentifier:[ECTestResultTableViewCell identifer] configureCellBlock:configureBlock];
    self.tableView.dataSource = self.tableViewDataSourceObject;
    [self.tableView reloadData];
}

- (IBAction)halfTips:(id)sender {
    [GLNetworkRequest englishClassHalfTipsRequestWithVideoID:self.examAnswers.videoId success:^(id result) {
        NSString *content = result[@"content"];
        [self.tipsWebView loadHTMLString:content baseURL:nil];
        NSLog(@"%@",result);
    }];
}

- (IBAction)allTips:(id)sender {
    [GLNetworkRequest englishClassAllTipsRequestWithVideoID:self.examAnswers.videoId success:^(id result) {
        NSString *content = result[@"content"];
        [self.tipsWebView loadHTMLString:content baseURL:nil];
        NSLog(@"%@",result);
    }];
}

- (IBAction)voiceTips:(id)sender {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
