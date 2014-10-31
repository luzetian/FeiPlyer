//
//  GLClassificationModel.h
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

/* 
 ndex.php/englishclassmobile/classification
 这个模型用来解析
 subitems: [
 {},
 {},
 {},
 {}
 ],
 dict_desc: "bbc",
 r_status: "Y",
 type: "A",

*/
#import "GLBaseModel.h"

@interface ECClassificationModel : GLBaseModel

@property (strong, nonatomic) NSString *classType;

@property (strong, nonatomic) NSArray *subitems;

@property (strong, nonatomic) NSString *classificationTitle;

@property (strong, nonatomic) NSString *classificationType;

@property (strong, nonatomic) NSString *status;
@end
