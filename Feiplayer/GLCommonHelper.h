//
//  LTCommonHelper.h
//  checkVLCFile
//
//  Created by lynd on 13-12-21.
//  Copyright (c) 2013年 Lintao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCommonHelper : NSObject

/*!
 *  获取硬盘剩余大小
 *
 *  @return 硬盘剩余大小
 *
 *  @since 1.0
 */
+(uint64_t)getFreeDiskspace;

/*!
 *  获取硬盘总大小
 *
 *  @return 硬盘总大小
 *
 *  @since 1.0
 */
+(uint64_t)getTotalDiskspace;

/*!
 *  获取硬盘信息
 *
 *  @return 硬盘信息
 *
 *  @since 1.0
 */
+(NSString *) getDiskSpaceInfo;


+ (NSDate *)makeDate:(NSString *)birthday;

+ (NSString *)dateToString:(NSDate*)date;

+ (NSString *)md5StringForData:(NSData*)data;

+ (NSString *)md5StringForString:(NSString*)str;

@end
