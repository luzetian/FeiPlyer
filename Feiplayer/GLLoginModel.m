//
//  GLLoginModel.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLLoginModel.h"
#import "GLModelConstants.h"
@implementation GLLoginModel
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"status" : @"status",
                             @"message" : @"message",
                             @"userinfo" : @"userinfo"
                             };
    return mapDic;
}

- (NSString *)userName
{
    if (_userName == nil) {
        _userName = [self.userinfo objectForKey:@"nick_name"];
    }
    return _userName;
    
}

- (NSString *)password
{
    if (_password == nil) {
        _password = [self.userinfo objectForKey:kLOGIN_PASSCODE];
    }
    return _password;
}

- (NSString *)userType
{
    if (_userType == nil) {
        _userType = [self.userinfo objectForKey:kLOGIN_TYPE];
    }
    return _userType;
}

- (NSString *)sessionid
{
    if (_sessionid == nil) {
        _sessionid = [self.userinfo objectForKey:kLOGIN_SESSIONID];
    }
    return _sessionid;
}

- (NSString *)age
{
    if (_age == nil) {
        _age = [self.userinfo objectForKey:kLOGIN_AGE];
    }
    return _age;
}
@end
