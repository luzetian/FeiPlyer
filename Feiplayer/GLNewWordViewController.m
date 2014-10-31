//
//  GLNewWordViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLNewWordViewController.h"
#import "GLAppUserDefaults.h"
#import "GLNetworkRequest.h"
#import "GLAudioService.h"
#import "SIAlertView.h"
#import "AFNetworking.h"
@interface GLNewWordViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

#define kWORD_BOOK_URL    @"http://42.121.253.181/index.php/movie/newword?sessionid="
@end

@implementation GLNewWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"生词本";
    [self _loadNewWord];
}

- (void)_loadNewWord
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[self _newWordUrl]]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (IBAction)goHome:(id)sender {
    [self _loadNewWord];
}

- (NSString *)_newWordUrl
{
    NSString *url = [kWORD_BOOK_URL stringByAppendingString:[GLAppUserDefaults stringValueForKey:kLOGIN_SESSIONID]];
    return url;
}

#pragma mark ---- Web view Delegate ----
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"%@",request.URL);
        [self _clickedLinke:request.URL];
    }
    return YES;
}

- (void)_clickedLinke:(NSURL *)url
{
    NSString *query = [[url query]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *queryDic = [self _dictionaryFromQuery:query usingEncoding:NSUTF8StringEncoding];
    if ([url.scheme isEqualToString:@"feienglishstudy"]) {
        NSString *host = [url host];
        if ([host isEqualToString:@"speech"]) {
            [self _speechText:queryDic];
        }else if ([host isEqualToString:@"clienttrans"]){
            [self _clientTrans:queryDic];
            NSLog(@"clienttrans %@",queryDic);
        }else if ([host isEqualToString:@"scenario"]){
            [self _scenario:queryDic];
            NSLog(@"scenario %@",queryDic);
        }else if ([host isEqualToString:@"trans"]){
            [self _trans:queryDic];
            NSLog(@"trans %@",queryDic);
        }else if ([host isEqualToString:@"clienttransext"]){
            [self _showTranslateTools];
        }else if([host isEqualToString:@"speechcheck"]){
            [self _speechcheck:queryDic];
            NSLog(@"speechcheck %@",queryDic);
        }
    }
}

- (void)_speechcheck:(NSDictionary *)dic
{
    if (dic == nil || ![dic count]) {
        return;
    }
    
    // NSString *text = [dic objectForKey:@"text"];
}

- (void)_showTranslateTools
{

}

- (NSDictionary*)_dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (void)_speechText:(NSDictionary *)dic
{
    if (dic == nil || ![dic count]) {
        return;
    }
    NSString *content = [dic objectForKey:@"text"];
    NSLog(@"content %@",content);
    GLAudioService *audioService = [[GLAudioService alloc]init];
    [audioService speechText:content withVoice:@"zh-TW"];
}

- (void)_trans:(NSDictionary *)dic
{
    if (dic == nil || ![dic count]) {
        return;
    }
    SIAlertView *alertView = [[SIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") andMessage:NSLocalizedString(@"OPERATION_FEE", @"")];
    
    [alertView addButtonWithTitle:NSLocalizedString(@"SURE", @"") type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        [params setObject:[self _sessionId] forKey:@"sessionid"];
        [GLNetworkRequest translate:params costResults:^(id result) {
            NSLog(@"result %@",result);
            if (result != nil) {
                NSString *errorCode = [result objectForKey:@"error_code"];
                NSString *errorMsg = [result objectForKey:@"error_msg"];
                NSString *trans = [result objectForKey:@"trans"];
                SIAlertView *alertView = [[SIAlertView alloc]init];
                if ([errorCode isEqualToString:@"0"]) {
                    [alertView setTitle:NSLocalizedString(@"TRANS_RESULT", @"")];
                    [alertView setMessage:trans];
                }else{
                    [alertView setTitle:NSLocalizedString(@"ERROR", @"")];
                    [alertView setMessage:errorMsg];
                }
                [alertView addButtonWithTitle:NSLocalizedString(@"SURE", @"") type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
                    
                }];
                [alertView show];
            }
        }];
    }];
    
    [alertView addButtonWithTitle:NSLocalizedString(@"CANCEL", @"") type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        
    }];
    [alertView show];
}

- (void)_scenario:(NSDictionary *)dic
{
    if (dic == nil || ![dic count]) {
        return;
    }
//    if (_audioPlayer.isPlaying) {
//        return;
//    }
    NSLog(@"%@",dic);
    NSString *filmId = [dic objectForKey:@"f"];
    NSString *episode = [dic objectForKey:@"fe"];
    // NSString *language = [dic objectForKey:@"language"];
    NSString *position = [dic objectForKey:@"position"];
    NSString *fileName = [dic objectForKey:@"filename"];
    // NSString *audioPath = nil;
    //GLMediaLibrary *dataLibrary = [[GLMediaLibrary alloc]init];
#warning 查询
    // NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"fileID == %@",filmId],[NSPredicate predicateWithFormat:@"episode = %@",episode]]];
    //
    //    NSRange  range = [fileName rangeOfString:@"/"];
    //    if (range.location != NSNotFound) {
    //        NSInteger index = [fileName rangeOfString:@"/"].location;
    //        fileName = [fileName substringToIndex:index];
    //    }
    //    fileName = [NSString stringWithFormat:@"%@%@",fileName,episode];
    //
    //
    //    GLDownloadHelp *help = [[GLDownloadHelp alloc]init];
    //    NSString *filePath =[help audioPathWithFileName:fileName audioType:GLENType];
    //
    //
    //    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
    //        [self playAudioWhitPath:filePath atPosition:position];
    //    }else{
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:NSLocalizedString(@"LOCAL_NOT_FOUND", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"SURE", @"") otherButtonTitles:nil];
    //        [alert show];
    //        [GLNetworkRequest requestMovieInfoWithFilmID:filmId andEpisode:episode succeedBlock:^(id result) {
    //            GLMovieJSONModel *model = result;
    //            NSString *audioURLStr = [model.audio objectForKey:@"en"];
    //            GLDownloadManager *download = [[GLDownloadManager alloc]init];
    //            [download fromOriginURL:audioURLStr getDownloadURLBlock:^(NSString *url) {
    //                NSURL *audioURL = [NSURL URLWithString:url];
    //                [self downloadForURL:audioURL filePath:filePath];
    //            }];
    //
    //        } requestFail:^(id result) {
    //            APLog(@"movie infomation request fail! %@",result);
    //        }];
    //    }
}

- (void)_clientTrans:(NSDictionary *)dic
{
    if (dic == nil || ![dic count]) {
        return;
    }
    
    NSString *content = [dic objectForKey:@"content"];
    NSString *studyid = [dic objectForKey:@"studyid"];
    NSString *type = [dic objectForKey:@"type"];
    if ([content length] && [studyid length] && [type length]) {
        SIAlertView *alertView = [[SIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") andMessage:NSLocalizedString(@"OPERATION_FEE", @"")];
        [alertView addButtonWithTitle:NSLocalizedString(@"SURE", @"") type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
            [GLNetworkRequest baiduTranslateWithText:content returnJson:^(id result) {
                if (result != nil) {
                    NSArray *transArray = [result objectForKey:@"trans_result"];
                    NSDictionary *transDic = transArray[0];
                    NSString *transResult = [transDic objectForKey:@"dst"];
                    NSDictionary *params = @{@"sessionid":[self _sessionId],
                                             @"sentence":content,
                                             @"result":transResult,
                                             @"type":type,
                                             @"studyid":studyid};
                    [GLNetworkRequest studytrans:params costResults:^(id result) {
                        NSString *errorCode = [result objectForKey:@"error_code"];
                        NSString *errorMsg = [result objectForKey:@"error_msg"];
                        NSString *trans = [result objectForKey:@"trans"];
                        SIAlertView *alertView = [[SIAlertView alloc]init];
                        if ([errorCode isEqualToString:@"0"]) {
                            [alertView setTitle:NSLocalizedString(@"TRANS_RESULT", @"")];
                            [alertView setMessage:trans];
                        }else{
                            [alertView setTitle:NSLocalizedString(@"ERROR", @"")];
                            [alertView setMessage:errorMsg];
                        }
                        [alertView addButtonWithTitle:NSLocalizedString(@"SURE", @"") type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
                        }];
                        [alertView show];
                    }];
                }
            }];
        }];
        [alertView addButtonWithTitle:NSLocalizedString(@"CANCEL", @"") type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        }];
        [alertView show];
    }
}

- (void)downloadForURL:(NSURL *)url filePath:(NSString *)path
{
    NSString *destinationPath = path;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:destinationPath];
        return documentsDirectoryPath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
    }];
    [downloadTask resume];
}

- (NSString *)_sessionId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [defaults objectForKey:@"sessionid"];
    return sessionID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
