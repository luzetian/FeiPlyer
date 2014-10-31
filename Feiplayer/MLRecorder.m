//
//  MLRecorder.m
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "MLRecorder.h"
#import "GLMediaLibrary.h"

@implementation MLRecorder
+ (NSArray *)allRecorder
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *manageContext = [[GLMediaLibrary sharedMediaLibrary] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recorder" inManagedObjectContext:manageContext];
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
    for (MLRecorder *recorder in fetchedObjects) {
        if ([recorder.userName isEqualToString:[self userName]]) {
            [array addObject:recorder];
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
@dynamic time;
@dynamic subtitleStr;
@dynamic recorderPath;
@dynamic fileName;
@dynamic userName;

@end
