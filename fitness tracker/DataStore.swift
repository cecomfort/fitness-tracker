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
    
    var yogaPractices: [YogaPractice] = []
    var runs: [Run] = []
    
    struct PropertyKey {
        static let yogaPractices = "yogaPractices"
        static let runs = "runs"
    }
    
    private override init() {
        self.yogaPractices = []
        self.runs = []
    }
    
    required init(coder decoder: NSCoder) {
        
//        self.yogaPractices = (decoder.decodeObject(forKey: "yogaPractices") as? [YogaPractice])!
        
        if let practices = decoder.decodeObject(forKey: "yogaPractices") as? [YogaPractice] {
            self.yogaPractices = practices
        } else if let trackedRuns = decoder.decodeObject(forKey: "runs") as? [Run] {
            self.runs = trackedRuns
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(yogaPractices, forKey: PropertyKey.yogaPractices)
        coder.encode(runs, forKey: PropertyKey.runs)
    }
    
    static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
//        print("this is the url path in the documentDirectory \(url)")
        return (url!.appendingPathComponent("Data").path)
    }
    
    func addPractice(item: YogaPractice) {
        self.yogaPractices.append(item)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    // make same for yoga and running?
    func deletePractice(index: Int) {
        self.yogaPractices.remove(at: index)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    func addRun(item: Run) {
        self.runs.append(item)
        NSKeyedArchiver.archiveRootObject(self, toFile: DataStore.filePath)
    }
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            print("Runs stored:")
            print(data.runs.count)
            return data
        } else {
            return DataStore() // no workout data saved
            
        }
    }
}
