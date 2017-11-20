//
//  Calendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/26/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import Foundation

public class CalendarLayout {
    public var locale: Locale {
        get {
            return calendar.locale ?? Locale.current
        }
        set {
            calendar.locale = newValue
        }
    }
    
    // MARK: - private properties
    
    var calendar:Calendar
    var date:Date
    
    
    // MARK: - initializers
    
    required public init(_ date:Date) {
        self.calendar = Calendar.current as Calendar
        self.date = date
    }
    
    // MARK: - module internal API
    
    var daysPerWeek:Int {
        //            let range = calendar.range(of: .day, in: .weekOfYear, for: date)
        //            assert(range.location != NSNotFound)
        //            return range.length
        // NOTE: Just hardcoded by now. Our aim is 7 days per week calendar – Gregorian.
        return 7
        
    }
    
    var numberOfWeeks:Int {
        fatalError(notImplementedMessage(functionName: #function))
    }
    
    fileprivate func dateComponents(at index: Int, referenceDate: Date) -> DateComponents {
        let referenceDateComponents = calendar.dateComponents([.weekday], from:referenceDate)
        let referenceDateWeekday = referenceDateComponents.weekday!
        let indexOffsetFromReferenceDate = index - referenceDateWeekday + firstWeekday
        var components = DateComponents()
        components.day = indexOffsetFromReferenceDate
        let dateWithOffset = calendar.date(byAdding: components, to: referenceDate)!
        
        components = calendar.dateComponents([.day, .month, .year], from: dateWithOffset)
        
        return components
    }
    
    // MARK: - Private API
    
    func notImplementedMessage(functionName: String) -> String {
        return "Subclasses need to implement the \(functionName) method."
    }
    
    // MARK: - public API   
    
    func weekdaySymbol(at index: Int) -> String {
        assert(index < daysPerWeek, "Weekday index out of range")
        // - 1 since .day property starts at 1 but dayNumber first index is 0
        return calendar.veryShortStandaloneWeekdaySymbols[(index + firstWeekday - 1) % daysPerWeek]
    }
    
    public var firstWeekday: Int {
        set {
            calendar.firstWeekday = newValue
        }
        
        get {
            return calendar.firstWeekday
        }
    }
    
    public var title: String {
        return "\(date.monthName(withLocale: locale)) \(currentYear)"
    }
    
    public var currentYear: Int {
        return date.year(withCalendar: calendar)
    }
    
    public func dateComponents(at index: Int) -> (components:DateComponents, isWithinCurrentCalendarPeriod:Bool) {
         fatalError(notImplementedMessage(functionName: #function))
    }
    
    public func moveCalendarForward() {
        fatalError(notImplementedMessage(functionName: #function))
    }
    
    public func moveCalendarBackward() {
        fatalError(notImplementedMessage(functionName: #function))
    }
}

public class MonthlyCalendarLayout: CalendarLayout {
    
    // MARK: - private API
    
    private func changeDate(monthOffset offset:Int) {
        let firstDayOfCurrentMonthDate = self.firstDayOfCurrentMonthDate
        var components = DateComponents()
        components.month = offset
        date = calendar.date(byAdding: components, to: firstDayOfCurrentMonthDate)!
    }
    
    // MARK: - module internal API
    
    override var numberOfWeeks:Int {
        //            let range = calendar.range(of: .weekOfMonth, in: .month, for: date)
        //            return range.length
        // NOTE: Just hardcoded by now. Our aim is 6 weeks per mont – Like Mac Dashboard Calendar
        return 6
    }
    
    private var firstDayOfCurrentMonthDate: Date {
        var components = calendar.dateComponents([.day, .month, .year], from: date)
        components.day = 1
        let firstDayOfCurrentMonthDate = calendar.date(from: components)!
        
        return firstDayOfCurrentMonthDate
    }
    
    // MARK: - public API
    
    public override func dateComponents(at index: Int) -> (components:DateComponents, isWithinCurrentCalendarPeriod:Bool) {
        var adjustedIndex: Int = index
        if firstWeekday != 1 {
            // Since first weekday doesn't match the default one (1), we have to check if we need some adjustements on the offset to fit all the current month days in the calendar:
            let currentDateMonth = calendar.dateComponents([.month], from: date).month!
            let firstCalendarDay = dateComponents(at: 0, referenceDate: self.firstDayOfCurrentMonthDate)
            if firstCalendarDay.month == currentDateMonth && firstCalendarDay.day != 1 {
                adjustedIndex -= daysPerWeek
            }
        }
        let components = dateComponents(at: adjustedIndex, referenceDate: self.firstDayOfCurrentMonthDate)
        let month:Int = components.month!
        let currentMonth:Int = calendar.component(.month, from: date)
        
        return (components, month == currentMonth)
    }
    
    public override func moveCalendarForward() {
        changeDate(monthOffset: 1)
    }
    
    public override func moveCalendarBackward() {
        changeDate(monthOffset: -1)
    }
}

public class WeeklyCalendarLayout: CalendarLayout {
    
    // MARK: - Private API
    
    private func changeDate(weeksOffset offset:Int) {
        var components = DateComponents()
        components.day = offset * daysPerWeek
        date = calendar.date(byAdding: components, to: date)!
    }
    
    // MARK: - module internal API
    
    override var numberOfWeeks:Int {
        return 1
    }
    
    public override func dateComponents(at index: Int) -> (components:DateComponents, isWithinCurrentCalendarPeriod:Bool) {
        
        var adjustedIndex: Int = index
        if firstWeekday != 1 {            
            let currentWeekday = calendar.dateComponents([.weekday], from: date).weekday!
           
            if currentWeekday == 1 {
                adjustedIndex -= daysPerWeek
            }
        }
        
        let components = dateComponents(at: adjustedIndex, referenceDate: date)
        
        return (components, index >= 0 && index < daysPerWeek)        
    }
    
    public override var title: String {
        let components = dateComponents(at: 0).components
        let date = calendar.date(from: components)!
        
        let dateString = date.short(withLocale: locale)
        return R.string.localizable.weeklyCalendarTitleFormat(dateString)
    }
    
    public override func moveCalendarForward() {
        changeDate(weeksOffset: 1)
    }
    
    public override func moveCalendarBackward() {
        changeDate(weeksOffset: -1)
    }
}

