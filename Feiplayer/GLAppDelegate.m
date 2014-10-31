//
//  GLAppDelegate.m
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLLoginViewController.h"
#import "GLFirstStepsViewController.h"
#import "GLAppUserDefaults.h"
#import "UIDevice+SpeedCategory.h"
@implementation GLAppDelegate
+ (void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *skipLoopFilterDefaultValue;
    int deviceSpeedCategory = [[UIDevice currentDevice] speedCategory];
    if (deviceSpeedCategory < 3)
        skipLoopFilterDefaultValue = kVLCSettingSkipLoopFilterNonKey;
    else
        skipLoopFilterDefaultValue = kVLCSettingSkipLoopFilterNonRef;
    
    NSDictionary *appDefaults = @{kVLCSettingPasscodeKey : @"", kVLCSettingPasscodeOnKey : @(NO), kVLCSettingContinueAudioInBackgroundKey : @(YES), kVLCSettingStretchAudio : @(NO), kVLCSettingTextEncoding : kVLCSettingTextEncodingDefaultValue, kVLCSettingSkipLoopFilter : skipLoopFilterDefaultValue, kVLCSettingSubtitlesFont : kVLCSettingSubtitlesFontDefaultValue, kVLCSettingSubtitlesFontColor : kVLCSettingSubtitlesFontColorDefaultValue, kVLCSettingSubtitlesFontSize : kVLCSettingSubtitlesFontSizeDefaultValue, kVLCSettingSubtitlesBoldFont: kVLCSettingSubtitlesBoldFontDefaulValue, kVLCSettingDeinterlace : kVLCSettingDeinterlaceDefaultValue, kVLCSettingNetworkCaching : kVLCSettingNetworkCachingDefaultValue, kVLCSettingPlaybackGestures : [NSNumber numberWithBool:YES]};
    
    [defaults registerDefaults:appDefaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    if ([GLAppUserDefaults boolValueForKey:FIREST_LAUNCH]) {
        GLLoginViewController *viewController = [[GLLoginViewController alloc]init];
        self.window.rootViewController = viewController;
    } else {
        UIViewController *firstStepsVC = [[GLFirstStepsViewController alloc] init];
        self.window.rootViewController = firstStepsVC;
    }
    /*
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
     */
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (deviceToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:deviceToken forKey:@"deviceToken"];
        [defaults synchronize];
        
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo %@",userInfo);
}

@end
