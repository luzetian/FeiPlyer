//
//  GLMediaListViewController.m
//  VLC For IOS
//
//  Created by lynd on 14-7-24.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLMediaListViewController.h"
#import "GLMediaLibrary.h"
#import "GLAppDelegate.h"
#import "MLFile.h"
#import "GLNetworkRequest.h"
#import "JGProgressHUD.h"
#import "GLNewWordViewController.h"
#import "GLLoginViewController.h"
#import "GLMovieViewController.h"
#import "UINavigationController+Rotation.h"
@interface GLMediaListViewController ()<UITableViewDataSource>
{
    NSMutableArray *m_mediaList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)configViewController;
@end

@implementation GLMediaListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configViewController];
}

- (void)configViewController
{
    if (!m_mediaList) {
        m_mediaList = [[NSMutableArray alloc]init];
    }
    if (self.fileID) {
        GLMediaLibrary *library = [GLMediaLibrary sharedMediaLibrary];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileID == %@",self.fileID];
        NSArray *array = [library fetchItemsAtPredicate:predicate andEntityName:@"File" sortingBy:@"episode"];
        for (MLFile *movie in array) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:movie.video.path] && [[NSFileManager defaultManager] fileExistsAtPath:movie.audio.enPath]) {
                   [m_mediaList addObject:movie];
            }
         
        }
    }
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mediaList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MLFile *movie = [m_mediaList objectAtIndex:indexPath.row];
    cell.textLabel.text = movie.episode;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playMediaFromManagedObject:m_mediaList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MLFile *movie = [m_mediaList objectAtIndex:indexPath.row];
        
        if ([MLFile deleteFileWithObject:movie]) {
            [m_mediaList removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else{
            NSLog(@"视频删除失败");
        }
    }
}

- (void)playMediaFromManagedObject:(NSManagedObject *)mediaObject
{
    NSString *msg = NSLocalizedString(@"BEGIN_ADD_SOURCE", @"");
    JGProgressHUD *hub = [[JGProgressHUD alloc]initWithStyle:JGProgressHUDStyleDark];
    hub.textLabel.text = msg;
    [hub showInView:self.view];
    if (![mediaObject isKindOfClass:[MLFile class]]) {
        return;
    }
    MLFile *movie = (MLFile *)mediaObject;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [defaults objectForKey:@"sessionid"];
    NSDictionary *params = @{@"sessionid": sessionid,
                             @"f":movie.fileID,
                             @"fe":movie.episode,
                             @"language":@"en"};
    
    [GLNetworkRequest checkUserRight:params returnJson:^(id result) {
        NSInteger errorCode = [[result objectForKey:@"error_code"] integerValue];
        // NSString  *errorMsg = [result objectForKey:@"error_msg"];
        NSInteger code      = [[result objectForKey:@"code"] integerValue];
        // NSString  *msg      = [result objectForKey:@"msg"];
        if (errorCode == 0 && code == 0) {
            GLMovieViewController *movieViewController = [[GLMovieViewController alloc]init];
            movieViewController.fileFromMediaLibrary = movie;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:movieViewController];
            [hub dismiss];
            [self presentViewController:nav animated:YES completion:nil];
        }
        if (errorCode == 1){
            [hub dismiss];
            GLLoginViewController *viewController = [[GLLoginViewController alloc]init];
            [self presentViewController:viewController animated:YES completion:nil];
        }else if (code == 1){
            GLNewWordViewController *newWordViewController = [[GLNewWordViewController alloc]init];
            newWordViewController.test = YES;
            [self.navigationController pushViewController:newWordViewController animated:YES];
        }else{
            //            NSString *errorMessage;
            //            if ([msg length]) {
            //                errorMessage = msg;
            //            }else{
            //                errorMessage= errorMsg;
            //            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
