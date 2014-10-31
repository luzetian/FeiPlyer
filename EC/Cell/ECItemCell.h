//
//  GLEnglishRoomItemCell.h
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ECItemCell : UICollectionViewCell
@property (strong, nonatomic) NSArray *movieTypes;
@property (strong, nonatomic) NSArray *subItem;
@property (strong, nonatomic) NSDictionary *requestParams;
+ (NSString *)identifer;
- (void)configureWithItem:(id)item;
@end
