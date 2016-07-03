//
//  MainView.h
//  SF-Gesture
//
//  Created by kenneth on 6/24/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YesOrNOActivity.h"

@protocol ActivityViewContainerDelegate <NSObject>

- (void) viewDisappearToLeft;
- (void) viewDisappearToRight;
- (void) viewIsMoving:(double)distance;
- (void) movingCancelled;
- (void) activityViewWillClose;
- (void) moveToNextActivityWithCurrectOne:(BOOL) passedOrNot;

@end


@interface ActivityViewContainer : UIView 

@property (nonatomic,assign) id<ActivityViewContainerDelegate> delegate;


- (id)initWithFrame:(CGRect)frame andActivityData:(NSDictionary *)activityData;
@end
