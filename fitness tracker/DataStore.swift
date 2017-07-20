//
//  DataStore.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/12/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import Foundation

class DataStore: NSObject, NSCoding {
    
    static let sharedInstance = loadData()
    
    var yogaPractices: [YogaPractice] { return self.workouts.filter { $0 is YogaPractice } as! [YogaPractice] }
    var runs: [Run] { return self.workouts.filter { $0 is Run } as! [Run] }
    var workouts : [Any] = []
    
    struct PropertyKey {
        static let yogaPractices = "yogaPractices"
        static let runs = "runs"
        static let workouts = "workouts"
    }
    
    private override init() {
//        self.yogaPractices = []
//        self.runs = []
        self.workouts = []
    }
    
    required init(coder decoder: NSCoder) {
        
//        self.yogaPractices = (decoder.decodeObject(forKey: "yogaPractices") as? [YogaPractice])!
        
//        if let practices = decoder.decodeObject(forKey: "yogaPractices") as? [YogaPractice] {
//            self.yogaPractices = practices
//        }
//        if let trackedRuns = decoder.decodeObject(forKey: "runs") as? [Run] {
//            self.runs = trackedRuns
//        }
        if let workouts = decoder.decodeObject(forKey: "workouts") as? [Any] {
            self.workouts = workouts
        }
        
    }
    
    func encode(with coder: NSCoder) {
        print("In encode")
//        coder.encode(yogaPractices, forKey: PropertyKey.yogaPractices)
//        coder.encode(runs, forKey: PropertyKey.runs)
        coder.encode(workouts, forKey: PropertyKey.workouts)
    }
    
    static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
//        print("this is the url path in the documentDirectory \(url)")
        return (url!.appendingPathComponent("Data").path)
    }
    
    func addPractice(item: YogaPractice) {
//        self.yogaPractices.append(item)
        self.workouts.append(item)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    // make same for yoga and running?
    func deletePractice(index: Int) {
//        self.yogaPractices.remove(at: index)
//        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func addRun(item: Run) {
//        self.runs.append(item)
        self.workouts.append(item)
        print("In addRun, run count is \(self.runs.count)")
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            print("Runs stored: \(data.runs.count)")
            print("Yoga practices stored: \(data.yogaPractices.count)")
            print("Workouts stored: \(data.workouts.count)")
            return data
        } else {
            return DataStore() // no workout data saved
            
        }
    }
}

//MARK: Archiving Paths
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("yogaPractices")
