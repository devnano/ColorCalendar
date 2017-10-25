//
//  WeeklyMontlyCalendarLayoutTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 25/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class WeeklyMontlyCalendarLayoutTests: XCTestCase {
    
    var calendarLayout: WeeklyMontlyCalendarLayout!
    var locale: Locale!
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        createMontlyCalendarLayout(year: 2017, month: 10, day: 25)
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
        
        calendarLayout = WeeklyMontlyCalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount1Week() {
        createMontlyCalendarLayout(year: 2017, month: 4, day: 1)
        XCTAssert(calendarLayout.numberOfWeeks == 1)
    }
    
    func testFirstCalendarDayNumberOnMonthMiddleWeekWithDefaultFirstWeekday() {
        let c = calendarLayout.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 22)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testDateInPreviousWeek() {
        let c = calendarLayout.dateComponents(at: -1)
        
        XCTAssert(c.components.day! == 21)
        XCTAssert(!c.isWithinCurrentCalendarPeriod)
    }
    
    func testDateInNextWeek() {
        let c = calendarLayout.dateComponents(at: 8)
        
        XCTAssert(c.components.day! == 29)
        XCTAssert(!c.isWithinCurrentCalendarPeriod)
    }
    
    func testFirstCalendarDayNumberOnTheFirstMonthWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 11, day: 1)

        let c = calendarLayout.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 29)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testEnglishTitleOnMonthMiddleWeekWithDefaultFirstWeekday() {
        XCTAssert(calendarLayout.title == "Week of 10/22/2017")
    }
    
    func testSpanishTitleOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        XCTAssert(calendarLayout.title == "Semana del 22/10/2017")
    }
    
    func testMoveCalendarForwardFirstCalendarDayNumberOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarForward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 29)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testMoveCalendarForwardFirstCalendarDayNumberOnMonthLastWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 29)
        calendarLayout.moveCalendarForward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 5)
        XCTAssert(c.components.month! == 11)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testMoveCalendarBackwardFirstCalendarDayNumberOnMonthFirstWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 1)
        calendarLayout.moveCalendarBackward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 24)
        XCTAssert(c.components.month! == 9)
    }
    
    func testMoveCalendarBackwardFirstCalendarDayNumberOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarBackward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 15)
        XCTAssert(c.components.month! == 10)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testEnglishTitleAfterMoveCalendarBackwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "Week of 10/15/2017")
    }
    
    func testSpanishTitleAfterMoveCalendarBackwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "Semana del 15/10/2017")
    }
    
    func testEnglishTitleAfterMoveCalendarBackwardOnMonthFirstWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 1)
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "Week of 9/24/2017")
    }
    
    func testSpanishTitleAfterMoveCalendarBackwardOnMonthFirstWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 1)
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "Semana del 24/10/2017")
    }
    
    func testEnglishTitleAfterMoveCalendarForwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Week of 10/29/2017")
    }
    
    func testSpanishTitleAfterMoveCalendarForwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Semana del 29/10/2017")
    }
    
    func testEnglishTitleAfterMoveCalendarForwardOnMonthLastWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 29)
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Week of 11/5/2017")
    }
    
    func testSpanishTitleAfterMoveCalendarForwardOnMonthLastWeekWithDefaultFirstWeekday() {
        createMontlyCalendarLayout(year: 2017, month: 10, day: 29)
        calendarLayout.locale = Locale(identifier: "ES_ar")
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Semana del 5/11/2017")
    }
}
