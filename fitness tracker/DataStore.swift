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
    // var yogastuff: [YogaWorkout] = []
    
    private override init() {
        self.yogaPractices = [];
    }
    
    required init(coder decoder: NSCoder) {
        self.yogaPractices = (decoder.decodeObject(forKey: "yogaPractices") as? [YogaPractice])!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(yogaPractices, forKey: "yogaPractices")
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
    
    private static func loadData() -> DataStore {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? DataStore {
            return data
        } else {
            return DataStore()
            
        }
    }
}
