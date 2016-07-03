//
//  ViewController.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 6/30/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit
import CoreLocation

class DebugViewController: UIViewController, CLLocationManagerDelegate {
    var myBeaconRegion : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "4568D9B6-F3F8-4E99-9AB6-350D92825A2E"), identifier:"com.ef.myRegion")
    var locationManager : CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var inRegionLabel: UILabel!
    @IBOutlet weak var UUIDLabel: UILabel!
    @IBOutlet weak var MajorLabel: UILabel!
    @IBOutlet weak var MinorLabel: UILabel!
    @IBOutlet weak var AccuracyLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var RSSILabel: UILabel!
    
    var alreadyInRegion = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) { locationManager.requestAlwaysAuthorization() }
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringForRegion(myBeaconRegion)
        locationManager.startRangingBeaconsInRegion(myBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(myBeaconRegion)
        println("Hey")
        //notify the user
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(myBeaconRegion)
        inRegionLabel.text = "Not in region"
        inRegionLabel.backgroundColor = UIColor(white: 0.5, alpha: 1)
        println("DID EXIT REGION WAS CALLED IN DEBUG")
    }
    
    //At one point in time didStartMonitoring from region was called here
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if(alreadyInRegion == 0){/*notify the user*/ alreadyInRegion++}
        var beacon :CLBeacon = CLBeacon()
        if(beacons.count < 1){
            statusLabel.text = "Disconnected"
            statusLabel.backgroundColor = UIColor(white: 0.5, alpha: 1)
            UUIDLabel.text = "null"
            MajorLabel.text = "null"
            MinorLabel.text = "null"
            AccuracyLabel.text = "-1"
            RSSILabel.text = "0"
            return
        }
        beacon = beacons[0] as! CLBeacon
        statusLabel.text = "Connected"
        statusLabel.backgroundColor = UIColor(hue: 0.39, saturation: 1.0, brightness: 0.61, alpha: 1)
        inRegionLabel.text = "In region"
        inRegionLabel.backgroundColor = UIColor(hue: 0.39, saturation: 1.0, brightness: 0.61, alpha: 1)
        UUIDLabel.text = beacon.proximityUUID.UUIDString
        MajorLabel.text = NSString(string: "\(beacon.major)" as String) as String
        MinorLabel.text = NSString(string: "\(beacon.minor)") as String
        
        AccuracyLabel.text = NSString(string:  "\(beacon.accuracy)") as String
        RSSILabel.text = NSString(string: "\(beacon.rssi)") as String
        //Assign the distanceLabel
        if(beacon.proximity == CLProximity.Unknown){
            DistanceLabel.text = "Unknown proximity"
        }
        if(beacon.proximity == CLProximity.Far){
            DistanceLabel.text = "Far"
        }
        if(beacon.proximity == CLProximity.Near){
            DistanceLabel.text = "Near"
        }
        if(beacon.proximity == CLProximity.Immediate){
            DistanceLabel.text = "Immediate"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

