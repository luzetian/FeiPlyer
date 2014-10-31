//
//  LTSubtitleList.h
//  Subtitle_Demo
//
//  Created by lynd on 13-11-22.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLSubtitle.h"
@interface GLSubtitleList : NSObject

- (void)clear;

- (BOOL)englishSubtitle;

- (BOOL)chineseSubtitle;

- (BOOL )loadSubtitleForUrl:(NSURL *)url;

- (BOOL)loadSubtitle:(NSDictionary *)path;

- (NSInteger)countOfSubtitleList;

- (GLSubtitle *)findSubtitle:(float)position;

- (GLSubtitle *)subtitle:(NSInteger)index;

- (void)setSubtitle:(GLSubtitle *)subtitle AtIndex:(NSInteger)index;
@property (nonatomic) BOOL isEnglish;
@end
