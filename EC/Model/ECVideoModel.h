//
//  GLVideoModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//


#import "GLBaseModel.h"

@interface ECVideoModel : GLBaseModel
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *enVideoName;
@property (strong, nonatomic) NSString *zhVideoName;
@property (strong, nonatomic) NSString *thumb;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *videoType;
@property (strong, nonatomic) NSString *videoType1;
@property (strong, nonatomic) NSString *totalEpisodes;
@property (strong, nonatomic) NSString *uploadEpisodes;
@property (strong, nonatomic) NSString *fileType;
@property (strong, nonatomic) NSString *focus;
@property (strong, nonatomic) NSString *compilations;
@property (strong, nonatomic) NSString *compilationsId;
@property (strong, nonatomic) NSString *createStaff;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *modifyStaff;
@property (strong, nonatomic) NSString *modifyTime;
@property (strong, nonatomic) NSString *sortNbr;
@property (strong, nonatomic) NSString *videoStatus;
@property (strong, nonatomic) NSString *contentAllTips;
@end
