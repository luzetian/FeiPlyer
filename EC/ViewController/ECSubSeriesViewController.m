//
//  GLSubSeriesViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECSubSeriesViewController.h"
#import "GLCollectionViewDataSource.h"
#import "ECVideoSeriesViewController.h"
#import "ECClassificationCell.h"

//#import "GLVideoSeriesViewController.m"
@interface ECSubSeriesViewController ()<UICollectionViewDelegate>
@property (strong, nonatomic) GLCollectionViewDataSource *collectionDataSource;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ECSubSeriesViewController

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
    [self setup];
}

- (void)setup
{
    if (!self.seriesList || ![self.seriesList count]) {
        return;
    }
    
    CollectionViewCellConfigureBlock block = ^(ECClassificationCell *cell, id item,NSIndexPath *indexPath){
        cell.backgroundColor = [self randanColor];
        [cell configureWithItem:item];
    };
    self.collectionDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.seriesList cellIdentifier:[ECClassificationCell identifer] configureCellBlock:block];
    [self.collectionView registerNib:[ECClassificationCell nib] forCellWithReuseIdentifier:[ECClassificationCell identifer]];
    self.collectionView.dataSource = self.collectionDataSource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECClassificationCell *cell = (ECClassificationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ECVideoSeriesViewController *vc = [[ECVideoSeriesViewController alloc]init];
    vc.requestParams = cell.classificationInfo.seriesRequesParam;
    [self.navigationController pushViewController:vc animated:YES];
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

@end
