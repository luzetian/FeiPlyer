//
//  MLRecorder.h
//  Feiplayer
//
//  Created by PES on 14/10/20.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MLRecorder : NSManagedObject
+ (NSArray *)allRecorder;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * subtitleStr;
@property (nonatomic, retain) NSString * recorderPath;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * userName;

@end
