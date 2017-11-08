//
//  ColorCalendarTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 12/12/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class MonthlyCalendarLayoutTests: XCTestCase {
    
    var calendarLayout: MonthlyCalendarLayout!
    var locale: Locale!    
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        createMonthlyCalendarLayout(year: 2016, month: 12, day: 27)
    }
    
    override func tearDown() {        
        super.tearDown()
        calendarLayout = nil
    }
    
    // MARK: - private methods
    
    private func createMonthlyCalendarLayout(year:Int, month:Int, day:Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        let date = calendar.date(from: dateComponents)!
        
        calendarLayout = MonthlyCalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount6Weeks() {
        createMonthlyCalendarLayout(year: 2017, month: 4, day: 1)
        XCTAssert(calendarLayout.numberOfWeeks == 6)
    }
    
    func testWeeksCount6WeeksWithMondayAsFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 4, day: 1)
        calendarLayout.firstWeekday = 2
        XCTAssert(calendarLayout.numberOfWeeks == 6)
    }
    
    func testWeekdaysCount() {
        XCTAssert(calendarLayout.daysPerWeek == 7)
    }
    
    func testWeekdaysCountWhenCurrentWeekHasLessThan7DaysInCurrentMonth() {
        createMonthlyCalendarLayout(year: 2016, month: 11, day: 1)
        XCTAssert(calendarLayout.daysPerWeek == 7)
    }
    
    func testWeekdaySymbolAtWithDefaultFirstWeekday() {
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "S")
    }
    
    func testWeekdaySymbolAtDefaultFirstWeekdayAndSpanishLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "D")
    }
    
    
    func testWeekdaySymbolAtWithMondayAsFirstWeekday() {
        calendarLayout.firstWeekday = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "M")
    }
    
    func testWeekdaySymbolAtWithMondayAsFirstWeekdayAndSpanishLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.firstWeekday = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "L")
    }
    
    func testDateComponentsWithMondayAsFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 3, day: 2)
        calendarLayout.firstWeekday = 2
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 27)
    }
    
    func testCurrentMonthName() {
        XCTAssert(calendarLayout.title == "December 2016")
    }
    
    func testCurrentMonthNameWithSpanishLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.title == "Diciembre 2016")
    }
    
    func testCurrentYear() {
        XCTAssert(calendarLayout.currentYear == 2016)
    }
    
    func testCurrentYearAfterMoveCalendarForward() {
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.currentYear == 2017)
    }
    
    func testFirstCalendarDayNumberWithDefaultFirstWeekday() {
        let c = calendarLayout.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 27)
        XCTAssert(!c.isWithinCurrentCalendarPeriod)
    }
    
    func testLastMonthDayNumberAtWithDefaultFirstWeekday() {
        let c = calendarLayout.dateComponents(at: 34)
        
        XCTAssert(c.components.day! == 31)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }

    // TODO: uncomment and fix this functionlity
    func testFirstCalendarDayWhen2FirstWeekdayAndCurrentMonthFirstDayIsSunday() {
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 24)
        calendarLayout.firstWeekday = 2
        let c = calendarLayout.dateComponents(at: 0)

        XCTAssert(c.components.day! == 25)
        XCTAssert(c.components.month! == 9)
        XCTAssert(!c.isWithinCurrentCalendarPeriod)
    }
    
    func testMoveCalendarForward() {
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "January 2017")
    }
    
    func testMoveCalendarForwardOnLastDayOfTheMonth() {
        createMonthlyCalendarLayout(year: 2016, month: 12, day: 31)
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "January 2017")
    }
    
    func testmMoveCalendarBackward() {
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "November 2016")
    }
    
}
