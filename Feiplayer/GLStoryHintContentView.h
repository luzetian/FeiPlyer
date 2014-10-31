//
//  GLStoryHintContentView.h
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GLStoryHintContentViewDelegate <NSObject>

- (void)changeToZH;
- (void)changeToGZ;
- (void)changeToJP;
- (void)showTranslateView;
- (void)speechWord;
- (void)series;
- (void)singleWord;
- (void)spellWord;
- (void)cutWord;
- (void)chooseCutWord;
- (void)cancelCutWord;
- (void)backWord;
- (void)nextWord;

@end
@interface GLStoryHintContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeToZHButton;
@property (weak, nonatomic) IBOutlet UIButton *changeToGZButton;
@property (weak, nonatomic) IBOutlet UIButton *changeToJPButton;
@property (weak, nonatomic) IBOutlet UIButton *translateButton;
@property (weak, nonatomic) IBOutlet UIButton *speechButon;
@property (weak, nonatomic) IBOutlet UIButton *seriesButton;
@property (weak, nonatomic) IBOutlet UIButton *singleWordButton;
@property (weak, nonatomic) IBOutlet UIButton *spellReadButton;
@property (weak, nonatomic) IBOutlet UIButton *cutWordButton;
@property (weak, nonatomic) IBOutlet UIButton *cutWordOkButton;
@property (weak, nonatomic) IBOutlet UIButton *cutWordCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *backWordButton;
@property (weak, nonatomic) IBOutlet UIButton *nextWordButton;

@property (nonatomic, assign) id<GLStoryHintContentViewDelegate>delegate;
+ (GLStoryHintContentView *)storyHintContentView;

@end
