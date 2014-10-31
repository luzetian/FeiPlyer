//
//  GLDownloadTableViewCell.m
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLDownloadTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@interface GLDownloadTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
@property (weak, nonatomic) IBOutlet UILabel *fileName;

@end
@implementation GLDownloadTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (NSString *)identifier {
    return @"DownloadCell";
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"GLDownloadTableViewCell" bundle:nil];
}

- (void)configWithItem:(id)item
{
    if (!item || ![item isKindOfClass:[MLFile class]]) {
        return;
    }
    self.file = item;
    self.fileName.text = self.file.name;
    NSString *imageUrl = [NSString stringWithFormat:@"http://42.121.253.181/public/images/feienglishstudy/movie%@.jpg",self.file.fileID];
    [self.thumb setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
