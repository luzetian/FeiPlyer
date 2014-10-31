//
//  GLBaseTableViewCell.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBaseTableViewCell : UITableViewCell
+ (NSString *)identifier;
+ (UINib *)nib;
- (void)configWithItem:(id)item;
@end
