//
//  GLDownloadHelp.h
//  DownloadManage
//
//  Created by lynd on 14-5-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GLAudioType) {
    GLZHType,
    GLHKType,
    GLENType,
};
@interface GLDownloadHelp : NSObject
- (NSString *)videoPathWithFileName:(NSString *)name andFileId:(NSString *)fileID;
- (NSString *)videoTempPathWithFileName:(NSString *)name;
- (NSString *)audioPathWithFileID:(NSString *)fileId;
- (NSString *)audioPathWithFileName:(NSString *)name audioType:(GLAudioType)type;
- (NSString *)audioTempPathWithFileName:(NSString *)name;
- (NSString *)getFileSizeString:(float )size;
- (NSString*)calculateSpeedString:(CGFloat)receivedDataSize startTime:(NSTimeInterval)time;
- (BOOL)createFileAtPath:(NSString *)path;
- (NSString *)downloadPathWith:(NSString *)fileId andEpisode:(NSString *)episode;
@end
