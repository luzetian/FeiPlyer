//
//  SCRatingView.m
//  RatingView
//
//  Created by lynd on 14-4-18.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "SCRatingView.h"
#define WIDTH 15.0f
#define OFF_ART  [UIImage imageNamed:@"Star-White"]
#define ON_ART [UIImage imageNamed:@"Star-bule"]
@implementation SCRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float minimunWidth = 8.0 * WIDTH;
        float minimunHeight = 20.0f;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, MAX(frame.size.width, minimunWidth), MAX(minimunHeight, frame.size.height));
        float offsetCenter = WIDTH;
        
        for (int i = 0; i < 5; i++) {
            UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
            star.image = OFF_ART;
            star.center = CGPointMake(offsetCenter, self.frame.size.height / 2);
            offsetCenter += WIDTH * 1.5;
            [self addSubview:star];
        }
    }
    return self;
}
- (id)init{
    return [self initWithFrame:CGRectZero];
}

+ (id)control
{
    return [[self alloc]init];
}

- (void)updataValueAtPoint:(CGPoint)p
{
    UIImageView *changeView = nil;
    NSInteger value = 0;
    for (UIImageView *eachItem in [self subviews]) {
        if (p.x <eachItem.frame.origin.x) {
            eachItem.image = OFF_ART;
        }else{
            changeView = eachItem;
            eachItem.image = ON_ART;
            value++;
        }
    }
    if (self.value != value) {
        self.value = value;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [UIView animateWithDuration:0.15f animations:^{
            changeView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        } completion:^(BOOL finished) {
            changeView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)ratingValue:(NSInteger)value
{
    UIImageView *starView = [[self subviews]objectAtIndex:value];
    CGPoint p = starView.center;
    [self updataValueAtPoint:p];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self updataValueAtPoint:p];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    }else{
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
    [self updataValueAtPoint:touchPoint];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, touchPoint)) {
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    }else{
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    }
}

- (void)cancelTrackingWithEvent: (UIEvent *) event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}

@end
