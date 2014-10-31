//
//  GLVideoDetailViewController.m
//  Feiplayer
//
//  Created by PES on 14/10/15.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLVideoDetailViewController.h"
#import "GLCollectionViewDataSource.h"
#import "GLEpisodeCell.h"
#import "GLNetworkRequest.h"
#import "GLVideoInfoModel.h"
#import "UIImageView+AFNetworking.h"
#import "GLDownloadHelp.h"
#import "GLHTTPDownload.h"
#import "MLFile.h"
@interface GLVideoDetailViewController ()<UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *actorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *synopsisTextView;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *zhDownload;

@property (weak, nonatomic) IBOutlet UIButton *hkDownload;
@property (strong, nonatomic) GLCollectionViewDataSource *collectionDataSource;
@property (strong, nonatomic) GLVideoInfoModel *videoInfo;

@end

@implementation GLVideoDetailViewController

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
    [self requestVideoDetail];
}

- (void)requestVideoDetail
{
    [GLNetworkRequest requestVideoDetailWith:self.videoID returnJson:^(id result) {
        [self setupWithDic:result];
    } requestFail:^(id result) {
        
    }];
}

- (void)setupWithDic:(NSDictionary *)dic
{
    GLVideoInfoModel *model = [[GLVideoInfoModel alloc]initWithContent:dic];
    self.videoInfo = model;
    self.videoName.text = model.filmName;
    self.actorNameLabel.text = model.mainActors;
    self.directorNameLabel.text = model.director;
    [self.videoThumb setImageWithURL:[NSURL URLWithString:model.fileImageURL]];
    self.synopsisTextView.text = model.synopsis;

    CollectionViewCellConfigureBlock block =
    ^(GLEpisodeCell *cell, id item,NSIndexPath *indexPath){
        [cell configureWithItem:item];
    };
    [self.collectionView registerNib:[GLEpisodeCell nib] forCellWithReuseIdentifier:[GLEpisodeCell identifier]];
    self.collectionDataSource = [[GLCollectionViewDataSource alloc]initWithItems:model.episodes cellIdentifier:[GLEpisodeCell identifier] configureCellBlock:block];
    self.collectionView.dataSource = self.collectionDataSource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GLEpisodeCell *cell = (GLEpisodeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MLFile *file = [MLFile createFile];
    file.fileID = self.videoInfo.filmId;
    file.name = self.videoInfo.filmName;
    
    GLVideoInfoModel *downloadInfo = [[GLVideoInfoModel alloc]initWithContent:cell.downloadInfo];
    file.video.url = downloadInfo.vedioURL;
    file.audio.enUrl = downloadInfo.audio[@"en"];
    file.audio.zhUrl = downloadInfo.audio[@"zh"];
    file.audio.hkUrl = downloadInfo.audio[@"hk"];
    file.audio.hkDwonload = [NSNumber numberWithBool:self.hkDownload.selected];
    file.audio.zhDownload = [NSNumber numberWithBool:self.zhDownload.selected];
    file.episode = downloadInfo.filmEpisode;
    
    file.subtitle.enUrl = downloadInfo.subtitle[@"en"];
    file.subtitle.zhUrl = downloadInfo.subtitle[@"zh"];
    file.subtitle.hkUrl = downloadInfo.subtitle[@"hk"];
    [file setFilePath];
    GLHTTPDownload *download = [GLHTTPDownload shareHTTPDowload];
    [download addDownloadFile:file];
}

- (IBAction)downloadCNAudio:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)downloadGZAudio:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
