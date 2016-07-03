//
//  ImagesScrollView.h
//  SF-Gesture
//
//  Created by kenneth on 6/25/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewContainer.h"


@interface LessonView : UIScrollView <ActivityViewContainerDelegate>


-(void) loadTwoActivityView;
-(id) initWithData:(NSArray *)activitiesData;
@end
