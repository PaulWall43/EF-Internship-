//
//  LessonMenuView.m
//  activitiesForTether
//
//  Created by kenneth on 7/6/15.
//  Copyright (c) 2015 kenneth. All rights reserved.
//

#import "LessonMenuView.h"
#import "LessonData.h"
#import "LessonView.h"

#define PathToFireBase @"https://tetheref.firebaseio.com/username"

@interface LessonMenuView () {
    
    UIButton *btnForLesson;
    UIButton *btnForGames;
    UIButton *btnForOutLine;
    CGRect frameOfLessonMenuView;
    
}

@end

@implementation LessonMenuView


- (id)initWithFrame: (CGRect)frame andData: (NSDictionary *)dictForData
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor grayColor];
        frameOfLessonMenuView = [UIScreen mainScreen].bounds;
        self.frame = frame;

        UILabel *thisIsClassroom = [[UILabel alloc] init];
        thisIsClassroom.textColor = [UIColor redColor];
        thisIsClassroom.text = @"This is Classroom";
        thisIsClassroom.textAlignment = NSTextAlignmentCenter;
        thisIsClassroom.frame = CGRectMake(0, 0, frame.size.width, 100);
        thisIsClassroom.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:thisIsClassroom];
        
        btnForLesson = [[UIButton alloc] init];
        [btnForLesson setTitle:@"Lesson" forState:UIControlStateNormal];
        btnForGames = [[UIButton alloc] init];
        [btnForGames setTitle:@"Game" forState:UIControlStateNormal];
        btnForOutLine = [[UIButton alloc] init];
        [btnForOutLine setTitle:@"OutLine" forState:UIControlStateNormal];
        
        NSArray *buttons = @[btnForLesson,btnForGames,btnForOutLine];
        NSInteger num = buttons.count;
        double widthForBtn = (frame.size.width ) / num ;
        double heigthForBtn = frame.size.height / 12;
        CGRect frameOfButton = CGRectMake(0, 0, widthForBtn, heigthForBtn);
        int n = 0;
        for (UIButton *btn in buttons)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.bounds = frameOfButton;
            btn.backgroundColor = [UIColor whiteColor];
            double xValue = n * widthForBtn + widthForBtn / 2;
            double yValue = frame.size.height - heigthForBtn / 2;
            btn.center = CGPointMake(xValue, yValue);
            [self addSubview:btn];
            [btn addTarget:self action:@selector(loadView:) forControlEvents:UIControlEventTouchUpInside];
            n ++;
        }
        
        
        //Add close button
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.backgroundColor = [UIColor clearColor];
        [closeButton setTitle:@"X" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //        closeButton.imageView.image = [UIImage imageNamed:@"MPCloseBtn.png"];
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        closeButton.center = CGPointMake(30, 30);
        [self addSubview:closeButton];
        [closeButton addTarget:self action:@selector(closeClassroom) forControlEvents:UIControlEventTouchUpInside];
        [self loadLessonView];
    }
    
    return self;
}

- (void) closeClassroom{
    [UIView animateWithDuration:0.5f animations:^{
        self.center = CGPointMake(self.center.x, self.center.y * 3);
        self.alpha = 0.5;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)loadView:(UIButton *)sender
{
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"Lesson"]) {
        
        [self loadLessonView];
        
    }
    else if ([title isEqualToString:@"Game"]) {
        
    } else {
        
    }
    
}

- (void) loadLessonView
{
    LessonData *actData = [[LessonData alloc] init];
    id dict = [actData getActivityDataFromActivityLevel:1 andActivityNO:1];
    if ([dict isKindOfClass:[NSArray class]])
    {
        LessonView *lesson = [[LessonView alloc] initWithData:dict];
        lesson.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
        [lesson loadTwoActivityView];
        [self addSubview:lesson];
        lesson.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,3 * [UIScreen mainScreen].bounds.size.height / 2);
        [UIView animateWithDuration:0.5 animations:^{
            lesson.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,[UIScreen mainScreen].bounds.size.height / 2 + 10);
        } completion:^(BOOL finished) {
            NSLog(@"Loaded activity view");
        }];
        
        
        
    }
}



@end
