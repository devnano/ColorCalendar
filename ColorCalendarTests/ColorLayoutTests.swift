//
//  ColorCalendarTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 12/12/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class ColorLayoutTests: XCTestCase {
    
    var calendarLayout: CalendarLayout!
    var locale: Locale!
    
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        createCalendarHighlight(year: 2016, month: 12, day: 27)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        calendarLayout = nil
    }
    
    // MARK: - private methods
    
    private func createCalendarHighlight(year:Int, month:Int, day:Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        let date = calendar.date(from: dateComponents)!
        
        calendarLayout = CalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount6Weeks() {
        createCalendarHighlight(year: 2017, month: 4, day: 1)
        XCTAssert(calendarLayout.weeksPerMonth == 6)
    }
    
    func testWeeksCount6WeeksWithMondayAsFirstWeekDay() {
        createCalendarHighlight(year: 2017, month: 4, day: 1)
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.weeksPerMonth == 6)
    }
    
    func testWeekdaysCount() {
        XCTAssert(calendarLayout.daysPerWeek == 7)
    }
    
    func testWeekdaysCountWhenCurrentWeekHasLessThan7DaysInMonth() {
        createCalendarHighlight(year: 2016, month: 11, day: 1)
        XCTAssert(calendarLayout.daysPerWeek == 7)
    }
    
    func testWeekdaySymbolAtWithoutOffset() {
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "S")
    }
    
    func testWeekdaySymbolAtWithoutOffsetWithLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "D")
    }
    
    
    func testWeekdaySymbolAtWithOffset() {
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "M")
    }
    
    func testWeekdaySymbolAtWithOffsetWithLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.firstWeekdayDay = 2
        XCTAssert(calendarLayout.weekdaySymbol(at: 0) == "L")
    }
    
    func testDateComponentsWithOffset() {
        createCalendarHighlight(year: 2017, month: 3, day: 2)
        calendarLayout.firstWeekdayDay = 2
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 27)
    }
    
    func testCurrentMonthName() {
        XCTAssert(calendarLayout.currentMonthName == "December")
    }
    
    func testCurrentMonthNameWithLocale() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.currentMonthName == "Diciembre")
    }
    
    func testCurrentYear() {
        XCTAssert(calendarLayout.currentYear == 2016)
    }
    
    func testCurrentYearAfterForwardMonth() {
        calendarLayout.forwardOneMonth()
        XCTAssert(calendarLayout.currentYear == 2017)
    }
    
    func testFirstMonthDayNumberAtWithoutOffset() {
        let c = calendarLayout.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 27)
        XCTAssert(!c.isCurrentMonth)
    }
    
    func testLastMonthDayNumberAtWithoutOffset() {
        let c = calendarLayout.dateComponents(at: 34)
        
        XCTAssert(c.components.day! == 31)
        XCTAssert(c.isCurrentMonth)
    }

    // TODO: uncomment and fix this functionlity
//    func testFirstCalendarDayWhen2FirstWeekdayAndCurrentMonthFirstDayIsSunday() {
//        createCalendarHighlight(year: 2017, month: 10, day: 24)
//        calendarLayout.firstWeekdayDay = 2
//        let c = calendarLayout.dateComponents(at: 0)
//
//        XCTAssert(c.components.day! == 25)
//        XCTAssert(!c.isCurrentMonth)
//    }
    
    func testForwardOneMonth() {
        calendarLayout.forwardOneMonth()
        XCTAssert(calendarLayout.currentMonthName == "January")
    }
    
    func testForwardOneMonthOnLastDayOfTheMonth() {
        createCalendarHighlight(year: 2016, month: 12, day: 31)
        calendarLayout.forwardOneMonth()
        XCTAssert(calendarLayout.currentMonthName == "January")
    }
    
    func testBackwardOneMonth() {
        calendarLayout.backwardOneMonth()
        XCTAssert(calendarLayout.currentMonthName == "November")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
