//
//  MLSubtitleComparison.h
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MLSubtitleComparison : NSManagedObject

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * userSubtitle;
@property (nonatomic, retain) NSString * userName;
+ (NSArray *)allSubtitle;
@end
