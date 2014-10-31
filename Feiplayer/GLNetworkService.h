//
//  GLNetworkService.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SucceedBlock)(id result);
typedef void(^Fail)(id result);
@interface GLNetworkService : NSObject

+ (void)httpRequestWithParam:(NSDictionary *)param requestPath:(NSString *)path success:(SucceedBlock)successBlock;

+ (void)youdaoTranslateWithText:(NSDictionary *)params returnJson:(SucceedBlock)json;


+ (void)baiduTranslateWithText:(NSDictionary *)params returnJson:(SucceedBlock)json;

/*!
 *  检查网络连接
 *
 *  @return 有网络连接返回YES
 *
 *  @since 1.0
 */
+ (BOOL)hasNetWork;

+ (BOOL)isEnableWIFI;

+ (BOOL)isEnable3G;
@end
