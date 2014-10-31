//
//  GLStoryHintRereadView.m
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLStoryHintRereadView.h"

@implementation GLStoryHintRereadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (GLStoryHintRereadView *)storyHintRereadView
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLStoryHintRereadView" owner:nil options:nil];
    GLStoryHintRereadView *view = (GLStoryHintRereadView *)[nibArray lastObject];
    return view;
}

- (IBAction)aRereadPointMark:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(aRereadPointMarkTime)]) {
        [self.delegate aRereadPointMarkTime];
    }
}

- (IBAction)bRereadPointMark:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(bRereadPointMarkTime)]) {
        [self.delegate bRereadPointMarkTime];
    }
}

- (IBAction)chooseTime:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chooseARereadPoint:andBtime:)]) {
        NSString *aTime = self.aRereadPointTextField.text;
        NSString *bTime = self.bRereadPointTextField.text;
        [self.delegate chooseARereadPoint:aTime andBtime:bTime];
    }
}

- (IBAction)cancelChoose:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelChoose)])
    {
        [self.delegate cancelChoose];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
