//
//  ECBaseTableViewCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECBaseTableViewCell.h"

@implementation ECBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

+ (UINib *)nib
{
    return nil;
}

+ (NSString *)identifer
{
    return nil;
}

- (void)configureWithItem:(id)item
{
        //to do
}
@end
