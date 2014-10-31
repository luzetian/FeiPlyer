//
//  GLTimeSelectorView.m
//  pickerView
//
//  Created by lynd on 14-6-5.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLTimeSelectorView.h"

@interface GLTimeSelectorView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSUInteger second;
    NSUInteger hour;
    NSUInteger minute;
    UIPickerView *pickerView;
//    UIButton *okButton;
//    UIButton *cancelButton;
}

@property (weak, nonatomic) IBOutlet UIPickerView *timeSelector;

@end
@implementation GLTimeSelectorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okButton.frame = CGRectMake(0, 0, 50, 50);
        [okButton setTitle:@"Ok" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(frame.size.width - 55, 0, 50, 50);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
       
        [self addSubview:okButton];
        [self addSubview:cancelButton];
        [self addSubview:pickerView];
    }
    return self;
}

- (void)chooseTime:(id)sender {
    
    NSString *time = [NSString stringWithFormat:@"%d : %d : %d",hour,minute,second];
    if ([self.delegate respondsToSelector:@selector(selectorTime:selectorView:)]) {
        [self.delegate selectorTime:time selectorView:self];
    }
}

- (void)cancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelSelectorView:)]) {
        [self.delegate cancelSelectorView:self];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 3;
    }
    return 60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *time = [NSString stringWithFormat:@"%d",row];
    return time;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        hour = row;
    }else if (component == 1){
        minute = row;
    }else if (component == 2){
        second = row;
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
