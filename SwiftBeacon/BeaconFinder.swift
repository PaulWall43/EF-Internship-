//
//  BeaconFinder.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 7/3/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit
import CoreLocation

//Class responsible for finding the beacons
class BeaconFinder: NSObject, CLLocationManagerDelegate {
    
        class var SharedInstance : BeaconFinder {
            struct Singleton {
                static let instance = BeaconFinder()
            }
            return Singleton.instance
        }
    
   var myBeaconRegion : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "4568D9B6-F3F8-4E99-9AB6-350D92825A2E"), identifier:"com.ef.myRegion")
    var locationManager : CLLocationManager = CLLocationManager()
    var alreadyInRegion : Int = 0
    let dataManager : DataManager = DataManager.SharedInstance
    var currentRegion : String?
    
    private override init(){
        super.init()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringForRegion(myBeaconRegion)
        locationManager.startRangingBeaconsInRegion(myBeaconRegion)
        //locationManager(locationManager, didStartMonitoringForRegion: myBeaconRegion)
        requestNotificationAuth()
    }
    
    func requestNotificationAuth(){
        var types = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        var mySettings = UIUserNotificationSettings(forTypes: types, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(myBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(myBeaconRegion)
        notifyUser(description:"See ya later!")
        alreadyInRegion = 0;
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        var closestBeacon :CLBeacon = CLBeacon()
        if(beacons.count < 1){
            return
        }
        closestBeacon = beacons[0] as! CLBeacon
        
        //check for different region

        if(alreadyInRegion == 0){
            notifyUser(description: "Welcome to your zone")
            alreadyInRegion++;
            dataManager.getCurrentEventModel(closestBeacon.proximityUUID.UUIDString as String, didGetBeaconMajor: NSString(string: "\(closestBeacon.major)") as String, didGetBeaconMinor: NSString(string: "\(closestBeacon.minor)") as String)
            currentRegion = NSString(string: "\(closestBeacon.major)\(closestBeacon.minor)") as String
            return
        }
        
        if(currentRegion != NSString(string: "\(closestBeacon.major)\(closestBeacon.minor)")){
            notifyUser(description: "Weclome to your zone")
            currentRegion = NSString(string: "\(closestBeacon.major)\(closestBeacon.minor)") as String
            dataManager.getCurrentEventModel(closestBeacon.proximityUUID.UUIDString as String, didGetBeaconMajor: NSString(string: "\(closestBeacon.major)") as String, didGetBeaconMinor: NSString(string: "\(closestBeacon.minor)") as String)
        }
    }
    
    func notifyUser(description aDescription: String){
        var currentSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        UIApplication.sharedApplication().registerUserNotificationSettings(currentSettings)
        var notification = UILocalNotification()
        notification.alertBody = aDescription
        notification.alertAction = "Notifications are working"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}
