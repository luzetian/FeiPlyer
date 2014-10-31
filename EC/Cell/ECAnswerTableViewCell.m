//
//  ECAnswerTableViewCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-19.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECAnswerTableViewCell.h"

@implementation ECAnswerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECAnswerTableViewCell" bundle:nil];
}

+ (NSString *)identifer
{
    return @"AnswerCell";
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
