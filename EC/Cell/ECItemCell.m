//
//  GLEnglishRoomItemCell.m
//  EnglishRoom
//
//  Created by PES on 14-9-16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECItemCell.h"
#import "ECClassificationModel.h"
@interface ECItemCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *classificationTypes;
@property (strong, nonatomic) ECClassificationModel *model;

@end

@implementation ECItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (NSString *)identifer
{
    return @"EnglishRoomCell";
}

- (NSArray *)subItem
{
    if (self.model == nil) {
        return nil;
    }
    return self.model.subitems;
}

- (void)configureWithItem:(id)item
{
    if (item == nil) {
        return;
    }
    if (![item isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.model = [[ECClassificationModel alloc]initWithContent:item];
    self.titleLabel.text = self.model.classificationTitle;
}

@end
