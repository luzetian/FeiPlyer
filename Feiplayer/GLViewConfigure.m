//
//  GLViewConfigure.m
//  Feiplayer
//
//  Created by PES on 14/10/14.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLViewConfigure.h"
@interface GLViewConfigure()
@property (nonatomic ,strong) NSDictionary *configPlist;
@end
@implementation GLViewConfigure
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSDictionary *)configPlist
{
    if (_configPlist) {
        return _configPlist;
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"viewConfigure" withExtension:@"plist"];
    _configPlist = [NSDictionary dictionaryWithContentsOfURL:url];
    return _configPlist;
}

- (NSArray *)videoMenu
{
    return self.configPlist[@"video"];
}

- (NSArray *)functionMenu
{
    return self.configPlist[@"function"];
}

- (NSDictionary *)requestMovieListWithMovieCollection:(NSInteger)collection
                                         andMovieType:(NSInteger)type
{
    if (self.configPlist == nil) {
        NSLog(@"Plist 文件读取错误");
        return nil;
    }
    
    NSArray *movieCollection = [self movieSubTypesWithCollection:collection];
    if (![movieCollection count]) {
        NSLog(@"%@",movieCollection);
        return nil;
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([movieCollection count] < type) {
        NSLog(@"%d %d",[movieCollection count],type);
        return nil;
    }
    
    NSArray *typeArray = movieCollection[type];
    if ([typeArray count]) {
        for (NSString *filmType in typeArray) {
            NSArray *types = [filmType componentsSeparatedByString:@"="];
            if ([types count] == 2) {
                [dictionary setValue:types[1] forKey:types[0]];
            }
        }
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *age = [userDefaults objectForKey:@"age"];
    NSString *sessionid = [userDefaults objectForKey:@"sessionid"];
    [dictionary setObject:sessionid forKey:@"sessionid"];
    [dictionary setObject:age forKey:@"age"];
    [dictionary setObject:@"1" forKey:@"page"];
    [dictionary setObject:@"300" forKey:@"page_size"];
    return [dictionary mutableCopy];
}

- (NSArray *)movieSubTypesWithCollection:(NSInteger)collection
{
    if (self.configPlist == nil) {
        NSLog(@"Plist 文件读取错误");
        return nil;
    }
    NSArray *array = [self.configPlist objectForKey:@"video"];
    if ([array count] < collection) {
        return nil;
    }
    
    NSDictionary *dictionary = array[collection];
    NSArray *subTypes = [dictionary objectForKey:@"subTypes"];
    return subTypes;
}

@end
