//
//  GLLANSharingViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLLANSharingViewController.h"
#import "GLCollectionViewDataSource.h"
#import "GLEpisodeViewController.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "GLMovieBrowseCell.h"
#import "AsyncUdpSocket.h"
#import "GLNetworkService.h"
#import "JGProgressHUD.h"
static NSString *const kHost = @"255.255.255.255";
static NSString *const kProt = @"33579";
static NSString *const kBroadcastmsg = @"feiplayer-broadcast";
static NSUInteger const kLocalPort = 10048;
static NSUInteger const kRemotePort = 10049;
@interface GLLANSharingViewController ()<NSXMLParserDelegate,UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *series;
@property (strong, nonatomic) NSMutableArray *episode;
@property (strong, nonatomic) NSMutableArray *episodeArray;
@property (strong, nonatomic) AsyncUdpSocket *udpSocket;
@property (strong, nonatomic) NSString *ips;
@property (nonatomic, strong) NSMutableArray *LanIpList;
@property (strong, nonatomic) JGProgressHUD *hub;

@property (strong, nonatomic) GLCollectionViewDataSource *collectionViewDataSource;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation GLLANSharingViewController

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
     self.title = @"局域网共享";
    [self udpSetup];
}

- (void)setup
{
    [self.collectionView registerNib:[GLMovieBrowseCell nib] forCellWithReuseIdentifier:[GLMovieBrowseCell identifier]];
    CollectionViewCellConfigureBlock configBlock = ^(GLMovieBrowseCell *cell, id item, NSIndexPath *indexPath){
        [cell Lanconfigure:item];
    };
    [self.collectionView registerNib:[GLMovieBrowseCell nib] forCellWithReuseIdentifier:[GLMovieBrowseCell identifier]];
    self.collectionViewDataSource = [[GLCollectionViewDataSource alloc]initWithItems:self.series cellIdentifier:[GLMovieBrowseCell identifier] configureCellBlock:configBlock];
    self.collectionView.dataSource = self.collectionViewDataSource;
    self.collectionView.delegate = self;
    [self.hub dismiss];
}

#pragma mark
#pragma mark ---- Async UDP Socket Deleaget ----
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port
{
    
    NSString *myIP = [self p_currentIPAddress];
    NSMutableString *tempIP = [NSMutableString stringWithFormat:@"::ffff:%@",myIP];
    if ([host isEqualToString:myIP]||[host isEqualToString:tempIP])
    {
        NSLog(@"host %@",host);
    }
    [sock receiveWithTimeout:2 tag:0];
    if (data) {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"feiplayer-response"]) {
            [_LanIpList addObject:host];
        }
    }
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    [self xmlParser];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        [self.udpSocket close];
    }
}

- (void)xmlParser
{
    if ([_LanIpList count]) {
        for (NSString *str in _LanIpList) {
            self.ips = str;
            NSString *str1 = [str stringByAppendingString:[NSString stringWithFormat:@":%@/resource.xml",kProt]];
            NSString *d = [NSString stringWithFormat:@"http://%@",str1];
            NSURL *url = [NSURL URLWithString:d];
            
            if (url) {
                NSXMLParser *parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
                parser.delegate = self;
                if ([parser parse]) {
                    [self setup];
                }
            }else{
                NSLog(@"解析失败");
            }
        }
    }else{
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *seriesDic = self.series[indexPath.row];
    NSArray *ep = self.episodeArray[indexPath.row];
    GLEpisodeViewController *episodeViewController = [[GLEpisodeViewController alloc]init];
    
    episodeViewController.fileImfo = seriesDic;
    episodeViewController.fileArray = ep;
    [self.navigationController pushViewController:episodeViewController animated:YES];
}

#pragma mark
#pragma mark ---- XML Parser Delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"%@",parser);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"series"]) {
        NSArray *array = [NSArray arrayWithArray:self.episode];
        [self.episodeArray addObject:array];
        [self.episode removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    if ([elementName isEqualToString:@"episode"]) {
        if ([self.ips length]) {
            [dic setValue:self.ips forKey:@"ip"];
        }
        [self.episode addObject:dic];
    }
    if ([elementName isEqualToString:@"series"]) {
        [self.series addObject:dic];
    }
}

#pragma mark
#pragma mark ---- Priveate Method ----

- (void)udpSetup
{
    if (![GLNetworkService isEnableWIFI]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您未加入任何局域网,请打开无线Wifi功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    self.udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    if (![self.udpSocket bindToPort:kLocalPort error:&error])
	{
		NSLog(@"Error binding: %@", error);
		return;
	}
	
    if (![self.udpSocket enableBroadcast:YES error:&error]) {
        NSLog(@"Error binding: %@", error);
        return;
    }
    self.series = [NSMutableArray array];
    self.episode = [NSMutableArray array];
    self.episodeArray = [NSMutableArray array];
    self.LanIpList = [NSMutableArray array];
    
    [self.udpSocket receiveWithTimeout:-1 tag:0];
	[self p_sendBroadcast:kBroadcastmsg toAddress:kHost andPort:10049];
    self.hub = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleLight];
    [self.hub showInView:self.view];
	NSLog(@"Ready");
}

- (void)p_sendBroadcast:(NSString *)msg
              toAddress:(NSString *)address
                andPort:(NSInteger)port
{
    if (port <= 0 || port > 65535)
	{
        NSLog(@"Valid port required");
        return;
	}
    
    if ([msg length] == 0)
	{
        NSLog(@"Message required");
        return;
	}
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    if (![self.udpSocket sendData:data toHost:kHost port:port withTimeout:-1 tag:0]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TIPS", @"") message:NSLocalizedString(@"REQUEST_ERROR", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"SURE", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSString *)p_currentIPAddress
{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([@(temp_addr->ifa_name) isEqualToString:@"en1"])
                    address = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr));
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
