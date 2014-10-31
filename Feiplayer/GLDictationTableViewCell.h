//
//  GLDictationTableViewCell.h
//  VLC For IOS
//
//  Created by lynd on 14-5-6.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBaseTableViewCell.h"
#import "MLSubtitleComparison.h"
@interface GLDictationTableViewCell : GLBaseTableViewCell

@end

@interface GLDictationTableViewCell (ConfigureDictation)

- (void)configureDiction:(MLSubtitleComparison *)subtitle atIndexPath:(NSIndexPath *)indexPath;

@end