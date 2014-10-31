//
//  GLStoryView.h
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLStoryHintContentView.h"
#import "GLStoryHintRereadView.h"
@protocol GLStoryHintViewDelegate <NSObject>
- (void)aRereadPointMarkTime;
- (void)bRereadPointMarkTime;
- (void)backWord;
- (void)cancelChoose;
- (void)cancelCutWord;
- (void)changeToGZ;
- (void)changeToJP;
- (void)changeToZH;
- (void)chooseARereadPoint:(NSString *)atime andBtime:(NSString *)btime;
- (void)chooseCutWord;
- (void)closeView;
- (void)cutWord;
- (void)nextWord;
- (void)series;
- (void)showTranslateView;
- (void)singleWord;
- (void)speechWord;
- (void)spellWord;
@end

@interface GLStoryHintView : UIView
@property (strong, nonatomic)  GLStoryHintRereadView    *storyHintRereadView;
@property (strong, nonatomic)  GLStoryHintContentView   *storyHintContentView;
@property (assign, nonatomic)  id<GLStoryHintViewDelegate> delegate;
@end
