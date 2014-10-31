//
//  LTSubtitle.h
//  Subtitle_Demo
//
//  Created by lynd on 13-11-21.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GLSubtitle : NSObject
@property (nonatomic) NSInteger sequenceNumber;
@property (nonatomic) NSString *content;
@property (nonatomic) float beginPosition;
@property (nonatomic) float endPosition;
@property (nonatomic,strong) NSString *strPostion;
@end
