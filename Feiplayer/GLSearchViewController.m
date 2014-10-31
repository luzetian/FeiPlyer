//
//  GLSearchViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLSearchViewController.h"
#import "GLCollectionViewDataSource.h"
#import "GLVideoDetailViewController.h"
#import "JGProgressHUD.h"
#import "GLMovieBrowseCell.h"
#import "GLNetworkRequest.h"
#import "GLVideoInfoModel.h"
@interface GLSearchViewController ()<UISearchBarDelegate,UICollectionViewDelegate>
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionViewDataSource;
@end

@implementation GLSearchViewController

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
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMovieBrowseCell" bundle:nil] forCellWithReuseIdentifier:@"MovieBrowseCell"];
}

#pragma mark ---- Collection Delegate ----
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectionViewDidSelectItemAtIndexPath:indexPath];
}

- (void)collectionViewDidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSDictionary *movieInfo = self.searchResults[row];
    NSLog(@"%@",movieInfo);
    GLVideoDetailViewController *popDetailViewController = [[GLVideoDetailViewController alloc]init];
    popDetailViewController.videoID = movieInfo[@"film_id"];
    [self.navigationController pushViewController:popDetailViewController animated:YES];
  
}

- (void)popDetailViewControllerWithMovieInfomation:(id)movieInfo
{
   
}

#pragma mark ---- Search Bar Delegate ----
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    JGProgressHUD *hub = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    [hub showInView:self.view];
    if ([searchBar.text length]) {
        [GLNetworkRequest searchMovie:searchBar.text returnJson:^(id result) {
            NSDictionary *dic = result;
            NSInteger statusCode = [[dic objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                self.searchResults = [dic objectForKey:@"films"];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:dic[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return ;
            }
            if ([self.searchResults count]) {
                [self setup];
            }else{
                hub.useProgressIndicatorView = NO;
                hub.textLabel.text = @"暂无此视频资源,请重新搜索";
            }
            [hub dismissAfterDelay:1];
            [searchBar resignFirstResponder];
        }];
    }
}

- (void)setup
{
    CollectionViewCellConfigureBlock configBlock = ^(GLMovieBrowseCell *cell, id item, NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    [self.collectionView registerNib:[GLMovieBrowseCell nib] forCellWithReuseIdentifier:[GLMovieBrowseCell identifier]];
    self.collectionViewDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.searchResults cellIdentifier:[GLMovieBrowseCell identifier] configureCellBlock:configBlock];
    self.collectionView.dataSource = self.collectionViewDataSource;
    self.collectionView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
