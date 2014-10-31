//
//  GLDownloadPage.h
//  DownloadDemo
//
//  Created by PES on 14/10/10.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GLDownloadPageDelegate <NSObject>
- (void)downloadURL:(NSString *)url downloadPath:(NSString *)path;
@end

@interface GLDownloadPage : NSObject
- (void)requestDownloadURL:(NSString *)url targetPath:(NSString *)path;

@property (assign, nonatomic) id<GLDownloadPageDelegate> delegate;

@end
