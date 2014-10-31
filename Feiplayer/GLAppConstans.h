//
//  GLAppConstans.h
//  Feiplayer
//
//  Created by PES on 14/10/13.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#ifndef Feiplayer_GLAppConstans_h
#define Feiplayer_GLAppConstans_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_RUNS_IOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define NSLog(FORMAT, ...) fprintf(stderr,"%s: %s\n Line :%d\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define kDEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define kDEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - Bar Buttons
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define IMGBARBUTTON(IMAGE, SELECTOR) [[UIBarButtonItem alloc] initWithImage:IMAGE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define CUSTOMBARBUTTON(VIEW) [[UIBarButtonItem alloc] initWithCustomView:VIEW]

#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]
#define BARBUTTON_TARGET(TITLE, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]

#pragma mark - Platform
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kVLCSettingVoiceSelector @"voiceSelector"

#define kVLCVersionCodename @"Books from Boxes"

#define kVLCSettingPasscodeKey @"Passcode"
#define kVLCSettingPasscodeOnKey @"PasscodeProtection"
#define kVLCSettingContinueAudioInBackgroundKey @"BackgroundAudioPlayback"
#define kVLCSettingStretchAudio @"audio-time-stretch"
#define kVLCSettingStretchAudioOnValue @"1"
#define kVLCSettingStretchAudioOffValue @"0"
#define kVLCSettingTextEncoding @"subsdec-encoding"
#define kVLCSettingTextEncodingDefaultValue @"Windows-1252"
#define kVLCSettingSkipLoopFilter @"avcodec-skiploopfilter"
#define kVLCSettingSkipLoopFilterNone @(0)
#define kVLCSettingSkipLoopFilterNonRef @(1)
#define kVLCSettingSkipLoopFilterNonKey @(3)
#define kVLCSettingSaveHTTPUploadServerStatus @"isHTTPServerOn"
#define kVLCSettingSubtitlesFont @"quartztext-font"
#define kVLCSettingSubtitlesFontDefaultValue @"HelveticaNeue"
#define kVLCSettingSubtitlesFontSize @"quartztext-rel-fontsize"
#define kVLCSettingSubtitlesFontSizeDefaultValue @"32"
#define kVLCSettingSubtitlesBoldFont @"quartztext-bold"
#define kVLCSettingSubtitlesBoldFontDefaulValue @NO
#define kVLCSettingSubtitlesFontColor @"quartztext-color"
#define kVLCSettingSubtitlesFontColorDefaultValue @"16777215"
#define kVLCSettingDeinterlace @"deinterlace"
#define kVLCSettingDeinterlaceDefaultValue @(0)
#define kVLCSettingNetworkCaching @"network-caching"
#define kVLCSettingNetworkCachingDefaultValue @(999)
#define kVLCSettingsDecrapifyTitles @"MLDecrapifyTitles"
#define kVLCSettingPlaybackGestures @"EnableGesturesToControlPlayback"

#define kVLCShowRemainingTime @"show-remaining-time"
#define kVLCRecentURLs @"recent-urls"
#define kVLCPrivateWebStreaming @"private-streaming"

#define kVLCFTPServer @"ftp-server"
#define kVLCFTPLogin @"ftp-login"
#define kVLCFTPPassword @"ftp-pass"

#define kVLCLastFTPServer @"last-ftp-server"
#define kVLCLastFTPLogin @"last-ftp-login"
#define kVLCLastFTPPassword @"last-ftp-pass"

#define kSupportedFileExtensions @"\\.(3gp|3gp|3gp2|3gpp|amv|asf|avi|axv|divx|dv|flv|f4v|gvi|gxf|m1v|m2p|m2t|m2ts|m2v|m4v|mks|mkv|moov|mov|mp2v|mp4|mpeg|mpeg1|mpeg2|mpeg4|mpg|mpv|mt2s|mts|mxf|mxg|nsv|nuv|oga|ogg|ogm|ogv|ogx|spx|ps|qt|rec|rm|rmvb|tod|ts|tts|vob|vro|webm|wm|wmv|wtv|xesc)$"
#define kSupportedSubtitleFileExtensions @"\\.(cdg|idx|srt|sub|utf|ass|ssa|aqt|jss|psb|rt|smi|txt|smil)$"
#define kSupportedAudioFileExtensions @"\\.(aac|aiff|aif|amr|aob|ape|axa|caf|flac|it|m2a|m4a|m4b|mka|mlp|mod|mp1|mp2|mp3|mpa|mpc|mpga|oga|ogg|oma|opus|rmi|s3m|spx|tta|voc|vqf|wav|w64|wma|wv|xa|xm)$"

#define kBlobHash @"521923d214b9ae628da7987cf621e94c4afdd726"

#if TARGET_IPHONE_SIMULATOR
#define WifiInterfaceName @"en1"
#else
#define WifiInterfaceName @"en0"
#endif

#endif
