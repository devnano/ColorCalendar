//
//  ColorCalendarViewTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

import XCTest
@testable import ColorCalendar

class ColorCalendarViewTests: XCTestCase {
    var colorCalendar: ColorCalendarView!
    
    override func setUp() {
        super.setUp()
        colorCalendar = ColorCalendarView()
        colorCalendar.calendar = MonthlyCalendarLayout(Date())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultCalendarHighlightRowHeightZero() {
        XCTAssert(colorCalendar.rowHeight == 0)
    }
    
    func testDefaultCalendarHighlightCurrentDate() {
        XCTAssert(colorCalendar.calendar.locale == .current)
    }
    
    func testCurrentMonthNotNil() {
        XCTAssert(colorCalendar.currentMonthTitleButton.titleLabel?.text != nil)
    }
}
