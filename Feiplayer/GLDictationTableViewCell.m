//
//  GLDictationTableViewCell.m
//  VLC For IOS
//
//  Created by lynd on 14-5-6.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLDictationTableViewCell.h"
@interface GLDictationTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *userInputSubtitle;
@end
@implementation GLDictationTableViewCell

+ (GLDictationTableViewCell *)cellWithResultWithIdentifer:(NSString *)identifer
{
    NSArray *nibArray;
    if (SYSTEM_RUNS_IOS7_OR_LATER) {
        nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLDictationTableViewCell" owner:nil options:nil];
    }else{
        nibArray = [[NSBundle mainBundle]loadNibNamed:@"GLDictationTableViewCell" owner:nil options:nil];
        NSAssert([nibArray count] == 1, @"meh");
        NSAssert([[nibArray lastObject] isKindOfClass:[GLDictationTableViewCell class]], @"meh meh");
    }
    GLDictationTableViewCell *cell = (GLDictationTableViewCell *)[nibArray lastObject];
    cell.multipleSelectionBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    return cell;
    
}

+ (NSString *)identifier
{
    return @"DictationCell";
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"GLDictationTableViewCell" bundle:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

@implementation GLDictationTableViewCell (ConfigureDictation)

- (void)configureDiction:(MLSubtitleComparison *)subtitle atIndexPath:(NSIndexPath *)indexPath
{
    self.fileName.text = subtitle.fileName;
    self.subtitle.text = subtitle.subtitle;
    self.time.text = subtitle.time;
    self.userInputSubtitle.text = subtitle.userSubtitle;
    if ([subtitle.subtitle isEqual:subtitle.userSubtitle]) {
        self.userInputSubtitle.textColor = [UIColor whiteColor];
    }else{
        self.userInputSubtitle.textColor = [UIColor redColor];
    }
    UIImageView *imaegView = [[UIImageView alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ([indexPath row] % 2) {
            imaegView.image = [UIImage imageNamed:@"cell_dictation_imageViewdown"];
        }else{
            imaegView.image = [UIImage imageNamed:@"cell_dictation_imageViewUp"];
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
