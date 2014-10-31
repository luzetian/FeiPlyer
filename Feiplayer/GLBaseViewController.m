//
//  GLBaseViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface GLBaseViewController ()

@end

@implementation GLBaseViewController

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
    if (IS_IPHONE) {
        [self.navigationItem setLeftBarButtonItem:IMGBARBUTTON([UIImage imageNamed:@"btn_MainView_leftSlider"], @selector(leftDrawerButtonPress:)) animated:YES];
        [self.navigationItem setRightBarButtonItem:IMGBARBUTTON([UIImage imageNamed:@"btn_MainView_rightSlider"], @selector(rightDrawerButtonPress:)) animated:YES];
    }
    if (IS_IPHONE) {
        [self loadIphoneTheme];
    } else {
        
    }
}

- (void)loadIphoneTheme
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor colorWithRed:0.263 green:0.522 blue:0.792 alpha:1.000];
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{ UITextAttributeTextColor : [UIColor whiteColor],UITextAttributeFont :[UIFont boldSystemFontOfSize:20.0] };
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
