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
    }
    
    // MARK: Initialization
    init?(date: Date, mileage: Double, duration: Int, locations: [Dictionary<String, Double>]) {
        
        // Initialization should fail if there is are no locations saved
//        if locations.isEmpty {
//            return nil
//        }
        
        self.date = date
        self.mileage = mileage
        self.duration = duration
        self.locations = locations
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(mileage, forKey: PropertyKey.mileage)
        aCoder.encode(duration, forKey: PropertyKey.duration)
        aCoder.encode(locations, forKey: PropertyKey.locations)
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
        
        let duration = aDecoder.decodeInteger(forKey: PropertyKey.duration)
        let mileage = aDecoder.decodeDouble(forKey: PropertyKey.mileage)
        
        self.init(date: date, mileage: mileage, duration: duration, locations: locations)
    }
    
    // MARK: Run methods
    // TODO: round mileage to two decimal places before calculations?
    func pace() -> Double { // in min/mile
        print("duration: \(Double(duration))")
        
        print("\(60 * mileage)")
        return Double(duration) / (60 * mileage)
    }
    
    static func paceToString(pace: Double) -> String {
        print("pace: \(pace)")
        print("remainder: \(pace.truncatingRemainder(dividingBy: 1))")
        let remainderInSeconds = pace.truncatingRemainder(dividingBy: 1) * 60
        print("remainderInsecs: \(remainderInSeconds)")
//        return "\(Int(pace))'\(Int(remainderInSeconds))\""
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
            return Dictionary()
        }
    }
    
}

//var coordinate = ["lat": 2.2, "long": 2.4]
//locations.append(coordinate)
