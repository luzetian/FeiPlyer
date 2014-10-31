//
//  GLSeriesListModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//
/*
 
 index.php/englishclassmobile/series
 
 series_id: "101",
 en_video_name: "BBC 新闻英语 初级 Part 13",
 zh_video_name: "BBC 新闻英语 初级 Part 13",
 thumb: "/public/upfiles/video/20140730172123.jpg",
 type: "A",
 video_status: "1",
 requetsParam: {
 video_type: "A",
 video_type1: "A",
 video_type2: "A",
 video_type3: "A"
 }
 },
 
 */

#import "GLBaseModel.h"
@interface ECSeriesListModel : GLBaseModel
@property (nonatomic, strong) NSString *seriesId;
@property (strong, nonatomic) NSString *enVideoName;
@property (strong, nonatomic) NSString *zhVideoName;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *videoType;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDictionary *requetsParam;
@property (strong, nonatomic) NSString *videoStatus;
@end
