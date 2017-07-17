//
//  Stopwatch.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/15/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import Foundation

class Stopwatch {
    var time : Int16 = 0 // in seconds
    
    func incrementTime() {
        time += 1
    }
    
    func convertTimeToString() -> String {
        var minutes = time / 60
        let seconds = time - (minutes * 60)
        
        if time < 3600 { // time < 1 hour
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            let hours = minutes / 60
            minutes -= hours * 60
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    func reset() {
        time = 0
    }
}
