//
//  GLTimeSelectorView.h
//  pickerView
//
//  Created by lynd on 14-6-5.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLTimeSelectorView;
@protocol GLTimeSelectorViewDelegate <NSObject>

- (void)selectorTime:(NSString *)time selectorView:(GLTimeSelectorView *)selectorView;

- (void)cancelSelectorView:(GLTimeSelectorView *)selectorView;
@end
@interface GLTimeSelectorView : UIView
@property (nonatomic, strong)id<GLTimeSelectorViewDelegate>delegate;
@end
