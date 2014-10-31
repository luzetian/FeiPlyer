//
//  GLCollectionViewDataSource.m
//  VLC For IOS
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLCollectionViewDataSource.h"
@interface GLCollectionViewDataSource()
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) CollectionViewCellConfigureBlock block;
@property (strong, nonatomic) NSString *identifer;
@end
@implementation GLCollectionViewDataSource

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock {
    self = [super init];
    if (self) {
        NSAssert(aConfigureCellBlock, @"Collection View config block nil");
        self.items = [anItems copy];
        self.block = [aConfigureCellBlock copy];
        self.identifer = [aCellIdentifier copy];
    }
    return  self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifer forIndexPath:indexPath];
    if (self.block) {
        id item = [self itemAtIndexPath:indexPath];
        self.block(cell, item, indexPath);
    }
    return cell;
}
@end
