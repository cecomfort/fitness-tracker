//
//  YogaPractice.swift
//  fitness tracker
//

import Foundation
import os.log

class YogaPractice: NSObject, NSCoding {
    
    //MARK: Properties
    var date: Date
    var style: String
    var duration: String
    var instructor: String?
    var focus: String?
    var notes: String?
//    var cardioLevel: Int?
//    var strengthBuildingLevel: Int?
//    var stretchingLevel: Int?
    
    //MARK: Archiving Paths
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("yogaPractices")
    
    //MARK: Types
    
    struct PropertyKey {
        static let date = "date"
        static let style = "style"
        static let duration = "duration"
//        static let time = "time"
        static let instructor = "instructor"
        static let focus = "focus"
        static let notes = "notes"
//        static let cardioLevel = "cardioLevel"
//        static let strengthBuildingLevel = "strengthBuildingLevel"
//        static let stretchingLevel = "stretchingLevel"
    }

    //MARK: Initialization
    init?(date: Date, style: String, duration: String, instructor: String?, focus: String?, notes: String?) {
        self.date = date
        self.style = style
        self.duration = duration
        self.instructor = instructor
        self.focus = focus
        self.notes = notes
    }
//    init?(date: String, style: String, duration: Double, time: String?, instructor: String?, focus: String?, notes: String?, cardioLevel: Int?, strengthBuildingLevel: Int?, stretchingLevel: Int?) {
//        
//        // date, style, and duration may not be empty
//        guard !date.isEmpty else {
//            return nil
//        }
//        
//        guard !style.isEmpty else {
//            return nil
//        }
//        
//        // TODO
////        guard !duration.isEmpty else {
////            return nil
////        }
//        
//        // The class ratings must be between 0 and 5 inclusively. TODO for other levels!
////        guard (cardioLevel >= 0) && (cardioLevel <= 5) else {
////            return nil
////        }
//        
//        // Initialization should fail if there is no date, style duration or if a rating is negative.
//        if date.isEmpty || style.isEmpty  { //rating < 0
//            return nil
//        }
//        
//        // Initialize stored properties
//        self.date = date
//        self.style = style
//        self.duration = duration
//        self.time = time
//        self.instructor = instructor
//        self.focus = focus
//        self.notes = notes
//        self.cardioLevel = cardioLevel
//        self.strengthBuildingLevel = strengthBuildingLevel
//        self.stretchingLevel = stretchingLevel
//        
//    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(style, forKey: PropertyKey.style)
        aCoder.encode(duration, forKey: PropertyKey.duration)
//        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(instructor, forKey: PropertyKey.instructor)
        aCoder.encode(focus, forKey: PropertyKey.focus)
        aCoder.encode(notes, forKey: PropertyKey.notes)
//        aCoder.encode(cardioLevel, forKey: PropertyKey.cardioLevel)
//        aCoder.encode(strengthBuildingLevel, forKey: PropertyKey.strengthBuildingLevel)
//        aCoder.encode(stretchingLevel, forKey: PropertyKey.stretchingLevel)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // Date, Style, and Duration is required. If we cannot decode them, the initializer should fail.
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date for the yoga practice.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let style = aDecoder.decodeObject(forKey: PropertyKey.style) as? String else {
            os_log("Unable to decode the style for the yoga practice.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let duration = aDecoder.decodeObject(forKey: PropertyKey.duration) as? String else {
            os_log("Unable to decode the style for the yoga practice.", log: OSLog.default, type: .debug)
            return nil
        }
        
//        let duration = aDecoder.decodeInteger(forKey:  PropertyKey.date) 

        
        // Optional properties get a conditional cast
//        let time = aDecoder.decodeObject(forKey: PropertyKey.instructor) as? String
        let instructor = aDecoder.decodeObject(forKey: PropertyKey.instructor) as? String
        let focus = aDecoder.decodeObject(forKey: PropertyKey.focus) as? String
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
//        let cardioLevel = aDecoder.decodeObject(forKey: PropertyKey.cardioLevel) as? Int
//        let strengthBuildingLevel = aDecoder.decodeObject(forKey: PropertyKey.strengthBuildingLevel) as? Int
//        let stretchingLevel = aDecoder.decodeObject(forKey: PropertyKey.stretchingLevel) as? Int

//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
//        self.init(date: date, style: style, duration: duration, time: time, instructor: instructor, focus: focus, notes: notes, cardioLevel: cardioLevel, strengthBuildingLevel: strengthBuildingLevel, stretchingLevel: stretchingLevel)
        self.init(date: date, style: style, duration: duration, instructor: instructor, focus: focus, notes: notes)
        
    }
//    let date : String
//    let style : String
//    let duration : String
//    var id : Int
//    
//    init(date: String, style: String, duration: String, id: Int = 0) {
//        self.date = date
//        self.style = style
//        self.duration = duration
//        self.id = id
//        
//        // if it's a new entry, generate an id for it
//        if self.id == 0 {
//            self.id = Int(arc4random_uniform(1000))
//        }
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        guard let date = aDecoder.decodeObject(forKey: "date") as? String,
//            let style = aDecoder.decodeObject(forKey: "style") as? String,
//            let duration = aDecoder.decodeObject(forKey: "style") as? String
//        else {
//             return nil
//        }
//        
//        self.init (
//            date: date,
//            style: style,
//            duration: duration,
//            id: aDecoder.decodeInteger(forKey: "id")
//        )
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.date, forKey: "date")
//        aCoder.encode(self.style, forKey: "style")
//        aCoder.encode(self.duration, forKey: "duration")
//        aCoder.encodeCInt(Int32(Int(self.id)), forKey: "id")
//    }
    
    
    // NSKeyedArchiver -> lets you turn object into binary object 
    // NSCoder turns obj in to NSData
    

    
}
