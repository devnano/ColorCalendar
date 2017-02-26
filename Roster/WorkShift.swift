//
//  WorkShift.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public enum WorkShift: String{
    // TODO: analyze if this could be easily refactored to work / free cases with String associated types and use pattern matching in switches referencing it.
    case night = "N"
    case morning = "M"
    case day = "D"
    case evening = "E"
    case free = "X"
    case empty = ""
    
    public var isWorkDay: Bool {
        return !WorkShift.freeShifts.contains(self)
    }
    
    public static let threeShiftsPerDay: [WorkShift] = [.morning, .day, .night]
    public static let twoShiftsPerDay: [WorkShift] = [.day, .night]
    public static let fourShiftsPerDay: [WorkShift] = [.morning, .day, .evening, .night]
    public static let freeShifts: [WorkShift] = [.free, .empty]
}

public extension NSArray {
    public func ciruclarNextElement(_ element: Any) -> Any? {
        let index = self.index(of: element)
        
        if index == NSNotFound {
            return nil
        }
        
        let nextIndex = (index + 1) % count
        
        return object(at: nextIndex)        
    }
}
