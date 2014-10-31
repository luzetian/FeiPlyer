//
//  ECBaseTableViewCell.h
//  EnglishRoom
//
//  Created by PES on 14-9-20.
//  Copyright (c) 2014年 PES. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ECBaseTableViewCell : UITableViewCell
+ (UINib *)nib;
+ (NSString *)identifer;
- (void)configureWithItem:(id)item;

@end
