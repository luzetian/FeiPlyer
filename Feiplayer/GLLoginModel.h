//
//  GLLoginModel.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
@interface GLLoginModel : GLBaseModel
@property (nonatomic, copy)     NSDictionary *userinfo;
@property (nonatomic, copy)     NSNumber     *status;
@property (nonatomic, copy)     NSString     *message;
@property (nonatomic, strong)   NSString *age;
@property (nonatomic, strong)   NSString *password;
@property (nonatomic, strong)   NSString *sessionid;
@property (nonatomic, strong)   NSString *userName;
@property (nonatomic, strong)   NSString *userType;
@end
