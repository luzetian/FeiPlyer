//
//  ECFillBlankTableViewCell.h
//  EnglishRoom
//
//  Created by PES on 14-9-19.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECBaseTableViewCell.h"
@interface ECFillBlankTableViewCell : ECBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UITextField *fillBlanTextField;

@end
