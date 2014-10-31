//
//  GLTranslateView.h
//  VLC For IOS
//
//  Created by lynd on 14-5-7.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLTranslateView : UIView
+ (GLTranslateView *)translateView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
