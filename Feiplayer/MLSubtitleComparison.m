//
//  MLSubtitleComparison.m
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "MLSubtitleComparison.h"
#import "GLMediaLibrary.h"

@implementation MLSubtitleComparison
+ (NSArray *)allSubtitle
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *manageContext = [[GLMediaLibrary sharedMediaLibrary] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubtitleComparison" inManagedObjectContext:manageContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [manageContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"fetched object error");
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (MLSubtitleComparison *subtitle in fetchedObjects) {
        if ([subtitle.userName isEqualToString:[self userName]]) {
            [array addObject:subtitle];
        }
    }
    return array;
}

+ (NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"username"];
    return name;
}
@dynamic fileName;
@dynamic subtitle;
@dynamic time;
@dynamic userSubtitle;
@dynamic userName;

@end
