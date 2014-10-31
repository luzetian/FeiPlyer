//
//  GLDownloadViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLDownloadViewController.h"
#import "GLHTTPDownload.h"
#import "GLTableViewDataSourceObject.h"
#import "GLDownloadTableViewCell.h"

@interface GLDownloadViewController ()<GLHTTPDownloadDelegate,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *currentDownloads;
@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) NSTimeInterval startDL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *downloadList;
@property (strong, nonatomic) GLTableViewDataSourceObject *dataSourceObject;

@end

@implementation GLDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    GLHTTPDownload *download = [GLHTTPDownload shareHTTPDowload];
    download.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"下载";
    
    GLHTTPDownload *download = [GLHTTPDownload shareHTTPDowload];
    download.delegate = self;
    self.downloadList = download.downloadList;
    [self setup];
}

- (void)setup
{
    [self.tableView registerNib:[GLDownloadTableViewCell nib] forCellReuseIdentifier:[GLDownloadTableViewCell identifier]];
    self.dataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:self.downloadList cellIdentifier:[GLDownloadTableViewCell identifier] configureCellBlock:^(GLDownloadTableViewCell *cell, id item, NSIndexPath *indexPath) {
            [cell configWithItem:item];
        }];
    self.tableView.dataSource = self.dataSourceObject;
    self.tableView.delegate = self;
}

- (void)stopDownloadWithFile:(MLFile *)file
{
    NSArray *cellArray = [self.tableView visibleCells];
    for (GLDownloadTableViewCell *cell in cellArray) {
        if ([cell.file.video.url isEqualToString:file.video.url]) {
            cell.speedRate.text = @"等待缓存";
        }
    }
}

- (void)downloadFailedWithErrorDescription:(NSString *)description
{
    NSLog(@"%@",description);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)downloadFile:(MLFile *)file progress:(NSString *)progress fractionCompleted:(CGFloat)fraction speedRate:(NSString *)rate
{
    NSArray *cellArray = [self.tableView visibleCells];
    for (GLDownloadTableViewCell *cell in cellArray) {
        if ([cell.file.video.url isEqualToString:file.video.url]) {
            [cell.progressView setProgress:fraction];
            cell.speedRate.text = rate;
            cell.progress.text = progress;
        }
    }
}

- (void)downloadCompleted
{
    NSLog(@"下载完成");
    GLHTTPDownload *download = [GLHTTPDownload shareHTTPDowload];
    self.downloadList = download.downloadList;
    [self setup];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLDownloadTableViewCell *cell = (GLDownloadTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
     GLHTTPDownload *download = [GLHTTPDownload shareHTTPDowload];
    if ([download downloading]) {
        [download pause];
    }else{
        [download startDownloadWithFile:cell.file]; 
    }
}

- (void)startDownloadName:(NSString *)name
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
