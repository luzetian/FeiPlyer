//
//  SCRatingView.h
//  RatingView
//
//  Created by lynd on 14-4-18.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRatingView : UIControl
@property (nonatomic,assign) NSInteger value;
+ (id) control;
- (void)ratingValue:(NSInteger)value;
@end
