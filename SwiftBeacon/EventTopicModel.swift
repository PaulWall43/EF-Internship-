//
//  EventTopicModel.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 7/3/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit

class EventTopicModel: NSObject {
    var eventTopicTitle : String!
    //var eventSubTopicArray : NSMutableArray?
    
    init(topicTitle:String){
        super.init()
        eventTopicTitle = topicTitle
    }
}
