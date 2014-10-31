//
//  LTEpisodeViewController.m
//  VLC for iOS
//
//  Created by lynd on 14-1-15.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLEpisodeViewController.h"
#import "GLMovieViewController.h"
#import "UINavigationController+Rotation.h"
#import "MLFile.h"
@interface GLEpisodeViewController ()

@end

@implementation GLEpisodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_fileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.fileImfo[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = _fileArray[indexPath.row];
    if ([info count] && [self.fileImfo count]) {
        NSString *baseIp        = [info objectForKey:@"ip"];
        NSString *episode       = [info objectForKey:@"episode"];
        NSString *subtitleURL   = [info objectForKey:@"subtitle"];
        NSString *uid           = self.fileImfo[@"uid"];
        NSString *vedioURL      = [NSString stringWithFormat:@"http://%@:33579/cache/%@/%@/video",baseIp,uid,episode];
        NSString *audioURL      = [NSString stringWithFormat:@"http://%@:33579/cache/%@/%@/audio/EN",baseIp,uid,episode];
      
        GLMovieViewController * movieViewController = [[GLMovieViewController alloc]init];
        movieViewController.isWLAN = YES;
        movieViewController.audioPath = [NSURL URLWithString:audioURL];
        movieViewController.videoPath = [NSURL URLWithString:vedioURL];
        movieViewController.subtitleURL = subtitleURL;
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:movieViewController];
        navCon.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.view.window.rootViewController presentViewController:navCon animated:YES completion:nil];
    }
}

@end
