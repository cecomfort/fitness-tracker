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
    var runsCompleted : [Run] { return DataStore.sharedInstance.runs.filter { $0.date > startDate} }
    var practicesCompleted : [YogaPractice] { return DataStore.sharedInstance.yogaPractices.filter { $0.date > startDate} }
    
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
        
        self.init(startDate: startDate, endDate: endDate, mileGoal: mileGoal,
                practiceGoal: practiceGoal)
    }
    
    func percentPracticesComplete() -> Double {
        return calculatePercent(dividend: Double(practicesCompleted.count), divisor: Double(practiceGoal))
    }
    
    func percentMilesComplete() -> Double {
        print("Mile goal: \(mileGoal)")
        print("Num of Miles: \(numOfMilesCompleted())")
        print("Percent")
        print(calculatePercent(dividend: numOfMilesCompleted(), divisor: Double(mileGoal)))
        return calculatePercent(dividend: numOfMilesCompleted(), divisor: Double(mileGoal))
    }
    
    private func calculatePercent(dividend : Double, divisor : Double) -> Double {
        return (dividend / divisor) * 100
    }

    // Calculate the number of days left to complete goal, with the end date as the last day
    func daysLeft() -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let finishDate = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: currentDate, to: finishDate)
        return components.day! + 1
    }
//    
//    var yogaPractices: [YogaPractice] { return self.workouts.filter { $0 is YogaPractice } as! [YogaPractice] }
//    var runs: [Run] { return self.workouts.filter { $0 is Run } as! [Run] }
//    var splits = splitTimes.map { splitTime -> Double in
//        mileNum += 1.0
//        return Run.pace(mileage: mileNum, duration: splitTime)
//    }
//    var yogaPractices: [YogaPractice] { return self.workouts.filter { $0 is YogaPractice } as! [YogaPractice] }
//    var runs: [Run] { return self.workouts.filter { $0 is Run } as! [Run] }
    
    func practicesLeft() -> Int {
        let numOfPracticesLeft = practiceGoal - practicesCompleted.count
        if numOfPracticesLeft > 0 {
            return numOfPracticesLeft
        } else { // goal met
            return 0
        }
    }
    
    // reduce to use num of miles completed method
    func milesLeft() -> Double {
        let milesCompleted = runsCompleted.map { run -> Double in
            return run.mileage
        }
        let numOfMilesCompleted = milesCompleted.reduce(0, +)
        let numOfMilesLeft = Double(mileGoal) - numOfMilesCompleted
        
        if numOfMilesLeft > 0 {
            return numOfMilesLeft
        } else { // goal met
            return 0
        }
    }
    
    func numOfMilesCompleted() -> Double {
        let milesCompleted = runsCompleted.map { run -> Double in
            return run.mileage
        }
        return milesCompleted.reduce(0, +)
    }
    
    // WIll crash is practice rating is nil 
    func workoutBreakdown() -> [String: Double] {
        var cardioCount = 0
        var strengthBuildingCount = 0
        var flexibilityCount = 0
        
        for practice in practicesCompleted {
            cardioCount += practice.cardioLevel!
            strengthBuildingCount += practice.strengthBuildingLevel!
            flexibilityCount += practice.flexibilityLevel!
        }
        
        cardioCount += runsCompleted.count * 5 // A run is a 5/5 cardio workout.
        let total = [cardioCount, strengthBuildingCount, flexibilityCount].reduce(0, +)
        print(total)
        
        if total > 0 {
            return ["cardioPercentage" : Double(cardioCount) / Double(total), "strengthBuildingPercentage" : Double(strengthBuildingCount) / Double(total), "flexibilityPercentage" : Double(flexibilityCount) / Double(total)]
        } else {
            return ["cardioPercentage" : 0, "strengthBuildingPercentage" : 0, "flexibilityPercentage" : 0]
        }
    }

}
