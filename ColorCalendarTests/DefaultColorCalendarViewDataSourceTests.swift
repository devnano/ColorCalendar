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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAugustThe8th2017() {
        XCTAssert(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date) == "August the 8th, 2017")
    }
    
    func testAugustThe9th2017() {
        createDate(day: 9)
        XCTAssert(dataSource.colorCalendar(colorCalendarView, accesibilityLabelForDate: date) == "August the 9th, 2017")
    }
    
    private func createDate(year: Int = 2017, month: Int = 8, day: Int = 8) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = DateComponents(calendar: calendar, timeZone: nil, era: nil, year: year, month: month, day: day)
        date = calendar.date(from: dateComponents)!
    }
}
