//
//  GLMediaViewController.m
//  EnglishRoom
//
//  Created by PES on 14-9-17.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "ECMediaViewController.h"
#import "ECMultipleChoiceViewController.h"
#import "GLNetworkRequest.h"
#import "ECVideoInfoModel.h"
@interface ECMediaViewController ()
@property (strong, nonatomic)  ECVideoInfoModel *model;
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@property (weak, nonatomic) IBOutlet UITextView *transTextView;
@end

@implementation ECMediaViewController

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
    [self setup];
}

- (void)setup
{
    if (![self.videoID length]) {
        return;
    }
    [GLNetworkRequest englishVideoDetailRequestWithVideoID:self.videoID success:^(id result) {
        if (result != nil && [result isKindOfClass:[NSDictionary class]]) {
            self.model = [[ECVideoInfoModel alloc]initWithContent:result];
            self.subjectTextView.text = self.model.enBackground;
        }
    }];
}

- (IBAction)translate:(id)sender {
    self.transTextView.text = self.model.zhBackground;
}

- (IBAction)downloadCnVoice:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)downloadHKVoice:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)next:(id)sender {
    ECMultipleChoiceViewController *multipleChoiceViewController = [[ECMultipleChoiceViewController alloc]init];
    multipleChoiceViewController.info = self.model;
    [self.navigationController pushViewController:multipleChoiceViewController animated:YES];
}

@end
