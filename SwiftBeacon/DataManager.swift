//
//  DataManager.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 7/6/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    class var SharedInstance : DataManager{
        struct Singleton {
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    
    internal var contentArray : NSMutableArray = []
    internal var currentEventModel : EventModel = EventModel(title: "holder")
    //let eventTableViewController : EventTableViewController = EventTableViewController.SharedInstance
    
    func getCurrentEventModel(beaconUUID: String, didGetBeaconMajor beaconMajor: String, didGetBeaconMinor beaconMinor: String){
        //create a file path to the json file
        var jsonFilePath : String = NSBundle.mainBundle().pathForResource("testData", ofType: "json")!
        //Create a data object from this file path
        var jsonData : NSData = NSData(contentsOfFile: jsonFilePath)!
        var json = JSON(data: jsonData)
        if let eventArray = json["events"].array {
            /*Loop through the array and find the correct event based on Beacon information*/
            var eventNumber: Int = 0
            for(eventNumber; eventNumber < eventArray.count; eventNumber++){
                if(eventArray[eventNumber]["beaconUUID"].string == beaconUUID as String &&
                    eventArray[eventNumber]["beaconMinor"].string == beaconMinor){
                        break;
                }
            }
            if(eventNumber == eventArray.count){
                println("Event not here")
                return
            }
            /*Now we have found it lets store the contents into a EventModel*/
            currentEventModel = EventModel(title: eventArray[eventNumber]["title"].string!)
            currentEventModel.descriptionOfEvent = eventArray[eventNumber]["descriptionOfEvent"].string!
            currentEventModel.dateOfEvent = eventArray[eventNumber]["dateOfEvent"].string!
            //set the rest of the fields later when we need them
            /*Loop through to put the eventTopics into the eventTopicsArray*/
            if let eventTopicArray = json["events"][eventNumber]["eventTopicsArray"].array{
                //println(eventTopicArray.count)
                for(var i = 0; i < eventTopicArray.count; i++){
                    println(eventTopicArray[i]["eventTopicTitle"].string!)
                    currentEventModel.eventTopicsArray.addObject(eventTopicArray[i]["eventTopicTitle"].string!)
                }
            }
            //eventTableViewController.reloadData()
        }
    }
    
    func isClassOver() -> Bool{
        var jsonFilePath : String = NSBundle.mainBundle().pathForResource("testData", ofType: "json")!
        var jsonData : NSData = NSData(contentsOfFile: jsonFilePath)!
        var json = JSON(data: jsonData)
        var format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = "MM/dd/yyyy HH:mm:ss"
        var timeOfEvent = json["events"][0]["timeOfEvent"].string!
        var durationOfClass  = json["events"][0]["durationOfEvent"].string!
        var durationOfClassInMinutes : Int = durationOfClass.toInt()!
        var currentCalendar : NSCalendar = NSCalendar.currentCalendar()
        var currentDate : NSDate = NSDate()
        var dayOfTheMonth = currentCalendar.component(.DayCalendarUnit, fromDate: currentDate)
        var monthOfTheYear = currentCalendar.component(.MonthCalendarUnit, fromDate: currentDate)
        var year = currentCalendar.component(.YearCalendarUnit, fromDate: currentDate)
        var stringOfPossibleCurrentClass = String(format: "%02u/%02u/%02u \(timeOfEvent)", monthOfTheYear, dayOfTheMonth, year)
        var possibleCurrentClassDate : NSDate = format.dateFromString(stringOfPossibleCurrentClass)!
        var flags : NSCalendarUnit = .HourCalendarUnit | .MinuteCalendarUnit
        var componentsOfPossibleCurrentClass = currentCalendar.components(flags, fromDate: possibleCurrentClassDate, toDate: currentDate, options: nil)
        if(durationOfClassInMinutes < componentsOfPossibleCurrentClass.minute ){
            println("Class is over")
            return true
        }
        println("Class still is session")
        return false
    }
    
    func isClassHappeningNow() -> Bool{
        var jsonFilePath : String = NSBundle.mainBundle().pathForResource("testData", ofType: "json")!
        var jsonData : NSData = NSData(contentsOfFile: jsonFilePath)!
        var json = JSON(data: jsonData)
        var dayOfWeek : Int = NSCalendar.currentCalendar().component(.WeekdayCalendarUnit, fromDate: NSDate())
        if(json["events"][0]["dateOfEvent"][ dayOfWeek - 1].string == "NO"){
            return false
        }
        var durationOfClass  = json["events"][0]["durationOfEvent"].string!
        var durationOfClassInMinutes : Int = durationOfClass.toInt()!
        var format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = "MM/dd/yyyy HH:mm:ss"
        /*For now just the first event*/ //Did not just use the minutes because it would require another field in the database and for now I would want to keep the datbase as simple as possible
        if let event = json["events"][0] as JSON? {
            //just check today
            var currentCalendar : NSCalendar = NSCalendar.currentCalendar()
            var currentDate : NSDate = NSDate()
            var dayOfTheMonth = currentCalendar.component(.DayCalendarUnit, fromDate: currentDate)
            var monthOfTheYear = currentCalendar.component(.MonthCalendarUnit, fromDate: currentDate)
            var year = currentCalendar.component(.YearCalendarUnit, fromDate: currentDate)
            var timeOfEvent = json["events"][0]["timeOfEvent"].string!
            var stringOfPossibleCurrentClass = String(format: "%02u/%02u/%02u \(timeOfEvent)", monthOfTheYear, dayOfTheMonth, year)
            //Construct a date from this string
            var possibleCurrentClassDate : NSDate = format.dateFromString(stringOfPossibleCurrentClass)!
            if(possibleCurrentClassDate.earlierDate(currentDate) != currentDate){
                var flags : NSCalendarUnit = .HourCalendarUnit | .MinuteCalendarUnit
                var componentsOfPossibleCurrentClass = currentCalendar.components(flags, fromDate: possibleCurrentClassDate, toDate: currentDate, options: nil)
                if(componentsOfPossibleCurrentClass.minute <= durationOfClassInMinutes){
                    return true
                }
            }
        }
        return false
    }

    func getStringTimeOfNextClass() -> String{
        /*First get the current date so we know where to look*/
        var currentDate : NSDate = NSDate()
        var currentCalendar : NSCalendar = NSCalendar.currentCalendar()
        var dayOfWeek : Int = currentCalendar.component(.WeekdayCalendarUnit, fromDate: currentDate)
        /*Now access the JSON file at where the current day is*/
        var jsonFilePath : String = NSBundle.mainBundle().pathForResource("testData", ofType: "json")!
        var jsonData : NSData = NSData(contentsOfFile: jsonFilePath)!
        var json = JSON(data: jsonData)
        
        /*Will later loop through the json file to find the correct event*/
        /*Check the array at todays date*/
        if let event = json["events"][0] as JSON? {
            //create a dateFormatter for the loop 
            var format : NSDateFormatter = NSDateFormatter()
            format.dateFormat = "MM/dd/yyyy HH:mm:ss"
            //get the time
            var timeOfEvent : String = event["timeOfEvent"].string!
            //Loop through the datesOfEvent array in order to get the dates
            var maxLoop : Int = 14 + dayOfWeek
            var counter : Int = 0
            for(var i = dayOfWeek; i < maxLoop; i++){
                if(event["dateOfEvent"][i - 1].string == "NO"){
                    counter++
                    continue;
                } else {
                    //create a date from this date and check it to now
                    var dayOfTheMonth = currentCalendar.component(.DayCalendarUnit, fromDate: currentDate)
                    var monthOfTheYear = currentCalendar.component(.MonthCalendarUnit, fromDate: currentDate)
                    var year = currentCalendar.component(.YearCalendarUnit, fromDate: currentDate)
                    //increment day of the month by the counter
                    dayOfTheMonth += counter
                    //construct a string with this information
                    var stringOfNextPossibleClass = String(format: "%02u/%02u/%02u \(timeOfEvent)", monthOfTheYear, dayOfTheMonth, year)
                    //Construct a date from this string
                    var nextPossibleClassDate : NSDate = format.dateFromString(stringOfNextPossibleClass)!
                    //compare now and this time
                    if(currentDate.earlierDate(nextPossibleClassDate) != nextPossibleClassDate){
                        println("Found it")
                        return stringOfNextPossibleClass
                    }
                    counter++
                }
            }
            
        }
        return "Error"
    }
}
