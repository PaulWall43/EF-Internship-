//
//  ClassDateModel.swift
//  SwiftBeacon
//
//  Created by Paul Wallace on 7/7/15.
//  Copyright (c) 2015 Paul Wallace. All rights reserved.
//

import UIKit

class ClassDateModel: NSObject {
    var onDaysArray : NSString!
    var atTime : String!
    
    init(daysActive:String , atTimeOnDay : String){
        onDaysArray = daysActive
        atTime = atTimeOnDay
    }
}
