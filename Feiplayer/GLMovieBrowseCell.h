//
//  GLMovieBrowseCell.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseCollectionViewCell.h"
@interface GLMovieBrowseCell : GLBaseCollectionViewCell
@property (strong, nonatomic) NSString *videId;
- (void)Lanconfigure:(NSDictionary *)dic;
@end
