//
//  FeiSpeechRecognitionViewController.h
//  VLC for iOS
//
//  Created by lynd on 13-11-27.
//  Copyright (c) 2013年 VideoLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLSpeechRecognitionDelegate <NSObject>
@optional
- (void)speechRecognitionViewDidAppear;
- (void)speechRecognitionViewDidDisappear;
- (void)repeatCurrentSubtitle;
- (void)hiddenSubtitle:(BOOL)isHidden;
@end

@interface GLSpeechRecognitionViewController : UIViewController
//当前显示的整句字幕
@property (nonatomic, strong) NSString * currentSubtitle;
//用户划到的单词
@property (nonatomic, strong) NSString * selectSubtitle;
@property (nonatomic, assign) id<GLSpeechRecognitionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton * showCurrentSubtitle;
@property (weak, nonatomic) IBOutlet UIButton * speechCurrentSubtitleBtn;
@end
