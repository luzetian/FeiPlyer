
//  GLHTTPDownload.m
//  DownloadDemo
//
//  Created by PES on 14-9-24.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLHTTPDownload.h"
#import "GLDownloadPage.h"
#import "AFNetworking.h"
#import "GLDownloadHelp.h"
#import "AFDownloadRequestOperation.h"
static void *ProgressObserverContext = &ProgressObserverContext;
@interface GLHTTPDownload()<GLDownloadPageDelegate>
@property (strong, nonatomic,readwrite) NSMutableArray *downloadItem;
@property (strong, nonatomic) NSMutableArray *fileList;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *downloadData;
@property (strong, nonatomic) AFDownloadRequestOperation *downloadOperate;
@property (strong, nonatomic) GLDownloadPage *downloadPage;
@property (strong, nonatomic) MLFile *downloadFile;
@property (assign, nonatomic) BOOL fileDownloading;
@property (assign, nonatomic) NSTimeInterval startDL;
@property (assign, nonatomic) NSTimeInterval lastStatsUpdate;

@end

@implementation GLHTTPDownload
+ (id)shareHTTPDowload
{
    static id shareObject = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareObject = [[[self class]alloc]init];
    });
    return shareObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.fileList = [[NSMutableArray alloc]init];
        self.downloadItem = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)startDownloadWithFile:(MLFile *)file
{
    if (file == nil) {
        return;
    }
    [self.fileList removeObject:file];
    for (MLFile *tempFile in self.fileList) {
        if ([tempFile.video.url isEqualToString:file.video.url]) {
            [self.fileList removeObject:tempFile];
        }
    }
    [self clear];
    [self.fileList addObject:file];
    [self configDwonloadFile:file];
}

#pragma mark --- 入口 ----
- (void)addDownloadFile:(MLFile *)file
{
    if (![self checkFile:file]) {
        return;
    }
    [self.fileList addObject:file];
    [self configDwonloadFile:[self.fileList firstObject]];
}

- (void)configDwonloadFile:(MLFile *)file
{
    if (file == nil) {
        return;
    }
//    if (self.fileDownloading) {
//        return;
//    }
    if (![self.fileList count]) {
        return;
    }
    self.downloadFile = file;
    if (self.downloadFile.audio.zhUrl && [self.downloadFile.audio.zhDownload boolValue]) {
        [self.downloadItem addObject:@{@"url": self.downloadFile.audio.zhUrl,@"path":self.downloadFile.audio.zhPath}];
    }
    if (self.downloadFile.audio.hkUrl && [self.downloadFile.audio.hkDwonload boolValue]) {
       
        [self.downloadItem addObject:@{@"url": self.downloadFile.audio.hkUrl,@"path":self.downloadFile.audio.hkPath}];
    }
    [self.downloadItem addObject:@{@"url": self.downloadFile.video.url,@"path":self.downloadFile.video.path}];
    [self.downloadItem addObject:@{@"url": self.downloadFile.audio.enUrl,@"path":self.downloadFile.audio.enPath}];
   
    self.fileName = self.downloadFile.name;
    [self requestDownloadURL];
}

- (void)requestDownloadURL
{
    if ([self.downloadItem count]) {
        self.downloadPage = [[GLDownloadPage alloc]init];
        self.downloadPage.delegate = self;
        NSDictionary *downloadDic = [self.downloadItem firstObject];
        [self.downloadPage requestDownloadURL:downloadDic[@"url"] targetPath:downloadDic[@"path"]];
        [self.downloadItem removeObjectAtIndex:0];
    }else {
        [self.fileList removeObject:self.downloadFile];
        if ([self.delegate respondsToSelector:@selector(downloadCompleted)]) {
            [self.delegate downloadCompleted];
        }
        [self configDwonloadFile:[self.fileList firstObject]];
    }
}

- (void)downloadURL:(NSString *)url downloadPath:(NSString *)path
{
    if ([url length] && [path length]) {
        self.downloadPage = nil;
       [self downloadWithUrl:url targetPath:path];
    }else {
        NSLog(@"URL : %@ PATH: %@",url,path);
    }
}

- (void)downloadWithUrl:(NSString *)url targetPath:(NSString *)path
{
    if (![url length] || ![path length]) {
        return;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    self.downloadOperate = [[AFDownloadRequestOperation alloc]initWithRequest:request targetPath:path shouldResume:YES];
    [self.downloadFile.managedObjectContext save:nil];
    __weak __typeof(self)weakSelf = self;
    
    [self.downloadOperate setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSError *error;
       [strongSelf.downloadFile.managedObjectContext save:&error];
        if (!error) {
            [strongSelf requestDownloadURL];
        }else {
            if ([strongSelf.delegate respondsToSelector:@selector(downloadFailedWithErrorDescription:)]) {
                [strongSelf.delegate downloadFailedWithErrorDescription:[error localizedDescription]];
            }
        }
        strongSelf.fileDownloading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(downloadFailedWithErrorDescription:)]) {
            [strongSelf.delegate downloadFailedWithErrorDescription:[error localizedDescription]];
        }
    }];
    
    NSProgress *progress = nil;
    [self.downloadOperate setDownloadProgress:&progress];
    [self.downloadOperate start];
    self.fileDownloading = YES;
    self.startDL = [NSDate timeIntervalSinceReferenceDate];
    if ([self.delegate respondsToSelector:@selector(startDownloadName:)]) {
        [self.delegate startDownloadName:self.fileName];
    }
    
    [progress addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) options:NSKeyValueObservingOptionInitial context:ProgressObserverContext];
}

- (NSString*)calculateSpeedString:(CGFloat)receivedDataSize
{
    CGFloat speed = receivedDataSize / ([NSDate timeIntervalSinceReferenceDate] - self.startDL);
    NSString *string = [NSByteCountFormatter stringFromByteCount:speed countStyle:NSByteCountFormatterCountStyleDecimal];
    string = [string stringByAppendingString:@"/s"];
    return string;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ProgressObserverContext) {
        NSProgress *progress = object;
        if ([progress isKindOfClass:[NSProgress class]]) {
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(downloadFile:progress:fractionCompleted:speedRate:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ((_lastStatsUpdate > 0 && ([NSDate timeIntervalSinceReferenceDate] - _lastStatsUpdate > .5)) || _lastStatsUpdate <= 0)
                        {
                            [self.delegate downloadFile:self.downloadFile progress:progress.localizedDescription fractionCompleted:progress.fractionCompleted speedRate:[self calculateSpeedString:progress.totalUnitCount]];
                            _lastStatsUpdate = [NSDate timeIntervalSinceReferenceDate];
                        }
                    });
                }
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)pause
{
    [self.downloadOperate pause];
}

#pragma mark Private Method
- (void)clear
{
    [self.downloadOperate pause];
    self.downloadOperate = nil;
    self.fileDownloading = NO;
    self.downloadItem = [[NSMutableArray alloc]init];
    if ([self.delegate respondsToSelector:@selector(stopDownloadWithFile:)]) {
        [self.delegate stopDownloadWithFile:self.downloadFile];
    }
   
}

- (void)downloadFailMessage:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络错误" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)checkFile:(MLFile *)file
{
    if (file == nil) {
        [self downloadFailMessage:@"文件错误"];
        return NO;
    }
    
    for (MLFile *temp in self.fileList) {
        if ([temp isEqualFile:file]) {
            [self downloadFailMessage:@"该文件已经存在下载列表中"];
            return NO;
        }
    }
    NSFileManager *manager = [NSFileManager defaultManager];
 
    if ([manager fileExistsAtPath:file.video.path]) {
        [self downloadFailMessage:@"本地有文件"];
        return NO;
    }
    return YES;
}

- (NSString *)rootPath
{
    NSArray *searchArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentPath = [searchArray firstObject];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"username"];
    NSString *path = [doucmentPath stringByAppendingPathComponent:name];
    return path;
}

- (NSArray *)downloadList
{
    return self.fileList;
}

- (BOOL)downloading
{
    return [self.downloadOperate isCancelled];
}
@end
