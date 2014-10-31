//
//  GLViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//
#import "GLNetworkRequest.h"
#import "ECViewController.h"
#import "GLCollectionViewDataSource.h"
#import "ECItemCell.h"
#import "ECCassificationViewController.h"
@interface ECViewController ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *classification;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionDataSource;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestEnglisRoomInfomation];
}

- (void)requestEnglisRoomInfomation
{
    [GLNetworkRequest englishClassMainClassificationRequestWithType:@"A" success:^(id result) {
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

- (void)setup
{
    if (![self.classification count]) {
        return;
    }
    CollectionViewCellConfigureBlock configureBlock = ^(ECItemCell *cell, id item,NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    self.collectionDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.classification cellIdentifier:[ECItemCell identifer] configureCellBlock:configureBlock];
    self.collectionView.dataSource = self.collectionDataSource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ECItemCell *cell = (ECItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.subItem count]) {
        [self performSegueWithIdentifier:@"SeriesSegue" sender:cell];
    }else{
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ECItemCell *cell = sender;
    if ([cell isKindOfClass:[ECItemCell class]]) {
        if ([segue.identifier isEqualToString:@"SeriesSegue"]) {
            ECCassificationViewController *cassificationViewController = segue.destinationViewController;
            cassificationViewController.series = cell.subItem;
        }else if ([segue.identifier isEqualToString:@"ListSegue"]){
            
        }
    }
}

@end
