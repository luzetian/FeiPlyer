//
//  GLMenuTableViewCell.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMenuTableViewCell.h"

@implementation GLMenuTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (NSString *)identifier
{
    return @"MenuTableViewCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"GLMenuTableViewCell" bundle:nil];
}

- (void)configWithItem:(id)item
{
    if (item == nil) {
        NSLog(@"%@",item);
        return;
    }
    self.textLabel.text = item[@"typeName"];
    self.textLabel.textColor = [UIColor whiteColor];
    [self.imageView setImage:[UIImage imageNamed:item[@"icon"]]];
}

@end
