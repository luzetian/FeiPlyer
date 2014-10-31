//
//  GLStoryView.m
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLStoryHintView.h"
#import "GLSubtitleParse.h"
@interface GLStoryHintView()<GLStoryHintRereadViewDelegate,GLStoryHintContentViewDelegate>
{
    GLSubtitleParse *_subtitleParse;
}
@property (assign, nonatomic)  CGPoint beginPoint;
@property (strong, nonatomic)  UISegmentedControl *segmentControl;


@end
@implementation GLStoryHintView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.size = CGSizeMake(280, 280);
        self.frame = frame;
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 45, 45)];
    [closeButton setTitle:@"x" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    self.segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"剧情提示",@"A - B 复读"]];
    [self.segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setSelectedSegmentIndex:0];
    self.segmentControl.frame = CGRectMake(20, 50, 240, 29);
    [self addSubview:self.segmentControl];
    
    self.storyHintContentView = [GLStoryHintContentView storyHintContentView];
   
    self.storyHintRereadView = [GLStoryHintRereadView storyHintRereadView];
    
    [self addSubview:self.storyHintRereadView];
    [self addSubview:self.storyHintContentView];
    self.storyHintRereadView.hidden = YES;
    CGPoint point = CGPointMake(0, self.segmentControl.frame.origin.y + self.segmentControl.frame.size.height + 10);
    CGRect frame = self.storyHintContentView.frame;
    frame.origin = point;
    self.storyHintRereadView.delegate = self;
    self.storyHintContentView.delegate = self;
    self.storyHintContentView.frame = frame;
    self.storyHintRereadView.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)segmentAction:(id)sender
{
    UISegmentedControl *segment = sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            self.storyHintRereadView.hidden = YES;
            self.storyHintContentView.hidden = NO;
        }
            break;
            case 1:
        {
            self.storyHintRereadView.hidden = NO;
            self.storyHintContentView.hidden = YES;
        }
        break;
            
        default:
            break;
    }
}

- (void)aRereadPointMarkTime
{
    if ([self.delegate respondsToSelector:@selector(aRereadPointMarkTime)]) {
        [self.delegate aRereadPointMarkTime];
    }
}

- (void)bRereadPointMarkTime
{
    if ([self.delegate respondsToSelector:@selector(bRereadPointMarkTime)]) {
        [self.delegate bRereadPointMarkTime];
    }
}

- (void)chooseARereadPoint:(NSString *)atime andBtime:(NSString *)btime
{
    if ([self.delegate respondsToSelector:@selector(chooseARereadPoint:andBtime:)]) {
        [self.delegate chooseARereadPoint:atime andBtime:btime];
    }
}

- (void)cancelChoose
{
    if ([self.delegate respondsToSelector:@selector(cancelChoose)]) {
        [self.delegate cancelChoose];
    }
}

- (void)changeToZH
{
    if ([self.delegate respondsToSelector:@selector(changeToZH)]) {
        [self.delegate changeToZH];
    }
}

- (void)changeToGZ
{
    if ([self.delegate respondsToSelector:@selector(changeToGZ)]) {
        [self.delegate changeToGZ];
    }
}

- (void)changeToJP
{
    if ([self.delegate respondsToSelector:@selector(changeToJP)]) {
        [self.delegate changeToJP];
    }
}

- (void)showTranslateView
{
    if ([self.delegate respondsToSelector:@selector(showTranslateView)]) {
        [self.delegate showTranslateView];
    }
}

- (void)speechWord
{
    if ([self.delegate respondsToSelector:@selector(speechWord)]) {
        [self.delegate speechWord];
    }
}

- (void)series
{
    if ([self.delegate respondsToSelector:@selector(series)]) {
        [self.delegate series];
    }
}

- (void)singleWord
{
    if ([self.delegate respondsToSelector:@selector(singleWord)]) {
        [self.delegate singleWord];
    }
}

- (void)spellWord
{
    if ([self.delegate respondsToSelector:@selector(spellWord)]) {
        [self.delegate spellWord];
    }
}

- (void)cutWord
{
    if ([self.delegate respondsToSelector:@selector(cutWord)]) {
        [self.delegate cutWord];
    }
}

- (void)chooseCutWord
{
    if ([self.delegate respondsToSelector:@selector(chooseCutWord)]) {
        [self.delegate chooseCutWord];
    }
}

- (void)cancelCutWord
{
    if ([self.delegate respondsToSelector:@selector(cancelCutWord)]) {
        [self.delegate cancelCutWord];
    }
}

- (void)backWord
{
    if ([self.delegate respondsToSelector:@selector(backWord)]) {
        [self.delegate backWord];
    }
}

- (void)nextWord
{
    if ([self.delegate respondsToSelector:@selector(nextWord)]) {
        [self.delegate nextWord];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    CGRect frame = self.frame;
    frame.origin.y += currentLocation.y - self.beginPoint.y;
    frame.origin.x += currentLocation.x - self.beginPoint.x;
    if (frame.origin.y > (768 - self.frame.size.height)||frame.origin.y < 0) {
        return;
    }
    if (frame.origin.x > (1024 - self.frame.size.width) || frame.origin.x < 0) {
        return;
    }
    self.frame = frame;
}

- (void)closeView:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closeView)]) {
        [self.delegate closeView];
    }
}

@end
