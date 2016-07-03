//
//  YesOrNOActivity.h
//  activitiesForTether
//
//  Created by kenneth on 7/1/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewContainer.h"

@protocol YesOrNOActivityDelegate <NSObject>

- (void) willMoveToNextActivityWithAnswered:(BOOL) CorrectlyOrNot;

@end

@interface YesOrNOActivity : UIView

//@property (weak,nonatomic) NSDictionary *data;

@property (assign,nonatomic) id<YesOrNOActivityDelegate> delegate;
- (void) loadActivityViewWithData: (NSDictionary *)data;
@end
