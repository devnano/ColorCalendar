//
//  Calendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public class CalendarHighlights {
    
    // MARK: private properties
    
    private var calendar:NSCalendar
    private var date:Date
    
    required public init(_ date:Date) {
        self.calendar = NSCalendar.current as NSCalendar
        self.date = date        
    }
    
    // MARK: module internal API
    
    var daysPerWeek:Int {
        get {
            let range = calendar.range(of: .day, in: .weekOfMonth, for: date)
            return range.length
        }
    }
    
    var weeksPerMonth:Int {
        get {
            let range = calendar.range(of: .weekOfMonth, in: .month, for: date)
            return range.length
        }
    }
    
    func weekdaySymbol(at index:Int) -> String {
        assert(index < daysPerWeek, "Weekday index out of range")
        
        return calendar.veryShortStandaloneWeekdaySymbols[(index + firstWeekdayOffset) % daysPerWeek]
    }
    
    // MARK: internal API
    
    public var firstWeekdayOffset:Int = 0
}
