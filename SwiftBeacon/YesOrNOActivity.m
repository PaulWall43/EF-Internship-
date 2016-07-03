//
//  YesOrNOActivity.m
//  activitiesForTether
//
//  Created by kenneth on 7/1/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import "YesOrNOActivity.h"

@interface YesOrNOActivity (){
    
    NSDictionary *actData;
    BOOL isCorrectInTheFirstTime;
}

@end
@implementation YesOrNOActivity

- (void) loadActivityViewWithData: (NSDictionary *)data {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.bounds = CGRectMake(0,0, 300, 100);
    lbl.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height / 2);
    lbl.text = @"This is YesOrNOActivity!";
    lbl.textColor = [UIColor redColor];
    self.bounds = [UIScreen mainScreen].bounds;
    [self addSubview:lbl];
    
    actData = [NSDictionary dictionaryWithDictionary:data];
    /*
     "activityType" : "YesOrNOActivity",
     "question" : "I am going to have lunch.",
     "instruction" : "Which question should get this reply?",
     "answerlist" : [
     "Hi, how are you?",
     "Where are you?",
     "*What are you going to do?"
     
     
     */
    
    
    UIView *mainView = [[UIView alloc] init];//WithFrame:[UIScreen mainScreen].bounds];
    mainView.frame = [UIScreen mainScreen].bounds;
    mainView.backgroundColor = [UIColor blackColor];
    [self addSubview:mainView];
    
    UILabel *question = [[UILabel alloc] init];
    question.frame = CGRectMake(0,0 ,mainView.frame.size.width - 20, 100);
    question.textColor = [UIColor whiteColor];
    question.text = data[@"question"];
    question.center = CGPointMake(mainView.center.x, mainView.frame.size.height * 2 / 5);
    question.textAlignment = NSTextAlignmentCenter;
    question.adjustsFontSizeToFitWidth = YES;
    question.backgroundColor = [UIColor clearColor];
    [mainView addSubview:question];
    
//    UIView *answersContainer = [[UIView alloc] init];
//    answersContainer.frame = CGRectMake(0,0 ,mainView.frame.size.width - 20, 100);
//
//    //Buttons of answers
    NSArray *answerList = data[@"answerlist"];
    CGRect frameOfAnswerButton = CGRectMake(0, 0, mainView.frame.size.width - 40, 40);
    double yValueOfAnswerButton = [UIScreen mainScreen].bounds.size.height - 50;
    double gapBetweenButtons = 50.0;
    for (int n = 0; n < answerList.count; n ++)
    {
        UIButton *answerButton = [[UIButton alloc] initWithFrame:frameOfAnswerButton];
        answerButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, yValueOfAnswerButton - n * gapBetweenButtons);
        answerButton.backgroundColor = [UIColor grayColor];
        [answerButton setTitle:[answerList[n] stringByReplacingOccurrencesOfString:@"*" withString:@""]  forState:UIControlStateNormal];
    
        [mainView addSubview:answerButton];
        [answerButton addTarget:self action:@selector(checkAnswerCorrectOrNot:) forControlEvents:UIControlEventTouchUpInside];
        
    }

    
    
    UILabel *instruction = [[UILabel alloc] init];
    instruction.frame = CGRectMake(0,0 ,mainView.frame.size.width - 20, 100);
    instruction.textColor = [UIColor whiteColor];
    instruction.text = data[@"instruction"];
    instruction.center = CGPointMake(mainView.center.x, mainView.frame.size.height * 1 / 8);
    instruction.textAlignment = NSTextAlignmentCenter;
    instruction.adjustsFontSizeToFitWidth = YES;
    instruction.backgroundColor = [UIColor clearColor];
//    instruction.lineBreakMode = YES;
    instruction.numberOfLines = 3;
    [mainView addSubview:instruction];
    
}


- (void)checkAnswerCorrectOrNot: (UIButton *)sender
{
    NSString *correctAnswer;
    for (NSString *answer in actData[@"answerlist"])
    {
        if ([answer hasPrefix:@"*"])
        {
            correctAnswer = answer;
        }
    }
    
    NSString *titleOfSender = [@"*" stringByAppendingString:[sender titleForState:UIControlStateNormal]];
    
    
    if ([titleOfSender isEqualToString:correctAnswer])
    {
        sender.backgroundColor = [UIColor greenColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(willMoveToNextActivityWithAnswered:)])
            {
                [_delegate willMoveToNextActivityWithAnswered:isCorrectInTheFirstTime];
            }
        });
    } else {
        sender.backgroundColor = [UIColor orangeColor];
        isCorrectInTheFirstTime = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.backgroundColor = [UIColor grayColor];
        });
    }
    
}

@end
