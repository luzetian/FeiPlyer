//
//  GLViewInfoModel.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLViewInfoModel : NSObject
- (id)initWithItem:(NSDictionary *)item;
@property (strong, nonatomic, readonly) NSString *className;
@property (strong, nonatomic, readonly) NSString *categoryName;
@property (strong, nonatomic, readonly) NSArray  *categoryTitle;
@property (strong, nonatomic, readonly) NSArray  *categoryParameters;
@end
