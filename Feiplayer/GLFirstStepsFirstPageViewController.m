//
//  GLFirstStepsViewController.m
//  FirstSteps
//
//  Created by lynd on 14-5-15.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLFirstStepsFirstPageViewController.h"

@interface GLFirstStepsFirstPageViewController ()

@end

@implementation GLFirstStepsFirstPageViewController

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
    UIImage *image;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        image = [UIImage imageNamed:@"iphoneStep1"];
    }else{
        image = [UIImage imageNamed:@"ipadStep1"];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    self.view = imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)pageTitle
{
    return @"第一个页面";
}

- (NSUInteger)page
{
    return 1;
}

@end
