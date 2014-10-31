//
//  ECFillBlankTableViewCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-19.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECFillBlankTableViewCell.h"

@implementation ECFillBlankTableViewCell

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
    return @"FillBlankCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECFillBlankTableViewCell" bundle:nil];
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
