//
//  ECExamAnswers.h
//  EnglishRoom
//
//  Created by PES on 14-9-19.
//  Copyright (c) 2014年 PES. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECExamAnswers : NSObject
@property (strong, nonatomic) NSString *testId;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) NSString *sessionID;

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *ip;
@property (strong, nonatomic) NSDictionary *multipleChoice;
//
@property (strong, nonatomic) NSArray *correctionWord;
@property (strong, nonatomic) NSArray *coreectionType;
@property (strong, nonatomic) NSArray *coreectionAnswer;
/*
[
 {问题Id : 答案},
]

*/
@property (strong, nonatomic) NSArray *fillBlank;

/*
 [
 {问题Id : 答案},
 ]
 
 */
@property (strong, nonatomic) NSArray *dictation;

@end
