//
//  GLMovieListInfoModel.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMovieListInfoModel.h"
@interface GLMovieListInfoModel()
@property (assign, nonatomic) GLMovieListInfoModelParseType parseType;

@end
@implementation GLMovieListInfoModel
- (id)initWithContent:(NSDictionary *)json forParseType:(GLMovieListInfoModelParseType)type
{
    self.parseType = type;
    return [self initWithContent:json];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)mapAttributes
{
    NSDictionary *mapDic = nil;
    if (self.parseType == GLDefaultType) {
        mapDic = @{
                   @"status" : @"status",
                   @"message" : @"message",
                   @"films" : @"films",
                   @"pageinfo":@"pageinfo"
                   };
    }else if (self.parseType == GLFilmsType){
        mapDic = @{
                   @"movieID" : @"film_id",
                   @"movieName" : @"film_name",
                   @"moviePicture" : @"film_pic",
                   @"movieUpdateTime":@"update_time",
                   @"movieClickTime":@"click_times"
                   };
    }else if(self.parseType == GLPageInfoType){
        mapDic = @{
                   @"movieTotal" : @"page_total",
                   @"page" : @"page",
                   @"moviePageSize" : @"page_size",
                   @"recordCount":@"record_count"
                   };
    }
    return mapDic;
}

- (NSString *)sessionID
{
    if (_sessionID == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _sessionID = [defaults objectForKey:@"sessionid"];
    }
    return _sessionID;
}
@end
