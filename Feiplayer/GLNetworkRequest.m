//
//  GLNetworkRequest.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLNetworkRequest.h"
#import "GLModelConstants.h"
#import "GLCommonHelper.h"
#import "GLNetworkConstants.h"
#import "GLAppUserDefaults.h"
#import "ECMianClassificationModel.h"
@implementation GLNetworkRequest
+ (void)loginRequestWithUserInfomation:(GLLoginModel *)userInfo succeeBlock:(SucceedBlock)succeed fail:(Fail)failBlock
{
    if (userInfo == nil) {
        failBlock(userInfo);
        return;
    }
    
    NSString *userName = userInfo.userName;
    NSString *passcode = userInfo.password;
    NSString *userType = userInfo.userType;
    NSString *passwords   = [GLCommonHelper md5StringForString:passcode];
    
    NSString *key =[[userName stringByAppendingString:passwords] stringByAppendingString:kLOGIN_KEY];
    key = [GLCommonHelper md5StringForString:key];
    
    NSDictionary *params = @{kLOGIN_USER_NAME:userName,
                             kLOGIN_PASSCODE:passwords,
                             kLOGIN_TYPE:userType,@"sign":key};
    
    [GLNetworkService httpRequestWithParam:params requestPath:kLOGIN_PATH success:^(id result) {
        GLLoginModel *loginModel = [[GLLoginModel alloc]initWithContent:result];
        NSInteger status = [loginModel.status integerValue];
        if (status == 1) {
            [GLAppUserDefaults setUserDefaultsValue:loginModel.userName forKey:kLOGIN_USER_NAME];
            [GLAppUserDefaults setUserDefaultsValue:passcode forKey:kLOGIN_PASSCODE];
            [GLAppUserDefaults setUserDefaultsValue:loginModel.age forKey:kLOGIN_AGE];
            [GLAppUserDefaults setUserDefaultsValue:loginModel.sessionid forKey:kLOGIN_SESSIONID];
            succeed(loginModel.userinfo);
        } else {
            failBlock(loginModel.message);
        }
    }];
}

+ (void)requestMovies:(NSDictionary *)requestInfo returnJson:(SucceedBlock)json requestFault:(Fail)fault
{
    if (requestInfo == nil) {
        return;
    }
    [GLNetworkService httpRequestWithParam:requestInfo requestPath:kMOVIE_LIST success:^(id result) {
        NSString *status = [result objectForKey:@"status"];
        if ([status integerValue] == -1) {
            fault(status);
        }else{
            json(result);
        }
    }];
}

+ (void)requestVideoDetailWith:(NSString *)videoID returnJson:(SucceedBlock)json requestFail:(Fail)fail
{
    if (videoID == nil) {
        return;
    }
    NSDictionary *dic = @{@"sessionid": [self sessionID],
                          @"film_id" : videoID};
    [GLNetworkService httpRequestWithParam:dic requestPath:kMOVIE_DETAILS success:^(id result) {
        NSDictionary *dic = result;
        if ([dic[@"status"] intValue] == 1) {
            json(dic[@"details"]);
        }else{
            [self alertMsg:dic[@"message"]];
        }
    }];
}

+ (void)translate:(NSDictionary *)params costResults:(SucceedBlock)json
{
    [GLNetworkService httpRequestWithParam:params requestPath:kTRANSLATE success:json];
}

+ (void)searchMovie:(NSString *)key returnJson:(SucceedBlock)json
{
    NSDictionary *parms = @{@"sessionid":[self sessionID],
                            @"age":[self age],
                            @"keywords":key,
                            @"page":@"1",
                            @"page_size":@"20"
                            };
    [GLNetworkService httpRequestWithParam:parms requestPath:kSEARCH_MOVIE success:json];
}

+ (void)baiduTranslateWithText:(NSString *)content returnJson:(SucceedBlock)json
{
    NSDictionary *params = @{@"from":@"en",
                             @"to":@"zh",
                             @"client_id":@"rwb94XxXowEcVQy5aW1ZQ0aH",
                             @"q":content
                             };
    
    [GLNetworkService baiduTranslateWithText:params returnJson:json];
}

+ (void)englishVideoDetailRequestWithVideoID:(NSString *)videoID
                                     success:(SucceedBlock)successBlock
{
    NSDictionary *param = @{@"sessionid": [self sessionID],
                            @"video_id":videoID};
    [GLNetworkService httpRequestWithParam:param requestPath:kVIDEO_INFO success:^(id result) {
        if (result != nil) {
            if ([result[@"error_code"] isEqualToString:@"0"]) {
                successBlock(result);
            } else {
                [self alertMsg:result[@"error_ msg"]];
            }
        }
    }];
}

+ (void)englishClassTestResultRequestTestId:(NSString *)aTestID
                                    videoId:(NSString *)aVideoId
                                    success:(SucceedBlock)successBlock
{
    NSDictionary *dic = @{@"result_id": aTestID,
                          @"sessionid":[self sessionID],
                          @"video_id": aVideoId};
    [GLNetworkService httpRequestWithParam:dic requestPath:kTEST_RESULTS success:successBlock];
    
}

+ (void)englishClassHalfTipsRequestWithVideoID:(NSString *)videoId
                                       success:(SucceedBlock)successBlock
{
    NSDictionary *dic = @{@"video_id": videoId,
                          @"sessionid":[self sessionID]};
    [GLNetworkService httpRequestWithParam:dic requestPath:kHALF_TIPS success:successBlock];
    
}

+ (void)studytrans:(NSDictionary *)params costResults:(SucceedBlock)json
{
      [GLNetworkService httpRequestWithParam:params requestPath:kTRANSLATESTUDY success:json];
}

+ (void)youdaoTranslateWithText:(NSString *)content returnJson:(SucceedBlock)json
{
    NSDictionary *parms = @{@"keyfrom":@"FeiPlayer",
                            @"key":@"945888533",
                            @"type":@"data",
                            @"doctype":@"json",
                            @"version":@"1.1",
                            @"q":content
                            };
    [GLNetworkService youdaoTranslateWithText:parms returnJson:json];
}

+ (void)englishClassAllTipsRequestWithVideoID:(NSDictionary *)videoId
                                      success:(SucceedBlock)successBlock
{
    NSDictionary *dic = @{@"video_id": videoId,
                          @"sessionid":[self sessionID]};
    [GLNetworkService httpRequestWithParam:dic requestPath:kALL_TIPS success:successBlock];
}

+ (void)switchSubtitleLanguage:(NSDictionary *)param costResults:(SucceedBlock)json
{
    if (!param || ![param count]) {
        NSLog(@"%@",param);
        return;
    }
    [GLNetworkService httpRequestWithParam:param requestPath:kTRANSLATE success:json];
    //    [GLNetworkServer switchSubtitleLanguage:param costResults:json];
}

+ (void)showSubtitleCost:(NSDictionary *)parmas
             costResults:(SucceedBlock)block
{
    [GLNetworkService httpRequestWithParam:parmas requestPath:SHOW_SUBTITLE success:block];
}

+ (NSString *)sessionID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [defaults objectForKey:@"sessionid"];
    return sessionID;
}

+ (NSString *)age
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *age = [defaults objectForKey:kLOGIN_AGE];
    return age;
}

+ (void)englishClassVideoListRequestWithType:(NSDictionary *)param
                                     success:(SucceedBlock)successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setValue:[self sessionID] forKey:@"sessionid"];
    [GLNetworkService httpRequestWithParam:params requestPath:kVIDEO_LIST success:^(id result) {
        if (result != nil) {
            if ([result[@"error_code"] isEqualToString:@"0"]) {
                successBlock(result[@"list"]);
            } else {
                [self alertMsg:result[@"error_ msg"]];
            }
        }
    }];
}

+ (void)englishClassSeriesListRequestWithParam:(NSDictionary *)param
                                       success:(SucceedBlock)successBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setValue:[self sessionID] forKey:@"sessionid"];
    [GLNetworkService httpRequestWithParam:params requestPath:kSERIES_LIST success:^(id result) {
        if (result != nil) {
            if ([result[@"error_code"] isEqualToString:@"0"]) {
                successBlock(result[@"series_info"]);
            } else {
                [self alertMsg:result[@"error_ msg"]];
            }
        }
    }];
}

+ (void)englishClassSubmitTestRequestWithType:(NSDictionary *)param
                                      success:(SucceedBlock)successBlock
{
    [GLNetworkService httpRequestWithParam:param requestPath:kSUBMIT_TEST success:^(id result) {
    
        if (result != nil) {
            if ([result[@"error_code"] isEqualToString:@"0"]) {
                successBlock(result);
            } else {
                [self alertMsg:result[@"error_ msg"]];
            }
        }
    }];
}

+ (void)sendTokenIDToService:(NSString *)tokenID userId:(NSString *)userId returnJson:(SucceedBlock)json
{
    NSDictionary *tokenDic = @{
                               @"userid": userId,
                               @"tokenid":tokenID
                               };
    [GLNetworkService httpRequestWithParam:tokenDic requestPath:kSEND_TOKEN success:json];
}

+ (void)checkUserRight:(NSDictionary *)params returnJson:(SucceedBlock)json
{
    [GLNetworkService httpRequestWithParam:params requestPath:kUSER_RIGHT success:json];
}

+ (void)englishClassMainClassificationRequestWithType:(NSString *)studyType
                                              success:(SucceedBlock)successBlock
{
    NSDictionary *params = @{@"sessionid": [self sessionID],
                             @"video_type": studyType
                             };
    [GLNetworkService httpRequestWithParam:params requestPath:kENGLISH_CLASS_MAIN success:^(id result) {
        if (result != nil) {
            ECMianClassificationModel *model =
            [[ECMianClassificationModel alloc]initWithContent:result];
            if (!model) {
                NSLog(@"english Class MainClassification Request error %@",model);
            }
            if ([model.errorCode isEqualToString:@"0"]) {
                successBlock(model.classification);
            } else {
                [self alertMsg:model.errorMsg];
            }
        }
    }];
}

+ (void)alertMsg:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
@end
