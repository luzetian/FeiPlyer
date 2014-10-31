//
//  GLViewConfigure.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLViewConfigure : NSObject
- (NSArray *)videoMenu;
- (NSArray *)functionMenu;
- (NSDictionary *)requestMovieListWithMovieCollection:(NSInteger)collection
                                         andMovieType:(NSInteger)type;
@end
