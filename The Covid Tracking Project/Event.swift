//
//  Event.swift
//  The Covid Tracking Project
//
//  Created by Scarlett Tao on 8/20/20.
//  Copyright © 2020 Scarlett Tao. All rights reserved.
//

import Foundation

class Event {
    let title: String
    var time: Date
    init(title: String, time: Date) {
        self.title = title
        self.time = time
    }
}

