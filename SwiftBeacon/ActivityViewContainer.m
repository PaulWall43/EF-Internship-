//
//  MainView.m
//  SF-Gesture
//
//  Created by kenneth on 6/24/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import "ActivityViewContainer.h"
#import "YesOrNOActivity.h"

@interface ActivityViewContainer (){
    
    UILabel *label;
    CGPoint centerOfScreen;
    CGPoint pointA;
    CGPoint originCenterOfMainView;
    BOOL recorded;
    UIPanGestureRecognizer *panGesture;
    
    
    
}

@end

@implementation ActivityViewContainer


- (id)initWithFrame:(CGRect)frame andActivityData:(NSDictionary *)activityData
{
    if (self = [super init])
    {
        originCenterOfMainView = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        recorded = NO;
        self.frame = frame;
        UIView *backGroundView = [[UIView alloc] initWithFrame:frame];
        backGroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:backGroundView];

        //loadActivity
        Class activityType = NSClassFromString(activityData[@"activityType"]);

        YesOrNOActivity *activity = [[activityType alloc] init];
        [activity loadActivityViewWithData:activityData];
        activity.center = originCenterOfMainView;
        [self addSubview:activity];
        activity.delegate = self;
        
        
        centerOfScreen = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 10);
        
        //Add close button
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.backgroundColor = [UIColor clearColor];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        closeButton.imageView.image = [UIImage imageNamed:@"MPCloseBtn.png"];
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        closeButton.center = CGPointMake(30, 30);
        [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeButton];
        
        
    }
    
    
    return  self;
}



- (void)closeView
{
    if ([_delegate respondsToSelector:@selector(activityViewWillClose)])
    {
        [_delegate activityViewWillClose];
    }
    
}

- (void) willMoveToNextActivityWithAnswered:(BOOL) CorrectlyOrNot
{
    [_delegate moveToNextActivityWithCurrectOne:CorrectlyOrNot];
}

@end
