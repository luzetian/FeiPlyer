//
//  GLSeriesCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECClassificationCell.h"

@interface ECClassificationCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) ECSubItemModel *seriesModel;

@end
@implementation ECClassificationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)configureWithItem:(id)item
{
    if (item == nil) {
        return;
    }
    if (![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    ECSubItemModel *model = [[ECSubItemModel alloc]initWithContent:item];
    self.titleLabel.text = model.seriesTitle;
    self.seriesModel = model;
}

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"ECClassificationCell" bundle:nil];
}

- (ECSubItemModel *)classificationInfo
{
    return self.seriesModel;
}

+ (NSString *)identifer
{
    return @"ClassificationCell";
}
@end
