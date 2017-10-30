//
//  DefaultColorCalendarViewDataSourceTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 8/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import ColorCalendar


class DefaultColorCalendarViewDataSourceTests: XCTestCase {
    
    private var date: Date!
    private var dataSource: ColorCalendarViewDataSource!
    private var colorCalendarView: ColorCalendarView!
    
    override func setUp() {
        super.setUp()
        createDate()
        dataSource = DefaultColorCalendarViewDataSource()
        colorCalendarView = ColorCalendarView()
        colorCalendarView.calendar = MonthlyCalendarLayout(Date())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
        
    func testAugustThe8th2016() {
        XCTAssertEqual(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date), "Monday, August 8, 2016")
    }
    
    func testAugustThe9th2016() {
        createDate(day: 9)
        XCTAssertEqual(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date), "Tuesday, August 9, 2016")
    }
    
    func testToday() {
        date = Date()
        XCTAssertEqual(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date), "Today")
    }
    
//    func testTodaySpanish() {
//        date = Date()
//        XCTAssertEqual(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date), "Hoy")
//    }
    
    private func createDate(year: Int = 2016, month: Int = 8, day: Int = 8) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        date = calendar.date(from: dateComponents)!
    }
}
