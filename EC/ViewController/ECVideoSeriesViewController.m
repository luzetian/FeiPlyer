//
//  GLVideoSeriesViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECVideoSeriesViewController.h"
#import "GLCollectionViewDataSource.h"
#import "ECNewsListViewController.h"
#import "GLNetworkRequest.h"
#import "ECSeriesItemCell.h"
@interface ECVideoSeriesViewController ()<UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *seriesList;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionDataSource;

@end

@implementation ECVideoSeriesViewController

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
    [self requestMovieList];
}

- (void)requestMovieList
{
    if (!self.requestParams || ![self.requestParams count]) {
        return;
    }
    [GLNetworkRequest englishClassSeriesListRequestWithParam:self.requestParams success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            self.seriesList = result;
            [self setup];
        }
    }];
}

- (void)setup
{
    if (!self.seriesList || ![self.seriesList count]) {
        return;
    }
    
    CollectionViewCellConfigureBlock block = ^(ECSeriesItemCell *cell, id item,NSIndexPath *indexPath){
        [cell configureWithItem:item];
        NSLog(@"%@",item);
    };
    self.collectionDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.seriesList cellIdentifier:[ECSeriesItemCell identifer] configureCellBlock:block];
    [self.collectionView registerNib:[ECSeriesItemCell nib] forCellWithReuseIdentifier:[ECSeriesItemCell identifer]];
    self.collectionView.dataSource = self.collectionDataSource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECSeriesItemCell *cell = (ECSeriesItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.seriesInfo.videoType isEqualToString:@"A"]) {
        ECNewsListViewController *viewController = [[ECNewsListViewController alloc]init];
        viewController.model = cell.seriesInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
//        [self performSegueWithIdentifier:@"USTVSeries" sender:cell];
    }
}

@end
