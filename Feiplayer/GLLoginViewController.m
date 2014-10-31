//
//  GLLoginViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLLoginViewController.h"
#import "GLNetworkRequest.h"
#import "GLAppUserDefaults.h"
#import "GLLoginModel.h"
#import "JGProgressHUD.h"
#import "GLVideoMenuViewController.h"
#import "GLMenuViewController.h"
#import "GLDrawerViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "GLVideoBrowseViewController.h"
#import "GLSliderSwitchViewController.h"
@interface GLLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *uidTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *rememberPassWordButton;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;

@end

@implementation GLLoginViewController

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
    [GLAppUserDefaults setBoolValue:YES forKey:FIREST_LAUNCH];
    if ([GLAppUserDefaults boolValueForKey:REMEMBER_PASSWORD]) {
        self.uidTextField.text = [GLAppUserDefaults stringValueForKey:kLOGIN_USER_NAME];
        self.passwordTextField.text = [GLAppUserDefaults stringValueForKey:kLOGIN_PASSCODE];
        self.checkBoxButton.selected = YES;
    }
}

- (IBAction)login:(id)sender {
    
    JGProgressHUD *hub = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    if (![self.uidTextField.text length] || ![self.passwordTextField.text length]) {
        hub.textLabel.text = @"请输入账号密码";
        hub.useProgressIndicatorView = NO;
        [hub showInView:self.view];
        [hub dismissAfterDelay:1];
       
    } else {
        GLLoginModel *loginModel = [[GLLoginModel alloc]init];
        loginModel.userName = self.uidTextField.text;
        loginModel.userType = @"n";
        loginModel.password = self.passwordTextField.text;
        hub.textLabel.text = NSLocalizedString(@"USER_LOGIN", @"");
        [hub showInView:self.view];
        
        [GLNetworkRequest loginRequestWithUserInfomation:loginModel succeeBlock:^(id result) {
            if (IS_IPAD) {
                [self loadIpad];
            }else{
                [self loadIphone];
            }
            [hub dismiss];
            
            /*  开启推送证书后使用
            NSData *data =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
            if (data) {
                NSString *tokenid = [[NSString alloc]initWithFormat:@"%@",data];
                tokenid = [tokenid stringByReplacingOccurrencesOfString:@" " withString:@""];
                tokenid = [tokenid stringByReplacingOccurrencesOfString:@"<" withString:@""];
                tokenid = [tokenid stringByReplacingOccurrencesOfString:@">" withString:@""];
                NSString *userID = [result objectForKey:@"user_id"];
                if (![userID length]) {
                    return ;
                }
                [GLNetworkRequest sendTokenIDToService:tokenid userId:userID returnJson:^(id result) {
                }];
            }
             */
        } fail:^(id result) {
            hub.textLabel.text = result;
            [hub dismissAfterDelay:2 animated:YES];
        }];
    }
}
    
- (NSString *)userPathWithName:(NSString *)name
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = searchPaths[0];
    directoryPath = [directoryPath stringByAppendingPathComponent:name];
    if (![[NSFileManager defaultManager]fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}

- (IBAction)rememberPassword:(UIButton *)sender {
    BOOL selecte = sender.selected;
    self.rememberPassWordButton.selected = !selecte;
    [GLAppUserDefaults setBoolValue:!selecte forKey:REMEMBER_PASSWORD];
}

- (void)loadIpad
{
    
}

- (void)loadIphone
{
    GLVideoMenuViewController *videoMenuViewController = [[GLVideoMenuViewController alloc]init];
    GLMenuViewController *menuViewController = [[GLMenuViewController alloc]init];
    GLSliderSwitchViewController *viewController = [[GLSliderSwitchViewController alloc]initWithPlistIndex:0];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    GLDrawerViewController *baseViewController;
    if (SYSTEM_RUNS_IOS7_OR_LATER) {
        UINavigationController *rightNavigation = [[UINavigationController alloc]initWithRootViewController:menuViewController];
        UINavigationController *leftNavigation = [[UINavigationController alloc]initWithRootViewController:videoMenuViewController];
        baseViewController = [[GLDrawerViewController alloc]initWithCenterViewController:navigationController leftDrawerViewController:leftNavigation rightDrawerViewController:rightNavigation];
    }else{
        baseViewController = [[GLDrawerViewController alloc]initWithCenterViewController:navigationController leftDrawerViewController:videoMenuViewController rightDrawerViewController:menuViewController];
    }
    [baseViewController setRestorationIdentifier:@"MMDrawer"];
    [baseViewController setMaximumLeftDrawerWidth:200.0];
    [baseViewController setMaximumRightDrawerWidth:200.0];
    [baseViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [baseViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [baseViewController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }

     }];
    self.view.window.rootViewController = baseViewController;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
