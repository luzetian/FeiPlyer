//
//  GLSotryHintViewController.h
//  ViewDome
//
//  Created by lynd on 14-6-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LanguageType) {
    ZHLanguageType,
};
@protocol GLStoryHintViewControllerDelegate<NSObject>
@optional
- (void)repeatCurrentSubtitle;
- (void)languageTypeChange:(LanguageType)type;
@end

@interface GLStoryHintViewController : UIViewController
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) id<GLStoryHintViewControllerDelegate>delegate;
@end
