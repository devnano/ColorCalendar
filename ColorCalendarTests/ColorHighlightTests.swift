//
//  ColorCalendarTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 12/12/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class ColorHighlightTests: XCTestCase {
    
   var calendarHighlights: CalendarHighlights!
    
    override func setUp() {
        super.setUp()
        createCalendarHighlight(year: 2016, month: 12, day: 27)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        calendarHighlights = nil
    }
    
    // MARK: - private methods
    
    private func createCalendarHighlight(year:Int, month:Int, day:Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        let date = calendar.date(from: dateComponents)!
        
        calendarHighlights = CalendarHighlights(date)
    }
    
    // MARK: - test methods
    
    func testWeeksCount6Weeks() {
        createCalendarHighlight(year: 2017, month: 4, day: 1)
        XCTAssert(calendarHighlights.weeksPerMonth == 6)
    }
    
    func testWeeksCount6WeeksWithMondayAsFirstWeekDay() {
        createCalendarHighlight(year: 2017, month: 4, day: 1)
        calendarHighlights.firstWeekdayDay = 2
        XCTAssert(calendarHighlights.weeksPerMonth == 6)
    }
    
    func testWeekdaysCount() {
        XCTAssert(calendarHighlights.daysPerWeek == 7)
    }
    
    func testWeekdaysCountWhenCurrentWeekHasLessThan7DaysInMonth() {
        createCalendarHighlight(year: 2016, month: 11, day: 1)
        XCTAssert(calendarHighlights.daysPerWeek == 7)
    }
    
    func testWeekdaySymbolAtWithoutOffset() {
        XCTAssert(calendarHighlights.weekdaySymbol(at: 0) == "S")
    }
    
    func testWeekdaySymbolAtWithOffset() {
        calendarHighlights.firstWeekdayDay = 2
        XCTAssert(calendarHighlights.weekdaySymbol(at: 0) == "M")
    }
    
    func testCurrentMonthName() {
        XCTAssert(calendarHighlights.currentMonthName == "December")
    }
    
    func testCurrentYear() {
        XCTAssert(calendarHighlights.currentYear == 2016)
    }
    
    func testCurrentYearAfterForwardMonth() {
        calendarHighlights.forwardOneMonth()
        XCTAssert(calendarHighlights.currentYear == 2017)
    }
    
    func testFirstMonthDayNumberAtWithoutOffset() {
        let c = calendarHighlights.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 27)
        XCTAssert(!c.isCurrentMonth)
    }
    
    func testLastMonthDayNumberAtWithoutOffset() {
        let c = calendarHighlights.dateComponents(at: 34)
        
        XCTAssert(c.components.day! == 31)
        XCTAssert(c.isCurrentMonth)
    }
    
    func testForwardOneMonth() {
        calendarHighlights.forwardOneMonth()
        XCTAssert(calendarHighlights.currentMonthName == "January")
    }
    
    func testForwardOneMonthOnLastDayOfTheMonth() {
        createCalendarHighlight(year: 2016, month: 12, day: 31)
        calendarHighlights.forwardOneMonth()
        XCTAssert(calendarHighlights.currentMonthName == "January")
    }
    
    func testBackwardOneMonth() {
        calendarHighlights.backwardOneMonth()
        XCTAssert(calendarHighlights.currentMonthName == "November")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
