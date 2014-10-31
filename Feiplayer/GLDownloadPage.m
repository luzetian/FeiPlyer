//
//  GLDownloadPage.m
//  DownloadDemo
//
//  Created by PES on 14/10/10.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLDownloadPage.h"
#import <objc/runtime.h>
@interface GLDownloadPage()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
//在网页模拟点击时会进行2次跳转,过滤掉第二次跳转避免重复下载
@property (assign, nonatomic) NSUInteger webJumpCount;
@property (strong, nonatomic) NSString *destination;

@end

#define kCLICKED_ELEMENT  @"var element=document.getElementsByTagName('a').item(2);var evObj = document.createEvent('MouseEvents');evObj.initEvent('click',true,true);element.dispatchEvent(evObj)"

//#define kCLICKED_ELEMENT @"var evObj = document.createEvent('MouseEvents'); evObj.initEvent('click', true, true);this.dispatchEvent(evObj);"

#define kAssociatedKey  @"com.pes.download"
@implementation GLDownloadPage

- (void)requestDownloadURL:(NSString *)url targetPath:(NSString *)path
{
    if (self.webView) {
        return;
    }
    if (![url length]) {
        NSLog(@"%@",url);
        return;
    }
    if (![path length]) {
        NSLog(@"%@",path);
        return;
    }
    if (self.webView) {
        self.webView = nil;
    }
    self.destination = path;
    self.webJumpCount = 0;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    self.webView = [[UIWebView alloc]init];
    self.webView.allowsInlineMediaPlayback = NO;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

#pragma mark -- web view ---
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //过滤掉第二次跳转
    if (self.webJumpCount == 1) {
        self.webJumpCount = 2;
        if ([self.delegate respondsToSelector:@selector(downloadURL:downloadPath:)]) {
            [self.delegate downloadURL:[request.URL absoluteString] downloadPath:self.destination];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.webJumpCount == 0) {
        [webView stringByEvaluatingJavaScriptFromString:kCLICKED_ELEMENT];
        webView.allowsInlineMediaPlayback = NO;
        self.webJumpCount = 1;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"web view didFaile %@",[error localizedDescription]);
}


@end
