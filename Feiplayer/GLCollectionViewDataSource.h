//
//  GLCollectionViewDataSource.h
//  VLC For IOS
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CollectionViewCellConfigureBlock)(id cell, id item,NSIndexPath *indexPath);

@interface GLCollectionViewDataSource : NSObject<UICollectionViewDataSource>
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(CollectionViewCellConfigureBlock)aConfigureCellBlock;
@end
