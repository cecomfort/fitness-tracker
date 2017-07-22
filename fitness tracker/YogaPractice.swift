//
//  YogaPractice.swift
//  fitness tracker
//

import Foundation

// TODO: make ratings not optionals

class YogaPractice: NSObject, NSCoding {
    
    // MARK: Properties
    var date: Date
    var style: String
    var duration: String
    var instructor: String?
    var focus: String?
    var location: String?
    var notes: String?
    var cardioLevel: Int?
    var strengthBuildingLevel: Int?
    var flexibilityLevel : Int?
    
    // MARK: Types
    struct PropertyKey {
        static let date = "date"
        static let style = "style"
        static let duration = "duration"
        static let instructor = "instructor"
        static let location = "location"
        static let focus = "focus"
        static let notes = "notes"
        static let cardioLevel = "cardioLevel"
        static let strengthBuildingLevel = "strengthBuildingLevel"
        static let flexibilityLevel  = "stretchingLevel"
    }

    //MARK: Initialization
    init?(date: Date, style: String, duration: String, instructor: String?, location: String?, focus: String?, notes: String?, cardioLevel : Int?, strengthBuildingLevel : Int?, flexibilityLevel : Int?) {
        // date, style, and duration may not be empty
        guard !style.isEmpty || !duration.isEmpty else {
            return nil
        }

        //
        //        // The class ratings must be between 0 and 5 inclusively. TODO for other levels!
        ////        guard (cardioLevel >= 0) && (cardioLevel <= 5) else {
        ////            return nil
        ////        }
        //

        
        self.date = date
        self.style = style
        self.duration = duration
        self.instructor = instructor
        self.location = location
        self.focus = focus
        self.notes = notes
        self.cardioLevel = cardioLevel
        self.strengthBuildingLevel = strengthBuildingLevel
        self.flexibilityLevel = flexibilityLevel
    
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(style, forKey: PropertyKey.style)
        aCoder.encode(duration, forKey: PropertyKey.duration)
        aCoder.encode(instructor, forKey: PropertyKey.instructor)
        aCoder.encode(focus, forKey: PropertyKey.focus)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(cardioLevel, forKey: PropertyKey.cardioLevel)
        aCoder.encode(strengthBuildingLevel, forKey: PropertyKey.strengthBuildingLevel)
        aCoder.encode(flexibilityLevel, forKey: PropertyKey.flexibilityLevel)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // Date, Style, and Duration is required. If we cannot decode them, the initializer should fail.
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date, let style = aDecoder.decodeObject(forKey: PropertyKey.style) as? String, let duration = aDecoder.decodeObject(forKey: PropertyKey.duration) as? String else {
            print("Unable to decode the date, style, and/or duration for the yoga practice.")
            return nil
        }
        

        // Optional properties get a conditional cast
        let instructor = aDecoder.decodeObject(forKey: PropertyKey.instructor) as? String
        let focus = aDecoder.decodeObject(forKey: PropertyKey.focus) as? String
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String
        let cardioLevel = aDecoder.decodeObject(forKey: PropertyKey.cardioLevel) as? Int
        let strengthBuildingLevel = aDecoder.decodeObject(forKey: PropertyKey.strengthBuildingLevel) as? Int
        let flexibilityLevel = aDecoder.decodeObject(forKey: PropertyKey.flexibilityLevel) as? Int

        self.init(date: date, style: style, duration: duration, instructor: instructor, location: location, focus: focus, notes: notes, cardioLevel: cardioLevel, strengthBuildingLevel: strengthBuildingLevel, flexibilityLevel: flexibilityLevel)
        
    }
}
