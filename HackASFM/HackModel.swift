//
//  HackModel.swift
//  HackASFM
//
//  Created by Rodrigo Chousal on 3/7/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation

class Event {
    var time: String
    var name: String
    var description: String
    
    init(time: String, name: String, desc: String) {
        self.time = time
        self.name = name
        self.description = desc
    }
}

class Schedule {
    var eventList: [Event]
    
    init() {
        self.eventList = [Event]()
    }
}
