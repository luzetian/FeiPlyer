//
//  GLStoryHintContentView.m
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLStoryHintContentView.h"

@implementation GLStoryHintContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (GLStoryHintContentView *)storyHintContentView
{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLStoryHintContentView" owner:nil options:nil];
    GLStoryHintContentView *view = (GLStoryHintContentView *)[nibArray lastObject];
    return view;
}

- (IBAction)changeToZH:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeToZH)]) {
        [self.delegate changeToZH];
    }
}

- (IBAction)changeToGZ:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeToGZ)]) {
        [self.delegate changeToGZ];
    }
}

- (IBAction)changeToJP:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(changeToJP)]) {
        [self.delegate changeToJP];
    }
}

- (IBAction)showTranslateView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(showTranslateView)]) {
        [self.delegate showTranslateView];
    }
}

- (IBAction)speechWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(speechWord)]) {
        [self.delegate speechWord];
    }
}

- (IBAction)series:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(series)]) {
        [self.delegate series];
    }
}

- (IBAction)singleWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(singleWord)]) {
        [self.delegate singleWord];
    }
}

- (IBAction)spellWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(spellWord)]) {
        [self.delegate spellWord];
    }
}

- (IBAction)cutWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cutWord)]) {
        [self.delegate cutWord];
    }
}

- (IBAction)chooseCutWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(chooseCutWord)]) {
        [self.delegate chooseCutWord];
    }
}

- (IBAction)cancelCutWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelCutWord)]) {
        [self.delegate cancelCutWord];
    }
}

- (IBAction)backWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(backWord)]) {
        [self.delegate backWord];
    }
}

- (IBAction)nextWord:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(nextWord)]) {
        [self.delegate nextWord];
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
