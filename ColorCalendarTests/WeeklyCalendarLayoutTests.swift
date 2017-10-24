//
//  WeeklyCalendarLayoutTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 25/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class WeeklyCalendarLayoutTests: XCTestCase {
    
    var calendarLayout: WeeklyCalendarLayout!
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
        
        calendarLayout = WeeklyCalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount6Weeks() {
        createCalendarHighlight(year: 2017, month: 4, day: 1)
        XCTAssert(calendarLayout.numberOfWeeks == 1)
    }
    
    
}
