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
    
    // MARK: initializers
    
    required public init(_ date:Date) {
        self.calendar = NSCalendar.current as NSCalendar
        self.date = date        
    }
    
    // MARK: private API
    
    private func firstDayOfCurrentMonthDate() -> Date {
        var components = calendar.components([.day, .month, .year], from: date)
        components.day = 1
        let firstDayOfCurrentMonthDate = calendar.date(from: components)!
        
        return firstDayOfCurrentMonthDate
    }
    
    private func changeDate(monthOffset offset:Int) {
        let firstDayOfCurrentMonthDate = self.firstDayOfCurrentMonthDate()
        var components = DateComponents()
        components.month = offset
        date = calendar.date(byAdding: components, to: firstDayOfCurrentMonthDate, options: NSCalendar.Options(rawValue: 0))!
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
    
    // MARK: public API
    
    public var firstWeekdayOffset:Int = 0
    
    public var currentMonthName:String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM"
            return formatter.string(from: date).capitalized
        }
    }
    
    public func dayNumber(at index:Int) -> Int {
        let firstDayOfCurrentMonthDate = self.firstDayOfCurrentMonthDate()
        let firstDayOfCurrentMonthDateComponents = calendar.components(.weekday, from:firstDayOfCurrentMonthDate)
        // - 1 since .day property starts at 1 but dayNumber first index is 0
        let firstDayOfCurrentMonthDateWeekday = firstDayOfCurrentMonthDateComponents.weekday! - firstWeekdayOffset - 1
        let indexOffsetFromFirstDayInMonth = index - firstDayOfCurrentMonthDateWeekday
        
        var components = DateComponents()
        components.day = indexOffsetFromFirstDayInMonth
        let dateWithOffset = calendar.date(byAdding: components, to: firstDayOfCurrentMonthDate, options: NSCalendar.Options(rawValue: 0))!
        
        let result:Int = calendar.component(.day, from: dateWithOffset)
        
        return result
    }
    
    public func forwardOneMonth() {
        changeDate(monthOffset: 1)
    }
    
    public func backwardOneMonth() {
        changeDate(monthOffset: -1)
    }
}
