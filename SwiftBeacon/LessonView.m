//
//  ImagesScrollView.m
//  SF-Gesture
//
//  Created by kenneth on 6/25/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import "LessonView.h"
#import "ActivityViewContainer.h"

@interface LessonView () {
    
    ActivityViewContainer *imageView0;
    ActivityViewContainer *imageView1;
    ActivityViewContainer *imageView2;
    CGPoint originalCenterForView0;
    CGPoint originalCenterForView1;
    CGPoint originalCenterForView2;
    BOOL isMovingToRight;
    NSArray *dataForActivities;
    
    int currentActivityNO;
    CGRect frameOfMainView;
    
    CGPoint invisibleCenter;
    
    BOOL isView0ON;
    BOOL isView2ON;
    
    NSMutableDictionary *userProgress;
    
}

@end

@implementation LessonView


- (id) initWithData:(NSArray *)activitiesData
{
    if (self = [super init])
    {
        dataForActivities = activitiesData;

        invisibleCenter = CGPointMake(0, -2000);
        frameOfMainView = [UIScreen mainScreen].bounds;
        originalCenterForView0 = CGPointMake(-2 * frameOfMainView.size.width / 10 , frameOfMainView.size.height / 2);
        originalCenterForView2 = CGPointMake(3 * frameOfMainView.size.width / 2 , frameOfMainView.size.height / 2);
        
        userProgress = [NSMutableDictionary dictionary];
        
        
    }
    return self;
}

 -(void) loadTwoActivityView
{
    
    
    imageView1 = [[ActivityViewContainer alloc] initWithFrame:frameOfMainView andActivityData:dataForActivities[currentActivityNO]];
    imageView1.backgroundColor = [UIColor greenColor];
    currentActivityNO = 0;
    originalCenterForView1 = imageView1.center;
    [self addSubview:imageView1];
    imageView1.delegate = self;
    
    
    [self generatePreviousActivity];
    [self generateNextActivity];
    [self bringSubviewToFront:imageView1];

}

- (void)generatePreviousActivity
{
    if (currentActivityNO > 0)
    {
        imageView0 = [[ActivityViewContainer alloc] initWithFrame:frameOfMainView andActivityData:dataForActivities[currentActivityNO - 1]];
        imageView0.center = originalCenterForView0;
        imageView0.backgroundColor = [UIColor greenColor];
        [self addSubview:imageView0];
        
        isView0ON = YES;
    } else {
        isView0ON = NO;
    }

}

- (void)generateNextActivity
{
    if (currentActivityNO + 1 < dataForActivities.count)
    {
        imageView2 = [[ActivityViewContainer alloc] initWithFrame:frameOfMainView andActivityData:dataForActivities[currentActivityNO + 1]];
        imageView2.center = originalCenterForView2;
        imageView2.backgroundColor = [UIColor greenColor];
        [self addSubview:imageView2];
        
        isView2ON = YES;
    } else {
        isView2ON = NO;
    }

}



- (void)viewDisappearToLeft
{
    if (currentActivityNO < dataForActivities.count - 1)
    {
        currentActivityNO += 1;
        [self bringSubviewToFront: imageView2];
        [UIView animateWithDuration:0.3 animations:^{
            imageView1.center = CGPointMake(-originalCenterForView1.x, originalCenterForView1.y);
            imageView2.center = originalCenterForView1;
        } completion:^(BOOL finished) {
            [imageView1 removeFromSuperview];
            imageView1 = imageView2;
            imageView1.delegate = self;


            [self generateNextActivity];
            [self generatePreviousActivity];
            
            NSLog(@"Swiped to left - %d",currentActivityNO);
            [self bringSubviewToFront:imageView1];
        }];
    } else {
        [self loadFeedBackView];
    }
}

//- (void)viewDisappearToRight
//{
//    currentActivityNO -= 1;
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView1.center = CGPointMake(originalCenterForView1.x * 3, originalCenterForView1.y);
//        imageView0.center = originalCenterForView1;
//    } completion:^(BOOL finished) {
//        [imageView1 removeFromSuperview];
//        imageView1 = imageView0;
//        imageView1.delegate = self;
//
//
//        [self generatePreviousActivity];
//        [self generateNextActivity];
//        NSLog(@"Swiped to right - %d",currentActivityNO);
//        [self bringSubviewToFront:imageView1];
//    }];
//    
//}
//

- (void) viewIsMoving:(double)distance
{
    if (distance >= 0)
    {
        if (isView0ON)
        {
            [self bringSubviewToFront:imageView1];
            double distanceForView0 = 7 * distance / 10;
            imageView0.center = CGPointMake(originalCenterForView0.x + distanceForView0, originalCenterForView0.y);
        } else {
            imageView1.center = originalCenterForView1;
            NSLog(@"It's the first activity, swiping failed!!");
        }
        
    } else
    {
        if (isView2ON)
        {
            [self bringSubviewToFront:imageView2];
            double distanceForView2 = 13 * distance / 10;
            imageView2.center = CGPointMake(originalCenterForView2.x + distanceForView2, originalCenterForView2.y);
        } else {
            imageView1.center = originalCenterForView1;
            NSLog(@"It's the last activity, swiping failed!!");
        }
    }

}

//- (void)movingCancelled
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView0.center = originalCenterForView0;
//        imageView2.center = originalCenterForView2;
//        imageView1.center = originalCenterForView1;
//    } completion:^(BOOL finished) {
//        [self bringSubviewToFront:imageView1];
//    }];
//
//}


- (void)activityViewWillClose{
    
    CGRect frame = self.frame;
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(frame.size.width / 2, frame.size.height * 3 / 2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}

- (void)moveToNextActivityWithCurrectOne:(BOOL)passedOrNot
{
    NSString *key = [NSString stringWithFormat:@"%d",currentActivityNO];
    NSString *value = [NSString stringWithFormat:@"%d",passedOrNot];
    [userProgress setValue:value forKey:key];
    
    [self viewDisappearToLeft];
}


- (void)loadFeedBackView
{
    
}

@end
