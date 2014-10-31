//
//  ECDictationModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
@interface ECDictationModel : GLBaseModel
@property (strong, nonatomic) NSString *testId;
@property (strong, nonatomic) NSString *testType;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *cnSubject;
@property (strong, nonatomic) NSString *integral;
@property (strong, nonatomic) NSString *optionId;
@property (strong, nonatomic) NSString *optionType;
@property (strong, nonatomic) NSString *actionType;
@property (strong, nonatomic) NSString *option;
@property (strong, nonatomic) NSString *cnOption;
@property (strong, nonatomic) NSString *beginTime;
@property (strong, nonatomic) NSString *Endtime;

@end

/*
 {
 "test_id":"题目ID",
 "test_type":"题目类型",
 "video_id":"视频ID",
 "subject":"题目主题",
 "cn_subject":"中文标题",
 "integral":"题目分数",
 "r_create_staff":"创建人",
 "r_create_time":"创建时间",
 "r_modify_staff":"修改人",
 "r_modify_time":"修改时间",
 "status":"状态",
 "sort":"排序",
 "option_id":"选项ID",
 "option_type":"纠错类型",
 "action_type":"纠错动作",
 "option":"正确答案",
 "cn_option":"正确答案翻译",
 "time1":"开始时间",
 "time2":结束时间
 },
 */