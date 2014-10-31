//
//  GLDictationViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLDictationViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "GLDictationTableViewCell.h"
#import "MLSubtitleComparison.h"
#import "GLMediaLibrary.h"
@interface GLDictationViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dictationList;

@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSource;
@end

@implementation GLDictationViewController

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
     self.title = @"自助听写";
    self.dictationList = [MLSubtitleComparison allSubtitle];
    if ([self.dictationList count]) {
        [self setup];
    }
}

- (void)setup
{
    [self.tableView registerNib:[GLDictationTableViewCell nib] forCellReuseIdentifier:[GLDictationTableViewCell identifier]];
    TableViewCellConfigureBlock configureBlock = ^(GLDictationTableViewCell *cell,MLSubtitleComparison *subtitle,NSIndexPath *indexPath){
        [cell configureDiction:subtitle atIndexPath:indexPath];
    };
    TableViewCellDeleteBlock deleteBlock = ^(GLDictationTableViewCell *cell,MLSubtitleComparison *item,NSIndexPath *indexPath){
        MLSubtitleComparison *db = item;
        GLMediaLibrary *library = [GLMediaLibrary sharedMediaLibrary];
        [library deleteObject:db atEntity:@"SubtitleComparison"];
        [library save];
        //[self setUpTabelView];
    };
   
    
    self.tableViewDataSource = [[GLTableViewDataSourceObject alloc]initWithItems:_dictationList cellIdentifier:[GLDictationTableViewCell identifier] configureCellBlock:configureBlock cellDeleteBlock:deleteBlock];
    self.tableView.delegate = self;
    self.tableView.dataSource = self.tableViewDataSource;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
