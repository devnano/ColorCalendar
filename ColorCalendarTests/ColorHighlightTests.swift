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
    
   var calendarHighlights:CalendarHighlights!
    
    override func setUp() {
        super.setUp()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: 2016, month: 12, day: 27)
        let date = calendar.date(from: dateComponents)!
        
        calendarHighlights = CalendarHighlights(date)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        calendarHighlights = nil
    }
    
    func testWeekdaysCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(calendarHighlights.daysPerWeek == 7)
    }
    
    func testWeekdaySymbolAtWithoutOffset() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(calendarHighlights.weekdaySymbol(at: 0) == "S")
    }
    
    func testWeekdaySymbolAtWithOffset() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        calendarHighlights.firstWeekdayOffset = 1
        XCTAssert(calendarHighlights.weekdaySymbol(at: 0) == "M")
    }
    
    func testCurrentMonthName() {
        XCTAssert(calendarHighlights.currentMonthName == "December")
    }
    
    func testFirstMonthDayNumberAtWithoutOffset() {
        XCTAssert(calendarHighlights.dayNumber(at: 0) == 27)
    }
    
    func testLastMonthDayNumberAtWithoutOffset() {
        XCTAssert(calendarHighlights.dayNumber(at: 34) == 31)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
