//
//  GLDownloadTableViewCell.h
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLBaseTableViewCell.h"
#import "MLFile.h"
@interface GLDownloadTableViewCell : GLBaseTableViewCell
@property (nonatomic, strong) MLFile *file;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *speedRate;
@property (weak, nonatomic) IBOutlet UILabel *progress;
@end
