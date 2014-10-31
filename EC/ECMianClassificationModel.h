//
//  GLMianClassificationModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//
/*
 英语课堂主分类接口.
 index.php/englishclassmobile/classification?
 
 error_code: "0",
 error_msg: "",
 classification: [
 {},
 {},
 {}
 ]
 }
 
 */


#import "GLBaseModel.h"


@interface ECMianClassificationModel : GLBaseModel
@property (strong, nonatomic) NSString *errorCode;
@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSArray  *classification;
@end
