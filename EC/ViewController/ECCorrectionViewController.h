//
//  ECCorrectionViewController.h
//  EnglishRoom
//
//  Created by PES on 14-9-18.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECVideoInfoModel.h"
#import "ECExamAnswers.h"
@interface ECCorrectionViewController : UIViewController
@property (strong, nonatomic) ECExamAnswers *examAnswers;
@property (strong, nonatomic) ECVideoInfoModel *info;
@end
