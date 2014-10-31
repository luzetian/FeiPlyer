//
//  GLNewsListViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECNewsListViewController.h"
#import "ECMediaViewController.h"
#import "ECSeriesListModel.h"
#import "GLTableViewDataSourceObject.h"
#import "ECVideoTableViewCell.h"
#import "GLNetworkRequest.h"
@interface ECNewsListViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) GLTableViewDataSourceObject *tableViewDataSourceObject;

@end

@implementation ECNewsListViewController

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
    [self requestNewsList];
}

- (void)requestNewsList
{
    if (self.model == nil) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.model.requetsParam];
    [params setValue:self.model.seriesId forKey:@"series_id"];
    [params setValue:@"1" forKey:@"page"];
    [params setValue:@"20" forKey:@"page_size"];
    [GLNetworkRequest englishClassVideoListRequestWithType:params success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            [self setupWithData:result];
        }
    }];
}

- (void)setupWithData:(NSArray *)data
{
    TableViewCellConfigureBlock configureBlock = ^(ECVideoTableViewCell *cell, id item,NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    self.tableViewDataSourceObject = [[GLTableViewDataSourceObject alloc]initWithItems:data cellIdentifier:[ECVideoTableViewCell identifer] configureCellBlock:configureBlock];
    [self.tableView registerNib:[ECVideoTableViewCell nib] forCellReuseIdentifier:[ECVideoTableViewCell identifer]];
    self.tableView.dataSource = self.tableViewDataSourceObject;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECVideoTableViewCell *cell = (ECVideoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ECMediaViewController *viewController = [[ECMediaViewController alloc]init];
    viewController.videoID = cell.videioId;
    [self.navigationController pushViewController:viewController animated:YES];
}

//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    ECVideoTableViewCell *cell = sender;
//    if ([cell isKindOfClass:[ECVideoTableViewCell class]]) {
//        if ([segue.identifier isEqualToString:@"TableNewsSegue"]) {
//            ECMediaViewController *viewController = segue.destinationViewController;
//            viewController.videoID = cell.videioId;
//        }
//    }
//}


@end
