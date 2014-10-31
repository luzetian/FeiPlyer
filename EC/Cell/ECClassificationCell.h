//
//  GLSeriesCell.h
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSubItemModel.h"

@interface ECClassificationCell : UICollectionViewCell
+ (NSString *)identifer;
+ (UINib *)nib;
- (void)configureWithItem:(id)item;
@property (strong, nonatomic,readonly) ECSubItemModel *classificationInfo;

@end
