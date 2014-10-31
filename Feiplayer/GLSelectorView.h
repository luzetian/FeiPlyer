//
//  LTSelectorView.h
//  selectorController
//
//  Created by lynd on 14-3-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLSelectorViewDataSource;

@interface GLSelectorView : UIControl
@property (nonatomic, weak)     IBOutlet id<GLSelectorViewDataSource> dataSource;
@property (nonatomic, assign)   NSInteger value;
- (void)reloadTitleString;
@end

@protocol GLSelectorViewDataSource<NSObject>
@required
- (NSArray *)titleofArray:(GLSelectorView *)tableView;
@end