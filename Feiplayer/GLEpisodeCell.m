//
//  GLEpisodeCell.m
//  Feiplayer
//
//  Created by PES on 14/10/15.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLEpisodeCell.h"
@interface GLEpisodeCell()
@property (weak, nonatomic) IBOutlet UILabel *episodeLabel;

@end
@implementation GLEpisodeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureWithItem:(id)item
{
    if (item == nil) {
        return;
    }
    self.downloadInfo = item;
    self.episodeLabel.text = [NSString stringWithFormat:@"第%@集",item[@"film_episode"]];
}

+ (NSString *)identifier
{
    return @"DetailEpisode";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"GLEpisodeCell" bundle:nil];
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
