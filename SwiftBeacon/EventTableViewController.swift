//
//  EventTableViewController.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 6/30/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    class var SharedInstance : EventTableViewController {
        struct Singleton {
            static let instance = EventTableViewController()
        }
        return Singleton.instance
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var color : UIColor?
    var eventItems : NSMutableArray = []
    var informationSource : DataManager = DataManager.SharedInstance
    var personalCurrentEventModel : EventModel?
    var timer = NSTimer()
    //let rootViewController : RootViewController = RootViewController()
    
    func loadinitialData(){
    }
    override func viewDidLoad() {
        self.loadinitialData()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "reviewInformationSource", userInfo: nil, repeats: true)
        /*if(eventModel is the flag set)*/
        //println(informationSource.contentArray)
//        if(informationSource.contentArray.count > 0){
//            //populate the tableView with the first names of the people in the JSON file
//            eventItems.addObjectsFromArray(informationSource.contentArray)
//        }
    }
    func getControllerArrayContents(sourceArray source: NSMutableArray){
        //eventItems.addObjectsFromArray(informationSource.contentArray
        //eventItems = informationSource.contentArray
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*If the flag is set*/
        //println(self.informationSource.currentEventModel.eventTopicsArray.count)
        if(self.informationSource.currentEventModel.eventTopicsArray.count < 1){
            self.navigationBar.title = "No current events :("
        }
        return self.informationSource.currentEventModel.eventTopicsArray.count
        //return self.eventItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let CellIdentifier: NSString = "ToDoPrototypeCell"
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier as String) as! UITableViewCell
        //var eventModel: EventModel  = self.eventItems.objectAtIndex(indexPath.row) as EventModel
        //cell.textLabel?.text = eventModel.title; ---> will change this to set the nav title bar
        //cell.textLabel?.text = self.eventItems.objectAtIndex(indexPath.row) as? String
        /*Loop through the array of eventModelTopics in eventModel and store them in the tableView*/
//        for eventTopicModel : EventTopicModel in eventModel.eventTopicsArray{
//            even
//        }
       // cell.textLabel?.text = eventModel.eventTopicsArray?.objectAtIndex()
//        if eventModel.completed{
//            cell.accessoryType = .Checkmark
//        }
//        else {
//            cell.accessoryType = .None
//        }
        
        /* Given the flag is set */
        cell.textLabel?.text = informationSource.currentEventModel.eventTopicsArray.objectAtIndex(indexPath.row) as? String
        /* Set the title bar */
        self.navigationBar.title = informationSource.currentEventModel.title
        return cell
    }
    func reviewInformationSource(){
        if(informationSource.currentEventModel.title != self.navigationBar.title){
            tableView.reloadData()
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
//        var tappedItem: EventModel = self.eventItems.objectAtIndex(indexPath.row) as EventModel
//        tappedItem.completed = !tappedItem.completed
//        tableView.reloadData()
    }
}
