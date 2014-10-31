//
//  GLSotryHintViewController.m
//  ViewDome
//
//  Created by lynd on 14-6-20.
//  Copyright (c) 2014年 lynd. All rights reserved.
//

#import "GLStoryHintViewController.h"
#import "GLSpeechRecognitionViewController.h"
#import "GLSubtitleParse.h"
@interface GLStoryHintViewController ()<GLSpeechRecognitionDelegate>
{
    GLSubtitleParse *_subtitleParse;
}
@property (weak, nonatomic) IBOutlet UIButton *zhButton;
@property (weak, nonatomic) IBOutlet UIButton *gzButton;
@property (weak, nonatomic) IBOutlet UIButton *jpButton;
@property (weak, nonatomic) IBOutlet UIButton *transButton;
@end
@implementation GLStoryHintViewController

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
    _subtitleParse = [[GLSubtitleParse alloc]initWithSubtitle:self.subtitle];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor darkTextColor];
}

- (IBAction)showSpeechRecognitionView:(id)sender
{
    GLSpeechRecognitionViewController *speechRecognitionViewController =[[GLSpeechRecognitionViewController alloc]init];
    speechRecognitionViewController.selectSubtitle = self.subtitle;
    speechRecognitionViewController.delegate = self;
    [self.navigationController pushViewController:speechRecognitionViewController animated:YES];
}

- (void)repeatCurrentSubtitle
{
    if ([self.delegate respondsToSelector:@selector(repeatCurrentSubtitle)]) {
        [self.delegate repeatCurrentSubtitle];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (IBAction)changeToZH:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(languageTypeChange:)]) {
        [self.delegate languageTypeChange:ZHLanguageType];
    }
}

- (IBAction)changeToGZ:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(changeToGZ)]) {
//        [self.delegate changeToGZ];
//    }
}

- (IBAction)changeToJP:(id)sender {
    
//    if ([self.delegate respondsToSelector:@selector(changeToJP)]) {
//        [self.delegate changeToJP];
//    }
}

- (IBAction)speechWord:(id)sender {
    [_subtitleParse speechSubtitle];
}

- (IBAction)series:(id)sender {
    [_subtitleParse speechSeriesSubtitle];
}

- (IBAction)singleWord:(id)sender {
    [_subtitleParse speechSingleSubtitle];
}

- (IBAction)spellWord:(id)sender {
    [_subtitleParse spellSingleSubtile];
}

- (IBAction)cutWord:(id)sender {
    [_subtitleParse cutWord];
}

- (IBAction)chooseCutWord:(id)sender {
    [_subtitleParse chooseCutWord];
}

- (IBAction)cancelCutWord:(id)sender {
    [_subtitleParse cancelCutWord:self.subtitle];
}

- (IBAction)backWord:(id)sender {
    [_subtitleParse setBackSubtitle];
}

- (IBAction)nextWord:(id)sender {
    [_subtitleParse setNextSubtitle];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
@end
