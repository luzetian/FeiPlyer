//
//  FeiBaseModel.h
//  Feiplayer
//
//  Created by Lt on 13-9-10.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBaseModel : NSObject

- (id)initWithContent:(NSDictionary *)json;

- (void)setModelData:(NSDictionary *)json;
@end
