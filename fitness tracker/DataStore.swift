//
//  DataStore.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/12/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import Foundation

// Future: Make add workout one method?

class DataStore: NSObject, NSCoding {
    
    static let sharedInstance = loadData()
    
    var yogaPractices: [YogaPractice] { return self.workouts.filter { $0 is YogaPractice } as! [YogaPractice] }
    var runs: [Run] { return self.workouts.filter { $0 is Run } as! [Run] }
    var workouts : [Any] = []
    var goal : Goal?
    
    struct PropertyKey {
        static let workouts = "workouts"
        static let goal = "goal"
    }
    
    private override init() {
        self.workouts = []
    }
    
    required init(coder decoder: NSCoder) {
        if let workouts = decoder.decodeObject(forKey: "workouts") as? [Any] {
            self.workouts = workouts
        } else {
            print("Could not load workouts")
        }
        
        if let goal = decoder.decodeObject(forKey: "goal") as? Goal {
            self.goal = goal
        } else {
            print("Cound not load goal")
        }
        
    }
    
    func encode(with coder: NSCoder) {
        print("In encode")
        coder.encode(workouts, forKey: PropertyKey.workouts)
        coder.encode(goal, forKey: PropertyKey.goal)
    }
    
    static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Data").path)
    }
    
    func addPractice(item: YogaPractice) {
        self.workouts.append(item)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func deleteWorkout(index: Int) {
        workouts.remove(at: index)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func editPractice(item: YogaPractice, index: Int) {
        workouts[index] = item
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func addRun(item: Run) {
        self.workouts.append(item)
        print("In addRun, run count is \(self.runs.count)")
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func saveGoal(item: Goal) -> Bool {
        self.goal = item
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
        return isSuccessfulSave
    }
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            print("Runs stored: \(data.runs.count)")
            print("Yoga practices stored: \(data.yogaPractices.count)")
            print("Workouts stored: \(data.workouts.count)")
            
            if data.goal != nil {
                print("Goal set!")
            } else {
                print("no current goal set")
            }
            return data
        } else {
            return DataStore() // no workout data saved
            
        }
    }
}
