//
//  GLVideoTableViewCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECVideoTableViewCell.h"
#import "ECVideoModel.h"
@implementation ECVideoTableViewCell

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

+ (NSString *)identifer
{
    return @"VideoTableCell";
}

- (void)configureWithItem:(id)item
{
    if (!item || ![item count]) {
        return;
    }
    if (![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    ECVideoModel *model = [[ECVideoModel alloc]initWithContent:item];
    self.textLabel.text = model.zhVideoName;
    self.videioId = model.videoId;
    
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECVideoTableViewCell" bundle:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
