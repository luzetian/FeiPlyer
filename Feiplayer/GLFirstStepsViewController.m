//
//  GLFirstStepsViewController.m
//  FirstSteps
//
//  Created by lynd on 14-5-15.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLFirstStepsViewController.h"
#import "GLLoginViewController.h"
#import "GLFirstStepsFirstPageViewController.h"
#import "GLFirstStepsFourthPageViewController.h"
#import "GLFirstStepsFifthPageViewController.h"
#import "GLFirstStepsThirdPageViewController.h"
#import "GLFirstStepsSecondPageViewController.h"

@interface GLFirstStepsViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
{
      UIPageViewController *pageVC;
}
@end

@implementation GLFirstStepsViewController

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
     pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    
    
    [pageVC setViewControllers:@[[[GLFirstStepsFirstPageViewController alloc] initWithNibName:nil bundle:nil]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:pageVC];
   
    [self.view addSubview:[pageVC view]];
    [[pageVC view] setFrame:[[self view] frame]];
    
    [pageVC didMoveToParentViewController:self];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    UIViewController *returnedVC;
    NSUInteger currentPage = 0;
    
    if ([viewController respondsToSelector:@selector(page)])
        currentPage = (NSUInteger)[viewController performSelector:@selector(page) withObject:nil];
    
    switch (currentPage) {
        case 5:
            returnedVC = [[GLLoginViewController alloc] initWithNibName:nil bundle:nil];
            [self presentViewController:returnedVC animated:YES completion:nil];
            //self.view.window.rootViewController = returnedVC;
            break;
        case 1:
            returnedVC = [[GLFirstStepsSecondPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 2:
            returnedVC = [[GLFirstStepsThirdPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 3:
            returnedVC = [[GLFirstStepsFourthPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 4:
            returnedVC = [[GLFirstStepsFifthPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
            
        default:
            nil;
    }
    
    return returnedVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    UIViewController *returnedVC;
    NSUInteger currentPage = 0;
    
    if ([viewController respondsToSelector:@selector(page)])
        currentPage = (NSUInteger)[viewController performSelector:@selector(page) withObject:nil];
    
    switch (currentPage) {
        case 2:
            returnedVC = [[GLFirstStepsFirstPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 3:
            returnedVC = [[GLFirstStepsSecondPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 4:
            returnedVC = [[GLFirstStepsThirdPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 5:
            returnedVC = [[GLFirstStepsFourthPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
        case 1:
            returnedVC = [[GLFirstStepsFifthPageViewController alloc] initWithNibName:nil bundle:nil];
            break;
            
        default:
            nil;
    }
    
    return returnedVC;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)dismissFirstSteps
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //self.title = [[pageViewController viewControllers][0] pageTitle];
}

@end
