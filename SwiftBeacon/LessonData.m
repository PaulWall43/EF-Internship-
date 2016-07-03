//
//  ActivityViewData.m
//  activitiesForTether
//
//  Created by kenneth on 7/1/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import "LessonData.h"

@implementation LessonData

- (id) getActivityDataFromActivityLevel: (int)activityLevel andActivityNO: (int) activityNO
{
    NSString *nameOfActivityData = [NSString stringWithFormat:@"activity_%d_%d",activityLevel,activityNO];
    

    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:nameOfActivityData ofType:@"json"];
//    NSString *stringForJSON = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    NSData *dataForJson = [NSData dataWithContentsOfFile:jsonPath];
    id a = [NSJSONSerialization JSONObjectWithData:dataForJson options:NSJSONReadingMutableContainers error:nil];
    
    return a;
}


+ (id) dataFromActivityLevel: (int)activityLevel andActivityNO: (int) activityNO
{
    LessonData *lessonViewData = [[LessonData alloc] init];
    id activityData = [lessonViewData getActivityDataFromActivityLevel:activityLevel andActivityNO:activityNO];
    
    return activityData;
}

@end
