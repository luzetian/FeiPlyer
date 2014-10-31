//
//  LTSelectorView.m
//  selectorController
//
//  Created by lynd on 14-3-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLSelectorView.h"
@interface GLSelectorView()
{
    NSInteger _userSelectedTag;
}
@end
@implementation GLSelectorView
#define kVIEW_HEIGHT 44.0f
#define kVIEW_WIDTH  891.0f
#define kBUTTON_HEIGHT 44.0f
#define kBUTTON_WIDTH  70.0f
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildView];
         self.frame = CGRectMake(frame.origin.x, frame.origin.y, kVIEW_WIDTH, kVIEW_HEIGHT);
        _userSelectedTag = 100;
        self.backgroundColor = [UIColor colorWithWhite:0.224 alpha:1.000];
        self.layer.cornerRadius = 10;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self buildView];
    
}
- (void)buildView
{
    NSArray *array = [self subviews];
    for (UIView *view in array) {
       
        [view removeFromSuperview];
    }
    _userSelectedTag = 100;
    NSArray *titles = [self loadTitleArray];
    NSInteger xOffset = 20.0f;
    NSInteger index = 0;
    for (NSString *title in titles) {
        if (index > 11) {
            break;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, 0, kBUTTON_WIDTH, kBUTTON_HEIGHT);
        xOffset += kBUTTON_WIDTH;
        button.titleLabel.textColor = [UIColor whiteColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"h"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setTag:_userSelectedTag + index];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        
        index++;
        
        [self addSubview:button];
    }
    UIButton *sButton = (UIButton *)[self viewWithTag:_userSelectedTag];
    sButton.selected = YES;
    
}

- (void)setDataSource:(id<GLSelectorViewDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        if (_dataSource)
        {
            [self setNeedsDisplay];
        }
    }
}


- (void)selectNameButton:(UIButton *)sender
{
    if (sender.tag != _userSelectedTag) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedTag];
        lastButton.selected = NO;
        _userSelectedTag = sender.tag;
    }
    if (!sender.selected) {
        sender.selected = YES;
    }
    NSInteger newValue = _userSelectedTag - 100;
    if (_value != newValue) {
        _value = newValue;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)reloadTitleString
{
    [self setNeedsLayout];
}

- (NSArray *)loadTitleArray
{
    NSArray *title = [_dataSource titleofArray:self];
    return title;
}

@end
