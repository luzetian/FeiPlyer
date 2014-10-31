//
//  GLNetworkRequest.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLNetworkService.h"
#import "GLLoginModel.h"
@interface GLNetworkRequest : NSObject

+ (void)sendTokenIDToService:(NSString *)tokenID userId:(NSString *)userId returnJson:(SucceedBlock)json;
+ (void)checkUserRight:(NSDictionary *)params returnJson:(SucceedBlock)json;
+ (void)switchSubtitleLanguage:(NSDictionary *)param costResults:(SucceedBlock)json;
+ (void)loginRequestWithUserInfomation:(GLLoginModel *)userInfo succeeBlock:(SucceedBlock)succeed fail:(Fail)failBlock;
+ (void)requestMovies:(NSDictionary *)requestInfo returnJson:(SucceedBlock)json requestFault:(Fail)fault;
+ (void)requestVideoDetailWith:(NSString *)videoID returnJson:(SucceedBlock)json requestFail:(Fail)fail;
+ (void)searchMovie:(NSString *)key returnJson:(SucceedBlock)json;
+ (void)youdaoTranslateWithText:(NSString *)content returnJson:(SucceedBlock)json;
+ (void)showSubtitleCost:(NSDictionary *)parmas
             costResults:(SucceedBlock)block;
+ (void)englishClassVideoListRequestWithType:(NSDictionary *)param
                                     success:(SucceedBlock)successBlock;
+ (void)translate:(NSDictionary *)params costResults:(SucceedBlock)json;
+ (void)baiduTranslateWithText:(NSString *)content returnJson:(SucceedBlock)json;
+ (void)studytrans:(NSDictionary *)params costResults:(SucceedBlock)json;
+ (void)englishClassSeriesListRequestWithParam:(NSDictionary *)param
                                       success:(SucceedBlock)successBlock;
+ (void)englishClassMainClassificationRequestWithType:(NSString *)studyType
                                              success:(SucceedBlock)successBlock;
+ (void)englishVideoDetailRequestWithVideoID:(NSString *)videoID
                                     success:(SucceedBlock)successBlock;
+ (void)englishClassTestResultRequestTestId:(NSString *)aTestID
                                    videoId:(NSString *)aVideoId
                                    success:(SucceedBlock)successBlock;
+ (void)englishClassHalfTipsRequestWithVideoID:(NSString *)videoId
                                       success:(SucceedBlock)successBlock;
+ (void)englishClassAllTipsRequestWithVideoID:(NSString *)videoId
                                      success:(SucceedBlock)successBlock;
+ (void)englishClassSubmitTestRequestWithType:(NSDictionary *)param
                                      success:(SucceedBlock)successBlock;
@end
