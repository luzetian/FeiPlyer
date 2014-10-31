//
//  MLSubtitle.h
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MLSubtitle : NSManagedObject

@property (nonatomic, retain) NSString * enUrl;
@property (nonatomic, retain) NSString * zhUrl;
@property (nonatomic, retain) NSString * hkUrl;

@end
