//
//  GLSeriesViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECCassificationViewController.h"
#import "GLCollectionViewDataSource.h"
#import "ECVideoSeriesViewController.h"
#import "ECSubSeriesViewController.h"
#import "ECClassificationCell.h"
#import "GLNetworkRequest.h"
#import "GLSelectorView.h"
#import "ECClassificationModel.h"
//#import "UIBarButtonItem+Theme.h"
#import "GLAppDelegate.h"
@interface ECCassificationViewController ()<UICollectionViewDelegate,GLSelectorViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) GLSelectorView *selectorView;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionDataSource;
@property (strong, nonatomic) NSArray *classification;
@end

@implementation ECCassificationViewController

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.selectorView = [[GLSelectorView alloc]initWithFrame:CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y - 70, 0, 0)];
        
        self.selectorView.dataSource = self;
        [self.selectorView addTarget:self action:@selector(movieTypeChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.selectorView];
    }
    [self.collectionView registerNib:[ECClassificationCell nib] forCellWithReuseIdentifier:[ECClassificationCell identifer]];
    [self navigationConfigure];
    [self requestEnglisRoomInfomation];
}

- (void)setup
{
    if (![self.classification count]) {
        return;
    }
    ECClassificationModel *model = [[ECClassificationModel alloc]initWithContent:self.classification[[self.indexPath row]]];
    
    CollectionViewCellConfigureBlock configureBlock = ^(ECClassificationCell *cell, id item,NSIndexPath *indexPath){
        cell.backgroundColor = [self randanColor];
        [cell configureWithItem:item];
    };
    self.collectionDataSource = [[GLCollectionViewDataSource alloc]initWithItems:model.subitems cellIdentifier:[ECClassificationCell identifer] configureCellBlock:configureBlock];
    
    self.collectionView.dataSource = self.collectionDataSource;
    self.collectionView.delegate = self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [self requestEnglisRoomInfomation];
}

- (void)movieTypeChange:(GLSelectorView *)selectorView
{
    self.indexPath = [NSIndexPath indexPathForRow:selectorView.value inSection:self.indexPath.section];
}

- (void)requestEnglisRoomInfomation
{
    NSString *movieType = nil;
    if (self.indexPath.section == 8) {
        movieType = @"A";
    }else{
        movieType = @"B";
    }
    
    [GLNetworkRequest englishClassMainClassificationRequestWithType:movieType success:^(id result) {
        if (result != nil) {
            if ([result isKindOfClass:[NSArray class]]) {
                self.classification = result;
                [self setup];
            } else {
                NSLog(@"request EnglisRoom Infomation error %@\n",result);
            }
        } else {
            NSLog(@"request EnglisRoom Infomation is nil %@\n",result);
        }
    }];
}

- (void)navigationConfigure
{
    if (IS_IPAD) {
//        UIBarButtonItem *menuBarbutton = [UIBarButtonItem themedRevealMenuButtonWithTarget:self andSelector:@selector(leftButtonAction:)];
//        self.navigationItem.leftBarButtonItem = menuBarbutton;
//        self.navigationItem.rightBarButtonItem = self.editButtonItem;
//        self.editButtonItem.tintColor = [UIColor whiteColor];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECClassificationCell *cell = (ECClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.classificationInfo.subItem) {
        ECSubSeriesViewController *vc = [[ECSubSeriesViewController alloc]init];
        vc.seriesList = cell.classificationInfo.subItem;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ECVideoSeriesViewController *vc = [[ECVideoSeriesViewController alloc]init];
        vc.requestParams = cell.classificationInfo.seriesRequesParam;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSArray *)titleofArray:(GLSelectorView *)tableView
{
    NSArray *title = @[@"BBC",@"CNN",@"VOA"];
    return title;
}

- (UIColor *)randanColor
{
    NSInteger colorIndex = arc4random() % 12;
    switch (colorIndex) {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor grayColor];
            break;
        case 2:
            return [UIColor greenColor];
            break;
        case 3:
            return [UIColor blueColor];
            break;
        case 4:
            return [UIColor brownColor];
            break;
        case 5:
            return [UIColor purpleColor];
            break;
        case 6:
            return [UIColor orangeColor];
            break;
        case 7:
            return [UIColor colorWithRed:1.000 green:0.965 blue:0.722 alpha:1.000];
            break;
        case 8:
            return [UIColor colorWithRed:0.125 green:0.612 blue:0.102 alpha:1.000];
            break;
        case 9:
            return [UIColor colorWithRed:0.141 green:0.686 blue:0.910 alpha:1.000];
            break;
        case 10:
            return [UIColor colorWithRed:0.796 green:0.792 blue:0.792 alpha:1.000];
            break;
        case 11:
            return [UIColor magentaColor];
            break;
    }
    return nil;
}

- (IBAction)leftButtonAction:(id)sender
{
//    [[(GLAppDelegate*)[UIApplication sharedApplication].delegate revealController] toggleSidebar:![(GLAppDelegate*)[UIApplication sharedApplication].delegate revealController].sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
