//
//  ECTestResultTableViewCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECTestResultTableViewCell.h"
@interface ECTestResultTableViewCell()

//@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
//@property (weak, nonatomic) IBOutlet UITextView *userAnswers;
//@property (weak, nonatomic) IBOutlet UITextView *subject;

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UITextView *userAnswers;
@property (weak, nonatomic) IBOutlet UITextView *subject;


@end
@implementation ECTestResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (NSString *)identifer
{
    return @"TestResultCell";
}

- (void)configureWithItem:(id)item
{
    NSDictionary *dic = item;
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if (!dic || ![dic count]) {
        return;
    }
    NSString *type = dic[@"test_type"];
    if ([type isEqualToString:@"A"]) {
        self.subject.text = [NSString stringWithFormat:@"纠错题 : %@",dic[@"subject"]];
    }else if ([type isEqualToString:@"B"]){
        self.subject.text = [NSString stringWithFormat:@"填空题 : %@",dic[@"subject"]];
    }else if ([type isEqualToString:@"C"]){
        self.subject.text = [NSString stringWithFormat:@"选择题 : %@",dic[@"subject"]];
    }else if ([type isEqualToString:@"D"]){
        self.subject.text = [NSString stringWithFormat:@"听写提 : %@",dic[@"subject"]];
    }
    if (dic[@"user_option"]) {
        NSLog(@"%@",dic);
       // self.userAnswers.text = dic[@"user_option"];
    }
    
    if (dic[@"user_is_right"]) {
        self.resultImage.image = [UIImage imageNamed:@"test_right"];
    }else{
        self.resultImage.image = [UIImage imageNamed:@"test_error"];
    }
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECTestResultTableViewCell" bundle:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
