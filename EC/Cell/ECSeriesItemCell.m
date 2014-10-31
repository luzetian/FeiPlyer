//
//  GLSeriesItemCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECSeriesItemCell.h"
#import "UIImageView+AFNetworking.h"
@interface ECSeriesItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

#define BASE_URL    @"http://42.121.253.181/"
@implementation ECSeriesItemCell

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
    self.seriesInfo = [[ECSeriesListModel alloc]initWithContent:item];
    self.titleLabel.text = self.seriesInfo.zhVideoName;
    [self.titleLabel sizeToFit];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL,self.seriesInfo.thumb];
    [self.thumb setImageWithURL:[NSURL URLWithString:urlStr]];
    
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECSeriesItemCell" bundle:nil];
}

+ (NSString *)identifer
{
    return @"SeriesItemCell";
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
