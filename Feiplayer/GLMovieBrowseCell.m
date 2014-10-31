//
//  GLMovieBrowseCell.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMovieBrowseCell.h"
#import "GLVideoInfoModel.h"
#import "UIImageView+AFNetworking.h"
@interface GLMovieBrowseCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoThumb;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@end
@implementation GLMovieBrowseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (NSString *)identifier
{
    return @"MovieBrowseCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"GLMovieBrowseCell" bundle:nil];
}

- (void)configureWithItem:(id)item
{
    if (item == nil) {
        NSLog(@"%@",item);
        return;
    }
    
    if (![item isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@",item);
        return;
    }
    
    GLVideoInfoModel *model = [[GLVideoInfoModel alloc]initWithContent:item];
    [self.videoThumb setImageWithURL:[NSURL URLWithString:model.fileImageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.videoTitle.text = model.filmName;
    self.videId = model.filmId;
}

- (void)Lanconfigure:(NSDictionary *)dic
{
    NSString *fileName = [dic objectForKey:@"title"];
    
    NSString *fileiD = [dic objectForKey:@"id"];
    NSString *str = [NSString stringWithFormat:@"http://42.121.253.181/public/images/feienglishstudy/movie%@.jpg",fileiD];
    [self.videoThumb setImageWithURL:[NSURL URLWithString:str]];
     self.videoTitle.text = fileName;
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
