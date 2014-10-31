//
//  GLRecorderViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLRecorderViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "MLRecorder.h"
#import "GLRecorderTableViewCell.h"
#import "GLMediaLibrary.h"
#import "MLRecorder.h"
@interface GLRecorderViewController ()
@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSource;
@property (strong, nonatomic) NSArray *recoderList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GLRecorderViewController

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
    self.title = @"录音匹配";
     self.recoderList = [MLRecorder allRecorder];
    if ([self.recoderList count]) {
        [self setupTabelView];
    }
}

- (void)setupTabelView
{
    TableViewCellConfigureBlock configureBlock = ^(GLRecorderTableViewCell *cell,MLRecorder *recoder,NSIndexPath *indexPath){
        [cell configCell:recoder atIndexPath:indexPath];
    };
    
    TableViewCellDeleteBlock deleteBlock = ^(GLRecorderTableViewCell *cell,MLRecorder *recoder,NSIndexPath *indexPath){
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        if ([manager fileExistsAtPath:recoder.recorderPath]) {
            [manager removeItemAtPath:recoder.recorderPath error:&error];
            if (error) {
                NSLog(@"删除录音文件错误 %@",error);
                return;
            }
        }
        GLMediaLibrary *library = [GLMediaLibrary sharedMediaLibrary];
        [library deleteObject:recoder atEntity:@"Recorder"];
    };
   
    self.tableViewDataSource = [[GLTableViewDataSourceObject alloc]initWithItems:self.recoderList cellIdentifier:[GLRecorderTableViewCell identifier] configureCellBlock:configureBlock cellDeleteBlock:deleteBlock];
    self.tableView.dataSource = _tableViewDataSource;
    [self.tableView registerNib:[GLRecorderTableViewCell nib] forCellReuseIdentifier:[GLRecorderTableViewCell identifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
