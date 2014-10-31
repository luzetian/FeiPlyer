//
//  GLNetworkService.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLNetworkService.h"
#import "GLNetworkConstants.h"
#import "AFNetworking.h"
#import "Reachability.h"
@implementation GLNetworkService

+ (void)httpRequestWithParam:(NSDictionary *)param requestPath:(NSString *)path success:(SucceedBlock)successBlock
{
    if ([self hasNetWork]) {
        NSString *urlstring = [BASE_URL stringByAppendingString:path];
        [self startPostRequest:param url:urlstring competeBlock:successBlock failure:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无网络连接,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

+ (void)startPostRequest:(NSDictionary *)params
                     url:(NSString *)urlstring
            competeBlock:(SucceedBlock)block
                 failure:(void (^)(NSError *error))failure
{
    
    if (![urlstring length]) {
        return;
    }
    if (![params count] || !params) {
        return;
    }
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage POST:urlstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post request error %@",[error localizedDescription]);
        //failure(error);
    }];
}

+ (void)startGetRequesturl:(NSString *)urlstring
              competeBlock:(SucceedBlock)block
                   failure:(void (^)(NSError *error))failure
{
    if (![urlstring length]) {
        return;
    }
    NSLog(@"url %@",urlstring);
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manage GET:urlstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure(error);
    }];
}

+ (void)youdaoTranslateWithText:(NSDictionary *)params returnJson:(SucceedBlock)json
{
    NSString *urlstring = [kYOUDAO_BASE_AIP stringByAppendingFormat:kYOUDAO_TRANS];
    [self startPostRequest:params url:urlstring competeBlock:json failure:nil];
}

+ (void)baiduTranslateWithText:(NSDictionary *)params returnJson:(SucceedBlock)json
{
    NSString *urlstring = [kBAIDU_BASE_AIP stringByAppendingFormat:kBAIDU_TRANS];
    [self startPostRequest:params url:urlstring competeBlock:json failure:nil];
}

//是否wifi
+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}

+ (BOOL)hasNetWork {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
@end
