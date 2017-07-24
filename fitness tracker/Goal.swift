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
    var endDate : Date
    var mileGoal : Int
    var practiceGoal : Int
    
    // MARK: Types
    struct PropertyKey {
        static let endDate = "endDate"
        static let mileGoal = "milesGoal"
        static let practiceGoal = "practiceGoal"
    }
    
    // MARK: Initialization
    init?(endDate: Date, mileGoal: Int, practiceGoal: Int) {
        
        // Initialization should fail if end date is not a future date
        if endDate < Date() {
            return nil
        }
        
        self.endDate = endDate
        self.practiceGoal = practiceGoal
        self.mileGoal = mileGoal
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(endDate, forKey: PropertyKey.endDate)
        aCoder.encode(mileGoal, forKey: PropertyKey.mileGoal)
        aCoder.encode(practiceGoal, forKey: PropertyKey.practiceGoal)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let endDate = aDecoder.decodeObject(forKey: PropertyKey.endDate) as? Date else {
            print("Unable to decode end date for goal")
            return nil
        }
        
        let mileGoal = aDecoder.decodeInteger(forKey: PropertyKey.mileGoal)
        let practiceGoal = aDecoder.decodeInteger(forKey: PropertyKey.practiceGoal)
        
        self.init(endDate: endDate, mileGoal: mileGoal, practiceGoal: practiceGoal)
    }
    

}
