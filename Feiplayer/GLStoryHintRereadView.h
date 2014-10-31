//
//  GLStoryHintRereadView.h
//  StoryHintView
//
//  Created by lynd on 14-6-6.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GLStoryHintRereadViewDelegate <NSObject>

- (void)aRereadPointMarkTime;
- (void)bRereadPointMarkTime;
- (void)chooseARereadPoint:(NSString *)atime andBtime:(NSString *)btime;
- (void)cancelChoose;

@end

@interface GLStoryHintRereadView : UIView

+ (GLStoryHintRereadView *)storyHintRereadView;
@property (strong, nonatomic)   id<GLStoryHintRereadViewDelegate>delegate;
@property (weak, nonatomic)     IBOutlet UITextField *aRereadPointTextField;
@property (weak, nonatomic)     IBOutlet UITextField *bRereadPointTextField;

@end
