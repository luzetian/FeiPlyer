//
//  GLMovieListInfoModel.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
typedef NS_ENUM(NSUInteger, GLMovieListInfoModelParseType) {
    GLDefaultType,
    GLFilmsType,
    GLPageInfoType,
};

@interface GLMovieListInfoModel : GLBaseModel

- (id)initWithContent:(NSDictionary *)json forParseType:(GLMovieListInfoModelParseType)type;

@property (nonatomic, strong) NSArray  *films;
@property (nonatomic, strong) NSDictionary *pageinfo;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *movieClickTime;
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *movieMainType;
@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *moviePageSize;
@property (nonatomic, strong) NSString *moviePicture;
@property (nonatomic, strong) NSString *movieSubtype;
@property (nonatomic, strong) NSString *movieTotal;
@property (nonatomic, strong) NSString *movieUpdateTime;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *recordCount;
@property (nonatomic, strong) NSString *sessionID;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *year;
@end
