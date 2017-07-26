//
//  Run.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/16/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import Foundation
//: NSObject, NSCoding
// to save a run must have 1 location saved! (or change load map)

class Run: NSObject, NSCoding {
    
    // MARK: Properties
    var date : Date
    var mileage : Double
    var duration : Int
    var locations : [[String:Double]] = []
    var splitTimes : [Int]
//    var splits : [Double] //or method
// max long and lat
    //var coordinate = ["lat": 2.2, "long": 2.4]
    //locations.append(coordinate)
// method for pace? or store?
    
    // MARK: Types
    struct PropertyKey {
        static let mileage = "mileage"
        static let date = "date"
        static let duration = "duration"
        static let locations = "locations"
        static let splits = "splits"
    }
    
    // MARK: Initialization
    init?(date: Date, mileage: Double, duration: Int, locations: [Dictionary<String, Double>], splitTimes: [Int]) {
        
        // Initialization should fail if there is are no locations saved
//        if locations.isEmpty {
//            return nil
//        }
        
        self.date = date
        self.mileage = mileage
        self.duration = duration
        self.locations = locations
        self.splitTimes = splitTimes
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(mileage, forKey: PropertyKey.mileage)
        aCoder.encode(duration, forKey: PropertyKey.duration)
        aCoder.encode(locations, forKey: PropertyKey.locations)
        aCoder.encode(splitTimes, forKey: PropertyKey.splits)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            print("Unable to decode date for run")
            return nil
        }
        
//        let date = NSDate()
        
        guard let locations = aDecoder.decodeObject(forKey: PropertyKey.locations) as? [[String:Double]] else {
            print("Unable to decode locations for run")
            return nil
        }
        
        guard let splits = aDecoder.decodeObject(forKey: PropertyKey.splits) as? [Int] else {
            print("Unable to decode splits for run")
            return nil
        }
        
        let duration = aDecoder.decodeInteger(forKey: PropertyKey.duration)
        let mileage = aDecoder.decodeDouble(forKey: PropertyKey.mileage)
        
        self.init(date: date, mileage: mileage, duration: duration, locations: locations, splitTimes: splits)
    }
    
    func avgPace() -> Double {
        return Run.pace(mileage: mileage, duration: duration)
    }
    
    // MARK: Run methods
    // TODO: round mileage to two decimal places before calculations?
    static func pace(mileage: Double, duration: Int) -> Double { // in min/mile
//        print("duration: \(Double(duration))")
//        
//        print("\(60 * mileage)")
        return Double(duration) / (60 * mileage)
    }
    
    static func paceToString(pace: Double) -> String {
        if pace.isNaN || pace.isInfinite {
            return "0\'00\""
        }

        let remainderInSeconds = pace.truncatingRemainder(dividingBy: 1) * 60
        return String(format: "%d'%02d\"", Int(pace), Int(remainderInSeconds))
    }
    
    func calculateMaxMinOfCoordinates() -> [String : Double] {
        if var maxLat = locations.first?["lat"], var minLat = locations.first?["lat"], var maxLong = locations.first?["long"], var minLong = locations.first?["long"] {
            for location in locations {
                if location["lat"]! > maxLat {
                    maxLat = location["lat"]!
                } else if location["lat"]! < minLat {
                    minLat = location["lat"]!
                } else if location["long"]! > maxLong {
                    maxLong = location["long"]!
                } else if location["long"]! < minLong {
                    minLong = location["long"]!
                }
            }
            return ["minLat" : minLat, "maxLat" : maxLat, "minLong" : minLong, "maxLong" : maxLong]
        } else {
            return ["minLat" : 0, "maxLat" : 0, "minLong" : 0, "maxLong" : 0]
        }
    }
    
    func splits() -> [Double] {
//        var splits = splitTimes
        var mileNum = 0.0
        var splits = splitTimes.map { splitTime -> Double in
            mileNum += 1.0
            return Run.pace(mileage: mileNum, duration: splitTime)
        }
        
        let mileageRemainder = mileage.truncatingRemainder(dividingBy: 1)
        var timeRemainder = duration // case of no splits
        
        if splitTimes.count > 0 { // case theres splits
            timeRemainder = duration - splitTimes.last!
        }
        let lastSplit = Run.pace(mileage: mileageRemainder, duration: timeRemainder)
        splits.append(lastSplit)
        
        return splits
    }
    
    func splitsToString() -> [String] {
        let splits = self.splits()
        return splits.map { split -> String in
            return Run.paceToString(pace: split)
        }
    }
    
}

//var coordinate = ["lat": 2.2, "long": 2.4]
//locations.append(coordinate)
