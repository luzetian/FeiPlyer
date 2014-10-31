//
//  GLSeriesModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
/*
 用于解析两个subitems
 classification ->subitems->subitems
 index.php/englishclassmobile/classification
 
 [
    {
    subitems: [],
    dict_desc: "bbc",
    r_status: "Y",
    type: "A",
    requetsParam: {
    video_type: "A",
    video_type1: "A"
    }
 ]
 */
@interface ECSubItemModel : GLBaseModel
@property (strong, nonatomic) NSString *seriesTitle;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDictionary *seriesRequesParam;
@property (strong, nonatomic) NSArray *subItem;
@end
