//
//  MLVideo.h
//  Feiplayer
//
//  Created by PES on 14/10/30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLFile;

@interface MLVideo : NSManagedObject

@property (nonatomic, retain,readonly) NSString * path;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) MLFile *file;

@end
