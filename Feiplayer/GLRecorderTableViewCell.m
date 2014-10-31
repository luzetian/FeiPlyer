//
//  GLRecorderTableViewCell.m
//  VLC For IOS
//
//  Created by lynd on 14-4-30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLRecorderTableViewCell.h"
#import <MobileVLCKit/MobileVLCKit.h>
@interface GLRecorderTableViewCell()
{
    VLCMediaPlayer *_palyer;
}
@end

@implementation GLRecorderTableViewCell

+ (NSString *)identifier
{
    return @"RecorderCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"GLRecorderTableViewCell" bundle:nil];
}

+ (GLRecorderTableViewCell *)cellWithResultWithIdentifer:(NSString *)identifer
{
    NSArray *nibArray;
    if (SYSTEM_RUNS_IOS7_OR_LATER) {
        nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLRecorderTableViewCell" owner:nil options:nil];
    }else{
        nibArray = [[NSBundle mainBundle] loadNibNamed:@"GLRecorderTableViewCell" owner:nil options:nil];
        NSAssert([nibArray count] == 1, @"meh");
        NSAssert([[nibArray lastObject] isKindOfClass:[GLRecorderTableViewCell class]], @"meh meh");
    }
    GLRecorderTableViewCell *cell = (GLRecorderTableViewCell *)[nibArray lastObject];
    cell.multipleSelectionBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)playRecorder:(id)sender {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.recoderPath]) {
        return;
    }
    
    if (_palyer == nil) {
        _palyer = [[VLCMediaPlayer alloc]init];
    }
    VLCMedia *media = [VLCMedia mediaWithPath:self.recoderPath];
    [_palyer setMedia:media];
    [_palyer play];
}

- (void)dealloc
{
    [_palyer pause];
    [_palyer stop];
    _palyer = nil;
}

@end

@implementation GLRecorderTableViewCell (Configure)

- (void)configCell:(MLRecorder *)recorder atIndexPath:(NSIndexPath *)indexPath
{
    self.fileName.text = recorder.fileName;
    self.subtitleText.text = recorder.subtitleStr;
    self.timeLabel.text = recorder.time;
    self.recoderPath = recorder.recorderPath;
    
    UIImageView *imaegView = [[UIImageView alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([indexPath row] % 2) {
            imaegView.image = [UIImage imageNamed:@"Background_downR"];
        }else{
            imaegView.image = [UIImage imageNamed:@"Background_upR"];
        }
    }else{
        if ([indexPath row] % 2) {
            imaegView.image = [UIImage imageNamed:@"cell_share_cellBackground_H"];
        }else{
            imaegView.image = [UIImage imageNamed:@"cell_share_cellBackground_N"];
        }
    }
    self.backgroundView = imaegView;
}

@end
