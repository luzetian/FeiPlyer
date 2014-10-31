//
//  GLSliderSwitchViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLSliderSwitchViewController.h"
#import "MMDrawerController+Subclass.h"
#import "UIViewController+MMDrawerController.h"
#import "GTSliderSwitchView.h"
#import "GLViewConfigure.h"
#import "GLViewInfoModel.h"
#import "GLDrawerViewController.h"
#import "GLVideoBrowseViewController.h"
#import "ECCassificationViewController.h"
@interface GLSliderSwitchViewController ()<GLSliderSwitchViewDelegate>
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet GTSliderSwitchView *sliderSwitchView;

@end

@implementation GLSliderSwitchViewController

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
}

- (id)initWithPlistIndex:(NSInteger )row
{
    if (self = [super init]) {
        self.index = row;
        self.contentViews = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)setup
{
//    [self.navigationItem setLeftBarButtonItem:IMGBARBUTTON([UIImage imageNamed:@"btn_MainView_leftSlider"], @selector(leftDrawerButtonPress:)) animated:YES];
//    [self.navigationItem setRightBarButtonItem:IMGBARBUTTON([UIImage imageNamed:@"btn_MainView_rightSlider"], @selector(rightDrawerButtonPress:)) animated:YES];
    GLViewConfigure *viewConfigure = [[GLViewConfigure alloc]init];
    GLViewInfoModel *model = [[GLViewInfoModel alloc]initWithItem:[viewConfigure videoMenu][self.index]];
    self.title = model.categoryName;
    self.sliderSwitchView.slideSwitchViewDelegate = self;
    for (NSString *title in model.categoryTitle) {
        
        Class className = NSClassFromString(model.className);
        UIViewController *viewController = [[className alloc]init];
        viewController.title = title;
        [self addChildViewController:viewController];
        [self.contentViews addObject:viewController];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self slideSwitchView:nil didselectTab:0];
   
    self.sliderSwitchView.tabItemNormalColor = [GTSliderSwitchView colorFromHexRGB:@"868686"];
    self.sliderSwitchView.tabItemSelectedColor = [GTSliderSwitchView colorFromHexRGB:@"bb0b15"];
    
    self.sliderSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    UIButton *rightSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow"] forState:UIControlStateNormal];
    [rightSideButton setImage:[UIImage imageNamed:@"icon_rightarrow"]  forState:UIControlStateHighlighted];
    rightSideButton.frame = CGRectMake(0, 0, 20.0f, 44.0f);
    rightSideButton.userInteractionEnabled = NO;
    self.sliderSwitchView.rigthSideButton = rightSideButton;
    [self.sliderSwitchView buildUI];
}

//#pragma mark - Button Handlers
//-(void)leftDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//}
//
//-(void)rightDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
//}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(GTSliderSwitchView *)view
{
    return [self.contentViews count];
}

- (UIViewController *)slideSwitchView:(GTSliderSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.contentViews[number];
}

- (void)slideSwitchView:(GTSliderSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    GLDrawerViewController *drawerController = (GLDrawerViewController *)self.navigationController.mm_drawerController;
    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(GTSliderSwitchView *)view didselectTab:(NSUInteger)number
{
    if (self.index < 8) {
        GLVideoBrowseViewController *vc = self.contentViews[number];
        [vc requestMovieListWith:self.index andSubtype:number];
    }else {
        ECCassificationViewController *vc = self.contentViews[number];
        NSIndexPath *index = [NSIndexPath indexPathForRow:number inSection:self.index] ;
        vc.indexPath = index;
    }
    
    //    if (self.plistIndex < 8) {
    //        GLBrowseMovieViewController *vc =[_browsViews objectAtIndex:number];
    //        [vc selectoMovie:_plistIndex andSubtype:number];
    //    }else{
    //        ECCassificationViewController *vc = _browsViews[number];
    //        NSIndexPath *index = [NSIndexPath indexPathForRow:number inSection:self.plistIndex] ;
    //        vc.indexPath = index;
    //    }
}

@end
