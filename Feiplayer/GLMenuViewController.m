//
//  GLMenuViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMenuViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "GLMenuTableViewCell.h"
#import "GLViewConfigure.h"
#import "GLNewWordViewController.h"
#import "GLLocalFileViewController.h"
#import "GLSearchViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "GLLANSharingViewController.h"
#import "IASKAppSettingsViewController.h"
#import "GLLoginViewController.h"
#import "GLDictationViewController.h"
#import "GLRecorderViewController.h"
#import "GLDownloadViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
@interface GLMenuViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GLTableViewDataSourceObject *dataSourceObject;
@end

@implementation GLMenuViewController

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
    [self setup];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_icon"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.220 green:0.243 blue:0.282 alpha:1.000];

}

- (void)setup
{
    GLViewConfigure *viewConfigure = [[GLViewConfigure alloc]init];
    [self.tableView registerNib:[GLMenuTableViewCell nib] forCellReuseIdentifier:[GLMenuTableViewCell identifier]];
    
    NSArray *data = [viewConfigure functionMenu];
    if ([data count]) {
        self.dataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:data cellIdentifier:[GLMenuTableViewCell identifier] configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
            [cell configWithItem:item];
        }];
        self.tableView.dataSource = self.dataSourceObject;
        self.tableView.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *viewController;
    switch (indexPath.row) {
        case 0:
        {
            viewController = [[GLSearchViewController alloc]init];
        }
            break;
        case 1:
        {
            viewController = [[GLNewWordViewController alloc]init];
        }
            break;
        case 2:
        {
            viewController = [[GLDownloadViewController alloc]init];
        }
            break;
        case 3:
        {
            viewController = [[GLLocalFileViewController alloc]init];
        }
            break;
        case 4:
        {
            viewController = [[GLLANSharingViewController alloc]init];
        }
            break;
        case 5:
        {
            viewController = [[GLDictationViewController alloc]init];
        }
            break;
        case 6:
        {
            viewController = [[GLRecorderViewController alloc]init];
        }
            break;
        case 7:
        {
            viewController = [[IASKAppSettingsViewController alloc]init];
        }
            break;
        case 8:
        {
            viewController = [[GLLoginViewController alloc]init];
            [self presentViewController:viewController animated:YES completion:nil];
        }
            break;
       
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
