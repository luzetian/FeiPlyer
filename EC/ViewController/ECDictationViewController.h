//
//  ECGLDictationViewController.h
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECExamAnswers.h"
#import "ECVideoInfoModel.h"
@interface ECDictationViewController : UIViewController
@property (strong, nonatomic) ECVideoInfoModel *info;
@property (strong, nonatomic) ECExamAnswers *examAnswers;

@end
