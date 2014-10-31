//
//  GLBaseCollectionViewCell.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBaseCollectionViewCell : UICollectionViewCell
+ (UINib *)nib;
+ (NSString *)identifier;
- (void)configureWithItem:(id)item;
@end
