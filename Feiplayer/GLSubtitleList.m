//
//  LTSubtitleList.m
//  Subtitle_Demo
//
//  Created by lynd on 13-11-22.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import "GLSubtitleList.h"
@interface GLSubtitleList()
@property (nonatomic,strong) NSMutableArray  *subtitleList;

@property (nonatomic) NSString *results;
- (BOOL)load:(NSString *)results;
@property (nonatomic,strong) NSDictionary *subtitleDic;
@end
@implementation GLSubtitleList

- (id)init
{
    self = [super init];
    if (self) {
        _subtitleList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(BOOL)chineseSubtitle
{
    NSString *str = [_subtitleDic objectForKey:@"zh"];
    NSURL *url = [NSURL URLWithString:str];
     NSLog(@"chineseSubtitle %@",str);
    NSError *error;
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString *results = [[NSString alloc]initWithData:data encoding:encode];
    if (error) {
        NSLog(@"load subtitle error %@",error);
        return NO;
    }
    self.isEnglish = NO;
    return [self load:results];
}

- (BOOL)englishSubtitle
{
    if (_subtitleDic == nil || ![_subtitleDic count]) {
        return NO;
    }
    NSString *str = [_subtitleDic objectForKey:@"en"];
    NSLog(@"englishSubtitle %@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSError *error;
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSString *results = [[NSString alloc]initWithData:data encoding:encode];
    if (error) {
        NSLog(@"load subtitle error %@",error);
        return NO;
    }
    self.isEnglish = YES;
    return [self load:results];
}

- (BOOL )loadSubtitleForUrl:(NSURL *)url
{
    if (url == nil) {
        return NO;
    }
    NSLog(@"%@",[url absoluteString]);
    NSError *error;

    //NSString *results = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *contentStr = [NSString stringWithContentsOfURL:url encoding:enc error:&error];
    if (error) {
        NSLog(@"load subtitle error %@",error);
        return NO;
    }
    
    return [self load:contentStr];
}

- (BOOL)loadSubtitle:(NSDictionary *)path {
    
    _subtitleDic = path;
    return [self englishSubtitle];
}

/**
 *  解析从网页获取的字幕，将每一句字幕内容存入subtitleList，
 *
 *  @param results 网页获取的字幕
 *
 *  @return 加载成功返回YES。
 */

- (BOOL)load:(NSString *)results
{
    if (![results length]) {
        NSLog(@"%@",results);
        return NO;
    }
    NSArray *lines = [results componentsSeparatedByString:@"\n"];
    if ([lines count] == 0) {
        return NO;
    }
    [self clear];
    NSInteger state = 0;
    GLSubtitle *subtitle;
    for (NSString *s in lines) {
        if (state == 0) {
            state = 1;
            subtitle  = [[GLSubtitle alloc]init];
            subtitle.sequenceNumber = [s integerValue];
           
        }else if(state == 1){
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\s*(\\d+):(\\d+):(\\d+),(\\d+)\\s*-->\\s*(\\d+):(\\d+):(\\d+),(\\d+)\\s*$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSArray *array = [regex matchesInString:s options:NSMatchingReportProgress range:NSMakeRange(0, [s length])];
            
            if ([array count] == 0) {
                NSLog(@"subtitle End");
                return YES;
            }
            NSTextCheckingResult *match = array[0];
            
            float sections[8];
            for (NSInteger index = 0; index < 8; index ++) {
                NSRange range = [match rangeAtIndex:index + 1];
                NSString *str = [s substringWithRange:range];
                sections[index] = [str doubleValue];
                
            }
            
            float t1 = (sections[0] * 3600000) + (sections[1] * 60000) + (sections[2] * 1000) + sections[3];
            float t2 = (sections[4] * 3600000) + (sections[5] * 60000) + (sections[6] * 1000) + sections[7];
        
            NSString *temp = [s stringByReplacingOccurrencesOfString:@"," withString:@":"];
            
            subtitle.strPostion = [temp stringByReplacingOccurrencesOfString:@" --> " withString:@","];
            subtitle.beginPosition = t1;
            subtitle.endPosition = t2;
            if (error) {
                NSLog(@"error %@",[error description]);
            }
            state = 2;
        }else if(state == 2){
            subtitle.content = s;
            // NSLog(@"content %@",s);
            state = 3;
        }else if(state == 3){
            NSString *ds = @"\r";
            if ([s isEqualToString:ds]) {
                state = 0;
                [_subtitleList addObject:subtitle];
            }
        }
    }
        return YES;
}


- (void)clear {
    [_subtitleList removeAllObjects];
}

- (NSInteger)countOfSubtitleList
{
    return _subtitleList.count;
}

- (GLSubtitle *)findSubtitle:(float)position {
    float pos = position;
    for (GLSubtitle *subtitle in _subtitleList) {
        if (pos >= subtitle.beginPosition && pos <= subtitle.endPosition) {
            return subtitle;
        }
    }
    return nil;
}

- (GLSubtitle *)subtitle:(NSInteger)index {
    if (index >= [_subtitleList count]) {
        NSLog(@"超出字幕范围");
        return nil;
    }
    return [_subtitleList objectAtIndex:index];
}

- (void)setSubtitle:(GLSubtitle *)subtitle AtIndex:(NSInteger)index
{
    if (_subtitleList == nil) {
        return;
    }
    
    if (![_subtitleList count]) {
        return;
    }
    
    if ([_subtitleList count] < index) {
        return;
    }
    if (subtitle == nil) {
        return;
    }
    
    [_subtitleList replaceObjectAtIndex:index withObject:subtitle];
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"subtitle count : %d",[self.subtitleList count]];
    return description;
}

@end
