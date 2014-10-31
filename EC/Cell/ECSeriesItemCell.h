//
//  GLSeriesItemCell.h
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSeriesListModel.h"

@interface ECSeriesItemCell : UICollectionViewCell
+ (NSString *)identifer;
- (void)configureWithItem:(id)item;
+ (UINib *)nib;
@property (strong, nonatomic) ECSeriesListModel *seriesInfo;
@end
