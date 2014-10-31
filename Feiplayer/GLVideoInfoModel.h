//
//  GLVideoInfoModel.h
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
@interface GLVideoInfoModel : GLBaseModel
@property (nonatomic, strong) NSDictionary  *languages;
@property (nonatomic, strong) NSDictionary  *audio;
@property (nonatomic, strong) NSDictionary  *subtitle;

@property (nonatomic, assign) BOOL          *isEncrypted;
@property (nonatomic, strong) NSArray       *episodes;

@property (nonatomic, strong) NSString *fileImageURL;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSString *filmId;
@property (nonatomic, strong) NSString *filmName;
@property (nonatomic, strong) NSString *filmType;
@property (nonatomic, strong) NSString *mainActors;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *totalEpisodes;
@property (nonatomic, strong) NSString *upDateTime;
@property (nonatomic, strong) NSString *uploadEpisodes;
@property (nonatomic, strong) NSString *clickTimes;
@property (nonatomic, strong) NSString *commentScores;
@property (nonatomic, strong) NSString *commentTimes;
@property (nonatomic, strong) NSString *director;
@property (nonatomic, strong) NSString *filmEpisode;
@property (nonatomic, strong) NSString *vedioURL;

@end
