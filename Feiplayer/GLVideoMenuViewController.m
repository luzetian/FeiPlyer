//
//  GLVideoMenuViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLVideoMenuViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "UIViewController+MMDrawerController.h"
#import "GLMenuTableViewCell.h"
#import "GLViewConfigure.h"
#import "GLSliderSwitchViewController.h"
@interface GLVideoMenuViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) GLTableViewDataSourceObject *dataSourceObject;

@end

@implementation GLVideoMenuViewController

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
    NSArray *data = [viewConfigure videoMenu];
    if ([data count]) {
        self.dataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:data cellIdentifier:[GLMenuTableViewCell identifier] configureCellBlock:^(id cell, id item, NSIndexPath *indexPath) {
            [cell configWithItem:item];
        }];
        self.tableView.dataSource = self.dataSourceObject;
        self.tableView.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLSliderSwitchViewController *sliderViewController = [[GLSliderSwitchViewController alloc]initWithPlistIndex:indexPath.row];
    UINavigationController *navigationView = [[UINavigationController alloc]initWithRootViewController:sliderViewController];
    [self.mm_drawerController setCenterViewController:navigationView
                                   withCloseAnimation:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
