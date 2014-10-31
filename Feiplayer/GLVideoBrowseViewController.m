//
//  GLVideoBrowseViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLVideoBrowseViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "GLMovieBrowseCell.h"
#import "UIViewController+MMDrawerController.h"
#import "GLViewConfigure.h"
#import "GLNetworkRequest.h"
#import "GLMovieListInfoModel.h"
#import "GLCollectionViewDataSource.h"
#import "GLVideoDetailViewController.h"
@interface GLVideoBrowseViewController ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSUInteger videoIndex;
@property (strong, nonatomic) NSArray *movieListArray;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionViewDataSource;

@end

@implementation GLVideoBrowseViewController

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
}

- (void)requestMovieListWith:(NSInteger)type andSubtype:(NSInteger)subtype
{
    self.videoIndex = type;
    GLViewConfigure *configure = [[GLViewConfigure alloc]init];
   
    NSDictionary *param = [configure requestMovieListWithMovieCollection:type andMovieType:subtype];
    if (param != nil) {
        [self requestMoviesInfomation:param];
    }
}

- (void) requestMoviesInfomation:(NSDictionary *)dic
{
    if (dic == nil) {
        NSLog(@"%@",dic);
        return;
    }
    [GLNetworkRequest requestMovies:dic returnJson:^(id result) {
        GLMovieListInfoModel *model = [[GLMovieListInfoModel alloc]initWithContent:result forParseType:GLDefaultType];
        self.movieListArray = model.films;
        [self.collectionView reloadData];
        CGPoint point = CGPointMake(0, 0);
        [self.collectionView setContentOffset:point animated:NO];
        [self setup];
    } requestFault:^(id result) {
       
    }];
}

- (void)setup
{
    CollectionViewCellConfigureBlock configBlock = ^(GLMovieBrowseCell *cell, id item, NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    [self.collectionView registerNib:[GLMovieBrowseCell nib] forCellWithReuseIdentifier:[GLMovieBrowseCell identifier]];
    self.collectionViewDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.movieListArray cellIdentifier:[GLMovieBrowseCell identifier] configureCellBlock:configBlock];
    self.collectionView.dataSource = self.collectionViewDataSource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLMovieBrowseCell *cell = (GLMovieBrowseCell *)[collectionView cellForItemAtIndexPath:indexPath];
    GLVideoDetailViewController *detailViewController = [[GLVideoDetailViewController alloc]init];
    detailViewController.videoID = cell.videId;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
@end
