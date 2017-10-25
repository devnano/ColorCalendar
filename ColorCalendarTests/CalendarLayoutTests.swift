//
//  ColorCalendarTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 12/12/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class MontlyCalendarLayoutTests: XCTestCase {
    
    var calendarLayout: MontlyCalendarLayout!
    var locale: Locale!    
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        createMontlyCalendarLayout(year: 2016, month: 12, day: 27)
    }
    
    override func tearDown() {        
        super.tearDown()
        calendarLayout = nil
    }
    
    // MARK: - private methods
    
    private func createMontlyCalendarLayout(year:Int, month:Int, day:Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        let date = calendar.date(from: dateComponents)!
        
        calendarLayout = MontlyCalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount6Weeks() {
        createMontlyCalendarLayout(year: 2017, month: 4, day: 1)
        XCTAssert(calendarLayout.numberOfWeeks == 6)
    }
    
    func testWeeksCount6WeeksWithMondayAsFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 4, day: 1)
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.numberOfWeeks == 6)
    }
    
    func testWeekdaysCount() {
        XCTAssert(calendarLayout.daysPerWeek == 7)
    }
    
    func testWeekdaysCountWhenCurrentWeekHasLessThan7DaysInCurrentMonth() {
        createMontlyCalendarLayout(year: 2016, month: 11, day: 1)
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
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "M")
    }
    
    func testWeekdaySymbolAtWithMondayAsFirstWeekdayAndSpanishLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "L")
    }
    
    func testDateComponentsWithMondayAsFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 3, day: 2)
        calendarLayout.firstWeekdayDay = 2
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 27)
    }
    
    func testCurrentMonthName() {
        XCTAssert(calendarLayout.title == "December")
    }
    
    func testCurrentMonthNameWithSpanishLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.title == "Diciembre")
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
//    func testFirstCalendarDayWhen2FirstWeekdayAndCurrentMonthFirstDayIsSunday() {
//        createMontlyCalendarLayout(year: 2017, month: 10, day: 24)
//        calendarLayout.firstWeekdayDay = 2
//        let c = calendarLayout.dateComponents(at: 0)
//
//        XCTAssert(c.components.day! == 25)
//        XCTAssert(!c.isWithinCurrentCalendarPeriod)
//    }
    
    func testMoveCalendarForward() {
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "January")
    }
    
    func testMoveCalendarForwardOnLastDayOfTheMonth() {
        createMontlyCalendarLayout(year: 2016, month: 12, day: 31)
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "January")
    }
    
    func testmMoveCalendarBackward() {
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "November")
    }
    
}
