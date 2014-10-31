//
//  MLAudio.h
//  Feiplayer
//
//  Created by PES on 14/10/30.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MLFile;

@interface MLAudio : NSManagedObject

@property (nonatomic, retain) NSString * enUrl;
@property (nonatomic, retain) NSString * hkUrl;
@property (nonatomic, retain) NSString * zhUrl;
@property (nonatomic, retain) NSNumber * zhDownload;
@property (nonatomic, retain) NSNumber * hkDwonload;
@property (nonatomic, retain) MLFile *file;
@property (nonatomic, retain,readonly) NSString * hkPath;
@property (nonatomic, retain,readonly) NSString * zhPath;
@property (nonatomic, retain,readonly) NSString * enPath;
@end
