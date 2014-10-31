//
//  GLLocalFileViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/16.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLLocalFileViewController.h"
#import "GLTableViewDataSourceObject.h"
#import "GLMediaListViewController.h"
#import "MLFile.h"
#import "GLMediaLibrary.h"
@interface GLLocalFileViewController ()<UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *fileList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GLTableViewDataSourceObject *dataSourceObject;

@end

@implementation GLLocalFileViewController

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
    self.title = @"本地视频";
    [self configView];
}

- (void)configView
{
    self.fileList = [[NSMutableArray alloc]init];
    NSFileManager *manager = [[NSFileManager alloc]init];
    if (![manager fileExistsAtPath:[self rootPath]]) {
        NSLog(@"not found path %@",[self rootPath]);
        return;
    }
    NSError *error;
    NSArray *searchArray = [manager contentsOfDirectoryAtPath:[self rootPath] error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
   
    for (NSString *fileID in searchArray) {
        NSString *filePath = [[self rootPath] stringByAppendingPathComponent:fileID];
        NSArray *mediaArray = [manager contentsOfDirectoryAtPath:filePath error:nil];
        if ([mediaArray count]) {
            GLMediaLibrary *library = [[GLMediaLibrary alloc]init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileID == %@",fileID];
            NSArray *array = [library fetchItemsAtPredicate:predicate andEntityName:@"File" sortingBy:@"episode"];
            
            BOOL hasFile = NO;
            
            for (MLFile *movie in array) {
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:movie.video.path] && [[NSFileManager defaultManager] fileExistsAtPath:movie.audio.enPath]) {
                    hasFile = YES;
                }else{
                    NSLog(@"音频位置 %@ \n",movie.audio.enPath);
                    NSLog(@"视频位置 %@",movie.video.path);
                }
            }
            if (hasFile) {
                [self.fileList addObject:fileID];
            }
        }
    }
    [self setup];
}

- (void)setup
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ArchivesCell"];
    if ([self.fileList count]) {
        self.dataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:self.fileList cellIdentifier:@"ArchivesCell" configureCellBlock:^(UITableViewCell *cell, id item, NSIndexPath *indexPath) {
            GLMediaLibrary *library = [[GLMediaLibrary alloc]init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileID == %@",item];
            NSArray *array = [library fetchItemsAtPredicate:predicate andEntityName:@"File" sortingBy:@"episode"];
            MLFile *video = [array firstObject];
            cell.textLabel.text = video.name;
        }];
        self.tableView.dataSource = self.dataSourceObject;
        self.tableView.delegate = self;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLMediaListViewController *viewController = [[GLMediaListViewController alloc]init];
    viewController.fileID = self.fileList[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    viewController.title = cell.textLabel.text;
    [self.navigationController pushViewController:viewController animated:YES];
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

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
