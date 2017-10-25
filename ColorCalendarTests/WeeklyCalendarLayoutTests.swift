//
//  WeeklyMonthlyCalendarLayoutTests.swift
//  ColorCalendarTests
//
//  Created by Mariano Heredia on 25/10/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar

class WeeklyMonthlyCalendarLayoutTests: XCTestCase {
    
    var calendarLayout: WeeklyMonthlyCalendarLayout!
    var locale: Locale!
    
    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "EN_us")
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 25)
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
        
        calendarLayout = WeeklyMonthlyCalendarLayout(date)
        calendarLayout.locale = locale
    }
    
    // MARK: - test methods
    
    func testWeeksCount1Week() {
        createMonthlyCalendarLayout(year: 2017, month: 4, day: 1)
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
        let c = calendarLayout.dateComponents(at: 7)
        
        XCTAssert(c.components.day! == 29)
        XCTAssert(!c.isWithinCurrentCalendarPeriod)
    }
    
    func testFirstCalendarDayNumberOnTheFirstMonthWeekWithDefaultFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 11, day: 1)

        let c = calendarLayout.dateComponents(at: 0)
        
        XCTAssert(c.components.day! == 29)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testEnglishTitleOnMonthMiddleWeekWithDefaultFirstWeekday() {
        XCTAssert(calendarLayout.title == "Week of 10/22/17")
    }

    // TODO: create spanish test target
//    func testSpanishTitleOnMonthMiddleWeekWithDefaultFirstWeekday() {
//        calendarLayout.locale = Locale(identifier: "ES_ar")
//        XCTAssert(calendarLayout.title == "Semana del 22/10/17")
//    }    
//    func testSpanishTitleAfterMoveCalendarBackwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
//        calendarLayout.locale = Locale(identifier: "ES_ar")
//        calendarLayout.moveCalendarBackward()
//        XCTAssert(calendarLayout.title == "Semana del 15/10/17")
//    }
//
//    func testSpanishTitleAfterMoveCalendarBackwardOnMonthFirstWeekWithDefaultFirstWeekday() {
//        createMonthlyCalendarLayout(year: 2017, month: 10, day: 1)
//        calendarLayout.locale = Locale(identifier: "ES_ar")
//        calendarLayout.moveCalendarBackward()
//        XCTAssert(calendarLayout.title == "Semana del 24/10/17")
//    }
//
//
//    func testSpanishTitleAfterMoveCalendarForwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
//        calendarLayout.locale = Locale(identifier: "ES_ar")
//        calendarLayout.moveCalendarForward()
//        XCTAssert(calendarLayout.title == "Semana del 29/10/17")
//    }
//
//
//    func testSpanishTitleAfterMoveCalendarForwardOnMonthLastWeekWithDefaultFirstWeekday() {
//        createMonthlyCalendarLayout(year: 2017, month: 10, day: 29)
//        calendarLayout.locale = Locale(identifier: "ES_ar")
//        calendarLayout.moveCalendarForward()
//        XCTAssert(calendarLayout.title == "Semana del 5/11/2017")
//    }
    
    func testMoveCalendarForwardFirstCalendarDayNumberOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarForward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 29)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testMoveCalendarForwardFirstCalendarDayNumberOnMonthLastWeekWithDefaultFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 29)
        calendarLayout.moveCalendarForward()
        let c = calendarLayout.dateComponents(at: 0)
        XCTAssert(c.components.day! == 5)
        XCTAssert(c.components.month! == 11)
        XCTAssert(c.isWithinCurrentCalendarPeriod)
    }
    
    func testMoveCalendarBackwardFirstCalendarDayNumberOnMonthFirstWeekWithDefaultFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 1)
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
        XCTAssert(calendarLayout.title == "Week of 10/15/17")
    }
    
    func testEnglishTitleAfterMoveCalendarBackwardOnMonthFirstWeekWithDefaultFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 1)
        calendarLayout.moveCalendarBackward()
        XCTAssert(calendarLayout.title == "Week of 9/24/17")
    }

    
    func testEnglishTitleAfterMoveCalendarForwardOnMonthMiddleWeekWithDefaultFirstWeekday() {
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Week of 10/29/17")
    }
    
    func testEnglishTitleAfterMoveCalendarForwardOnMonthLastWeekWithDefaultFirstWeekday() {
        createMonthlyCalendarLayout(year: 2017, month: 10, day: 29)
        calendarLayout.moveCalendarForward()
        XCTAssert(calendarLayout.title == "Week of 11/5/17")
    }

}
