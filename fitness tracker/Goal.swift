//
//  Goal.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/24/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import Foundation

class Goal: NSObject, NSCoding {
    
    // MARK: Properties
    var startDate : Date
    var endDate : Date
    var mileGoal : Int
    var practiceGoal : Int
    
    // MARK: Types
    struct PropertyKey {
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let mileGoal = "milesGoal"
        static let practiceGoal = "practiceGoal"
    }
    
    // MARK: Initialization
    init?(startDate: Date, endDate: Date, mileGoal: Int, practiceGoal: Int) {
        
        // Initialization should fail if end date is not a future date
        if endDate > Date() || Calendar.current.isDateInToday(endDate) {
            self.startDate = startDate
            self.endDate = endDate
            self.practiceGoal = practiceGoal
            self.mileGoal = mileGoal
        } else {
             return nil
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(startDate, forKey: PropertyKey.startDate)
        aCoder.encode(endDate, forKey: PropertyKey.endDate)
        aCoder.encode(mileGoal, forKey: PropertyKey.mileGoal)
        aCoder.encode(practiceGoal, forKey: PropertyKey.practiceGoal)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let endDate = aDecoder.decodeObject(forKey: PropertyKey.endDate) as? Date, let startDate = aDecoder.decodeObject(forKey: PropertyKey.startDate) as? Date
        else {
            print("Unable to decode date for goal")
            return nil
        }
        
        let mileGoal = aDecoder.decodeInteger(forKey: PropertyKey.mileGoal)
        let practiceGoal = aDecoder.decodeInteger(forKey: PropertyKey.practiceGoal)
        
        self.init(startDate: startDate, endDate: endDate, mileGoal: mileGoal, practiceGoal: practiceGoal)
    }

    // Calculate the number of days left to complete goal, with the end date as the last day
    func daysLeft() -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: currentDate, to: finishDate)
        return components.day! + 1
    }
    

}
