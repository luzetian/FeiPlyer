//
//  GLRecorderTableViewCell.h
//  VLC For IOS
//
//  Created by lynd on 14-4-30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLRecorder.h"
#import "GLBaseTableViewCell.h"
@interface GLRecorderTableViewCell : GLBaseTableViewCell

+ (GLRecorderTableViewCell *)cellWithResultWithIdentifer:(NSString *)identifer;

@property (strong, nonatomic) NSString *recoderPath;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *subtitleText;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@interface GLRecorderTableViewCell (Configure)
- (void)configCell:(MLRecorder *)recorder atIndexPath:(NSIndexPath *)indexPath;
@end
