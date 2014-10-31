//
//  ECMultipleChoice.h
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseModel.h"
@interface ECMultipleChoiceModel : GLBaseModel
//"cn_subject":"中文标题",
@property (strong, nonatomic) NSString *cnSubject;
//subject英文标题
@property (strong, nonatomic) NSString *enSubject;
//"integral":"题目分数"
@property (strong, nonatomic) NSString *integral;
//"integral":"题目分数"
@property (strong, nonatomic) NSArray *options;
//"test_id":"题目ID",
@property (strong, nonatomic) NSString *testId;
//"test_type":"题目类型",
@property (strong, nonatomic) NSString *testType;

@end
