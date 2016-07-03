//
//  RootViewController.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 7/1/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit
import CoreLocation

class RootViewController: UIViewController {

    var eventModelArray : NSMutableArray = [] //just keeping for now
    let beaconFinder : BeaconFinder = BeaconFinder.SharedInstance
    let dataManager : DataManager = DataManager.SharedInstance
    @IBOutlet weak var eventsHappeningNowButton: UIButton!
    @IBOutlet weak var timeUntilNextClass: UILabel!
    var timer : NSTimer = NSTimer()
    var nextClassDate : NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCountDownClock()
        eventsHappeningNowButton.addTarget(self, action: "goToClassroom", forControlEvents: UIControlEvents.TouchUpInside)
    }
    

    
    func setUpCountDownClock(){
        /*Make sure that class is not happening now*/
        if(dataManager.isClassHappeningNow()){
            timeUntilNextClass.text = "Class in session!"
            timer = NSTimer.scheduledTimerWithTimeInterval(5.0 , target: self, selector: "isClassOver:", userInfo: nil, repeats: true)
            return
        }
        /*Ask the dataManager for the string that gives the time of next class.*/
        var nextDate : String = dataManager.getStringTimeOfNextClass()
        var format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = "MM/dd/yyyy HH:mm:ss"
        nextClassDate  = format.dateFromString(nextDate)!
        var numberOfSecondsUntilNextClass : NSTimeInterval  = nextClassDate.timeIntervalSinceNow
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5 , target: self, selector: "updateClock:", userInfo: nil, repeats: true)
    }
    
    func updateClock( theTimer: NSTimer){
        var now : NSDate = NSDate()
        if(nextClassDate.earlierDate(now) == nextClassDate){
            timer.invalidate()
        } else {
            var currCalendar : NSCalendar = NSCalendar.currentCalendar();
            var flags : NSCalendarUnit = .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit
            var componentsOfNextDate = currCalendar.components(flags, fromDate: now, toDate: nextClassDate, options: nil)
            //println("\(componentsOfNextDate.hour):\(componentsOfNextDate.minute):\(componentsOfNextDate.second)")
            timeUntilNextClass.text = String(format: "%02u:%02u:%02u", componentsOfNextDate.hour, componentsOfNextDate.minute, componentsOfNextDate.second)
        }
    }
    
    
    
    func isClassOver(theTimer: NSTimer){
        if(dataManager.isClassOver()){
            timer.invalidate()
            setUpCountDownClock()
        }
    }
    
    
    func goToClassroom(){
        
        //classroomView is using a fake data, the 'nil' below should be changed to real data in the future
        var classroomView : LessonMenuView = LessonMenuView(frame:UIScreen.mainScreen().bounds,andData : nil)
        self.view.addSubview(classroomView)
        var realPoint : CGPoint = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        classroomView.center = CGPointMake(realPoint.x, realPoint.y * 3)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            classroomView.center = realPoint
            }, completion: nil)
        
        
    }
}
