//
//  Calendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public class CalendarHighlights {
    
    public var locale: Locale {
        get {
            return calendar.locale ?? Locale.current
        }
        set {
            calendar.locale = newValue
        }
    }
    
    // MARK: - private properties
    
    private var calendar:Calendar
    private var date:Date
    
    private var firstDayOfCurrentMonthDate: Date {
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = 1
        let firstDayOfCurrentMonthDate = calendar.date(from: components)!
        
        return firstDayOfCurrentMonthDate
    }
    
    
    // MARK: - initializers
    
    required public init(_ date:Date) {
        self.calendar = Calendar.current as Calendar
        self.date = date        
    }
    
    // MARK: - private API

    private func changeDate(monthOffset offset:Int) {
        let firstDayOfCurrentMonthDate = self.firstDayOfCurrentMonthDate
        var components = DateComponents()
        components.month = offset
        date = calendar.date(byAdding: components, to: firstDayOfCurrentMonthDate)!
    }
    
    // MARK: - module internal API
    
    var daysPerWeek:Int {
//            let range = calendar.range(of: .day, in: .weekOfYear, for: date)
//            assert(range.location != NSNotFound)
//            return range.length
            // NOTE: Just hardcoded by now. Our aim is 7 days per week calendar – Gregorian.
        return 7
        
    }
    
    var weeksPerMonth:Int {
//            let range = calendar.range(of: .weekOfMonth, in: .month, for: date)
//            return range.length
            // NOTE: Just hardcoded by now. Our aim is 6 weeks per mont – Like Mac Dashboard Calendar
        return 6
        
    }
    
    func weekdaySymbol(at index: Int) -> String {
        assert(index < daysPerWeek, "Weekday index out of range")
        // - 1 since .day property starts at 1 but dayNumber first index is 0
        return calendar.veryShortStandaloneWeekdaySymbols[(index + firstWeekdayDay - 1) % daysPerWeek]
    }
    
    // MARK: - public API
    
    public var firstWeekdayDay: Int {
        set {
            calendar.firstWeekday = newValue
        }
        
        get {
            return calendar.firstWeekday
        }
    }
    
    public var currentMonthName: String {
        return date.monthName(withLocale: locale)
    }
    
    public var currentYear: Int {
        return date.year(withCalendar: calendar)
    }
    
    public func dateComponents(at index: Int) -> (components:DateComponents, isCurrentMonth:Bool) {
        let firstDayOfCurrentMonthDate = self.firstDayOfCurrentMonthDate
        let firstDayOfCurrentMonthDateComponents = calendar.dateComponents([.weekday], from:firstDayOfCurrentMonthDate)
        let firstDayOfCurrentMonthDateWeekday = firstDayOfCurrentMonthDateComponents.weekday!
        // TODO: logic below is only working if firstWeekdayDay is == 1 – default English and Spanish calendar
        // A generic way of calculating the index should be implemente: to reproduce the issue set firstWeekdayDay to 2 and then go to October 2017 -> 1st day is not shown on the calendar. See and Uncomment test testFirstCalendarDayWhen2FirstWeekdayAndCurrentMonthFirstDayIsSunday
        let indexOffsetFromFirstDayInMonth = index - firstDayOfCurrentMonthDateWeekday + firstWeekdayDay
        
        var components = DateComponents()
        components.day = indexOffsetFromFirstDayInMonth
        let dateWithOffset = calendar.date(byAdding: components, to: firstDayOfCurrentMonthDate)!
        
        components = calendar.dateComponents([.day, .month, .year], from: dateWithOffset)        
        let month:Int = components.month!
        let currentMonth:Int = calendar.component(.month, from: date)
        
        return (components, month == currentMonth)
    }
    
    public func forwardOneMonth() {
        changeDate(monthOffset: 1)
    }
    
    public func backwardOneMonth() {
        changeDate(monthOffset: -1)
    }
}
