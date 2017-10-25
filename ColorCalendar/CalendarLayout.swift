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
    
    func dateComponents(at index: Int, referenceDate: Date) -> DateComponents {
        let referenceDateComponents = calendar.dateComponents([.weekday], from:referenceDate)
        let referenceDateWeekday = referenceDateComponents.weekday!
        // TODO: logic below is only working if firstWeekdayDay is == 1 – default English and Spanish calendar
        // A generic way of calculating the index should be implemente: to reproduce the issue set firstWeekdayDay to 2 and then go to October 2017 -> 1st day is not shown on the calendar. See and Uncomment test testFirstCalendarDayWhen2FirstWeekdayAndCurrentMonthFirstDayIsSunday
        let indexOffsetFromReferenceDate = index - referenceDateWeekday + firstWeekdayDay
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
    
    public var firstWeekdayDay: Int {
        set {
            calendar.firstWeekday = newValue
        }
        
        get {
            return calendar.firstWeekday
        }
    }
    
    public var title: String {
        return date.monthName(withLocale: locale)
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
    
    func weekdaySymbol(at index: Int) -> String {
        assert(index < daysPerWeek, "Weekday index out of range")
        // - 1 since .day property starts at 1 but dayNumber first index is 0
        return calendar.veryShortStandaloneWeekdaySymbols[(index + firstWeekdayDay - 1) % daysPerWeek]
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
        let components = dateComponents(at: index, referenceDate: self.firstDayOfCurrentMonthDate)
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

public class WeeklyMonthlyCalendarLayout: MonthlyCalendarLayout {
    
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
        let components = dateComponents(at: index, referenceDate: date)
        
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

