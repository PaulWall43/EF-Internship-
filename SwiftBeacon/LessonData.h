//
//  ActivityViewData.h
//  activitiesForTether
//
//  Created by kenneth on 7/1/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonData : NSObject

@property (weak) id data;

- (id) getActivityDataFromActivityLevel: (int)activityLevel andActivityNO: (int) activityNO;

+ (id) dataFromActivityLevel: (int)activityLevel andActivityNO: (int) activityNO;

@end
