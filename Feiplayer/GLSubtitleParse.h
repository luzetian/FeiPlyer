//
//  GLSubtitleParse.h
//  VLC For IOS
//
//  Created by lynd on 14-6-26.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLSubtitleParse : NSObject
- (id)initWithSubtitle:(NSString *)subtitle;
- (void)cancelCutWord:(NSString *)subtitle;
- (void)chooseCutWord;
- (void)cutWord;
- (void)setBackSubtitle;
- (void)setNextSubtitle;
- (void)speechSeriesSubtitle;
- (void)speechSingleSubtitle;
- (void)speechSubtitle;
- (void)spellSingleSubtile;
- (void)stopSpeech;
@end
