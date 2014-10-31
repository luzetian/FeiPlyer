//
//  GLMovieViewController.h
//  VLC For IOS
//
//  Created by lynd on 14-6-27.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFile.h"

@interface GLMovieViewController : UIViewController

@property (nonatomic, assign) BOOL      isWLAN;
@property (nonatomic, strong) MLFile   * fileFromMediaLibrary;
@property (nonatomic, strong) NSString  * subtitleURL;
@property (nonatomic, strong) NSURL     * audioPath;
@property (nonatomic, strong) NSURL     * url;
@property (nonatomic, strong) NSURL     * videoPath;

@end
